Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab2BMKXw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:23:52 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 05/24] iwlegacy: regulatory_bands is not an ops
Date: Mon, 13 Feb 2012 11:23:12 +0100
Message-Id: <1329128611-6815-6-git-send-email-sgruszka@redhat.com> (sfid-20120213_112355_959964_AB290E5F)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945.c   |   39 ++++++++++++++++++++-----------
 drivers/net/wireless/iwlegacy/4965.c   |   19 +++++++++------
 drivers/net/wireless/iwlegacy/common.c |   10 +++-----
 drivers/net/wireless/iwlegacy/common.h |    3 +-
 4 files changed, 42 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 6c1ae5f..66a5dc0 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -2646,18 +2646,9 @@ static struct il_lib_ops il3945_lib = {
 		    .config = il3945_nic_config,
 		    },
 	.eeprom_ops = {
-		       .regulatory_bands = {
-					    EEPROM_REGULATORY_BAND_1_CHANNELS,
-					    EEPROM_REGULATORY_BAND_2_CHANNELS,
-					    EEPROM_REGULATORY_BAND_3_CHANNELS,
-					    EEPROM_REGULATORY_BAND_4_CHANNELS,
-					    EEPROM_REGULATORY_BAND_5_CHANNELS,
-					    EEPROM_REGULATORY_BAND_NO_HT40,
-					    EEPROM_REGULATORY_BAND_NO_HT40,
-					    },
-		       .acquire_semaphore = il3945_eeprom_acquire_semaphore,
-		       .release_semaphore = il3945_eeprom_release_semaphore,
-		       },
+		.acquire_semaphore = il3945_eeprom_acquire_semaphore,
+		.release_semaphore = il3945_eeprom_release_semaphore,
+	},
 	.send_tx_power = il3945_send_tx_power,
 	.is_valid_rtc_data_addr = il3945_hw_valid_rtc_data_addr,
 
@@ -2707,7 +2698,17 @@ static struct il_cfg il3945_bg_cfg = {
 	.set_l0s = false,
 	.use_bsm = true,
 	.led_compensation = 64,
-	.wd_timeout = IL_DEF_WD_TIMEOUT
+	.wd_timeout = IL_DEF_WD_TIMEOUT,
+
+	.regulatory_bands = {
+		EEPROM_REGULATORY_BAND_1_CHANNELS,
+		EEPROM_REGULATORY_BAND_2_CHANNELS,
+		EEPROM_REGULATORY_BAND_3_CHANNELS,
+		EEPROM_REGULATORY_BAND_4_CHANNELS,
+		EEPROM_REGULATORY_BAND_5_CHANNELS,
+		EEPROM_REGULATORY_BAND_NO_HT40,
+		EEPROM_REGULATORY_BAND_NO_HT40,
+	},
 };
 
 static struct il_cfg il3945_abg_cfg = {
@@ -2726,7 +2727,17 @@ static struct il_cfg il3945_abg_cfg = {
 	.set_l0s = false,
 	.use_bsm = true,
 	.led_compensation = 64,
-	.wd_timeout = IL_DEF_WD_TIMEOUT
+	.wd_timeout = IL_DEF_WD_TIMEOUT,
+
+	.regulatory_bands = {
+		EEPROM_REGULATORY_BAND_1_CHANNELS,
+		EEPROM_REGULATORY_BAND_2_CHANNELS,
+		EEPROM_REGULATORY_BAND_3_CHANNELS,
+		EEPROM_REGULATORY_BAND_4_CHANNELS,
+		EEPROM_REGULATORY_BAND_5_CHANNELS,
+		EEPROM_REGULATORY_BAND_NO_HT40,
+		EEPROM_REGULATORY_BAND_NO_HT40,
+	},
 };
 
 DEFINE_PCI_DEVICE_TABLE(il3945_hw_card_ids) = {
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 79e4e79..aea84bf 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -2217,14 +2217,6 @@ static struct il_lib_ops il4965_lib = {
 		    .config = il4965_nic_config,
 		    },
 	.eeprom_ops = {
-		       .regulatory_bands = {
-					    EEPROM_REGULATORY_BAND_1_CHANNELS,
-					    EEPROM_REGULATORY_BAND_2_CHANNELS,
-					    EEPROM_REGULATORY_BAND_3_CHANNELS,
-					    EEPROM_REGULATORY_BAND_4_CHANNELS,
-					    EEPROM_REGULATORY_BAND_5_CHANNELS,
-					    EEPROM_4965_REGULATORY_BAND_24_HT40_CHANNELS,
-					    EEPROM_4965_REGULATORY_BAND_52_HT40_CHANNELS},
 		       .acquire_semaphore = il4965_eeprom_acquire_semaphore,
 		       .release_semaphore = il4965_eeprom_release_semaphore,
 		       },
@@ -2288,6 +2280,17 @@ struct il_cfg il4965_cfg = {
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
+
+	.regulatory_bands = {
+		EEPROM_REGULATORY_BAND_1_CHANNELS,
+		EEPROM_REGULATORY_BAND_2_CHANNELS,
+		EEPROM_REGULATORY_BAND_3_CHANNELS,
+		EEPROM_REGULATORY_BAND_4_CHANNELS,
+		EEPROM_REGULATORY_BAND_5_CHANNELS,
+		EEPROM_4965_REGULATORY_BAND_24_HT40_CHANNELS,
+		EEPROM_4965_REGULATORY_BAND_52_HT40_CHANNELS
+	},
+
 };
 
 /* Module firmware */
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 50308da..5a7ad52 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -798,8 +798,8 @@ il_init_band_reference(const struct il_priv *il, int eep_band,
 		       const struct il_eeprom_channel **eeprom_ch_info,
 		       const u8 **eeprom_ch_idx)
 {
-	u32 offset =
-	    il->ops->lib->eeprom_ops.regulatory_bands[eep_band - 1];
+	u32 offset = il->cfg->regulatory_bands[eep_band - 1];
+
 	switch (eep_band) {
 	case 1:		/* 2.4GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(il_eeprom_band_1);
@@ -1000,10 +1000,8 @@ il_init_channel_map(struct il_priv *il)
 	}
 
 	/* Check if we do have HT40 channels */
-	if (il->ops->lib->eeprom_ops.regulatory_bands[5] ==
-	    EEPROM_REGULATORY_BAND_NO_HT40 &&
-	    il->ops->lib->eeprom_ops.regulatory_bands[6] ==
-	    EEPROM_REGULATORY_BAND_NO_HT40)
+	if (il->cfg->regulatory_bands[5] == EEPROM_REGULATORY_BAND_NO_HT40 &&
+	    il->cfg->regulatory_bands[6] == EEPROM_REGULATORY_BAND_NO_HT40)
 		return 0;
 
 	/* Two additional EEPROM bands for 2.4 and 5 GHz HT40 channels */
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index fd2a4ee..37bc406 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -426,7 +426,6 @@ struct il_eeprom_calib_info {
 #define EEPROM_REGULATORY_BAND_NO_HT40			(0)
 
 struct il_eeprom_ops {
-	const u32 regulatory_bands[7];
 	int (*acquire_semaphore) (struct il_priv *il);
 	void (*release_semaphore) (struct il_priv *il);
 };
@@ -1769,6 +1768,8 @@ struct il_cfg {
 	const bool ucode_tracing;
 	const bool sensitivity_calib_by_driver;
 	const bool chain_noise_calib_by_driver;
+
+	const u32 regulatory_bands[7];
 };
 
 /***************************
-- 
1.7.1

