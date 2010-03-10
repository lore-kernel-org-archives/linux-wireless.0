Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab0CJFWG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:06 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/24] iwlwifi: move 3945 clip groups to 3945 data
Date: Tue,  9 Mar 2010 21:21:41 -0800
Message-Id: <1268198512-6572-14-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Only used on 3945, so it can be in the
3945-specific part of the data.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-dev.h  |   12 ++++++++----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 9a5a7b1..ed59e27 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1607,7 +1607,7 @@ static int iwl3945_hw_reg_set_new_power(struct iwl_priv *priv,
 	int power;
 
 	/* Get this chnlgrp's rate-to-max/clip-powers table */
-	clip_pwrs = priv->clip39_groups[ch_info->group_index].clip_powers;
+	clip_pwrs = priv->_3945.clip_groups[ch_info->group_index].clip_powers;
 
 	/* Get this channel's rate-to-current-power settings table */
 	power_info = ch_info->power_info;
@@ -1733,7 +1733,7 @@ static int iwl3945_hw_reg_comp_txpower_temp(struct iwl_priv *priv)
 		}
 
 		/* Get this chnlgrp's rate-to-max/clip-powers table */
-		clip_pwrs = priv->clip39_groups[ch_info->group_index].clip_powers;
+		clip_pwrs = priv->_3945.clip_groups[ch_info->group_index].clip_powers;
 
 		/* set scan tx power, 1Mbit for CCK, 6Mbit for OFDM */
 		for (scan_tbl_index = 0;
@@ -2140,7 +2140,7 @@ static void iwl3945_hw_reg_init_channel_groups(struct iwl_priv *priv)
 		 *   power peaks, without too much distortion (clipping).
 		 */
 		/* we'll fill in this array with h/w max power levels */
-		clip_pwrs = (s8 *) priv->clip39_groups[i].clip_powers;
+		clip_pwrs = (s8 *) priv->_3945.clip_groups[i].clip_powers;
 
 		/* divide factory saturation power by 2 to find -3dB level */
 		satur_pwr = (s8) (group->saturation_power >> 1);
@@ -2224,7 +2224,7 @@ int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv)
 			iwl3945_hw_reg_get_ch_grp_index(priv, ch_info);
 
 		/* Get this chnlgrp's rate->max/clip-powers table */
-		clip_pwrs = priv->clip39_groups[ch_info->group_index].clip_powers;
+		clip_pwrs = priv->_3945.clip_groups[ch_info->group_index].clip_powers;
 
 		/* calculate power index *adjustment* value according to
 		 *  diff between current temperature and factory temperature */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ba404b9..90d2b6e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1092,10 +1092,6 @@ struct iwl_priv {
 	struct iwl_channel_info *channel_info;	/* channel info array */
 	u8 channel_count;	/* # of channels */
 
-	/* each calibration channel group in the EEPROM has a derived
-	 * clip setting for each rate. 3945 only.*/
-	const struct iwl3945_clip_group clip39_groups[5];
-
 	/* thermal calibration */
 	s32 temperature;	/* degrees Kelvin */
 	s32 last_temperature;
@@ -1271,6 +1267,14 @@ struct iwl_priv {
 			/* Rx'd packet timing information */
 			u32 last_beacon_time;
 			u64 last_tsf;
+
+			/*
+			 * each calibration channel group in the
+			 * EEPROM has a derived clip setting for
+			 * each rate.
+			 */
+			const struct iwl3945_clip_group clip_groups[5];
+
 		} _3945;
 #endif
 #if defined(CONFIG_IWLAGN) || defined(CONFIG_IWLAGN_MODULE)
-- 
1.6.3.3

