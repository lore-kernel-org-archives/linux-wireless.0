Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39285 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3KXUG5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:06:57 -0500
Received: by mail-wi0-f172.google.com with SMTP id en1so2723374wid.17
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:06:56 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/29] iwlwifi: mvm: simplify iwl_mvm_send_lq_cmd
Date: Sun, 24 Nov 2013 22:06:22 +0200
Message-Id: <1385323606-3603-5-git-send-email-egrumbach@gmail.com> (sfid-20131124_210708_622010_92B91643)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Remove the flags parameter which should be set to sync or async
according to whether this is called during sta init or not.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h   |    3 +--
 drivers/net/wireless/iwlwifi/mvm/rs.c    |   12 ++++++------
 drivers/net/wireless/iwlwifi/mvm/sta.c   |    2 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c |    8 ++------
 4 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index fed21ef..7992baa 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -750,8 +750,7 @@ iwl_mvm_vif_dbgfs_clean(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 
 /* rate scaling */
-int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq,
-			u8 flags, bool init);
+int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq, bool init);
 
 /* power managment */
 static inline int iwl_mvm_power_update_mode(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index f7ac485..0a64089 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -298,7 +298,7 @@ static void rs_program_fix_rate(struct iwl_mvm *mvm,
 
 	if (lq_sta->dbg_fixed_rate) {
 		rs_fill_link_cmd(NULL, NULL, lq_sta, lq_sta->dbg_fixed_rate);
-		iwl_mvm_send_lq_cmd(lq_sta->drv, &lq_sta->lq, CMD_ASYNC, false);
+		iwl_mvm_send_lq_cmd(lq_sta->drv, &lq_sta->lq, false);
 	}
 }
 #endif
@@ -855,7 +855,7 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 		lq_sta->missed_rate_counter++;
 		if (lq_sta->missed_rate_counter > IWL_MISSED_RATE_MAX) {
 			lq_sta->missed_rate_counter = 0;
-			iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, CMD_ASYNC, false);
+			iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, false);
 		}
 		/* Regardless, ignore this status info for outdated rate */
 		return;
@@ -1667,7 +1667,7 @@ static void rs_update_rate_tbl(struct iwl_mvm *mvm,
 	/* Update uCode's rate table. */
 	rate = rate_n_flags_from_tbl(mvm, tbl, index);
 	rs_fill_link_cmd(mvm, sta, lq_sta, rate);
-	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, CMD_ASYNC, false);
+	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, false);
 }
 
 static u8 rs_get_tid(struct iwl_lq_sta *lq_data,
@@ -2064,7 +2064,7 @@ lq_update:
 				       "Switch current  mcs: %X index: %d\n",
 				       tbl->current_rate, index);
 			rs_fill_link_cmd(mvm, sta, lq_sta, tbl->current_rate);
-			iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, CMD_ASYNC, false);
+			iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, false);
 		} else {
 			done_search = 1;
 		}
@@ -2168,7 +2168,7 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 	rs_set_expected_tpt_table(lq_sta, tbl);
 	rs_fill_link_cmd(NULL, NULL, lq_sta, rate);
 	/* TODO restore station should remember the lq cmd */
-	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, CMD_SYNC, true);
+	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, true);
 }
 
 static void rs_get_rate(void *mvm_r, struct ieee80211_sta *sta, void *mvm_sta,
@@ -2841,5 +2841,5 @@ int iwl_mvm_tx_protection(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 			lq->flags &= ~LQ_FLAG_SET_STA_TLC_RTS_MSK;
 	}
 
-	return iwl_mvm_send_lq_cmd(mvm, lq, CMD_ASYNC, false);
+	return iwl_mvm_send_lq_cmd(mvm, lq, false);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 3299523..c89232c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -945,7 +945,7 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		 */
 	}
 
-	return iwl_mvm_send_lq_cmd(mvm, &mvmsta->lq_sta.lq, CMD_ASYNC, false);
+	return iwl_mvm_send_lq_cmd(mvm, &mvmsta->lq_sta.lq, false);
 }
 
 int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index ed69e9b..56cf819 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -486,22 +486,18 @@ void iwl_mvm_dump_sram(struct iwl_mvm *mvm)
  * this case to clear the state indicating that station creation is in
  * progress.
  */
-int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq,
-			u8 flags, bool init)
+int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq, bool init)
 {
 	struct iwl_host_cmd cmd = {
 		.id = LQ_CMD,
 		.len = { sizeof(struct iwl_lq_cmd), },
-		.flags = flags,
+		.flags = init ? CMD_SYNC : CMD_ASYNC,
 		.data = { lq, },
 	};
 
 	if (WARN_ON(lq->sta_id == IWL_MVM_STATION_COUNT))
 		return -EINVAL;
 
-	if (WARN_ON(init && (cmd.flags & CMD_ASYNC)))
-		return -EINVAL;
-
 	return iwl_mvm_send_cmd(mvm, &cmd);
 }
 
-- 
1.7.9.5

