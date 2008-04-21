Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59302 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbYDUWmO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 18:42:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Guy Cohen <guy.cohen@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 06/11] iwlwifi: remove support for Narrow Channel (10Mhz)
Date: Mon, 21 Apr 2008 15:41:56 -0700
Message-Id: <1208817721-11333-7-git-send-email-reinette.chatre@intel.com> (sfid-20080422_004343_057554_9F4AD0E4)
In-Reply-To: <1208817721-11333-6-git-send-email-reinette.chatre@intel.com>
References: <1208817721-11333-1-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-2-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-3-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-4-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-5-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Cohen <guy.cohen@intel.com>

Setting Narrow Channel bit in the scan command caused the device
not to send probe request on all the channels

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    5 -----
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    5 -----
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    6 ++----
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 +-----
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 ---
 7 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index ad612a8..8821c26 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -126,7 +126,7 @@ enum {
 	EEPROM_CHANNEL_ACTIVE = (1 << 3),	/* active scanning allowed */
 	EEPROM_CHANNEL_RADAR = (1 << 4),	/* radar detection required */
 	EEPROM_CHANNEL_WIDE = (1 << 5),		/* 20 MHz channel okay */
-	EEPROM_CHANNEL_NARROW = (1 << 6),	/* 10 MHz channel (not used) */
+	/* Bit 6 Reserved (was Narrow Channel) */
 	EEPROM_CHANNEL_DFS = (1 << 7),	/* dynamic freq selection candidate */
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 45c1c55..fb3247b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -925,11 +925,6 @@ static inline int is_channel_valid(const struct iwl3945_channel_info *ch_info)
 	return (ch_info->flags & EEPROM_CHANNEL_VALID) ? 1 : 0;
 }
 
-static inline int is_channel_narrow(const struct iwl3945_channel_info *ch_info)
-{
-	return (ch_info->flags & EEPROM_CHANNEL_NARROW) ? 1 : 0;
-}
-
 static inline int is_channel_radar(const struct iwl3945_channel_info *ch_info)
 {
 	return (ch_info->flags & EEPROM_CHANNEL_RADAR) ? 1 : 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 86de144..aaec064 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -1228,11 +1228,6 @@ static inline int is_channel_valid(const struct iwl_channel_info *ch_info)
 	return (ch_info->flags & EEPROM_CHANNEL_VALID) ? 1 : 0;
 }
 
-static inline int is_channel_narrow(const struct iwl_channel_info *ch_info)
-{
-	return (ch_info->flags & EEPROM_CHANNEL_NARROW) ? 1 : 0;
-}
-
 static inline int is_channel_radar(const struct iwl_channel_info *ch_info)
 {
 	return (ch_info->flags & EEPROM_CHANNEL_RADAR) ? 1 : 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index a436f87..efd48ca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -377,7 +377,7 @@ static int iwl4965_set_fat_chan_info(struct iwl_priv *priv,
 	if (!is_channel_valid(ch_info))
 		return -1;
 
-	IWL_DEBUG_INFO("FAT Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x"
+	IWL_DEBUG_INFO("FAT Ch. %d [%sGHz] %s%s%s%s%s(0x%02x"
 			" %ddBm): Ad-Hoc %ssupported\n",
 			ch_info->channel,
 			is_channel_a_band(ch_info) ?
@@ -386,7 +386,6 @@ static int iwl4965_set_fat_chan_info(struct iwl_priv *priv,
 			CHECK_AND_PRINT(ACTIVE),
 			CHECK_AND_PRINT(RADAR),
 			CHECK_AND_PRINT(WIDE),
-			CHECK_AND_PRINT(NARROW),
 			CHECK_AND_PRINT(DFS),
 			eeprom_ch->flags,
 			eeprom_ch->max_power_avg,
@@ -490,7 +489,7 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 			ch_info->scan_power = eeprom_ch_info[ch].max_power_avg;
 			ch_info->min_power = 0;
 
-			IWL_DEBUG_INFO("Ch. %d [%sGHz] %s%s%s%s%s%s%s(0x%02x"
+			IWL_DEBUG_INFO("Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x"
 				       " %ddBm): Ad-Hoc %ssupported\n",
 				       ch_info->channel,
 				       is_channel_a_band(ch_info) ?
@@ -500,7 +499,6 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 				       CHECK_AND_PRINT_I(ACTIVE),
 				       CHECK_AND_PRINT_I(RADAR),
 				       CHECK_AND_PRINT_I(WIDE),
-				       CHECK_AND_PRINT_I(NARROW),
 				       CHECK_AND_PRINT_I(DFS),
 				       eeprom_ch_info[ch].flags,
 				       eeprom_ch_info[ch].max_power_avg,
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 26a73e9..d576814 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -106,7 +106,7 @@ enum {
 	EEPROM_CHANNEL_ACTIVE = (1 << 3),	/* active scanning allowed */
 	EEPROM_CHANNEL_RADAR = (1 << 4),	/* radar detection required */
 	EEPROM_CHANNEL_WIDE = (1 << 5),		/* 20 MHz channel okay */
-	EEPROM_CHANNEL_NARROW = (1 << 6),	/* 10 MHz channel (not used) */
+	/* Bit 6 Reserved (was Narrow Channel) */
 	EEPROM_CHANNEL_DFS = (1 << 7),	/* dynamic freq selection candidate */
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 1351e91..94e6c49 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4840,7 +4840,7 @@ static int iwl3945_init_channel_map(struct iwl3945_priv *priv)
 			ch_info->scan_power = eeprom_ch_info[ch].max_power_avg;
 			ch_info->min_power = 0;
 
-			IWL_DEBUG_INFO("Ch. %d [%sGHz] %s%s%s%s%s%s%s(0x%02x"
+			IWL_DEBUG_INFO("Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x"
 				       " %ddBm): Ad-Hoc %ssupported\n",
 				       ch_info->channel,
 				       is_channel_a_band(ch_info) ?
@@ -4850,7 +4850,6 @@ static int iwl3945_init_channel_map(struct iwl3945_priv *priv)
 				       CHECK_AND_PRINT(ACTIVE),
 				       CHECK_AND_PRINT(RADAR),
 				       CHECK_AND_PRINT(WIDE),
-				       CHECK_AND_PRINT(NARROW),
 				       CHECK_AND_PRINT(DFS),
 				       eeprom_ch_info[ch].flags,
 				       eeprom_ch_info[ch].max_power_avg,
@@ -4997,9 +4996,6 @@ static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv,
 		if (scan_ch->type & 1)
 			scan_ch->type |= (direct_mask << 1);
 
-		if (is_channel_narrow(ch_info))
-			scan_ch->type |= (1 << 7);
-
 		scan_ch->active_dwell = cpu_to_le16(active_dwell);
 		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index d6c5658..53c5c01 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4403,9 +4403,6 @@ static int iwl4965_get_channels_for_scan(struct iwl_priv *priv,
 		if (scan_ch->type & 1)
 			scan_ch->type |= (direct_mask << 1);
 
-		if (is_channel_narrow(ch_info))
-			scan_ch->type |= (1 << 7);
-
 		scan_ch->active_dwell = cpu_to_le16(active_dwell);
 		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
 
-- 
1.5.3.4

