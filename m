Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:57470 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbaCYJPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 05:15:36 -0400
Subject: [PATCH 6/8] ath10k: improve pci debug messages
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 25 Mar 2014 11:15:34 +0200
Message-ID: <20140325091534.16651.46543.stgit@potku.adurom.net> (sfid-20140325_101539_515940_1187A619)
In-Reply-To: <20140325091311.16651.15747.stgit@potku.adurom.net>
References: <20140325091311.16651.15747.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To make it easier to debug pci problems improve the log messages in pci.c. Also
change some debug messages to warning messages to more easily catch problems.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   45 ++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 0d8efba160dd..5842fa51f9c5 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -451,8 +451,8 @@ done:
 				__le32_to_cpu(((__le32 *)data_buf)[i]);
 		}
 	} else
-		ath10k_dbg(ATH10K_DBG_PCI, "%s failure (0x%x)\n",
-			   __func__, address);
+		ath10k_warn("failed to read diag value at 0x%x: %d\n",
+			    address, ret);
 
 	if (data_buf)
 		pci_free_consistent(ar_pci->pdev, orig_nbytes,
@@ -602,8 +602,8 @@ done:
 	}
 
 	if (ret != 0)
-		ath10k_dbg(ATH10K_DBG_PCI, "%s failure (0x%x)\n", __func__,
-			   address);
+		ath10k_warn("failed to write diag value at 0x%x: %d\n",
+			    address, ret);
 
 	return ret;
 }
@@ -812,6 +812,9 @@ unlock:
 static u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
+	ath10k_dbg(ATH10K_DBG_PCI, "pci hif get free queue number\n");
+
 	return ath10k_ce_num_free_src_entries(ar_pci->pipe_info[pipe].ce_hdl);
 }
 
@@ -863,6 +866,8 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 static void ath10k_pci_hif_send_complete_check(struct ath10k *ar, u8 pipe,
 					       int force)
 {
+	ath10k_dbg(ATH10K_DBG_PCI, "pci hif send complete check\n");
+
 	if (!force) {
 		int resources;
 		/*
@@ -889,7 +894,7 @@ static void ath10k_pci_hif_set_callbacks(struct ath10k *ar,
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
-	ath10k_dbg(ATH10K_DBG_PCI, "%s\n", __func__);
+	ath10k_dbg(ATH10K_DBG_PCI, "pci hif set callbacks\n");
 
 	memcpy(&ar_pci->msg_callbacks_current, callbacks,
 	       sizeof(ar_pci->msg_callbacks_current));
@@ -947,6 +952,8 @@ static int ath10k_pci_hif_map_service_to_pipe(struct ath10k *ar,
 {
 	int ret = 0;
 
+	ath10k_dbg(ATH10K_DBG_PCI, "pci hif map service\n");
+
 	/* polling for received messages not supported */
 	*dl_is_polled = 0;
 
@@ -1006,6 +1013,8 @@ static void ath10k_pci_hif_get_default_pipe(struct ath10k *ar,
 {
 	int ul_is_polled, dl_is_polled;
 
+	ath10k_dbg(ATH10K_DBG_PCI, "pci hif get default pipe\n");
+
 	(void)ath10k_pci_hif_map_service_to_pipe(ar,
 						 ATH10K_HTC_SVC_ID_RSVD_CTRL,
 						 ul_pipe,
@@ -1107,6 +1116,8 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret, ret_early;
 
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif start\n");
+
 	ath10k_pci_free_early_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
 
@@ -1261,7 +1272,7 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret;
 
-	ath10k_dbg(ATH10K_DBG_PCI, "%s\n", __func__);
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif stop\n");
 
 	ret = ath10k_ce_disable_interrupts(ar);
 	if (ret)
@@ -1780,7 +1791,7 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
 	int ret = 0;
 	u32 val;
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot performing warm chip reset\n");
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot warm reset\n");
 
 	ret = ath10k_do_pci_wake(ar);
 	if (ret) {
@@ -1963,6 +1974,8 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 {
 	int ret;
 
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif power up\n");
+
 	/*
 	 * Hardware CUS232 version 2 has some issues with cold reset and the
 	 * preferred (and safer) way to perform a device reset is through a
@@ -1996,6 +2009,8 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif power down\n");
+
 	ath10k_pci_free_early_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
 	ath10k_pci_deinit_irq(ar);
@@ -2401,6 +2416,8 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 	int ret;
 	u32 val;
 
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot waiting target to initialise\n");
+
 	ret = ath10k_pci_wake(ar);
 	if (ret) {
 		ath10k_err("failed to wake up target for init: %d\n", ret);
@@ -2411,6 +2428,9 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 
 	do {
 		val = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
+
+		ath10k_dbg(ATH10K_DBG_BOOT, "boot target indicator %x\n", val);
+
 		if (val == FW_IND_INITIALIZED)
 			break;
 
@@ -2430,6 +2450,8 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 		goto out;
 	}
 
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot target initialised\n");
+
 out:
 	ath10k_pci_sleep(ar);
 	return ret;
@@ -2440,6 +2462,8 @@ static int ath10k_pci_cold_reset(struct ath10k *ar)
 	int i, ret;
 	u32 val;
 
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot cold reset\n");
+
 	ret = ath10k_do_pci_wake(ar);
 	if (ret) {
 		ath10k_err("failed to wake up target: %d\n",
@@ -2471,6 +2495,9 @@ static int ath10k_pci_cold_reset(struct ath10k *ar)
 	}
 
 	ath10k_do_pci_sleep(ar);
+
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot cold reset complete\n");
+
 	return 0;
 }
 
@@ -2502,7 +2529,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	struct ath10k_pci *ar_pci;
 	u32 lcr_val, chip_id;
 
-	ath10k_dbg(ATH10K_DBG_PCI, "%s\n", __func__);
+	ath10k_dbg(ATH10K_DBG_PCI, "pci probe\n");
 
 	ar_pci = kzalloc(sizeof(*ar_pci), GFP_KERNEL);
 	if (ar_pci == NULL)
@@ -2643,7 +2670,7 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 	struct ath10k *ar = pci_get_drvdata(pdev);
 	struct ath10k_pci *ar_pci;
 
-	ath10k_dbg(ATH10K_DBG_PCI, "%s\n", __func__);
+	ath10k_dbg(ATH10K_DBG_PCI, "pci remove\n");
 
 	if (!ar)
 		return;

