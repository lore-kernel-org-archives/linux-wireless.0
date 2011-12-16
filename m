Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27087 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760202Ab1LPQh5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:57 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 22/24] iwlwifi: remove unused AMPDU factor/density configuration
Date: Fri, 16 Dec 2011 07:37:27 -0800
Message-Id: <1324049849-831-23-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173826_725007_E4B90104)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These are unused, so can be removed safely. They also
don't make a lot of sense in Bluetooth configuration.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    4 ----
 drivers/net/wireless/iwlwifi/iwl-core.h |    4 ----
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index fb690a2..e513a80 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -76,11 +76,7 @@ static void iwl_init_ht_hw_capab(const struct iwl_priv *priv,
 		ht_info->cap |= IEEE80211_HT_CAP_MAX_AMSDU;
 
 	ht_info->ampdu_factor = CFG_HT_RX_AMPDU_FACTOR_DEF;
-	if (cfg(priv)->bt_params && cfg(priv)->bt_params->ampdu_factor)
-		ht_info->ampdu_factor = cfg(priv)->bt_params->ampdu_factor;
 	ht_info->ampdu_density = CFG_HT_MPDU_DENSITY_DEF;
-	if (cfg(priv)->bt_params && cfg(priv)->bt_params->ampdu_density)
-		ht_info->ampdu_density = cfg(priv)->bt_params->ampdu_density;
 
 	ht_info->mcs.rx_mask[0] = 0xFF;
 	if (rx_chains_num >= 2)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 792e802..7bf76ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -142,8 +142,6 @@ struct iwl_base_params {
  * @bt_init_traffic_load: specify initial bt traffic load
  * @bt_prio_boost: default bt priority boost value
  * @agg_time_limit: maximum number of uSec in aggregation
- * @ampdu_factor: Maximum A-MPDU length factor
- * @ampdu_density: Minimum A-MPDU spacing
  * @bt_sco_disable: uCode should not response to BT in SCO/ESCO mode
  */
 struct iwl_bt_params {
@@ -151,8 +149,6 @@ struct iwl_bt_params {
 	u8 bt_init_traffic_load;
 	u8 bt_prio_boost;
 	u16 agg_time_limit;
-	u8 ampdu_factor;
-	u8 ampdu_density;
 	bool bt_sco_disable;
 	bool bt_session_2;
 };
-- 
1.7.0.4

