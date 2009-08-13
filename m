Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:11292 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394AbZHMUbP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 16:31:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/13] iwlwifi: cleanup HT40 extension channels setup
Date: Thu, 13 Aug 2009 13:30:53 -0700
Message-Id: <1250195462-15811-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
References: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

The patch cleans up the HT40 extension channels setup for EEPROM
band 6 and 7 to make it more readable.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |   37 +++++++++-------------------
 1 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 78c4a32..ded6332 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -484,14 +484,14 @@ static void iwl_init_band_reference(const struct iwl_priv *priv,
 			    ? # x " " : "")
 
 /**
- * iwl_set_ht40_chan_info - Copy ht40 channel info into driver's priv.
+ * iwl_mod_ht40_chan_info - Copy ht40 channel info into driver's priv.
  *
  * Does not set up a command, or touch hardware.
  */
-static int iwl_set_ht40_chan_info(struct iwl_priv *priv,
+static int iwl_mod_ht40_chan_info(struct iwl_priv *priv,
 			      enum ieee80211_band band, u16 channel,
 			      const struct iwl_eeprom_channel *eeprom_ch,
-			      u8 ht40_extension_channel)
+			      u8 clear_ht40_extension_channel)
 {
 	struct iwl_channel_info *ch_info;
 
@@ -523,7 +523,7 @@ static int iwl_set_ht40_chan_info(struct iwl_priv *priv,
 	ch_info->ht40_min_power = 0;
 	ch_info->ht40_scan_power = eeprom_ch->max_power_avg;
 	ch_info->ht40_flags = eeprom_ch->flags;
-	ch_info->ht40_extension_channel = ht40_extension_channel;
+	ch_info->ht40_extension_channel &= ~clear_ht40_extension_channel;
 
 	return 0;
 }
@@ -592,8 +592,7 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 			/* First write that ht40 is not enabled, and then enable
 			 * one by one */
 			ch_info->ht40_extension_channel =
-				(IEEE80211_CHAN_NO_HT40PLUS |
-				 IEEE80211_CHAN_NO_HT40MINUS);
+					IEEE80211_CHAN_NO_HT40;
 
 			if (!(is_channel_valid(ch_info))) {
 				IWL_DEBUG_INFO(priv, "Ch. %d Flags %x [%sGHz] - "
@@ -652,7 +651,6 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 	/* Two additional EEPROM bands for 2.4 and 5 GHz HT40 channels */
 	for (band = 6; band <= 7; band++) {
 		enum ieee80211_band ieeeband;
-		u8 ht40_extension_chan;
 
 		iwl_init_band_reference(priv, band, &eeprom_ch_count,
 					&eeprom_ch_info, &eeprom_ch_index);
@@ -663,28 +661,17 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 
 		/* Loop through each band adding each of the channels */
 		for (ch = 0; ch < eeprom_ch_count; ch++) {
-
-			if ((band == 6) &&
-				((eeprom_ch_index[ch] == 5) ||
-				 (eeprom_ch_index[ch] == 6) ||
-				 (eeprom_ch_index[ch] == 7)))
-				/* both are allowed: above and below */
-				ht40_extension_chan = 0;
-			else
-				ht40_extension_chan =
-					IEEE80211_CHAN_NO_HT40MINUS;
-
 			/* Set up driver's info for lower half */
-			iwl_set_ht40_chan_info(priv, ieeeband,
+			iwl_mod_ht40_chan_info(priv, ieeeband,
 						eeprom_ch_index[ch],
-						&(eeprom_ch_info[ch]),
-						ht40_extension_chan);
+						&eeprom_ch_info[ch],
+						IEEE80211_CHAN_NO_HT40PLUS);
 
 			/* Set up driver's info for upper half */
-			iwl_set_ht40_chan_info(priv, ieeeband,
-						(eeprom_ch_index[ch] + 4),
-						&(eeprom_ch_info[ch]),
-						IEEE80211_CHAN_NO_HT40PLUS);
+			iwl_mod_ht40_chan_info(priv, ieeeband,
+						eeprom_ch_index[ch] + 4,
+						&eeprom_ch_info[ch],
+						IEEE80211_CHAN_NO_HT40MINUS);
 		}
 	}
 
-- 
1.5.6.3

