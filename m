Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:59501 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab3KXUHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:24 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so2001648wgh.14
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:23 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/29] iwlwifi: mvm: stop using MIMO in case BT doesn't allow it
Date: Sun, 24 Nov 2013 22:06:44 +0200
Message-Id: <1385323606-3603-27-git-send-email-egrumbach@gmail.com> (sfid-20131124_210809_838453_13DDA3ED)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Switch to using the new btcoex decision api regarding MIMO and stop
accessing the internal btcoex structs.
In case MIMO should be disabled it would detect this upon the next
Tx and force a search. The search will switch to SISO on a antenna A
which isn't used by BT.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |   26 ++++++--------------------
 drivers/net/wireless/iwlwifi/mvm/rs.h |   13 -------------
 2 files changed, 6 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 482b91b8..9565260 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1499,6 +1499,9 @@ static int rs_move_mimo2_to_other(struct iwl_mvm *mvm,
 	u8 update_search_tbl_counter = 0;
 	int ret;
 
+	if (!iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta))
+		tbl->action = IWL_MIMO2_SWITCH_SISO_A;
+
 	start_action = tbl->action;
 	while (1) {
 		lq_sta->action_counter++;
@@ -1970,26 +1973,9 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	     (current_tpt > (100 * tbl->expected_tpt[low]))))
 		scale_action = 0;
 
-	if ((le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) >=
-	     IWL_BT_COEX_TRAFFIC_LOAD_HIGH) && (is_mimo(tbl->lq_type))) {
-		if (lq_sta->last_bt_traffic >
-		    le32_to_cpu(mvm->last_bt_notif.bt_activity_grading)) {
-			/*
-			 * don't set scale_action, don't want to scale up if
-			 * the rate scale doesn't otherwise think that is a
-			 * good idea.
-			 */
-		} else if (lq_sta->last_bt_traffic <=
-			   le32_to_cpu(mvm->last_bt_notif.bt_activity_grading)) {
-			scale_action = -1;
-		}
-	}
-	lq_sta->last_bt_traffic =
-		le32_to_cpu(mvm->last_bt_notif.bt_activity_grading);
-
-	if ((le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) >=
-	     IWL_BT_COEX_TRAFFIC_LOAD_HIGH) && is_mimo(tbl->lq_type)) {
-		/* search for a new modulation */
+	/* Force a search in case BT doesn't like us being in MIMO */
+	if (is_mimo(tbl->lq_type) &&
+	    !iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta)) {
 		rs_stay_in_table(lq_sta, true);
 		goto lq_update;
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index b41686b..5dd30ea 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -328,19 +328,6 @@ struct iwl_lq_sta {
 	u32 last_rate_n_flags;
 	/* packets destined for this STA are aggregated */
 	u8 is_agg;
-	/* BT traffic this sta was last updated in */
-	u8 last_bt_traffic;
-};
-
-enum iwl_bt_coex_profile_traffic_load {
-	IWL_BT_COEX_TRAFFIC_LOAD_NONE		= 0,
-	IWL_BT_COEX_TRAFFIC_LOAD_LOW		= 1,
-	IWL_BT_COEX_TRAFFIC_LOAD_HIGH		= 2,
-	IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS	= 3,
-/*
- * There are no more even though below is a u8, the
- * indication from the BT device only has two bits.
- */
 };
 
 /* Initialize station's rate scaling information after adding station */
-- 
1.7.9.5

