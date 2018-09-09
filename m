Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48054 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726627AbeIIO0o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 10:26:44 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun,  9 Sep 2018 12:36:52 +0300
Message-Id: <20180909093656.10194-13-luca@coelho.fi> (sfid-20180909_113741_368842_7486FB46)
In-Reply-To: <20180909093656.10194-1-luca@coelho.fi>
References: <20180909093656.10194-1-luca@coelho.fi>
Subject: [PATCH 12/16] iwlwifi: pcie: support transmitting SKBs with fraglist
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We want to be able to build A-MSDUs in higher layers, e.g. by
xmit_more, so support transmitting SKBs with fraglist to use
it for such.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 6b6b86458819..67820bfaba64 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -2408,10 +2408,18 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 						     tb1_len)))
 			goto out_err;
 	} else {
+		struct sk_buff *frag;
+
 		if (unlikely(iwl_fill_data_tbs(trans, skb, txq, hdr_len,
 					       out_meta)))
 			goto out_err;
 
+		skb_walk_frags(skb, frag) {
+			if (unlikely(iwl_fill_data_tbs(trans, frag, txq, 0,
+						       out_meta)))
+				goto out_err;
+		}
+
 		trace_iwlwifi_dev_tx(trans->dev, skb,
 				     iwl_pcie_get_tfd(trans, txq,
 						      txq->write_ptr),
-- 
2.18.0
