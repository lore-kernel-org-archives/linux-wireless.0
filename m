Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46924 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753566AbeE3HUP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 03:20:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 30 May 2018 10:19:59 +0300
Message-Id: <20180530072005.633-5-luca@coelho.fi> (sfid-20180530_092029_730643_8B92F074)
In-Reply-To: <20180530072005.633-1-luca@coelho.fi>
References: <20180530072005.633-1-luca@coelho.fi>
Subject: [PATCH 04/10] iwlwifi: mvm: fix TSO with highly fragmented SKBs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Our hardware has a limited amount of buffer descriptors
for each Tx packet. Because of that, there is a short
piece of code that makes sure that that we don't push too
many subframes in an A-MSDU because of subframes needs 2
buffer descriptors. This code also takes into account the
number of fragment of the skb since we also need a buffer
descriptor for each fragment in the skb.

This piece of code though didn't check that the resulting
number of subframes wasn't 0.

A user reported that using NFS client, he could get skbs
that are so fragmented that the code mentioned above
returned 0 for the number of subframes making
skb_gso_segment fail and subconsequently iwlwifi would WARN.

Fix this by make sure that num_subframes is at least 1.

This fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=199209

Fixes: a6d5e32f247c ("iwlwifi: mvm: send large SKBs to the transport")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index df4c60496f72..0b7f98d00298 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -843,8 +843,6 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	 * N * subf_len + (N - 1) * pad.
 	 */
 	num_subframes = (max_amsdu_len + pad) / (subf_len + pad);
-	if (num_subframes > 1)
-		*ieee80211_get_qos_ctl(hdr) |= IEEE80211_QOS_CTL_A_MSDU_PRESENT;
 
 	tcp_payload_len = skb_tail_pointer(skb) - skb_transport_header(skb) -
 		tcp_hdrlen(skb) + skb->data_len;
@@ -855,10 +853,12 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	 *	1 more for each fragment
 	 *	1 more for the potential data in the header
 	 */
-	num_subframes =
-		min_t(unsigned int, num_subframes,
-		      (mvm->trans->max_skb_frags - 1 -
-		       skb_shinfo(skb)->nr_frags) / 2);
+	if ((num_subframes * 2 + skb_shinfo(skb)->nr_frags + 1) >
+	    mvm->trans->max_skb_frags)
+		num_subframes = 1;
+
+	if (num_subframes > 1)
+		*ieee80211_get_qos_ctl(hdr) |= IEEE80211_QOS_CTL_A_MSDU_PRESENT;
 
 	/* This skb fits in one single A-MSDU */
 	if (num_subframes * mss >= tcp_payload_len) {
-- 
2.17.0
