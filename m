Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:56722 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab1J0PsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 11:48:18 -0400
Subject: [PATCH 03/10] ath6kl: move power control from sdio to core
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 27 Oct 2011 18:48:14 +0300
Message-ID: <20111027154814.23519.93093.stgit@localhost6.localdomain6> (sfid-20111027_174820_666866_23B0C8CA)
In-Reply-To: <20111027154746.23519.39680.stgit@localhost6.localdomain6>
References: <20111027154746.23519.39680.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for cutting down power from the chip on the fly.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/hif-ops.h |   15 +++++++++++++++
 drivers/net/wireless/ath/ath6kl/hif.h     |    2 ++
 drivers/net/wireless/ath/ath6kl/init.c    |   16 ++++++++++++----
 drivers/net/wireless/ath/ath6kl/sdio.c    |   20 ++++++++------------
 4 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif-ops.h b/drivers/net/wireless/ath/ath6kl/hif-ops.h
index 95e7303..34adc77 100644
--- a/drivers/net/wireless/ath/ath6kl/hif-ops.h
+++ b/drivers/net/wireless/ath/ath6kl/hif-ops.h
@@ -96,4 +96,19 @@ static inline int ath6kl_hif_resume(struct ath6kl *ar)
 
 	return ar->hif_ops->resume(ar);
 }
+
+static inline int ath6kl_hif_power_on(struct ath6kl *ar)
+{
+	ath6kl_dbg(ATH6KL_DBG_HIF, "hif power on\n");
+
+	return ar->hif_ops->power_on(ar);
+}
+
+static inline int ath6kl_hif_power_off(struct ath6kl *ar)
+{
+	ath6kl_dbg(ATH6KL_DBG_HIF, "hif power off\n");
+
+	return ar->hif_ops->power_off(ar);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 93d2912..ee7c31a 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -242,6 +242,8 @@ struct ath6kl_hif_ops {
 	void (*cleanup_scatter)(struct ath6kl *ar);
 	int (*suspend)(struct ath6kl *ar);
 	int (*resume)(struct ath6kl *ar);
+	int (*power_on)(struct ath6kl *ar);
+	int (*power_off)(struct ath6kl *ar);
 };
 
 int ath6kl_hif_setup(struct ath6kl_device *dev);
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 64975a9..0564add 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -554,6 +554,8 @@ void ath6kl_core_free(struct ath6kl *ar)
 
 void ath6kl_core_cleanup(struct ath6kl *ar)
 {
+	ath6kl_hif_power_off(ar);
+
 	destroy_workqueue(ar->ath6kl_wq);
 
 	if (ar->htc_target)
@@ -1601,27 +1603,31 @@ int ath6kl_core_init(struct ath6kl *ar)
 	if (ret)
 		goto err_wq;
 
-	ret = ath6kl_bmi_get_target_info(ar, &targ_info);
+	ret = ath6kl_hif_power_on(ar);
 	if (ret)
 		goto err_bmi_cleanup;
 
+	ret = ath6kl_bmi_get_target_info(ar, &targ_info);
+	if (ret)
+		goto err_power_off;
+
 	ar->version.target_ver = le32_to_cpu(targ_info.version);
 	ar->target_type = le32_to_cpu(targ_info.type);
 	ar->wiphy->hw_version = le32_to_cpu(targ_info.version);
 
 	ret = ath6kl_init_hw_params(ar);
 	if (ret)
-		goto err_bmi_cleanup;
+		goto err_power_off;
 
 	ret = ath6kl_configure_target(ar);
 	if (ret)
-		goto err_bmi_cleanup;
+		goto err_power_off;
 
 	ar->htc_target = ath6kl_htc_create(ar);
 
 	if (!ar->htc_target) {
 		ret = -ENOMEM;
-		goto err_bmi_cleanup;
+		goto err_power_off;
 	}
 
 	ret = ath6kl_fetch_firmwares(ar);
@@ -1640,6 +1646,8 @@ int ath6kl_core_init(struct ath6kl *ar)
 
 err_htc_cleanup:
 	ath6kl_htc_cleanup(ar->htc_target);
+err_power_off:
+	ath6kl_hif_power_off(ar);
 err_bmi_cleanup:
 	ath6kl_bmi_cleanup(ar);
 err_wq:
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 5ce0b8b..682c47c 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -463,8 +463,9 @@ static void ath6kl_sdio_irq_handler(struct sdio_func *func)
 	WARN_ON(status && status != -ECANCELED);
 }
 
-static int ath6kl_sdio_power_on(struct ath6kl_sdio *ar_sdio)
+static int ath6kl_sdio_power_on(struct ath6kl *ar)
 {
+	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
 	struct sdio_func *func = ar_sdio->func;
 	int ret = 0;
 
@@ -495,8 +496,9 @@ static int ath6kl_sdio_power_on(struct ath6kl_sdio *ar_sdio)
 	return ret;
 }
 
-static int ath6kl_sdio_power_off(struct ath6kl_sdio *ar_sdio)
+static int ath6kl_sdio_power_off(struct ath6kl *ar)
 {
+	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
 	int ret;
 
 	if (ar_sdio->is_disabled)
@@ -772,6 +774,8 @@ static const struct ath6kl_hif_ops ath6kl_sdio_ops = {
 	.cleanup_scatter = ath6kl_sdio_cleanup_scatter,
 	.suspend = ath6kl_sdio_suspend,
 	.resume = ath6kl_sdio_resume,
+	.power_on = ath6kl_sdio_power_on,
+	.power_off = ath6kl_sdio_power_off,
 };
 
 static int ath6kl_sdio_probe(struct sdio_func *func,
@@ -852,10 +856,6 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 
 	sdio_release_host(func);
 
-	ret = ath6kl_sdio_power_on(ar_sdio);
-	if (ret)
-		goto err_core_alloc;
-
 	sdio_claim_host(func);
 
 	ret = sdio_set_block_size(func, HIF_MBOX_BLOCK_SIZE);
@@ -863,7 +863,7 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 		ath6kl_err("Set sdio block size %d failed: %d)\n",
 			   HIF_MBOX_BLOCK_SIZE, ret);
 		sdio_release_host(func);
-		goto err_off;
+		goto err_hif;
 	}
 
 	sdio_release_host(func);
@@ -871,13 +871,11 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 	ret = ath6kl_core_init(ar);
 	if (ret) {
 		ath6kl_err("Failed to init ath6kl core\n");
-		goto err_off;
+		goto err_hif;
 	}
 
 	return ret;
 
-err_off:
-	ath6kl_sdio_power_off(ar_sdio);
 err_core_alloc:
 	ath6kl_core_free(ar_sdio->ar);
 err_dma:
@@ -903,8 +901,6 @@ static void ath6kl_sdio_remove(struct sdio_func *func)
 
 	ath6kl_core_cleanup(ar_sdio->ar);
 
-	ath6kl_sdio_power_off(ar_sdio);
-
 	kfree(ar_sdio->dma_buffer);
 	kfree(ar_sdio);
 }

