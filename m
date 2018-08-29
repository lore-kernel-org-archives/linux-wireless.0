Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-blr-01.qualcomm.com ([103.229.18.197]:18155 "EHLO
        alexa-out-blr-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727054AbeH2K4Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 06:56:16 -0400
From: Rakesh Pillai <pillair@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH] ath10k: Enable Factory Test Mode for WCN3990
Date: Wed, 29 Aug 2018 12:30:38 +0530
Message-Id: <1535526038-4299-1-git-send-email-pillair@codeaurora.org> (sfid-20180829_090056_601899_07C795FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The support to put WCN3990 firmware into Factory
test mode is not present currently. The WCN3990
firmware can operate in Factory test mode based
on the mode it receives in the wlan enable message
from the host driver.

When the host driver is started in testmode send
the operating mode as UTF mode, to the WCN3990
firmware, in the wlan enable message to start the
firmware in Factory test mode.

Tested on: WCN3990
Tested FW: WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1.

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/ahb.c      |  3 ++-
 drivers/net/wireless/ath/ath10k/core.c     |  2 +-
 drivers/net/wireless/ath/ath10k/hif.h      |  7 ++++---
 drivers/net/wireless/ath/ath10k/mac.c      |  2 +-
 drivers/net/wireless/ath/ath10k/pci.c      |  3 ++-
 drivers/net/wireless/ath/ath10k/sdio.c     |  3 ++-
 drivers/net/wireless/ath/ath10k/snoc.c     | 20 ++++++++++++++++----
 drivers/net/wireless/ath/ath10k/testmode.c |  2 +-
 drivers/net/wireless/ath/ath10k/usb.c      |  3 ++-
 9 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index c9bd0e2..8c0e605 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -661,7 +661,8 @@ static void ath10k_ahb_hif_stop(struct ath10k *ar)
 	napi_disable(&ar->napi);
 }
 
-static int ath10k_ahb_hif_power_up(struct ath10k *ar)
+static int ath10k_ahb_hif_power_up(struct ath10k *ar,
+				   enum ath10k_firmware_mode fw_mode)
 {
 	int ret;
 
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 7ff70a6..fe6169d 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2515,7 +2515,7 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 	struct bmi_target_info target_info;
 	int ret = 0;
 
-	ret = ath10k_hif_power_up(ar);
+	ret = ath10k_hif_power_up(ar, ATH10K_FIRMWARE_MODE_NORMAL);
 	if (ret) {
 		ath10k_err(ar, "could not power on hif bus (%d)\n", ret);
 		return ret;
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 1a59ea0..171fdd0 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -81,7 +81,7 @@ struct ath10k_hif_ops {
 	void (*write32)(struct ath10k *ar, u32 address, u32 value);
 
 	/* Power up the device and enter BMI transfer mode for FW download */
-	int (*power_up)(struct ath10k *ar);
+	int (*power_up)(struct ath10k *ar, enum ath10k_firmware_mode fw_mode);
 
 	/* Power down the device and free up resources. stop() must be called
 	 * before this if start() was called earlier
@@ -165,9 +165,10 @@ static inline u16 ath10k_hif_get_free_queue_number(struct ath10k *ar,
 	return ar->hif.ops->get_free_queue_number(ar, pipe_id);
 }
 
-static inline int ath10k_hif_power_up(struct ath10k *ar)
+static inline int ath10k_hif_power_up(struct ath10k *ar,
+				      enum ath10k_firmware_mode fw_mode)
 {
-	return ar->hif.ops->power_up(ar);
+	return ar->hif.ops->power_up(ar, fw_mode);
 }
 
 static inline void ath10k_hif_power_down(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 90f9372..155b720 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4654,7 +4654,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		goto err;
 	}
 
-	ret = ath10k_hif_power_up(ar);
+	ret = ath10k_hif_power_up(ar, ATH10K_FIRMWARE_MODE_NORMAL);
 	if (ret) {
 		ath10k_err(ar, "Could not init hif: %d\n", ret);
 		goto err_off;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index af2cf55..b867171 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2789,7 +2789,8 @@ static int ath10k_pci_chip_reset(struct ath10k *ar)
 	return ar_pci->pci_hard_reset(ar);
 }
 
-static int ath10k_pci_hif_power_up(struct ath10k *ar)
+static int ath10k_pci_hif_power_up(struct ath10k *ar,
+				   enum ath10k_firmware_mode fw_mode)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret;
diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 7f61591..90abfc6 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -1381,7 +1381,8 @@ static int ath10k_sdio_hif_disable_intrs(struct ath10k *ar)
 	return ret;
 }
 
-static int ath10k_sdio_hif_power_up(struct ath10k *ar)
+static int ath10k_sdio_hif_power_up(struct ath10k *ar,
+				    enum ath10k_firmware_mode fw_mode)
 {
 	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
 	struct sdio_func *func = ar_sdio->func;
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index e9a6b3d..c79cca1 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -942,7 +942,8 @@ static int ath10k_snoc_init_pipes(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_snoc_wlan_enable(struct ath10k *ar)
+static int ath10k_snoc_wlan_enable(struct ath10k *ar,
+				   enum ath10k_firmware_mode fw_mode)
 {
 	struct ath10k_tgt_pipe_cfg tgt_cfg[CE_COUNT_MAX];
 	struct ath10k_qmi_wlan_enable_cfg cfg;
@@ -976,7 +977,17 @@ static int ath10k_snoc_wlan_enable(struct ath10k *ar)
 	cfg.shadow_reg_cfg = (struct ath10k_shadow_reg_cfg *)
 		&target_shadow_reg_cfg_map;
 
-	mode = QMI_WLFW_MISSION_V01;
+	switch (fw_mode) {
+	case ATH10K_FIRMWARE_MODE_NORMAL:
+		mode = QMI_WLFW_MISSION_V01;
+		break;
+	case ATH10K_FIRMWARE_MODE_UTF:
+		mode = QMI_WLFW_FTM_V01;
+		break;
+	default:
+		ath10k_err(ar, "invalid firmware mode %d\n", fw_mode);
+		return -EINVAL;
+	}
 
 	return ath10k_qmi_wlan_enable(ar, &cfg, mode,
 				       NULL);
@@ -995,14 +1006,15 @@ static void ath10k_snoc_hif_power_down(struct ath10k *ar)
 	ath10k_ce_free_rri(ar);
 }
 
-static int ath10k_snoc_hif_power_up(struct ath10k *ar)
+static int ath10k_snoc_hif_power_up(struct ath10k *ar,
+				    enum ath10k_firmware_mode fw_mode)
 {
 	int ret;
 
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "%s:WCN3990 driver state = %d\n",
 		   __func__, ar->state);
 
-	ret = ath10k_snoc_wlan_enable(ar);
+	ret = ath10k_snoc_wlan_enable(ar, fw_mode);
 	if (ret) {
 		ath10k_err(ar, "failed to enable wcn3990: %d\n", ret);
 		return ret;
diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index c24ee61..67faafe 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -270,7 +270,7 @@ static int ath10k_tm_cmd_utf_start(struct ath10k *ar, struct nlattr *tb[])
 	ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode wmi version %d\n",
 		   ar->testmode.utf_mode_fw.fw_file.wmi_op_version);
 
-	ret = ath10k_hif_power_up(ar);
+	ret = ath10k_hif_power_up(ar, ATH10K_FIRMWARE_MODE_UTF);
 	if (ret) {
 		ath10k_err(ar, "failed to power up hif (testmode): %d\n", ret);
 		ar->state = ATH10K_STATE_OFF;
diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index d4803ff..a91524f5 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -706,7 +706,8 @@ static void ath10k_usb_hif_send_complete_check(struct ath10k *ar,
 {
 }
 
-static int ath10k_usb_hif_power_up(struct ath10k *ar)
+static int ath10k_usb_hif_power_up(struct ath10k *ar,
+				   enum ath10k_firmware_mode fw_mode)
 {
 	return 0;
 }
-- 
2.7.4
