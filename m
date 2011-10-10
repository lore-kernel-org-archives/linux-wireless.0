Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab1JJPQ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi GUy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/34] iwlagn: don't assign seqno to QoS Null frames
Date: Mon, 10 Oct 2011 07:26:53 -0700
Message-Id: <1318256839-31837-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171633_579893_85C3B477)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

802.11 says:
"Sequence numbers for QoS (+)Null frames may be
set to any value."

However, if we use the normal counters then peers
will get confused with aggregation since there'll
be holes in the sequence number sequence.

To avoid that, don't assign sequence numbers to
QoS Null frames.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi GUy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 416e992..60a8ecc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1077,7 +1077,7 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		txq_id =
 		    trans_pcie->ac_to_queue[ctx][skb_get_queue_mapping(skb)];
 
-	if (ieee80211_is_data_qos(fc)) {
+	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc)) {
 		u8 *qc = NULL;
 		struct iwl_tid_data *tid_data;
 		qc = ieee80211_get_qos_ctl(hdr);
@@ -1206,7 +1206,7 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	iwl_txq_update_write_ptr(trans, txq);
 
-	if (ieee80211_is_data_qos(fc)) {
+	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc)) {
 		trans->shrd->tid_data[sta_id][tid].tfds_in_queue++;
 		if (!ieee80211_has_morefrags(fc))
 			trans->shrd->tid_data[sta_id][tid].seq_number =
-- 
1.7.0.4

