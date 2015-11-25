Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:49897 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbbKYNiP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 08:38:15 -0500
Subject: [PATCH 2/6] ath10k: reorganise hardware and firmware info messages
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 25 Nov 2015 15:38:12 +0200
Message-ID: <20151125133812.25507.45550.stgit@potku.adurom.net> (sfid-20151125_143818_148193_4BE66394)
In-Reply-To: <20151125133654.25507.10863.stgit@potku.adurom.net>
References: <20151125133654.25507.10863.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is to make it easier to split them later and also make room for crc32
checksums.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 145c066b5087..4c0e0a1ef0f1 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -136,14 +136,28 @@ void ath10k_print_driver_info(struct ath10k *ar)
 		scnprintf(boardinfo, sizeof(boardinfo), "sub %04x:%04x",
 			  ar->id.subsystem_vendor, ar->id.subsystem_device);
 
-	ath10k_info(ar, "%s (0x%08x, 0x%08x %s) fw %s fwapi %d bdapi %d htt-ver %d.%d wmi-op %d htt-op %d cal %s max-sta %d raw %d hwcrypto %d features %s\n",
+	ath10k_info(ar, "%s target 0x%08x chip_id 0x%08x %s",
 		    ar->hw_params.name,
 		    ar->target_version,
 		    ar->chip_id,
-		    boardinfo,
+		    boardinfo);
+
+	ath10k_info(ar, "firmware ver %s api %d features %s\n",
 		    ar->hw->wiphy->fw_version,
 		    ar->fw_api,
-		    ar->bd_api,
+		    fw_features);
+
+	ath10k_info(ar, "board_file api %d",
+		    ar->bd_api);
+
+	ath10k_info(ar, "kconfig debug %d debugfs %d tracing %d dfs %d testmode %d\n",
+		    config_enabled(CONFIG_ATH10K_DEBUG),
+		    config_enabled(CONFIG_ATH10K_DEBUGFS),
+		    config_enabled(CONFIG_ATH10K_TRACING),
+		    config_enabled(CONFIG_ATH10K_DFS_CERTIFIED),
+		    config_enabled(CONFIG_NL80211_TESTMODE));
+
+	ath10k_info(ar, "htt-ver %d.%d wmi-op %d htt-op %d cal %s max-sta %d raw %d hwcrypto %d\n",
 		    ar->htt.target_version_major,
 		    ar->htt.target_version_minor,
 		    ar->wmi.op_version,
@@ -151,14 +165,7 @@ void ath10k_print_driver_info(struct ath10k *ar)
 		    ath10k_cal_mode_str(ar->cal_mode),
 		    ar->max_num_stations,
 		    test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags),
-		    !test_bit(ATH10K_FLAG_HW_CRYPTO_DISABLED, &ar->dev_flags),
-		    fw_features);
-	ath10k_info(ar, "debug %d debugfs %d tracing %d dfs %d testmode %d\n",
-		    config_enabled(CONFIG_ATH10K_DEBUG),
-		    config_enabled(CONFIG_ATH10K_DEBUGFS),
-		    config_enabled(CONFIG_ATH10K_TRACING),
-		    config_enabled(CONFIG_ATH10K_DFS_CERTIFIED),
-		    config_enabled(CONFIG_NL80211_TESTMODE));
+		    !test_bit(ATH10K_FLAG_HW_CRYPTO_DISABLED, &ar->dev_flags));
 }
 EXPORT_SYMBOL(ath10k_print_driver_info);
 

