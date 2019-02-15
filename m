Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB7E9C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C64F021929
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436643AbfBOLt6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:49:58 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:60528 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727790AbfBOLt5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:49:57 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1guc01-0008TN-PO; Fri, 15 Feb 2019 13:49:46 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Feb 2019 13:49:23 +0200
Message-Id: <20190215114924.2545-20-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190215114924.2545-1-luca@coelho.fi>
References: <20190215114924.2545-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 19/20] iwlwifi: mvm: add some debug data to TX path
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

This helps debugging when things go wrong.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  8 +++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 11 +++++++----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 24556a7cd29c..f8928ba1f338 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -941,8 +941,14 @@ void iwl_mvm_mac_itxq_xmit(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
 			       IWL_PLAT_PM_MODE_DISABLED))) {
 			skb = ieee80211_tx_dequeue(hw, txq);
 
-			if (!skb)
+			if (!skb) {
+				if (txq->sta)
+					IWL_DEBUG_TX(mvm,
+						     "TXQ of sta %pM tid %d is now empty\n",
+						     txq->sta->addr,
+						     txq->tid);
 				break;
+			}
 
 			if (!txq->sta)
 				iwl_mvm_tx_skb_non_sta(mvm, skb);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index d01998853d1f..0c2aabc842f9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1115,12 +1115,14 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	 */
 	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc)) {
 		tid = ieee80211_get_tid(hdr);
-		if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
+		if (WARN_ONCE(tid >= IWL_MAX_TID_COUNT, "Invalid TID %d", tid))
 			goto drop_unlock_sta;
 
 		is_ampdu = info->flags & IEEE80211_TX_CTL_AMPDU;
-		if (WARN_ON_ONCE(is_ampdu &&
-				 mvmsta->tid_data[tid].state != IWL_AGG_ON))
+		if (WARN_ONCE(is_ampdu &&
+			      mvmsta->tid_data[tid].state != IWL_AGG_ON,
+			      "Invalid internal agg state %d for TID %d",
+			       mvmsta->tid_data[tid].state, tid))
 			goto drop_unlock_sta;
 
 		seq_number = mvmsta->tid_data[tid].seq_number;
@@ -1142,7 +1144,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	WARN_ON_ONCE(info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM);
 
-	if (WARN_ON_ONCE(txq_id == IWL_MVM_INVALID_QUEUE)) {
+	if (WARN_ONCE(txq_id == IWL_MVM_INVALID_QUEUE, "Invalid TXQ id")) {
 		iwl_trans_free_tx_cmd(mvm->trans, dev_cmd);
 		spin_unlock(&mvmsta->lock);
 		return 0;
@@ -1192,6 +1194,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	iwl_trans_free_tx_cmd(mvm->trans, dev_cmd);
 	spin_unlock(&mvmsta->lock);
 drop:
+	IWL_DEBUG_TX(mvm, "TX to [%d|%d] dropped\n", mvmsta->sta_id, tid);
 	return -1;
 }
 
-- 
2.20.1

