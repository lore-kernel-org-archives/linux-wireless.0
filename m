Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab2LTNcC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 08:32:02 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/3] iwl3945: disable 11a support
Date: Thu, 20 Dec 2012 14:31:52 +0100
Message-Id: <1356010313-9782-2-git-send-email-sgruszka@redhat.com> (sfid-20121220_143208_346303_FEE45543)
In-Reply-To: <1356010313-9782-1-git-send-email-sgruszka@redhat.com>
References: <1356010313-9782-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't believe if there still are users using 11a mode. If they are,
they should probably update their network to something that was
designed in current century, but I also left module option for them.

Having 11a (5GHz band) enabled on 3945 cause non-necessary scan delays.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    6 ++++-
 drivers/net/wireless/iwlegacy/4965-mac.c |    2 +-
 drivers/net/wireless/iwlegacy/common.c   |   36 ++++++++++++++++++-----------
 drivers/net/wireless/iwlegacy/common.h   |    3 +-
 4 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 962400a..7a6ce09 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -88,6 +88,7 @@ struct il_mod_params il3945_mod_params = {
 	.sw_crypto = 1,
 	.restart_fw = 1,
 	.disable_hw_scan = 1,
+	.disable_11a = 1,
 	/* the rest are 0 by default */
 };
 
@@ -3509,7 +3510,8 @@ il3945_init_drv(struct il_priv *il)
 		ret = -EINVAL;
 		goto err;
 	}
-	ret = il_init_channel_map(il);
+
+	ret = il_init_channel_map(il, il3945_mod_params.disable_11a);
 	if (ret) {
 		IL_ERR("initializing regulatory failed: %d\n", ret);
 		goto err;
@@ -3938,6 +3940,8 @@ MODULE_PARM_DESC(debug, "debug output mask");
 #endif
 module_param_named(fw_restart, il3945_mod_params.restart_fw, int, S_IRUGO);
 MODULE_PARM_DESC(fw_restart, "restart firmware in case of error");
+module_param_named(disable_11a, il3945_mod_params.disable_11a, bool, S_IRUGO);
+MODULE_PARM_DESC(disable_11a, "disable 11a support (default true)");
 
 module_exit(il3945_exit);
 module_init(il3945_init);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 7d462d8..eb68c83 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6338,7 +6338,7 @@ il4965_init_drv(struct il_priv *il)
 
 	il_init_scan_params(il);
 
-	ret = il_init_channel_map(il);
+	ret = il_init_channel_map(il, false);
 	if (ret) {
 		IL_ERR("initializing regulatory failed: %d\n", ret);
 		goto err;
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 56b8021..12f5655 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -899,16 +899,18 @@ il_mod_ht40_chan_info(struct il_priv *il, enum ieee80211_band band, u16 channel,
 			    ? # x " " : "")
 
 /**
- * il_init_channel_map - Set up driver's info for all possible channels
+ * il_init_channel_map - Set up driver's info for all possible channels,
+ *			 disable 5GHz channels if requested.
  */
 int
-il_init_channel_map(struct il_priv *il)
+il_init_channel_map(struct il_priv *il, bool disable_5ghz)
 {
 	int eeprom_ch_count = 0;
 	const u8 *eeprom_ch_idx = NULL;
 	const struct il_eeprom_channel *eeprom_ch_info = NULL;
 	int band, ch;
 	struct il_channel_info *ch_info;
+	enum ieee80211_band ieeeband;
 
 	if (il->channel_count) {
 		D_EEPROM("Channel map already initialized.\n");
@@ -917,10 +919,11 @@ il_init_channel_map(struct il_priv *il)
 
 	D_EEPROM("Initializing regulatory info from EEPROM\n");
 
-	il->channel_count =
-	    ARRAY_SIZE(il_eeprom_band_1) + ARRAY_SIZE(il_eeprom_band_2) +
-	    ARRAY_SIZE(il_eeprom_band_3) + ARRAY_SIZE(il_eeprom_band_4) +
-	    ARRAY_SIZE(il_eeprom_band_5);
+	il->channel_count = ARRAY_SIZE(il_eeprom_band_1);
+	if (!disable_5ghz)
+		il->channel_count +=
+		    ARRAY_SIZE(il_eeprom_band_2) + ARRAY_SIZE(il_eeprom_band_3) +
+		    ARRAY_SIZE(il_eeprom_band_4) + ARRAY_SIZE(il_eeprom_band_5);
 
 	D_EEPROM("Parsing data for %d channels.\n", il->channel_count);
 
@@ -939,6 +942,12 @@ il_init_channel_map(struct il_priv *il)
 	 * channel map we maintain (that contains additional information than
 	 * what just in the EEPROM) */
 	for (band = 1; band <= 5; band++) {
+		if (band == 1)
+			ieeeband = IEEE80211_BAND_2GHZ;
+		else if (disable_5ghz)
+			break;
+		else
+			ieeeband = IEEE80211_BAND_5GHZ;
 
 		il_init_band_reference(il, band, &eeprom_ch_count,
 				       &eeprom_ch_info, &eeprom_ch_idx);
@@ -946,9 +955,7 @@ il_init_channel_map(struct il_priv *il)
 		/* Loop through each band adding each of the channels */
 		for (ch = 0; ch < eeprom_ch_count; ch++) {
 			ch_info->channel = eeprom_ch_idx[ch];
-			ch_info->band =
-			    (band ==
-			     1) ? IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+			ch_info->band = ieeeband;
 
 			/* permanently store EEPROM's channel regulatory flags
 			 *   and max power in channel info database. */
@@ -1006,15 +1013,16 @@ il_init_channel_map(struct il_priv *il)
 
 	/* Two additional EEPROM bands for 2.4 and 5 GHz HT40 channels */
 	for (band = 6; band <= 7; band++) {
-		enum ieee80211_band ieeeband;
+		if (band == 6)
+			ieeeband = IEEE80211_BAND_2GHZ;
+		else if (disable_5ghz)
+			break;
+		else
+			ieeeband = IEEE80211_BAND_5GHZ;
 
 		il_init_band_reference(il, band, &eeprom_ch_count,
 				       &eeprom_ch_info, &eeprom_ch_idx);
 
-		/* EEPROM band 6 is 2.4, band 7 is 5 GHz */
-		ieeeband =
-		    (band == 6) ? IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
-
 		/* Loop through each band adding each of the channels */
 		for (ch = 0; ch < eeprom_ch_count; ch++) {
 			/* Set up driver's info for lower half */
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 37fe553..0ab8757 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -429,7 +429,7 @@ int il_eeprom_init(struct il_priv *il);
 void il_eeprom_free(struct il_priv *il);
 const u8 *il_eeprom_query_addr(const struct il_priv *il, size_t offset);
 u16 il_eeprom_query16(const struct il_priv *il, size_t offset);
-int il_init_channel_map(struct il_priv *il);
+int il_init_channel_map(struct il_priv *il, bool disable_5ghz);
 void il_free_channel_map(struct il_priv *il);
 const struct il_channel_info *il_get_channel_info(const struct il_priv *il,
 						  enum ieee80211_band band,
@@ -1601,6 +1601,7 @@ struct il_mod_params {
 	int amsdu_size_8K;	/* def: 1 = enable 8K amsdu size */
 	int antenna;		/* def: 0 = both antennas (use diversity) */
 	int restart_fw;		/* def: 1 = restart firmware */
+	bool disable_11a;	/* def: true = 11a disabled (3945 only) */
 };
 
 #define IL_LED_SOLID 11
-- 
1.7.1

