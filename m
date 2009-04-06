Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59599 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357AbZDFUQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 16:16:07 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 2/5] wireless: rename IEEE80211_CHAN_NO_FAT_* to HT40-/+
Date: Mon,  6 Apr 2009 16:15:55 -0400
Message-Id: <1239048958-11775-3-git-send-email-lrodriguez@atheros.com> (sfid-20090406_221616_762899_97C24EB2)
In-Reply-To: <1239048958-11775-1-git-send-email-lrodriguez@atheros.com>
References: <1239048958-11775-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is more consistent with our nl80211 naming convention
for HT40-/+.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    8 ++++----
 include/net/wireless.h                    |   10 +++++-----
 net/mac80211/mlme.c                       |    4 ++--
 net/wireless/reg.c                        |    8 ++++----
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c54fb93..d558797 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -591,10 +591,10 @@ static u8 iwl_is_channel_extension(struct iwl_priv *priv,
 
 	if (extension_chan_offset == IEEE80211_HT_PARAM_CHA_SEC_ABOVE)
 		return !(ch_info->fat_extension_channel &
-					IEEE80211_CHAN_NO_FAT_ABOVE);
+					IEEE80211_CHAN_NO_HT40PLUS);
 	else if (extension_chan_offset == IEEE80211_HT_PARAM_CHA_SEC_BELOW)
 		return !(ch_info->fat_extension_channel &
-					IEEE80211_CHAN_NO_FAT_BELOW);
+					IEEE80211_CHAN_NO_HT40MINUS);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 75517d0..9d73f19 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -481,8 +481,8 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 			/* First write that fat is not enabled, and then enable
 			 * one by one */
 			ch_info->fat_extension_channel =
-				(IEEE80211_CHAN_NO_FAT_ABOVE |
-				 IEEE80211_CHAN_NO_FAT_BELOW);
+				(IEEE80211_CHAN_NO_HT40PLUS |
+				 IEEE80211_CHAN_NO_HT40MINUS);
 
 			if (!(is_channel_valid(ch_info))) {
 				IWL_DEBUG_INFO(priv, "Ch. %d Flags %x [%sGHz] - "
@@ -561,7 +561,7 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 				fat_extension_chan = 0;
 			else
 				fat_extension_chan =
-					IEEE80211_CHAN_NO_FAT_BELOW;
+					IEEE80211_CHAN_NO_HT40MINUS;
 
 			/* Set up driver's info for lower half */
 			iwl_set_fat_chan_info(priv, ieeeband,
@@ -573,7 +573,7 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 			iwl_set_fat_chan_info(priv, ieeeband,
 						(eeprom_ch_index[ch] + 4),
 						&(eeprom_ch_info[ch]),
-						IEEE80211_CHAN_NO_FAT_ABOVE);
+						IEEE80211_CHAN_NO_HT40PLUS);
 		}
 	}
 
diff --git a/include/net/wireless.h b/include/net/wireless.h
index 5211f5d..bb0a8f0 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -40,9 +40,9 @@ enum ieee80211_band {
  *	on this channel.
  * @IEEE80211_CHAN_NO_IBSS: IBSS is not allowed on this channel.
  * @IEEE80211_CHAN_RADAR: Radar detection is required on this channel.
- * @IEEE80211_CHAN_NO_FAT_ABOVE: extension channel above this channel
+ * @IEEE80211_CHAN_NO_HT40PLUS: extension channel above this channel
  * 	is not permitted.
- * @IEEE80211_CHAN_NO_FAT_BELOW: extension channel below this channel
+ * @IEEE80211_CHAN_NO_HT40MINUS: extension channel below this channel
  * 	is not permitted.
  */
 enum ieee80211_channel_flags {
@@ -50,12 +50,12 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_PASSIVE_SCAN	= 1<<1,
 	IEEE80211_CHAN_NO_IBSS		= 1<<2,
 	IEEE80211_CHAN_RADAR		= 1<<3,
-	IEEE80211_CHAN_NO_FAT_ABOVE	= 1<<4,
-	IEEE80211_CHAN_NO_FAT_BELOW	= 1<<5,
+	IEEE80211_CHAN_NO_HT40PLUS	= 1<<4,
+	IEEE80211_CHAN_NO_HT40MINUS	= 1<<5,
 };
 
 #define IEEE80211_CHAN_NO_HT40 \
-	(IEEE80211_CHAN_NO_FAT_ABOVE | IEEE80211_CHAN_NO_FAT_BELOW)
+	(IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS)
 
 /**
  * struct ieee80211_channel - channel definition
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7ecda9d..3670014 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -263,13 +263,13 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 
 		switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-			if (flags & IEEE80211_CHAN_NO_FAT_ABOVE) {
+			if (flags & IEEE80211_CHAN_NO_HT40PLUS) {
 				cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 				cap &= ~IEEE80211_HT_CAP_SGI_40;
 			}
 			break;
 		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-			if (flags & IEEE80211_CHAN_NO_FAT_BELOW) {
+			if (flags & IEEE80211_CHAN_NO_HT40MINUS) {
 				cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 				cap &= ~IEEE80211_HT_CAP_SGI_40;
 			}
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b5810a0..8cf2208 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1218,14 +1218,14 @@ static void reg_process_ht_flags_channel(struct wiphy *wiphy,
 	 * to include that as well.
 	 */
 	if (is_ht40_not_allowed(channel_before))
-		channel->flags |= IEEE80211_CHAN_NO_FAT_BELOW;
+		channel->flags |= IEEE80211_CHAN_NO_HT40MINUS;
 	else
-		channel->flags &= ~IEEE80211_CHAN_NO_FAT_BELOW;
+		channel->flags &= ~IEEE80211_CHAN_NO_HT40MINUS;
 
 	if (is_ht40_not_allowed(channel_after))
-		channel->flags |= IEEE80211_CHAN_NO_FAT_ABOVE;
+		channel->flags |= IEEE80211_CHAN_NO_HT40PLUS;
 	else
-		channel->flags &= ~IEEE80211_CHAN_NO_FAT_ABOVE;
+		channel->flags &= ~IEEE80211_CHAN_NO_HT40PLUS;
 }
 
 static void reg_process_ht_flags_band(struct wiphy *wiphy,
-- 
1.6.0.6

