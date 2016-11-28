Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60660 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932094AbcK1LtN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 06:49:13 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 2/4] wil6210: validate wil_pmc_alloc parameters
Date: Mon, 28 Nov 2016 13:49:01 +0200
Message-Id: <1480333743-7306-3-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20161128_124917_832865_2918F1C7)
In-Reply-To: <1480333743-7306-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1480333743-7306-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

num_descriptors and descriptor_size needs to be
checked for:
1) not being negative values
2) no overflow occurs when these are multiplied
together as done in wil_pmc_read.
An overflow of two signed integers is undefined
behavior.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pmc.c | 55 ++++++++++++++++++++++++++++++----
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/pmc.c b/drivers/net/wireless/ath/wil6210/pmc.c
index 5ca0307..b9faae0 100644
--- a/drivers/net/wireless/ath/wil6210/pmc.c
+++ b/drivers/net/wireless/ath/wil6210/pmc.c
@@ -54,6 +54,7 @@ void wil_pmc_alloc(struct wil6210_priv *wil,
 	struct pmc_ctx *pmc = &wil->pmc;
 	struct device *dev = wil_to_dev(wil);
 	struct wmi_pmc_cmd pmc_cmd = {0};
+	int last_cmd_err = -ENOMEM;
 
 	mutex_lock(&pmc->lock);
 
@@ -62,6 +63,29 @@ void wil_pmc_alloc(struct wil6210_priv *wil,
 		wil_err(wil, "%s: ERROR pmc is already allocated\n", __func__);
 		goto no_release_err;
 	}
+	if ((num_descriptors <= 0) || (descriptor_size <= 0)) {
+		wil_err(wil,
+			"Invalid params num_descriptors(%d), descriptor_size(%d)\n",
+			num_descriptors, descriptor_size);
+		last_cmd_err = -EINVAL;
+		goto no_release_err;
+	}
+
+	if (num_descriptors > (1 << WIL_RING_SIZE_ORDER_MAX)) {
+		wil_err(wil,
+			"num_descriptors(%d) exceeds max ring size %d\n",
+			num_descriptors, 1 << WIL_RING_SIZE_ORDER_MAX);
+		last_cmd_err = -EINVAL;
+		goto no_release_err;
+	}
+
+	if (num_descriptors > INT_MAX / descriptor_size) {
+		wil_err(wil,
+			"Overflow in num_descriptors(%d)*descriptor_size(%d)\n",
+			num_descriptors, descriptor_size);
+		last_cmd_err = -EINVAL;
+		goto no_release_err;
+	}
 
 	pmc->num_descriptors = num_descriptors;
 	pmc->descriptor_size = descriptor_size;
@@ -189,7 +213,7 @@ void wil_pmc_alloc(struct wil6210_priv *wil,
 	pmc->descriptors = NULL;
 
 no_release_err:
-	pmc->last_cmd_status = -ENOMEM;
+	pmc->last_cmd_status = last_cmd_err;
 	mutex_unlock(&pmc->lock);
 }
 
@@ -295,7 +319,7 @@ ssize_t wil_pmc_read(struct file *filp, char __user *buf, size_t count,
 	size_t retval = 0;
 	unsigned long long idx;
 	loff_t offset;
-	size_t pmc_size = pmc->descriptor_size * pmc->num_descriptors;
+	size_t pmc_size;
 
 	mutex_lock(&pmc->lock);
 
@@ -306,6 +330,8 @@ ssize_t wil_pmc_read(struct file *filp, char __user *buf, size_t count,
 		return -EPERM;
 	}
 
+	pmc_size = pmc->descriptor_size * pmc->num_descriptors;
+
 	wil_dbg_misc(wil,
 		     "%s: size %u, pos %lld\n",
 		     __func__, (unsigned)count, *f_pos);
@@ -345,7 +371,18 @@ loff_t wil_pmc_llseek(struct file *filp, loff_t off, int whence)
 	loff_t newpos;
 	struct wil6210_priv *wil = filp->private_data;
 	struct pmc_ctx *pmc = &wil->pmc;
-	size_t pmc_size = pmc->descriptor_size * pmc->num_descriptors;
+	size_t pmc_size;
+
+	mutex_lock(&pmc->lock);
+
+	if (!wil_is_pmc_allocated(pmc)) {
+		wil_err(wil, "error, pmc is not allocated!\n");
+		pmc->last_cmd_status = -EPERM;
+		mutex_unlock(&pmc->lock);
+		return -EPERM;
+	}
+
+	pmc_size = pmc->descriptor_size * pmc->num_descriptors;
 
 	switch (whence) {
 	case 0: /* SEEK_SET */
@@ -361,15 +398,21 @@ loff_t wil_pmc_llseek(struct file *filp, loff_t off, int whence)
 		break;
 
 	default: /* can't happen */
-		return -EINVAL;
+		newpos = -EINVAL;
+		goto out;
 	}
 
-	if (newpos < 0)
-		return -EINVAL;
+	if (newpos < 0) {
+		newpos = -EINVAL;
+		goto out;
+	}
 	if (newpos > pmc_size)
 		newpos = pmc_size;
 
 	filp->f_pos = newpos;
 
+out:
+	mutex_unlock(&pmc->lock);
+
 	return newpos;
 }
-- 
1.9.1
