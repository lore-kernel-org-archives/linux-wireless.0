Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23946 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab1HZGxd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:33 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 23/60] iwlagn: enable 11n aggregation without checking traffic load
Date: Thu, 25 Aug 2011 23:10:55 -0700
Message-Id: <1314339092-20797-24-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085455_816051_3D8DF276)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable HT aggregation when it reach reasonable traffic without
checking traffic load which delay enabling the aggregation and lower
the throughput

but this behavior can be overwrite by module parameter

this address
https://bugzilla.kernel.org/show_bug.cgi?id=40042

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-shared.h  |    1 +
 4 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 82fb55b..6cfd236 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -612,6 +612,7 @@ struct iwl_mod_params iwlagn_mod_params = {
 	.power_level = IWL_POWER_INDEX_1,
 	.bt_ch_announce = 1,
 	.wanted_ucode_alternative = 1,
+	.auto_agg = true,
 	/* the rest are 0 by default */
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index cff6442..3870b72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -420,7 +420,7 @@ static int rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 
 	load = rs_tl_get_load(lq_data, tid);
 
-	if (load > IWL_AGG_LOAD_THRESHOLD) {
+	if ((iwlagn_mod_params.auto_agg) || (load > IWL_AGG_LOAD_THRESHOLD)) {
 		IWL_DEBUG_HT(priv, "Starting Tx agg: STA: %pM tid: %d\n",
 				sta->addr, tid);
 		ret = ieee80211_start_tx_ba_session(sta, tid, 5000);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f6884a5..be2ba4d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3588,6 +3588,11 @@ module_param_named(power_level, iwlagn_mod_params.power_level,
 MODULE_PARM_DESC(power_level,
 		 "default power save level (range from 1 - 5, default: 1)");
 
+module_param_named(auto_agg, iwlagn_mod_params.auto_agg,
+		bool, S_IRUGO);
+MODULE_PARM_DESC(auto_agg,
+		 "enable agg w/o check traffic load (default: enable)");
+
 /*
  * For now, keep using power level 1 instead of automatically
  * adjusting ...
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index a5ef79b..ec71ec7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -93,6 +93,7 @@ struct iwl_mod_params {
 	int ant_coupling;
 	bool bt_ch_announce;
 	int wanted_ucode_alternative;
+	bool auto_agg;		/* def: true = enable agg. without check */
 };
 
 /**
-- 
1.7.0.4

