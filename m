Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:22360 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbcCBH5k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:40 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/43] iwlwifi: pcie: prevent skbs shadowing in iwl_trans_pcie_reclaim
Date: Wed,  2 Mar 2016 09:56:25 +0200
Message-Id: <1456905404-14435-24-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085953_039087_E57B9C52)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch below introduced a variable shadowing. Fix that.

Fixes: 3955525d5d17 ("iwlwifi: pcie: buffer packets to avoid overflowing Tx queues")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 837a7d5..16ad820 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1062,10 +1062,10 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 
 	if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
 	    test_bit(txq_id, trans_pcie->queue_stopped)) {
-		struct sk_buff_head skbs;
+		struct sk_buff_head overflow_skbs;
 
-		__skb_queue_head_init(&skbs);
-		skb_queue_splice_init(&txq->overflow_q, &skbs);
+		__skb_queue_head_init(&overflow_skbs);
+		skb_queue_splice_init(&txq->overflow_q, &overflow_skbs);
 
 		/*
 		 * This is tricky: we are in reclaim path which is non
@@ -1076,8 +1076,8 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 		 */
 		spin_unlock_bh(&txq->lock);
 
-		while (!skb_queue_empty(&skbs)) {
-			struct sk_buff *skb = __skb_dequeue(&skbs);
+		while (!skb_queue_empty(&overflow_skbs)) {
+			struct sk_buff *skb = __skb_dequeue(&overflow_skbs);
 			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 			u8 dev_cmd_idx = IWL_TRANS_FIRST_DRIVER_DATA + 1;
 			struct iwl_device_cmd *dev_cmd =
-- 
2.5.0

