Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:56806 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaC1Hcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 03:32:54 -0400
Subject: [PATCH v2 6/8] ath10k: improve pci debug messages
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Mar 2014 09:32:52 +0200
Message-ID: <20140328073252.30438.42187.stgit@potku.adurom.net> (sfid-20140328_083258_227059_E7E81040)
In-Reply-To: <20140328073040.30438.17966.stgit@potku.adurom.net>
References: <20140328073040.30438.17966.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To make it easier to debug pci problems improve the log messages in pci.c. Also
change some debug messages to warning messages to more easily catch problems.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   44 ++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 14d955b45c00..a4e2da3251dc 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -454,8 +454,8 @@ done:
 				__le32_to_cpu(((__le32 *)data_buf)[i]);
 		}
 	} else
-		ath10k_dbg(ATH10K_DBG_PCI, "%s failure (0x%x)\n",
-			   __func__, address);
+		ath10k_warn("failed to read diag value at 0x%x: %d\n",
+			    address, ret);
 
 	if (data_buf)
 		pci_free_consistent(ar_pci->pdev, orig_nbytes,
@@ -605,8 +605,8 @@ done:
 	}
 
 	if (ret != 0)
-		ath10k_dbg(ATH10K_DBG_PCI, "%s failure (0x%x)\n", __func__,
-			   address);
+		ath10k_warn("failed to write diag value at 0x%x: %d\n",
+			    address, ret);
 
 	return ret;
 }
@@ -815,6 +815,9 @@ unlock:
 static u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
+	ath10k_dbg(ATH10K_DBG_PCI, "pci hif get free queue number\n");
+
 	return ath10k_ce_num_free_src_entries(ar_pci->pipe_info[pipe].ce_hdl);
 }
 
@@ -866,6 +869,8 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 static void ath10k_pci_hif_send_complete_check(struct ath10k *ar, u8 pipe,
 					       int force)
 {
+	ath10k_dbg(ATH10K_DBG_PCI, "pci hif send complete check\n");
+
 	if (!force) {
 		int resources;
 		/*
@@ -892,7 +897,7 @@ static void ath10k_pci_hif_set_callbacks(struct ath10k *ar,
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
-	ath10k_dbg(ATH10K_DBG_PCI, "%s\n", __func__);
+	ath10k_dbg(ATH10K_DBG_PCI, "pci hif set callbacks\n");
 
 	memcpy(&ar_pci->msg_callbacks_current, callbacks,
 	       sizeof(ar_pci->msg_callbacks_current));
@@ -950,6 +955,8 @@ static int ath10k_pci_hif_map_service_to_pipe(struct ath10k *ar,
 {
 	int ret = 0;
 
+	ath10k_dbg(ATH10K_DBG_PCI, "pci hif map service\n");
+
 	/* polling for received messages not supported */
 	*dl_is_polled = 0;
 
@@ -1009,6 +1016,8 @@ static void ath10k_pci_hif_get_default_pipe(struct ath10k *ar,
 {
 	int ul_is_polled, dl_is_polled;
 
+	ath10k_dbg(ATH10K_DBG_PCI, "pci hif get default pipe\n");
+
 	(void)ath10k_pci_hif_map_service_to_pipe(ar,
 						 ATH10K_HTC_SVC_ID_RSVD_CTRL,
 						 ul_pipe,
@@ -1110,6 +1119,8 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret, ret_early;
 
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif start\n");
+
 	ath10k_pci_free_early_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
 
@@ -1264,7 +1275,7 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret;
 
-	ath10k_dbg(ATH10K_DBG_PCI, "%s\n", __func__);
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif stop\n");
 
 	ret = ath10k_ce_disable_interrupts(ar);
 	if (ret)
@@ -1783,7 +1794,7 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
 	int ret = 0;
 	u32 val;
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot performing warm chip reset\n");
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot warm reset\n");
 
 	ret = ath10k_do_pci_wake(ar);
 	if (ret) {
@@ -1966,6 +1977,8 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 {
 	int ret;
 
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif power up\n");
+
 	/*
 	 * Hardware CUS232 version 2 has some issues with cold reset and the
 	 * preferred (and safer) way to perform a device reset is through a
@@ -1999,6 +2012,8 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif power down\n");
+
 	ath10k_pci_free_early_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
 	ath10k_pci_deinit_irq(ar);
@@ -2403,6 +2418,8 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 	int ret;
 	u32 val;
 
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot waiting target to initialise\n");
+
 	ret = ath10k_pci_wake(ar);
 	if (ret) {
 		ath10k_err("failed to wake up target for init: %d\n", ret);
@@ -2414,6 +2431,8 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 	do {
 		val = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
 
+		ath10k_dbg(ATH10K_DBG_BOOT, "boot target indicator %x\n", val);
+
 		/* target should never return this */
 		if (val == 0xffffffff)
 			continue;
@@ -2437,6 +2456,8 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 		goto out;
 	}
 
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot target initialised\n");
+
 out:
 	ath10k_pci_sleep(ar);
 	return ret;
@@ -2447,6 +2468,8 @@ static int ath10k_pci_cold_reset(struct ath10k *ar)
 	int i, ret;
 	u32 val;
 
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot cold reset\n");
+
 	ret = ath10k_do_pci_wake(ar);
 	if (ret) {
 		ath10k_err("failed to wake up target: %d\n",
@@ -2478,6 +2501,9 @@ static int ath10k_pci_cold_reset(struct ath10k *ar)
 	}
 
 	ath10k_do_pci_sleep(ar);
+
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot cold reset complete\n");
+
 	return 0;
 }
 
@@ -2509,7 +2535,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	struct ath10k_pci *ar_pci;
 	u32 lcr_val, chip_id;
 
-	ath10k_dbg(ATH10K_DBG_PCI, "%s\n", __func__);
+	ath10k_dbg(ATH10K_DBG_PCI, "pci probe\n");
 
 	ar_pci = kzalloc(sizeof(*ar_pci), GFP_KERNEL);
 	if (ar_pci == NULL)
@@ -2650,7 +2676,7 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 	struct ath10k *ar = pci_get_drvdata(pdev);
 	struct ath10k_pci *ar_pci;
 
-	ath10k_dbg(ATH10K_DBG_PCI, "%s\n", __func__);
+	ath10k_dbg(ATH10K_DBG_PCI, "pci remove\n");
 
 	if (!ar)
 		return;

