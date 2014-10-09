Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:61111 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbaJIIdp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 04:33:45 -0400
Received: by mail-wg0-f43.google.com with SMTP id m15so696522wgh.2
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 01:33:44 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/5] ath10k: replace power up/down with reset callback
Date: Thu,  9 Oct 2014 10:22:30 +0200
Message-Id: <1412842950-14098-6-git-send-email-michal.kazior@tieto.com> (sfid-20141009_103422_541402_5414EB3B)
In-Reply-To: <1412842950-14098-1-git-send-email-michal.kazior@tieto.com>
References: <1412842950-14098-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The power up/down didn't make much sense any more
since hif_stop already stops the device
compeletely. The target lifecycle was never symmetric
so don't bother trying to make it look like it is
and expose a reset hif callback instead of power
up/down callbacks.

This removes redundant reset calls and thus makes
device boot/stop/recovery a bit faster.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c     |  7 +------
 drivers/net/wireless/ath/ath10k/hif.h      | 22 ++++++----------------
 drivers/net/wireless/ath/ath10k/mac.c      |  8 ++------
 drivers/net/wireless/ath/ath10k/pci.c      | 12 ++----------
 drivers/net/wireless/ath/ath10k/testmode.c |  8 ++------
 5 files changed, 13 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 37e3166..5000348 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -915,7 +915,7 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 	struct bmi_target_info target_info;
 	int ret = 0;
 
-	ret = ath10k_hif_power_up(ar);
+	ret = ath10k_hif_reset(ar);
 	if (ret) {
 		ath10k_err(ar, "could not start pci hif (%d)\n", ret);
 		return ret;
@@ -925,7 +925,6 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 	ret = ath10k_bmi_get_target_info(ar, &target_info);
 	if (ret) {
 		ath10k_err(ar, "could not get target info (%d)\n", ret);
-		ath10k_hif_power_down(ar);
 		return ret;
 	}
 
@@ -935,14 +934,12 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 	ret = ath10k_init_hw_params(ar);
 	if (ret) {
 		ath10k_err(ar, "could not get hw params (%d)\n", ret);
-		ath10k_hif_power_down(ar);
 		return ret;
 	}
 
 	ret = ath10k_core_fetch_firmware_files(ar);
 	if (ret) {
 		ath10k_err(ar, "could not fetch firmware files (%d)\n", ret);
-		ath10k_hif_power_down(ar);
 		return ret;
 	}
 
@@ -952,7 +949,6 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 	if (ret) {
 		ath10k_err(ar, "could not init core (%d)\n", ret);
 		ath10k_core_free_firmware_files(ar);
-		ath10k_hif_power_down(ar);
 		mutex_unlock(&ar->conf_mutex);
 		return ret;
 	}
@@ -962,7 +958,6 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 
 	mutex_unlock(&ar->conf_mutex);
 
-	ath10k_hif_power_down(ar);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 30301f5..26a8bcf 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -56,11 +56,13 @@ struct ath10k_hif_ops {
 				void *request, u32 request_len,
 				void *response, u32 *response_len);
 
+	/* Reset the device and puts it into BMI */
+	int (*reset)(struct ath10k *ar);
+
 	/* Post BMI phase, after FW is loaded. Starts regular operation */
 	int (*start)(struct ath10k *ar);
 
-	/* Clean up what start() did. This does not revert to BMI phase. If
-	 * desired so, call power_down() and power_up() */
+	/* Clean up what start() did. This does not revert to BMI */
 	void (*stop)(struct ath10k *ar);
 
 	int (*map_service_to_pipe)(struct ath10k *ar, u16 service_id,
@@ -84,13 +86,6 @@ struct ath10k_hif_ops {
 
 	u16 (*get_free_queue_number)(struct ath10k *ar, u8 pipe_id);
 
-	/* Power up the device and enter BMI transfer mode for FW download */
-	int (*power_up)(struct ath10k *ar);
-
-	/* Power down the device and free up resources. stop() must be called
-	 * before this if start() was called earlier */
-	void (*power_down)(struct ath10k *ar);
-
 	int (*suspend)(struct ath10k *ar);
 	int (*resume)(struct ath10k *ar);
 };
@@ -161,14 +156,9 @@ static inline u16 ath10k_hif_get_free_queue_number(struct ath10k *ar,
 	return ar->hif.ops->get_free_queue_number(ar, pipe_id);
 }
 
-static inline int ath10k_hif_power_up(struct ath10k *ar)
-{
-	return ar->hif.ops->power_up(ar);
-}
-
-static inline void ath10k_hif_power_down(struct ath10k *ar)
+static inline int ath10k_hif_reset(struct ath10k *ar)
 {
-	ar->hif.ops->power_down(ar);
+	return ar->hif.ops->reset(ar);
 }
 
 static inline int ath10k_hif_suspend(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 75e0aeb..001ff1a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2392,7 +2392,6 @@ void ath10k_halt(struct ath10k *ar)
 	ath10k_scan_finish(ar);
 	ath10k_peer_cleanup_all(ar);
 	ath10k_core_stop(ar);
-	ath10k_hif_power_down(ar);
 
 	spin_lock_bh(&ar->data_lock);
 	list_for_each_entry(arvif, &ar->arvifs, list)
@@ -2495,7 +2494,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		goto err;
 	}
 
-	ret = ath10k_hif_power_up(ar);
+	ret = ath10k_hif_reset(ar);
 	if (ret) {
 		ath10k_err(ar, "Could not init hif: %d\n", ret);
 		goto err_off;
@@ -2504,7 +2503,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	ret = ath10k_core_start(ar, ATH10K_FIRMWARE_MODE_NORMAL);
 	if (ret) {
 		ath10k_err(ar, "Could not init core: %d\n", ret);
-		goto err_power_down;
+		goto err_off;
 	}
 
 	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->pmf_qos, 1);
@@ -2551,9 +2550,6 @@ static int ath10k_start(struct ieee80211_hw *hw)
 err_core_stop:
 	ath10k_core_stop(ar);
 
-err_power_down:
-	ath10k_hif_power_down(ar);
-
 err_off:
 	ar->state = ATH10K_STATE_OFF;
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index a63fe7c..78226a6 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1855,7 +1855,7 @@ static int ath10k_pci_chip_reset(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_pci_hif_power_up(struct ath10k *ar)
+static int ath10k_pci_hif_reset(struct ath10k *ar)
 {
 	int ret;
 
@@ -1904,13 +1904,6 @@ err:
 	return ret;
 }
 
-static void ath10k_pci_hif_power_down(struct ath10k *ar)
-{
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif power down\n");
-
-	ath10k_pci_warm_reset(ar);
-}
-
 #ifdef CONFIG_PM
 
 #define ATH10K_PCI_PM_CONTROL 0x44
@@ -1964,6 +1957,7 @@ static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.tx_sg			= ath10k_pci_hif_tx_sg,
 	.diag_read		= ath10k_pci_hif_diag_read,
 	.exchange_bmi_msg	= ath10k_pci_hif_exchange_bmi_msg,
+	.reset			= ath10k_pci_hif_reset,
 	.start			= ath10k_pci_hif_start,
 	.stop			= ath10k_pci_hif_stop,
 	.map_service_to_pipe	= ath10k_pci_hif_map_service_to_pipe,
@@ -1971,8 +1965,6 @@ static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.send_complete_check	= ath10k_pci_hif_send_complete_check,
 	.set_callbacks		= ath10k_pci_hif_set_callbacks,
 	.get_free_queue_number	= ath10k_pci_hif_get_free_queue_number,
-	.power_up		= ath10k_pci_hif_power_up,
-	.power_down		= ath10k_pci_hif_power_down,
 #ifdef CONFIG_PM
 	.suspend		= ath10k_pci_hif_suspend,
 	.resume			= ath10k_pci_hif_resume,
diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index 483db9c..0bb3df6 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -195,7 +195,7 @@ static int ath10k_tm_cmd_utf_start(struct ath10k *ar, struct nlattr *tb[])
 	memset(ar->fw_features, 0, sizeof(ar->fw_features));
 	__set_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features);
 
-	ret = ath10k_hif_power_up(ar);
+	ret = ath10k_hif_reset(ar);
 	if (ret) {
 		ath10k_err(ar, "failed to power up hif (testmode): %d\n", ret);
 		ar->state = ATH10K_STATE_OFF;
@@ -206,7 +206,7 @@ static int ath10k_tm_cmd_utf_start(struct ath10k *ar, struct nlattr *tb[])
 	if (ret) {
 		ath10k_err(ar, "failed to start core (testmode): %d\n", ret);
 		ar->state = ATH10K_STATE_OFF;
-		goto err_power_down;
+		goto err_fw_features;
 	}
 
 	ar->state = ATH10K_STATE_UTF;
@@ -217,9 +217,6 @@ static int ath10k_tm_cmd_utf_start(struct ath10k *ar, struct nlattr *tb[])
 
 	return 0;
 
-err_power_down:
-	ath10k_hif_power_down(ar);
-
 err_fw_features:
 	/* return the original firmware features */
 	memcpy(ar->fw_features, ar->testmode.orig_fw_features,
@@ -239,7 +236,6 @@ static void __ath10k_tm_cmd_utf_stop(struct ath10k *ar)
 	lockdep_assert_held(&ar->conf_mutex);
 
 	ath10k_core_stop(ar);
-	ath10k_hif_power_down(ar);
 
 	spin_lock_bh(&ar->data_lock);
 
-- 
1.8.5.3

