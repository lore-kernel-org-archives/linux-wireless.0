Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:51827 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab1JXJSL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 05:18:11 -0400
Subject: [PATCH 9/9] ath6kl: add more boot debug messages
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 24 Oct 2011 12:18:07 +0300
Message-ID: <20111024091807.5004.7813.stgit@localhost6.localdomain6> (sfid-20111024_111819_259422_114FA841)
In-Reply-To: <20111024091644.5004.2767.stgit@localhost6.localdomain6>
References: <20111024091644.5004.2767.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move some of the debug logs to boot level because they are more
interesting when debugging boot issues.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c  |    8 ++++----
 drivers/net/wireless/ath/ath6kl/sdio.c |   22 +++++++++++++---------
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index a971c2f..976e352 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -2499,7 +2499,7 @@ static void htc_setup_msg_bndl(struct htc_target *target)
 	target->msg_per_bndl_max = min(target->max_scat_entries,
 				       target->msg_per_bndl_max);
 
-	ath6kl_dbg(ATH6KL_DBG_HTC,
+	ath6kl_dbg(ATH6KL_DBG_BOOT,
 		   "htc bundling allowed msg_per_bndl_max %d\n",
 		   target->msg_per_bndl_max);
 
@@ -2509,7 +2509,7 @@ static void htc_setup_msg_bndl(struct htc_target *target)
 	target->max_tx_bndl_sz = min(HIF_MBOX0_EXT_WIDTH,
 				     target->max_xfer_szper_scatreq);
 
-	ath6kl_dbg(ATH6KL_DBG_HTC, "htc max_rx_bndl_sz %d max_tx_bndl_sz %d\n",
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "htc max_rx_bndl_sz %d max_tx_bndl_sz %d\n",
 		   target->max_rx_bndl_sz, target->max_tx_bndl_sz);
 
 	if (target->max_tx_bndl_sz)
@@ -2563,7 +2563,7 @@ int ath6kl_htc_wait_target(struct htc_target *target)
 	target->tgt_creds = le16_to_cpu(rdy_msg->ver2_0_info.cred_cnt);
 	target->tgt_cred_sz = le16_to_cpu(rdy_msg->ver2_0_info.cred_sz);
 
-	ath6kl_dbg(ATH6KL_DBG_HTC,
+	ath6kl_dbg(ATH6KL_DBG_BOOT,
 		   "htc target ready credits %d size %d\n",
 		   target->tgt_creds, target->tgt_cred_sz);
 
@@ -2578,7 +2578,7 @@ int ath6kl_htc_wait_target(struct htc_target *target)
 		target->msg_per_bndl_max = 0;
 	}
 
-	ath6kl_dbg(ATH6KL_DBG_HTC, "htc using protocol %s (%d)\n",
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "htc using protocol %s (%d)\n",
 		  (target->htc_tgt_ver == HTC_VERSION_2P0) ? "2.0" : ">= 2.1",
 		  target->htc_tgt_ver);
 
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 58e31f6..b7bbe56 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -471,6 +471,8 @@ static int ath6kl_sdio_power_on(struct ath6kl_sdio *ar_sdio)
 	if (!ar_sdio->is_disabled)
 		return 0;
 
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "sdio power on\n");
+
 	sdio_claim_host(func);
 
 	ret = sdio_enable_func(func);
@@ -500,6 +502,8 @@ static int ath6kl_sdio_power_off(struct ath6kl_sdio *ar_sdio)
 	if (ar_sdio->is_disabled)
 		return 0;
 
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "sdio power off\n");
+
 	/* Disable the card */
 	sdio_claim_host(ar_sdio->func);
 	ret = sdio_disable_func(ar_sdio->func);
@@ -678,8 +682,8 @@ static int ath6kl_sdio_enable_scatter(struct ath6kl *ar)
 				MAX_SCATTER_REQUESTS, virt_scat);
 
 		if (!ret) {
-			ath6kl_dbg(ATH6KL_DBG_SCATTER,
-				   "hif-scatter enabled: max scatter req : %d entries: %d\n",
+			ath6kl_dbg(ATH6KL_DBG_BOOT,
+				   "hif-scatter enabled requests %d entries %d\n",
 				   MAX_SCATTER_REQUESTS,
 				   MAX_SCATTER_ENTRIES_PER_REQ);
 
@@ -703,8 +707,8 @@ static int ath6kl_sdio_enable_scatter(struct ath6kl *ar)
 			return ret;
 		}
 
-		ath6kl_dbg(ATH6KL_DBG_SCATTER,
-			   "Vitual scatter enabled, max_scat_req:%d, entries:%d\n",
+		ath6kl_dbg(ATH6KL_DBG_BOOT,
+			   "virtual scatter enabled requests %d entries %d\n",
 			   ATH6KL_SCATTER_REQS, ATH6KL_SCATTER_ENTRIES_PER_REQ);
 
 		target->max_scat_entries = ATH6KL_SCATTER_ENTRIES_PER_REQ;
@@ -778,8 +782,8 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 	struct ath6kl *ar;
 	int count;
 
-	ath6kl_dbg(ATH6KL_DBG_SDIO,
-		   "new func %d vendor 0x%x device 0x%x block 0x%x/0x%x\n",
+	ath6kl_dbg(ATH6KL_DBG_BOOT,
+		   "sdio new func %d vendor 0x%x device 0x%x block 0x%x/0x%x\n",
 		   func->num, func->vendor, func->device,
 		   func->max_blksize, func->cur_blksize);
 
@@ -840,7 +844,7 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 			goto err_cfg80211;
 		}
 
-		ath6kl_dbg(ATH6KL_DBG_SDIO, "4-bit async irq mode enabled\n");
+		ath6kl_dbg(ATH6KL_DBG_BOOT, "4-bit async irq mode enabled\n");
 	}
 
 	/* give us some time to enable, in ms */
@@ -888,8 +892,8 @@ static void ath6kl_sdio_remove(struct sdio_func *func)
 {
 	struct ath6kl_sdio *ar_sdio;
 
-	ath6kl_dbg(ATH6KL_DBG_SDIO,
-		   "removed func %d vendor 0x%x device 0x%x\n",
+	ath6kl_dbg(ATH6KL_DBG_BOOT,
+		   "sdio removed func %d vendor 0x%x device 0x%x\n",
 		   func->num, func->vendor, func->device);
 
 	ar_sdio = sdio_get_drvdata(func);

