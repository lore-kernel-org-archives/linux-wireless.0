Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:13372 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728588AbeHWPQm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 11:16:42 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Karthick Gopalasubramanian <kargop@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 1/9] wil6210: remove reset file from debugfs
Date: Thu, 23 Aug 2018 14:47:05 +0300
Message-Id: <1535024833-15178-2-git-send-email-merez@codeaurora.org> (sfid-20180823_134729_371059_3AEFA5E7)
In-Reply-To: <1535024833-15178-1-git-send-email-merez@codeaurora.org>
References: <1535024833-15178-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karthick Gopalasubramanian <kargop@codeaurora.org>

Reset file is not used and may cause race conditions
with operational driver if used.

Signed-off-by: Karthick Gopalasubramanian <kargop@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 51c3330..4057f06 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -725,32 +725,6 @@ struct dentry *wil_debugfs_create_ioblob(const char *name,
 	return debugfs_create_file(name, mode, parent, wil_blob, &fops_ioblob);
 }
 
-/*---reset---*/
-static ssize_t wil_write_file_reset(struct file *file, const char __user *buf,
-				    size_t len, loff_t *ppos)
-{
-	struct wil6210_priv *wil = file->private_data;
-	struct net_device *ndev = wil->main_ndev;
-
-	/**
-	 * BUG:
-	 * this code does NOT sync device state with the rest of system
-	 * use with care, debug only!!!
-	 */
-	rtnl_lock();
-	dev_close(ndev);
-	ndev->flags &= ~IFF_UP;
-	rtnl_unlock();
-	wil_reset(wil, true);
-
-	return len;
-}
-
-static const struct file_operations fops_reset = {
-	.write = wil_write_file_reset,
-	.open  = simple_open,
-};
-
 /*---write channel 1..4 to rxon for it, 0 to rxoff---*/
 static ssize_t wil_write_file_rxon(struct file *file, const char __user *buf,
 				   size_t len, loff_t *ppos)
@@ -2451,7 +2425,6 @@ static void wil6210_debugfs_init_blobs(struct wil6210_priv *wil,
 	{"desc",	0444,		&fops_txdesc},
 	{"bf",		0444,		&fops_bf},
 	{"mem_val",	0644,		&fops_memread},
-	{"reset",	0244,		&fops_reset},
 	{"rxon",	0244,		&fops_rxon},
 	{"tx_mgmt",	0244,		&fops_txmgmt},
 	{"wmi_send", 0244,		&fops_wmi},
-- 
1.9.1
