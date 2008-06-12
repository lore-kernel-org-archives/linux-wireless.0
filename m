Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20549 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbYFLBtl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:41 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 10/29] iwlwifi: remove redundant flags regarding to FAT channel
Date: Thu, 12 Jun 2008 09:47:00 +0800
Message-Id: <1213235239-2954-11-git-send-email-yi.zhu@intel.com> (sfid-20080612_041913_862798_D3CCD01E)
In-Reply-To: <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-9-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch removes redundant flags regarding to FAT channel. Use
mac80211's flag instead.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |   42 ++++++++------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   14 ---------
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |   19 ++++++++----
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    6 ++-
 include/linux/ieee80211.h                   |    1 +
 5 files changed, 31 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6c7617c..fad26f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -478,24 +478,7 @@ static int iwlcore_init_geos(struct iwl_priv *priv)
 			if (ch->flags & EEPROM_CHANNEL_RADAR)
 				geo_ch->flags |= IEEE80211_CHAN_RADAR;
 
-			switch (ch->fat_extension_channel) {
-			case HT_IE_EXT_CHANNEL_ABOVE:
-				/* only above is allowed, disable below */
-				geo_ch->flags |= IEEE80211_CHAN_NO_FAT_BELOW;
-				break;
-			case HT_IE_EXT_CHANNEL_BELOW:
-				/* only below is allowed, disable above */
-				geo_ch->flags |= IEEE80211_CHAN_NO_FAT_ABOVE;
-				break;
-			case HT_IE_EXT_CHANNEL_NONE:
-				/* fat not allowed: disable both*/
-				geo_ch->flags |= (IEEE80211_CHAN_NO_FAT_ABOVE |
-						  IEEE80211_CHAN_NO_FAT_BELOW);
-				break;
-			case HT_IE_EXT_CHANNEL_MAX:
-				/* both above and below are permitted */
-				break;
-			}
+			geo_ch->flags |= ch->fat_extension_channel;
 
 			if (ch->max_power_avg > priv->max_channel_txpower_limit)
 				priv->max_channel_txpower_limit =
@@ -507,7 +490,7 @@ static int iwlcore_init_geos(struct iwl_priv *priv)
 		/* Save flags for reg domain usage */
 		geo_ch->orig_flags = geo_ch->flags;
 
-		IWL_DEBUG_INFO("Channel %d Freq=%d[%sGHz] %s flag=0%X\n",
+		IWL_DEBUG_INFO("Channel %d Freq=%d[%sGHz] %s flag=0x%X\n",
 				ch->channel, geo_ch->center_freq,
 				is_channel_a_band(ch) ?  "5.2" : "2.4",
 				geo_ch->flags & IEEE80211_CHAN_DISABLED ?
@@ -552,6 +535,7 @@ static u8 is_single_rx_stream(struct iwl_priv *priv)
 		(priv->current_ht_config.supp_mcs_set[2] == 0)) ||
 	       priv->ps_mode == IWL_MIMO_PS_STATIC;
 }
+
 static u8 iwl_is_channel_extension(struct iwl_priv *priv,
 				   enum ieee80211_band band,
 				   u16 channel, u8 extension_chan_offset)
@@ -562,12 +546,12 @@ static u8 iwl_is_channel_extension(struct iwl_priv *priv,
 	if (!is_channel_valid(ch_info))
 		return 0;
 
-	if (extension_chan_offset == IWL_EXT_CHANNEL_OFFSET_NONE)
-		return 0;
-
-	if ((ch_info->fat_extension_channel == extension_chan_offset) ||
-	    (ch_info->fat_extension_channel == HT_IE_EXT_CHANNEL_MAX))
-		return 1;
+	if (extension_chan_offset == IEEE80211_HT_IE_CHA_SEC_ABOVE)
+		return !(ch_info->fat_extension_channel &
+					IEEE80211_CHAN_NO_FAT_ABOVE);
+	else if (extension_chan_offset == IEEE80211_HT_IE_CHA_SEC_BELOW)
+		return !(ch_info->fat_extension_channel &
+					IEEE80211_CHAN_NO_FAT_BELOW);
 
 	return 0;
 }
@@ -579,7 +563,7 @@ u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
 
 	if ((!iwl_ht_conf->is_ht) ||
 	   (iwl_ht_conf->supported_chan_width != IWL_CHANNEL_WIDTH_40MHZ) ||
-	   (iwl_ht_conf->extension_chan_offset == IWL_EXT_CHANNEL_OFFSET_NONE))
+	   (iwl_ht_conf->extension_chan_offset == IEEE80211_HT_IE_CHA_SEC_NONE))
 		return 0;
 
 	if (sta_ht_inf) {
@@ -619,13 +603,13 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 
 	/* Note: control channel is opposite of extension channel */
 	switch (ht_info->extension_chan_offset) {
-	case IWL_EXT_CHANNEL_OFFSET_ABOVE:
+	case IEEE80211_HT_IE_CHA_SEC_ABOVE:
 		rxon->flags &= ~(RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
 		break;
-	case IWL_EXT_CHANNEL_OFFSET_BELOW:
+	case IEEE80211_HT_IE_CHA_SEC_BELOW:
 		rxon->flags |= RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK;
 		break;
-	case IWL_EXT_CHANNEL_OFFSET_NONE:
+	case IEEE80211_HT_IE_CHA_SEC_NONE:
 	default:
 		rxon->flags &= ~RXON_FLG_CHANNEL_MODE_MIXED_MSK;
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index fa35193..daa14d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -179,15 +179,6 @@ struct iwl4965_scan_power_info {
 	s8 requested_power;	/* scan pwr (dBm) requested for chnl/rate */
 };
 
-/* For fat_extension_channel */
-enum {
-	HT_IE_EXT_CHANNEL_NONE = 0,
-	HT_IE_EXT_CHANNEL_ABOVE,
-	HT_IE_EXT_CHANNEL_INVALID,
-	HT_IE_EXT_CHANNEL_BELOW,
-	HT_IE_EXT_CHANNEL_MAX
-};
-
 /*
  * One for each channel, holds all channel setup data
  * Some of the fields (e.g. eeprom and flags/max_power_avg) are redundant
@@ -782,11 +773,6 @@ struct iwl_kw {
 #define IWL_OPERATION_MODE_MIXED    2
 #define IWL_OPERATION_MODE_20MHZ    3
 
-#define IWL_EXT_CHANNEL_OFFSET_NONE      0
-#define IWL_EXT_CHANNEL_OFFSET_ABOVE     1
-#define IWL_EXT_CHANNEL_OFFSET_RESERVE1  2
-#define IWL_EXT_CHANNEL_OFFSET_BELOW     3
-
 #define IWL_TX_CRC_SIZE 4
 #define IWL_TX_DELIMITER_SIZE 4
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 11f9d95..cbb812f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -470,6 +470,11 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 			/* Copy the run-time flags so they are there even on
 			 * invalid channels */
 			ch_info->flags = eeprom_ch_info[ch].flags;
+			/* First write that fat is not enabled, and then enable
+			 * one by one */
+			ch_info->fat_extension_channel =
+				(IEEE80211_CHAN_NO_FAT_ABOVE |
+				 IEEE80211_CHAN_NO_FAT_BELOW);
 
 			if (!(is_channel_valid(ch_info))) {
 				IWL_DEBUG_INFO("Ch. %d Flags %x [%sGHz] - "
@@ -534,12 +539,14 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 		for (ch = 0; ch < eeprom_ch_count; ch++) {
 
 			if ((band == 6) &&
-			    ((eeprom_ch_index[ch] == 5) ||
-			    (eeprom_ch_index[ch] == 6) ||
-			    (eeprom_ch_index[ch] == 7)))
-			       fat_extension_chan = HT_IE_EXT_CHANNEL_MAX;
+				((eeprom_ch_index[ch] == 5) ||
+				 (eeprom_ch_index[ch] == 6) ||
+				 (eeprom_ch_index[ch] == 7)))
+				/* both are allowed: above and below */
+				fat_extension_chan = 0;
 			else
-				fat_extension_chan = HT_IE_EXT_CHANNEL_ABOVE;
+				fat_extension_chan =
+					IEEE80211_CHAN_NO_FAT_BELOW;
 
 			/* Set up driver's info for lower half */
 			iwl_set_fat_chan_info(priv, ieeeband,
@@ -551,7 +558,7 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 			iwl_set_fat_chan_info(priv, ieeeband,
 						(eeprom_ch_index[ch] + 4),
 						&(eeprom_ch_info[ch]),
-						HT_IE_EXT_CHANNEL_BELOW);
+						IEEE80211_CHAN_NO_FAT_ABOVE);
 		}
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 0acd42b..de40e89 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -664,9 +664,11 @@ static void iwl4965_ht_conf(struct iwl_priv *priv,
 	iwl_conf->extension_chan_offset =
 		ht_bss_conf->bss_cap & IEEE80211_HT_IE_CHA_SEC_OFFSET;
 	/* If no above or below channel supplied disable FAT channel */
-	if (iwl_conf->extension_chan_offset != IWL_EXT_CHANNEL_OFFSET_ABOVE &&
-	    iwl_conf->extension_chan_offset != IWL_EXT_CHANNEL_OFFSET_BELOW)
+	if (iwl_conf->extension_chan_offset != IEEE80211_HT_IE_CHA_SEC_ABOVE &&
+	    iwl_conf->extension_chan_offset != IEEE80211_HT_IE_CHA_SEC_BELOW) {
+		iwl_conf->extension_chan_offset = IEEE80211_HT_IE_CHA_SEC_NONE;
 		iwl_conf->supported_chan_width = 0;
+	}
 
 	iwl_conf->tx_mimo_ps_mode =
 		(u8)((ht_conf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2);
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 9300f37..8f2c20b 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -320,6 +320,7 @@ struct ieee80211_ht_addt_info {
 #define IEEE80211_HT_CAP_MCS_TX_UEQM		0x10
 /* 802.11n HT IE masks */
 #define IEEE80211_HT_IE_CHA_SEC_OFFSET		0x03
+#define IEEE80211_HT_IE_CHA_SEC_NONE	 	0x00
 #define IEEE80211_HT_IE_CHA_SEC_ABOVE 		0x01
 #define IEEE80211_HT_IE_CHA_SEC_BELOW 		0x03
 #define IEEE80211_HT_IE_CHA_WIDTH		0x04
-- 
1.5.3.6

