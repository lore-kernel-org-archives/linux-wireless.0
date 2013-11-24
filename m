Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:64638 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab3KXUHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:16 -0500
Received: by mail-wi0-f180.google.com with SMTP id hm4so4611265wib.7
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:15 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/29] iwlwifi: fix check for a single rx antenna
Date: Sun, 24 Nov 2013 22:06:37 +0200
Message-Id: <1385323606-3603-20-git-send-email-egrumbach@gmail.com> (sfid-20131124_210810_133822_8E36FEE1)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

valid_rx_ant is a bitmask of available antennas and not the number
of Rx antennas. Use num_of_ant and remove duplicate definitions
in both dvm and mvm.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/rs.h        |    7 -------
 drivers/net/wireless/iwlwifi/iwl-config.h    |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |    3 ++-
 drivers/net/wireless/iwlwifi/mvm/rs.h        |    8 --------
 4 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.h b/drivers/net/wireless/iwlwifi/dvm/rs.h
index 26fc550..41988f4 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.h
@@ -389,13 +389,6 @@ struct iwl_lq_sta {
 	u8 last_bt_traffic;
 };
 
-static inline u8 num_of_ant(u8 mask)
-{
-	return  !!((mask) & ANT_A) +
-		!!((mask) & ANT_B) +
-		!!((mask) & ANT_C);
-}
-
 static inline u8 first_antenna(u8 mask)
 {
 	if (mask & ANT_A)
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 18f232e..ab19cea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -129,6 +129,12 @@ enum iwl_led_mode {
 #define ANT_BC		(ANT_B | ANT_C)
 #define ANT_ABC		(ANT_A | ANT_B | ANT_C)
 
+static inline u8 num_of_ant(u8 mask)
+{
+	return  !!((mask) & ANT_A) +
+		!!((mask) & ANT_B) +
+		!!((mask) & ANT_C);
+}
 
 /*
  * @max_ll_items: max number of OTP blocks
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index b76a9a8..5348bd4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -283,7 +283,8 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 			    IEEE80211_VHT_MCS_NOT_SUPPORTED << 12 |
 			    IEEE80211_VHT_MCS_NOT_SUPPORTED << 14);
 
-	if (data->valid_rx_ant == 1 || cfg->rx_with_siso_diversity) {
+	if (num_of_ant(data->valid_rx_ant) == 1 ||
+	    cfg->rx_with_siso_diversity) {
 		vht_cap->cap |= IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN |
 				IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN;
 		/* this works because NOT_SUPPORTED == 3 */
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 8d5dc78..b41686b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -343,14 +343,6 @@ enum iwl_bt_coex_profile_traffic_load {
  */
 };
 
-
-static inline u8 num_of_ant(u8 mask)
-{
-	return  !!((mask) & ANT_A) +
-		!!((mask) & ANT_B) +
-		!!((mask) & ANT_C);
-}
-
 /* Initialize station's rate scaling information after adding station */
 void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			  enum ieee80211_band band, bool init);
-- 
1.7.9.5

