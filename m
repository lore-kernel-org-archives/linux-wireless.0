Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47755 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbaFXTw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:58 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so6402782wib.3
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:55 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/27] iwlwifi: mvm: BT Coex - allow MIMO in more cases
Date: Tue, 24 Jun 2014 22:52:13 +0300
Message-Id: <1403639541-4621-19-git-send-email-egrumbach@gmail.com> (sfid-20140624_220200_066251_520DC338)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We can Tx in MIMO rates when we are in TxTx Disallow mode
just like we can when we are in Tight mode.
Same if we are in 5Ghz regardless of the mode we are.
Change the code to allow MIMO in these cases.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index b2003d8..aab92a6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -538,7 +538,7 @@ iwl_get_coex_type(struct iwl_mvm *mvm, const struct ieee80211_vif *vif)
 	if (!chanctx_conf ||
 	     chanctx_conf->def.chan->band != IEEE80211_BAND_2GHZ) {
 		rcu_read_unlock();
-		return BT_COEX_LOOSE_LUT;
+		return BT_COEX_INVALID_LUT;
 	}
 
 	ret = BT_COEX_TX_DIS_LUT;
@@ -1214,7 +1214,7 @@ u16 iwl_mvm_coex_agg_time_limit(struct iwl_mvm *mvm,
 
 	lut_type = iwl_get_coex_type(mvm, mvmsta->vif);
 
-	if (lut_type == BT_COEX_LOOSE_LUT)
+	if (lut_type == BT_COEX_LOOSE_LUT || lut_type == BT_COEX_INVALID_LUT)
 		return LINK_QUAL_AGG_TIME_LIMIT_DEF;
 
 	/* tight coex, high bt traffic, reduce AGG time limit */
@@ -1225,18 +1225,21 @@ bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 				     struct ieee80211_sta *sta)
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	enum iwl_bt_coex_lut_type lut_type;
 
 	if (le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) <
 	    BT_HIGH_TRAFFIC)
 		return true;
 
 	/*
-	 * In Tight, BT can't Rx while we Tx, so use both antennas since BT is
-	 * already killed.
-	 * In Loose, BT can Rx while we Tx, so forbid MIMO to let BT Rx while we
-	 * Tx.
+	 * In Tight / TxTxDis, BT can't Rx while we Tx, so use both antennas
+	 * since BT is already killed.
+	 * In Loose, BT can Rx while we Tx, so forbid MIMO to let BT Rx while
+	 * we Tx.
+	 * When we are in 5GHz, we'll get BT_COEX_INVALID_LUT allowing MIMO.
 	 */
-	return iwl_get_coex_type(mvm, mvmsta->vif) == BT_COEX_TIGHT_LUT;
+	lut_type = iwl_get_coex_type(mvm, mvmsta->vif);
+	return lut_type != BT_COEX_LOOSE_LUT;
 }
 
 bool iwl_mvm_bt_coex_is_tpc_allowed(struct iwl_mvm *mvm,
-- 
1.8.3.2

