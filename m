Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:51910 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbbKYNrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 08:47:15 -0500
Subject: [PATCH 4/6] ath10k: split driver info messages during device
 initialisation
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 25 Nov 2015 15:38:27 +0200
Message-ID: <20151125133827.25507.71671.stgit@potku.adurom.net> (sfid-20151125_144725_623025_1C949B10)
In-Reply-To: <20151125133654.25507.10863.stgit@potku.adurom.net>
References: <20151125133654.25507.10863.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Earlier we printed all the info messages after a successful device
initialisation and firmware boot, but that's problematic if something goes
wrong and there's no easy way to know what firmware version was used and so on.

Split the info messages into smaller pieces and print them as soon as we have
the info available.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c  |    6 ++++
 drivers/net/wireless/ath/ath10k/debug.c |   44 ++++++++++++++++++++-----------
 drivers/net/wireless/ath/ath10k/debug.h |    4 +++
 3 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 78fe1863ad04..32917be5a6d9 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1751,6 +1751,8 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		goto err_power_down;
 	}
 
+	ath10k_debug_print_hwfw_info(ar);
+
 	ret = ath10k_core_get_board_id_from_otp(ar);
 	if (ret && ret != -EOPNOTSUPP) {
 		ath10k_err(ar, "failed to get board id from otp: %d\n",
@@ -1764,6 +1766,8 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		goto err_free_firmware_files;
 	}
 
+	ath10k_debug_print_board_info(ar);
+
 	ret = ath10k_core_init_firmware_features(ar);
 	if (ret) {
 		ath10k_err(ar, "fatal problem with firmware features: %d\n",
@@ -1786,7 +1790,7 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		goto err_unlock;
 	}
 
-	ath10k_print_driver_info(ar);
+	ath10k_debug_print_boot_info(ar);
 	ath10k_core_stop(ar);
 
 	mutex_unlock(&ar->conf_mutex);
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 2bc7ae21ade4..ebe3e52cdd1d 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -122,41 +122,48 @@ void ath10k_info(struct ath10k *ar, const char *fmt, ...)
 }
 EXPORT_SYMBOL(ath10k_info);
 
-void ath10k_print_driver_info(struct ath10k *ar)
+void ath10k_debug_print_hwfw_info(struct ath10k *ar)
 {
 	char fw_features[128] = {};
-	char boardinfo[100];
 
 	ath10k_core_get_fw_features_str(ar, fw_features, sizeof(fw_features));
 
-	if (ar->id.bmi_ids_valid)
-		scnprintf(boardinfo, sizeof(boardinfo), "%d:%d",
-			  ar->id.bmi_chip_id, ar->id.bmi_board_id);
-	else
-		scnprintf(boardinfo, sizeof(boardinfo), "N/A");
-
 	ath10k_info(ar, "%s target 0x%08x chip_id 0x%08x sub %04x:%04x",
 		    ar->hw_params.name,
 		    ar->target_version,
 		    ar->chip_id,
 		    ar->id.subsystem_vendor, ar->id.subsystem_device);
 
+	ath10k_info(ar, "kconfig debug %d debugfs %d tracing %d dfs %d testmode %d\n",
+		    config_enabled(CONFIG_ATH10K_DEBUG),
+		    config_enabled(CONFIG_ATH10K_DEBUGFS),
+		    config_enabled(CONFIG_ATH10K_TRACING),
+		    config_enabled(CONFIG_ATH10K_DFS_CERTIFIED),
+		    config_enabled(CONFIG_NL80211_TESTMODE));
+
 	ath10k_info(ar, "firmware ver %s api %d features %s\n",
 		    ar->hw->wiphy->fw_version,
 		    ar->fw_api,
 		    fw_features);
+}
+
+void ath10k_debug_print_board_info(struct ath10k *ar)
+{
+	char boardinfo[100];
+
+	if (ar->id.bmi_ids_valid)
+		scnprintf(boardinfo, sizeof(boardinfo), "%d:%d",
+			  ar->id.bmi_chip_id, ar->id.bmi_board_id);
+	else
+		scnprintf(boardinfo, sizeof(boardinfo), "N/A");
 
 	ath10k_info(ar, "board_file api %d bmi_id %s",
 		    ar->bd_api,
 		    boardinfo);
+}
 
-	ath10k_info(ar, "kconfig debug %d debugfs %d tracing %d dfs %d testmode %d\n",
-		    config_enabled(CONFIG_ATH10K_DEBUG),
-		    config_enabled(CONFIG_ATH10K_DEBUGFS),
-		    config_enabled(CONFIG_ATH10K_TRACING),
-		    config_enabled(CONFIG_ATH10K_DFS_CERTIFIED),
-		    config_enabled(CONFIG_NL80211_TESTMODE));
-
+void ath10k_debug_print_boot_info(struct ath10k *ar)
+{
 	ath10k_info(ar, "htt-ver %d.%d wmi-op %d htt-op %d cal %s max-sta %d raw %d hwcrypto %d\n",
 		    ar->htt.target_version_major,
 		    ar->htt.target_version_minor,
@@ -167,6 +174,13 @@ void ath10k_print_driver_info(struct ath10k *ar)
 		    test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags),
 		    !test_bit(ATH10K_FLAG_HW_CRYPTO_DISABLED, &ar->dev_flags));
 }
+
+void ath10k_print_driver_info(struct ath10k *ar)
+{
+	ath10k_debug_print_hwfw_info(ar);
+	ath10k_debug_print_board_info(ar);
+	ath10k_debug_print_boot_info(ar);
+}
 EXPORT_SYMBOL(ath10k_print_driver_info);
 
 void ath10k_err(struct ath10k *ar, const char *fmt, ...)
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 7de780c4ec8d..814719cf4f22 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -63,6 +63,10 @@ extern unsigned int ath10k_debug_mask;
 __printf(2, 3) void ath10k_info(struct ath10k *ar, const char *fmt, ...);
 __printf(2, 3) void ath10k_err(struct ath10k *ar, const char *fmt, ...);
 __printf(2, 3) void ath10k_warn(struct ath10k *ar, const char *fmt, ...);
+
+void ath10k_debug_print_hwfw_info(struct ath10k *ar);
+void ath10k_debug_print_board_info(struct ath10k *ar);
+void ath10k_debug_print_boot_info(struct ath10k *ar);
 void ath10k_print_driver_info(struct ath10k *ar);
 
 #ifdef CONFIG_ATH10K_DEBUGFS

