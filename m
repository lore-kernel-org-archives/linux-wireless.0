Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46958 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S935179AbeE3HUS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 03:20:18 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 30 May 2018 10:20:03 +0300
Message-Id: <20180530072005.633-9-luca@coelho.fi> (sfid-20180530_092030_310801_84413100)
In-Reply-To: <20180530072005.633-1-luca@coelho.fi>
References: <20180530072005.633-1-luca@coelho.fi>
Subject: [PATCH 08/10] iwlwifi: mvm: honor the max_amsdu_subframes limit
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

A peer can limit the number of subframes it can handle in a
single A-MSDU.  Honor this limit.

Note that the smallest limit is 8, and we are very unlikely to reach
that limit. So this isn't really a big deal.

Fixes: a6d5e32f247c ("iwlwifi: mvm: send large SKBs to the transport")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 0b7f98d00298..cf2591f2ac23 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -844,6 +844,10 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	 */
 	num_subframes = (max_amsdu_len + pad) / (subf_len + pad);
 
+	if (sta->max_amsdu_subframes &&
+	    num_subframes > sta->max_amsdu_subframes)
+		num_subframes = sta->max_amsdu_subframes;
+
 	tcp_payload_len = skb_tail_pointer(skb) - skb_transport_header(skb) -
 		tcp_hdrlen(skb) + skb->data_len;
 
-- 
2.17.0
