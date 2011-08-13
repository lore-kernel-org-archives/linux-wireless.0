Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16165 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab1HMSSn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:43 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 23/60] iwlagn: enable 11n aggregation without checking traffic load
Date: Sat, 13 Aug 2011 10:37:59 -0700
Message-Id: <1313257116-2697-24-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201946_847345_3F67131A)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
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
index 5aac9cd..8fc68e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -421,7 +421,7 @@ static int rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 
 	load = rs_tl_get_load(lq_data, tid);
 
-	if (load > IWL_AGG_LOAD_THRESHOLD) {
+	if ((iwlagn_mod_params.auto_agg) || (load > IWL_AGG_LOAD_THRESHOLD)) {
 		IWL_DEBUG_HT(priv, "Starting Tx agg: STA: %pM tid: %d\n",
 				sta->addr, tid);
 		ret = ieee80211_start_tx_ba_session(sta, tid, 5000);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 37cb31b..2764c7a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3652,6 +3652,11 @@ module_param_named(power_level, iwlagn_mod_params.power_level,
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

