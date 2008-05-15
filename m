Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14451 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbYEOF4h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 01:56:37 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 23/26] iwlwifi: remove 4965 remainings in iwl-eeprom.c file
Date: Thu, 15 May 2008 13:54:15 +0800
Message-Id: <1210830858-3410-24-git-send-email-yi.zhu@intel.com> (sfid-20080515_081615_444486_B2D84E91)
In-Reply-To: <1210830858-3410-23-git-send-email-yi.zhu@intel.com>
References: <1210830858-3410-1-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-2-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-3-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-4-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-5-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-6-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-7-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-8-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-9-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-10-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-11-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-12-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-13-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-14-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-15-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-16-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-17-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-18-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-19-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-20-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-21-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-22-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-23-git-send-email-yi.zhu@intel.com>
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

