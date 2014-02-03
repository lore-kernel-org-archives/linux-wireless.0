Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:39541 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaBCU6d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:33 -0500
Received: by mail-ee0-f54.google.com with SMTP id e53so3910771eek.13
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:32 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/62] iwlwifi: mvm: provide helper to fetch the iwl_mvm_sta from sta_id
Date: Mon,  3 Feb 2014 22:57:17 +0200
Message-Id: <1391461088-8082-11-git-send-email-egrumbach@gmail.com> (sfid-20140203_215838_943219_5C1981ED)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We somtimes need to fetch the iwl_mvm_sta structure from a
station index - provide a helper to do that.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c |   14 ++------------
 drivers/net/wireless/iwlwifi/mvm/debugfs.c |   11 +++++------
 drivers/net/wireless/iwlwifi/mvm/mvm.h     |   18 ++++++++++++++++++
 3 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index 76cde6c..b1a572e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -500,23 +500,13 @@ static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
 		.dataflags = { IWL_HCMD_DFL_DUP, },
 		.flags = CMD_ASYNC,
 	};
-
-	struct ieee80211_sta *sta;
 	struct iwl_mvm_sta *mvmsta;
 	int ret;
 
-	if (sta_id == IWL_MVM_STATION_COUNT)
-		return 0;
-
-	sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[sta_id],
-					lockdep_is_held(&mvm->mutex));
-
-	/* This can happen if the station has been removed right now */
-	if (IS_ERR_OR_NULL(sta))
+	mvmsta = iwl_mvm_sta_from_staid_protected(mvm, sta_id);
+	if (!mvmsta)
 		return 0;
 
-	mvmsta = iwl_mvm_sta_from_mac80211(sta);
-
 	/* nothing to do */
 	if (mvmsta->bt_reduced_txpower == enable)
 		return 0;
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 369d4c9..8d3bf25 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -90,7 +90,7 @@ static ssize_t iwl_dbgfs_tx_flush_write(struct iwl_mvm *mvm, char *buf,
 static ssize_t iwl_dbgfs_sta_drain_write(struct iwl_mvm *mvm, char *buf,
 					 size_t count, loff_t *ppos)
 {
-	struct ieee80211_sta *sta;
+	struct iwl_mvm_sta *mvmsta;
 	int sta_id, drain, ret;
 
 	if (!mvm->ucode_loaded || mvm->cur_ucode != IWL_UCODE_REGULAR)
@@ -105,13 +105,12 @@ static ssize_t iwl_dbgfs_sta_drain_write(struct iwl_mvm *mvm, char *buf,
 
 	mutex_lock(&mvm->mutex);
 
-	sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[sta_id],
-					lockdep_is_held(&mvm->mutex));
-	if (IS_ERR_OR_NULL(sta))
+	mvmsta = iwl_mvm_sta_from_staid_protected(mvm, sta_id);
+
+	if (!mvmsta)
 		ret = -ENOENT;
 	else
-		ret = iwl_mvm_drain_sta(mvm, (void *)sta->drv_priv, drain) ? :
-			count;
+		ret = iwl_mvm_drain_sta(mvm, mvmsta, drain) ? : count;
 
 	mutex_unlock(&mvm->mutex);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index bf13c46..02e4bdc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -595,6 +595,24 @@ static inline bool iwl_mvm_is_radio_killed(struct iwl_mvm *mvm)
 	       test_bit(IWL_MVM_STATUS_HW_CTKILL, &mvm->status);
 }
 
+static inline struct iwl_mvm_sta *
+iwl_mvm_sta_from_staid_protected(struct iwl_mvm *mvm, u8 sta_id)
+{
+	struct ieee80211_sta *sta;
+
+	if (sta_id >= ARRAY_SIZE(mvm->fw_id_to_mac_id))
+		return NULL;
+
+	sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[sta_id],
+					lockdep_is_held(&mvm->mutex));
+
+	/* This can happen if the station has been removed right now */
+	if (IS_ERR_OR_NULL(sta))
+		return NULL;
+
+	return iwl_mvm_sta_from_mac80211(sta);
+}
+
 extern const u8 iwl_mvm_ac_to_tx_fifo[];
 
 struct iwl_rate_info {
-- 
1.7.9.5

