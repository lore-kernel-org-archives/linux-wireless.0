Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44238 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757882AbZKXDaP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 22:30:15 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/8] iwmc3200wifi: Parse HT channels EEPROM entries
Date: Tue, 24 Nov 2009 11:33:27 +0800
Message-Id: <1259033613-25600-3-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1259033613-25600-2-git-send-email-yi.zhu@intel.com>
References: <1259033613-25600-1-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

The fat channels eeprom entries let us know if 11n is enabled or not. We
update our wiphy supported bands based on that.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/eeprom.c |   30 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwmc3200wifi/eeprom.h |   28 ++++++++++++++++++-------
 drivers/net/wireless/iwmc3200wifi/main.c   |    6 +++++
 3 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/eeprom.c b/drivers/net/wireless/iwmc3200wifi/eeprom.c
index 365910f..c574f58 100644
--- a/drivers/net/wireless/iwmc3200wifi/eeprom.c
+++ b/drivers/net/wireless/iwmc3200wifi/eeprom.c
@@ -66,6 +66,10 @@ static struct iwm_eeprom_entry eeprom_map[] = {
 	[IWM_EEPROM_SKU_CAP] =
 	{"SKU capabilities", IWM_EEPROM_SKU_CAP_OFF, IWM_EEPROM_SKU_CAP_LEN},
 
+	[IWM_EEPROM_FAT_CHANNELS_CAP] =
+	{"HT channels capabilities", IWM_EEPROM_FAT_CHANNELS_CAP_OFF,
+	 IWM_EEPROM_FAT_CHANNELS_CAP_LEN},
+
 	[IWM_EEPROM_CALIB_RXIQ_OFFSET] =
 	{"RX IQ offset", IWM_EEPROM_CALIB_RXIQ_OFF, IWM_EEPROM_INDIRECT_LEN},
 
@@ -146,6 +150,32 @@ u8 *iwm_eeprom_access(struct iwm_priv *iwm, u8 eeprom_id)
 	return iwm->eeprom + eeprom_map[eeprom_id].offset;
 }
 
+int iwm_eeprom_fat_channels(struct iwm_priv *iwm)
+{
+	struct wiphy *wiphy = iwm_to_wiphy(iwm);
+	struct ieee80211_supported_band *band;
+	u16 *channels, i;
+
+	channels = (u16 *)iwm_eeprom_access(iwm, IWM_EEPROM_FAT_CHANNELS_CAP);
+	if (IS_ERR(channels))
+		return PTR_ERR(channels);
+
+	band = wiphy->bands[IEEE80211_BAND_2GHZ];
+	band->ht_cap.ht_supported = true;
+
+	for (i = 0; i < IWM_EEPROM_FAT_CHANNELS_24; i++)
+		if (!(channels[i] & IWM_EEPROM_FAT_CHANNEL_ENABLED))
+			band->ht_cap.ht_supported = false;
+
+	band = wiphy->bands[IEEE80211_BAND_5GHZ];
+	band->ht_cap.ht_supported = true;
+	for (i = IWM_EEPROM_FAT_CHANNELS_24; i < IWM_EEPROM_FAT_CHANNELS; i++)
+		if (!(channels[i] & IWM_EEPROM_FAT_CHANNEL_ENABLED))
+			band->ht_cap.ht_supported = false;
+
+	return 0;
+}
+
 int iwm_eeprom_init(struct iwm_priv *iwm)
 {
 	int i, ret = 0;
diff --git a/drivers/net/wireless/iwmc3200wifi/eeprom.h b/drivers/net/wireless/iwmc3200wifi/eeprom.h
index cdb31a6..0f7f226 100644
--- a/drivers/net/wireless/iwmc3200wifi/eeprom.h
+++ b/drivers/net/wireless/iwmc3200wifi/eeprom.h
@@ -48,6 +48,7 @@ enum {
 	IWM_EEPROM_CARD_ID,
 	IWM_EEPROM_RADIO_CONF,
 	IWM_EEPROM_SKU_CAP,
+	IWM_EEPROM_FAT_CHANNELS_CAP,
 
 	IWM_EEPROM_INDIRECT_OFFSET,
 	IWM_EEPROM_CALIB_RXIQ_OFFSET = IWM_EEPROM_INDIRECT_OFFSET,
@@ -58,14 +59,15 @@ enum {
 	IWM_EEPROM_LAST,
 };
 
-#define IWM_EEPROM_SIG_OFF             0x00
-#define IWM_EEPROM_VERSION_OFF        (0x54 << 1)
-#define IWM_EEPROM_OEM_HW_VERSION_OFF (0x56 << 1)
-#define IWM_EEPROM_MAC_VERSION_OFF    (0x30 << 1)
-#define IWM_EEPROM_CARD_ID_OFF        (0x5d << 1)
-#define IWM_EEPROM_RADIO_CONF_OFF     (0x58 << 1)
-#define IWM_EEPROM_SKU_CAP_OFF        (0x55 << 1)
-#define IWM_EEPROM_CALIB_CONFIG_OFF   (0x7c << 1)
+#define IWM_EEPROM_SIG_OFF                 0x00
+#define IWM_EEPROM_VERSION_OFF            (0x54 << 1)
+#define IWM_EEPROM_OEM_HW_VERSION_OFF     (0x56 << 1)
+#define IWM_EEPROM_MAC_VERSION_OFF        (0x30 << 1)
+#define IWM_EEPROM_CARD_ID_OFF            (0x5d << 1)
+#define IWM_EEPROM_RADIO_CONF_OFF         (0x58 << 1)
+#define IWM_EEPROM_SKU_CAP_OFF            (0x55 << 1)
+#define IWM_EEPROM_CALIB_CONFIG_OFF       (0x7c << 1)
+#define IWM_EEPROM_FAT_CHANNELS_CAP_OFF   (0xde << 1)
 
 #define IWM_EEPROM_SIG_LEN              4
 #define IWM_EEPROM_VERSION_LEN          2
@@ -74,6 +76,7 @@ enum {
 #define IWM_EEPROM_CARD_ID_LEN          2
 #define IWM_EEPROM_RADIO_CONF_LEN       2
 #define IWM_EEPROM_SKU_CAP_LEN          2
+#define IWM_EEPROM_FAT_CHANNELS_CAP_LEN 40
 #define IWM_EEPROM_INDIRECT_LEN		2
 
 #define IWM_MAX_EEPROM_DATA_LEN         240
@@ -87,6 +90,14 @@ enum {
 #define IWM_EEPROM_SKU_CAP_BAND_52GHZ           (1 << 5)
 #define IWM_EEPROM_SKU_CAP_11N_ENABLE           (1 << 6)
 
+#define IWM_EEPROM_FAT_CHANNELS 20
+/* 2.4 gHz FAT primary channels: 1, 2, 3, 4, 5, 6, 7, 8, 9 */
+#define IWM_EEPROM_FAT_CHANNELS_24 9
+/* 5.2 gHz FAT primary channels: 36,44,52,60,100,108,116,124,132,149,157 */
+#define IWM_EEPROM_FAT_CHANNELS_52 11
+
+#define IWM_EEPROM_FAT_CHANNEL_ENABLED (1 << 0)
+
 enum {
 	IWM_EEPROM_CALIB_CAL_HDR,
 	IWM_EEPROM_CALIB_TX_POWER,
@@ -110,5 +121,6 @@ struct iwm_eeprom_entry {
 int iwm_eeprom_init(struct iwm_priv *iwm);
 void iwm_eeprom_exit(struct iwm_priv *iwm);
 u8 *iwm_eeprom_access(struct iwm_priv *iwm, u8 eeprom_id);
+int iwm_eeprom_fat_channels(struct iwm_priv *iwm);
 
 #endif
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 75f105a..365f3fc 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -691,6 +691,12 @@ static int __iwm_up(struct iwm_priv *iwm)
 		goto err_disable;
 	}
 
+	ret = iwm_eeprom_fat_channels(iwm);
+	if (ret) {
+		IWM_ERR(iwm, "Couldnt read HT channels EEPROM entries\n");
+		goto err_fw;
+	}
+
 	snprintf(wiphy->fw_version, sizeof(wiphy->fw_version), "L%s_U%s",
 		 iwm->lmac_version, iwm->umac_version);
 
-- 
1.6.0.4

