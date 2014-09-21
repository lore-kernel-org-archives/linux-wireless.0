Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:57269 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaIUTWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:22:49 -0400
Received: by mail-wi0-f181.google.com with SMTP id z2so1844549wiv.8
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2014 12:22:47 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/17] iwlwifi: mvm: rs: fix logic in case of multiple TIDs
Date: Sun, 21 Sep 2014 22:22:16 +0300
Message-Id: <1411327338-23099-15-git-send-email-egrumbach@gmail.com> (sfid-20140921_213114_153282_2C269D1D)
In-Reply-To: <541F23D2.90600@gmail.com>
References: <541F23D2.90600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

In case of traffic on multiple TIDs where one is aggregated
and the other is not RS would toggle between considering
traffic vs. the station as aggregated and not aggregated.
Instead consider the sta state as aggregated as long as
there's at least one TID aggregated.
This limitation is because the rates table is kept per
station and not per TID.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c  | 11 +----------
 drivers/net/wireless/iwlwifi/mvm/sta.c |  8 ++++++++
 drivers/net/wireless/iwlwifi/mvm/sta.h |  2 ++
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 1865ba6..18a5399 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1980,16 +1980,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	struct iwl_mvm_tid_data *tid_data;
 	struct rs_rate *rate;
 
-	if ((tid != IWL_MAX_TID_COUNT) &&
-	    (lq_sta->tx_agg_tid_en & (1 << tid))) {
-		tid_data = &sta_priv->tid_data[tid];
-		if (tid_data->state == IWL_AGG_OFF)
-			lq_sta->is_agg = 0;
-		else
-			lq_sta->is_agg = 1;
-	} else {
-		lq_sta->is_agg = 0;
-	}
+	lq_sta->is_agg = !!sta_priv->agg_tids;
 
 	/*
 	 * Select rate-scale / modulation-mode table to work with in
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index bccd787..1731c20 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -247,6 +247,7 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 		memset(&mvm_sta->tid_data[i], 0, sizeof(mvm_sta->tid_data[i]));
 		mvm_sta->tid_data[i].seq_number = seq;
 	}
+	mvm_sta->agg_tids = 0;
 
 	ret = iwl_mvm_sta_send_to_fw(mvm, sta, false);
 	if (ret)
@@ -872,12 +873,16 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	int queue, fifo, ret;
 	u16 ssn;
 
+	BUILD_BUG_ON((sizeof(mvmsta->agg_tids) * BITS_PER_BYTE)
+		     != IWL_MAX_TID_COUNT);
+
 	buf_size = min_t(int, buf_size, LINK_QUAL_AGG_FRAME_LIMIT_DEF);
 
 	spin_lock_bh(&mvmsta->lock);
 	ssn = tid_data->ssn;
 	queue = tid_data->txq_id;
 	tid_data->state = IWL_AGG_ON;
+	mvmsta->agg_tids |= BIT(tid);
 	tid_data->ssn = 0xffff;
 	spin_unlock_bh(&mvmsta->lock);
 
@@ -932,6 +937,8 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	IWL_DEBUG_TX_QUEUES(mvm, "Stop AGG: sta %d tid %d q %d state %d\n",
 			    mvmsta->sta_id, tid, txq_id, tid_data->state);
 
+	mvmsta->agg_tids &= ~BIT(tid);
+
 	switch (tid_data->state) {
 	case IWL_AGG_ON:
 		tid_data->ssn = IEEE80211_SEQ_TO_SN(tid_data->seq_number);
@@ -1005,6 +1012,7 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			    mvmsta->sta_id, tid, txq_id, tid_data->state);
 	old_state = tid_data->state;
 	tid_data->state = IWL_AGG_OFF;
+	mvmsta->agg_tids &= ~BIT(tid);
 	spin_unlock_bh(&mvmsta->lock);
 
 	if (old_state >= IWL_AGG_ON) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index aeb3a7f..d9c0d7b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -299,6 +299,7 @@ static inline u16 iwl_mvm_tid_queued(struct iwl_mvm_tid_data *tid_data)
  * @tx_protection: reference counter for controlling the Tx protection.
  * @tt_tx_protection: is thermal throttling enable Tx protection?
  * @disable_tx: is tx to this STA disabled?
+ * @agg_tids: bitmap of tids whose status is operational aggregated (IWL_AGG_ON)
  *
  * When mac80211 creates a station it reserves some space (hw->sta_data_size)
  * in the structure for use by driver. This structure is placed in that
@@ -323,6 +324,7 @@ struct iwl_mvm_sta {
 	bool tt_tx_protection;
 
 	bool disable_tx;
+	u8 agg_tids;
 };
 
 static inline struct iwl_mvm_sta *
-- 
1.9.1

