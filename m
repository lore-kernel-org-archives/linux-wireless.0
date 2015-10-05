Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57221 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751872AbbJEPB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:01:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:47 +0300
Message-Id: <1444055820-27506-16-git-send-email-luca@coelho.fi> (sfid-20151005_170201_332785_BDB94F7A)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 16/29] iwlwifi: mvm: support enabling a queue with a given ssn
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

When enabling a queue, the default SSN is 0.

Allow determining what that SSN should be, if required. This
can happen, for example, if a queue gets reconfigured.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 6 +++---
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/sta.c      | 5 +++--
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index d2a221d..9d36ba7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -487,17 +487,17 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	case NL80211_IFTYPE_P2P_DEVICE:
 		iwl_mvm_enable_ac_txq(mvm, IWL_MVM_OFFCHANNEL_QUEUE,
 				      IWL_MVM_OFFCHANNEL_QUEUE,
-				      IWL_MVM_TX_FIFO_VO, wdg_timeout);
+				      IWL_MVM_TX_FIFO_VO, 0, wdg_timeout);
 		break;
 	case NL80211_IFTYPE_AP:
 		iwl_mvm_enable_ac_txq(mvm, vif->cab_queue, vif->cab_queue,
-				      IWL_MVM_TX_FIFO_MCAST, wdg_timeout);
+				      IWL_MVM_TX_FIFO_MCAST, 0, wdg_timeout);
 		/* fall through */
 	default:
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 			iwl_mvm_enable_ac_txq(mvm, vif->hw_queue[ac],
 					      vif->hw_queue[ac],
-					      iwl_mvm_ac_to_tx_fifo[ac],
+					      iwl_mvm_ac_to_tx_fifo[ac], 0,
 					      wdg_timeout);
 		break;
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index a7a9619..99182df 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1366,7 +1366,7 @@ int iwl_mvm_find_free_queue(struct iwl_mvm *mvm, u8 minq, u8 maxq);
 
 static inline
 void iwl_mvm_enable_ac_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
-			   u8 fifo, unsigned int wdg_timeout)
+			   u8 fifo, u16 ssn, unsigned int wdg_timeout)
 {
 	struct iwl_trans_txq_scd_cfg cfg = {
 		.fifo = fifo,
@@ -1375,7 +1375,7 @@ void iwl_mvm_enable_ac_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 		.frame_limit = IWL_FRAME_LIMIT,
 	};
 
-	iwl_mvm_enable_txq(mvm, queue, mac80211_queue, 0, &cfg, wdg_timeout);
+	iwl_mvm_enable_txq(mvm, queue, mac80211_queue, ssn, &cfg, wdg_timeout);
 }
 
 static inline void iwl_mvm_enable_agg_txq(struct iwl_mvm *mvm, int queue,
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 9bda6c9..a9a3eb6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -235,7 +235,8 @@ static int iwl_mvm_tdls_sta_init(struct iwl_mvm *mvm,
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		iwl_mvm_enable_ac_txq(mvm, mvmsta->hw_queue[ac],
 				      mvmsta->hw_queue[ac],
-				      iwl_mvm_ac_to_tx_fifo[ac], wdg_timeout);
+				      iwl_mvm_ac_to_tx_fifo[ac], 0,
+				      wdg_timeout);
 		mvmsta->tfd_queue_msk |= BIT(mvmsta->hw_queue[ac]);
 	}
 
@@ -653,7 +654,7 @@ int iwl_mvm_add_aux_sta(struct iwl_mvm *mvm)
 
 	/* Map Aux queue to fifo - needs to happen before adding Aux station */
 	iwl_mvm_enable_ac_txq(mvm, mvm->aux_queue, mvm->aux_queue,
-			      IWL_MVM_TX_FIFO_MCAST, wdg_timeout);
+			      IWL_MVM_TX_FIFO_MCAST, 0, wdg_timeout);
 
 	/* Allocate aux station and assign to it the aux queue */
 	ret = iwl_mvm_allocate_int_sta(mvm, &mvm->aux_sta, BIT(mvm->aux_queue),
-- 
2.5.3

