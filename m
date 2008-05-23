Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:42800 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758726AbYEWCLd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:33 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: remove 4965 remainings in iwl-eeprom.c file
Date: Fri, 23 May 2008 10:09:01 +0800
Message-Id: <1211508569-3163-24-git-send-email-yi.zhu@intel.com> (sfid-20080523_042834_705157_8A095064)
In-Reply-To: <1211508569-3163-23-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-13-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-14-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-15-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-16-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-17-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-18-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-19-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-20-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-21-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-22-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-23-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

The patch cleans up 4965 remaings from iwl-eeprom.c file.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index fa30660..300ef8e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -365,11 +365,11 @@ static void iwl_init_band_reference(const struct iwl_priv *priv,
 			    ? # x " " : "")
 
 /**
- * iwl4965_set_fat_chan_info - Copy fat channel info into driver's priv.
+ * iwl_set_fat_chan_info - Copy fat channel info into driver's priv.
  *
  * Does not set up a command, or touch hardware.
  */
-static int iwl4965_set_fat_chan_info(struct iwl_priv *priv,
+static int iwl_set_fat_chan_info(struct iwl_priv *priv,
 			      enum ieee80211_band band, u16 channel,
 			      const struct iwl_eeprom_channel *eeprom_ch,
 			      u8 fat_extension_channel)
@@ -542,16 +542,16 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 				fat_extension_chan = HT_IE_EXT_CHANNEL_ABOVE;
 
 			/* Set up driver's info for lower half */
-			iwl4965_set_fat_chan_info(priv, ieeeband,
-						  eeprom_ch_index[ch],
-						  &(eeprom_ch_info[ch]),
-						  fat_extension_chan);
+			iwl_set_fat_chan_info(priv, ieeeband,
+						eeprom_ch_index[ch],
+						&(eeprom_ch_info[ch]),
+						fat_extension_chan);
 
 			/* Set up driver's info for upper half */
-			iwl4965_set_fat_chan_info(priv, ieeeband,
-						  (eeprom_ch_index[ch] + 4),
-						  &(eeprom_ch_info[ch]),
-						  HT_IE_EXT_CHANNEL_BELOW);
+			iwl_set_fat_chan_info(priv, ieeeband,
+						(eeprom_ch_index[ch] + 4),
+						&(eeprom_ch_info[ch]),
+						HT_IE_EXT_CHANNEL_BELOW);
 		}
 	}
 
@@ -560,7 +560,7 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 EXPORT_SYMBOL(iwl_init_channel_map);
 
 /*
- * iwl_free_channel_map - undo allocations in iwl4965_init_channel_map
+ * iwl_free_channel_map - undo allocations in iwl_init_channel_map
  */
 void iwl_free_channel_map(struct iwl_priv *priv)
 {
-- 
1.5.3.6

