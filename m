Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58071 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903Ab3GZITf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:19:35 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/7] iwlwifi: mvm: fix flushing not started aggregation sessions
Date: Fri, 26 Jul 2013 10:19:27 +0200
Message-Id: <1374826768-2440-6-git-send-email-johannes@sipsolutions.net> (sfid-20130726_101950_818160_A4676F91)
In-Reply-To: <1374826768-2440-1-git-send-email-johannes@sipsolutions.net>
References: <1374826675.8248.11.camel@jlt4.sipsolutions.net>
 <1374826768-2440-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a not fully started aggregation session is destroyed
and flushed, we get a warning, e.g.

  WARNING: at drivers/net/wireless/iwlwifi/pcie/tx.c:1142 iwl_trans_pcie_txq_disable+0x11c/0x160
  queue 16 not used
  Modules linked in: [...]
  Pid: 5135, comm: hostapd Tainted: G        W  O 3.5.0 #10
  Call Trace:
  wlan0: driver sets block=0 for sta 00:03:7f:10:44:d3
   [<ffffffff81036492>] warn_slowpath_common+0x72/0xa0
   [<ffffffff81036577>] warn_slowpath_fmt+0x47/0x50
   [<ffffffffa0368d6c>] iwl_trans_pcie_txq_disable+0x11c/0x160 [iwlwifi]
   [<ffffffffa03a2099>] iwl_mvm_sta_tx_agg_flush+0xe9/0x150 [iwlmvm]
   [<ffffffffa0396c43>] iwl_mvm_mac_ampdu_action+0xf3/0x1e0 [iwlmvm]
   [<ffffffffa0293ad3>] ___ieee80211_stop_tx_ba_session+0x193/0x920 [mac80211]
   [<ffffffffa0294ed8>] __ieee80211_stop_tx_ba_session+0x48/0x70 [mac80211]
   [<ffffffffa029159f>] ieee80211_sta_tear_down_BA_sessions+0x4f/0x80 [mac80211]
   [<ffffffffa028a686>] __sta_info_destroy+0x66/0x370 [mac80211]
   [<ffffffffa028abb4>] sta_info_destroy_addr_bss+0x44/0x70 [mac80211]
   [<ffffffffa02a3e26>] ieee80211_del_station+0x26/0x50 [mac80211]
   [<ffffffffa01e6395>] nl80211_del_station+0x85/0x200 [cfg80211]

when a station deauthenticated from us without fully setting
up the aggregation session.

Fix this by checking the aggregation state before removing
the hardware queue.

Cc: stable@vger.kernel.org
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 85d4bbe..563f559 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -915,6 +915,7 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_mvm_sta *mvmsta = (void *)sta->drv_priv;
 	struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
 	u16 txq_id;
+	enum iwl_mvm_agg_state old_state;
 
 	/*
 	 * First set the agg state to OFF to avoid calling
@@ -924,13 +925,17 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	txq_id = tid_data->txq_id;
 	IWL_DEBUG_TX_QUEUES(mvm, "Flush AGG: sta %d tid %d q %d state %d\n",
 			    mvmsta->sta_id, tid, txq_id, tid_data->state);
+	old_state = tid_data->state;
 	tid_data->state = IWL_AGG_OFF;
 	spin_unlock_bh(&mvmsta->lock);
 
-	if (iwl_mvm_flush_tx_path(mvm, BIT(txq_id), true))
-		IWL_ERR(mvm, "Couldn't flush the AGG queue\n");
+	if (old_state >= IWL_AGG_ON) {
+		if (iwl_mvm_flush_tx_path(mvm, BIT(txq_id), true))
+			IWL_ERR(mvm, "Couldn't flush the AGG queue\n");
+
+		iwl_trans_txq_disable(mvm->trans, tid_data->txq_id);
+	}
 
-	iwl_trans_txq_disable(mvm->trans, tid_data->txq_id);
 	mvm->queue_to_mac80211[tid_data->txq_id] =
 				IWL_INVALID_MAC80211_QUEUE;
 
-- 
1.8.0

