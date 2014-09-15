Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:51528 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbaIOFNU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:20 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so3438866wib.8
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:19 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/28] iwlwifi: mvm: disable aggregation queues in station DB in FW
Date: Mon, 15 Sep 2014 08:12:42 +0300
Message-Id: <1410757980-2138-10-git-send-email-egrumbach@gmail.com> (sfid-20140915_073114_324832_FB8D7B4C)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When disabling aggregation, disable the queues in the station
DB in the firmware, otherwise we leave the tfd_queue_mask in
a wrong state after an aggregation session has been torn down.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index dd9f3a4..666f16b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -948,8 +948,16 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		}
 
 		tid_data->ssn = 0xffff;
+		tid_data->state = IWL_AGG_OFF;
+		mvm->queue_to_mac80211[txq_id] = IWL_INVALID_MAC80211_QUEUE;
+		spin_unlock_bh(&mvmsta->lock);
+
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+
+		iwl_mvm_sta_tx_agg(mvm, sta, tid, txq_id, false);
+
 		iwl_trans_txq_disable(mvm->trans, txq_id, true);
-		/* fall through */
+		return 0;
 	case IWL_AGG_STARTING:
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
 		/*
@@ -1003,6 +1011,8 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		if (iwl_mvm_flush_tx_path(mvm, BIT(txq_id), true))
 			IWL_ERR(mvm, "Couldn't flush the AGG queue\n");
 
+		iwl_mvm_sta_tx_agg(mvm, sta, tid, txq_id, false);
+
 		iwl_trans_txq_disable(mvm->trans, tid_data->txq_id, true);
 	}
 
-- 
1.9.1

