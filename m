Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37300 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751074AbdGEGFs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 02:05:48 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  5 Jul 2017 09:05:33 +0300
Message-Id: <20170705060539.20737-2-luca@coelho.fi> (sfid-20170705_080553_511790_009D5917)
In-Reply-To: <20170705060539.20737-1-luca@coelho.fi>
References: <20170705060539.20737-1-luca@coelho.fi>
Subject: [PATCH 1/7] iwlwifi: dvm: prevent an out of bounds access
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwlagn_check_ratid_empty takes the tid as a parameter, but
it doesn't check that it is not IWL_TID_NON_QOS.
Since IWL_TID_NON_QOS = 8 and iwl_priv::tid_data is an array
with 8 entries, accessing iwl_priv::tid_data[IWL_TID_NON_QOS]
is a bad idea.
This happened in iwlagn_rx_reply_tx. Since
iwlagn_check_ratid_empty is relevant only to check whether
we can open A-MPDU, this flow is irrelevant if tid is
IWL_TID_NON_QOS. Call iwlagn_check_ratid_empty only inside
the
	if (tid != IWL_TID_NON_QOS)

a few lines earlier in the function.

Cc: <stable@vger.kernel.org>
Reported-by: Seraphime Kirkovski <kirkseraph@gmail.com>
Tested-by: Seraphime Kirkovski <kirkseraph@gmail.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
index adaa2f0097cc..fb40ddfced99 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
@@ -1189,11 +1189,11 @@ void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb)
 				next_reclaimed;
 			IWL_DEBUG_TX_REPLY(priv, "Next reclaimed packet:%d\n",
 						  next_reclaimed);
+			iwlagn_check_ratid_empty(priv, sta_id, tid);
 		}
 
 		iwl_trans_reclaim(priv->trans, txq_id, ssn, &skbs);
 
-		iwlagn_check_ratid_empty(priv, sta_id, tid);
 		freed = 0;
 
 		/* process frames */
-- 
2.11.0
