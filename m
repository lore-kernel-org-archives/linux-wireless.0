Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38072 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752286AbdBCOla (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:41:30 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:38:07 +0200
Message-Id: <20170203143812.7525-21-luca@coelho.fi> (sfid-20170203_154148_955275_A10F2A85)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 20/25] iwlwifi: mvm: cleanup iwl_mvm_tx_mpdu a bit
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Unify code, remove redundant assignments.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 35 ++++++++++-------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index f82b765650d6..4ba639eda7a3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -907,6 +907,10 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	spin_lock(&mvmsta->lock);
 
+	/* nullfunc frames should go to the MGMT queue regardless of QOS,
+	 * the condition of !ieee80211_is_qos_nullfunc(fc) keeps the default
+	 * assignment of MGMT TID
+	 */
 	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc)) {
 		u8 *qc = NULL;
 		qc = ieee80211_get_qos_ctl(hdr);
@@ -919,27 +923,13 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
 		hdr->seq_ctrl |= cpu_to_le16(seq_number);
 		is_ampdu = info->flags & IEEE80211_TX_CTL_AMPDU;
-	} else if (iwl_mvm_is_dqa_supported(mvm) &&
-		   (ieee80211_is_qos_nullfunc(fc) ||
-		    ieee80211_is_nullfunc(fc))) {
-		/*
-		 * nullfunc frames should go to the MGMT queue regardless of QOS
-		 */
-		tid = IWL_MAX_TID_COUNT;
+		if (WARN_ON_ONCE(is_ampdu &&
+				 mvmsta->tid_data[tid].state != IWL_AGG_ON))
+			goto drop_unlock_sta;
 	}
 
-	if (iwl_mvm_is_dqa_supported(mvm)) {
+	if (iwl_mvm_is_dqa_supported(mvm) || is_ampdu)
 		txq_id = mvmsta->tid_data[tid].txq_id;
-
-		if (ieee80211_is_mgmt(fc))
-			tx_cmd->tid_tspec = IWL_TID_NON_QOS;
-	}
-
-	/* Copy MAC header from skb into command buffer */
-	memcpy(tx_cmd->hdr, hdr, hdrlen);
-
-	WARN_ON_ONCE(info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM);
-
 	if (sta->tdls && !iwl_mvm_is_dqa_supported(mvm)) {
 		/* default to TID 0 for non-QoS packets */
 		u8 tdls_tid = tid == IWL_MAX_TID_COUNT ? 0 : tid;
@@ -947,11 +937,10 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 		txq_id = mvmsta->hw_queue[tid_to_mac80211_ac[tdls_tid]];
 	}
 
-	if (is_ampdu) {
-		if (WARN_ON_ONCE(mvmsta->tid_data[tid].state != IWL_AGG_ON))
-			goto drop_unlock_sta;
-		txq_id = mvmsta->tid_data[tid].txq_id;
-	}
+	/* Copy MAC header from skb into command buffer */
+	memcpy(tx_cmd->hdr, hdr, hdrlen);
+
+	WARN_ON_ONCE(info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM);
 
 	/* Check if TXQ needs to be allocated or re-activated */
 	if (unlikely(txq_id == IEEE80211_INVAL_HW_QUEUE ||
-- 
2.11.0
