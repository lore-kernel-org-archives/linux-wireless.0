Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:60289 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555AbaGVT1V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:21 -0400
Received: by mail-we0-f178.google.com with SMTP id w61so113908wes.23
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:20 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ariej Marjieh <ariej.marjieh@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/20] iwlwifi: mvm: Enabling Aux Queue
Date: Tue, 22 Jul 2014 22:26:38 +0300
Message-Id: <1406057211-31752-7-git-send-email-egrumbach@gmail.com> (sfid-20140722_212738_493770_71884E42)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ariej Marjieh <ariej.marjieh@intel.com>

Enabling the Aux queue and mapping it to FIFO 5.
Defining the Aux queue for the Aux station.

Signed-off-by: Ariej Marjieh <ariej.marjieh@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c |  8 ++++++--
 drivers/net/wireless/iwlwifi/mvm/tx.c  | 10 ++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 5445934..7635488 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -526,8 +526,12 @@ int iwl_mvm_add_aux_sta(struct iwl_mvm *mvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
-	/* Add the aux station, but without any queues */
-	ret = iwl_mvm_allocate_int_sta(mvm, &mvm->aux_sta, 0,
+	/* Map Aux queue to fifo - needs to happen before adding Aux station */
+	iwl_trans_ac_txq_enable(mvm->trans, mvm->aux_queue,
+				IWL_MVM_TX_FIFO_MCAST);
+
+	/* Allocate aux station and assign to it the aux queue */
+	ret = iwl_mvm_allocate_int_sta(mvm, &mvm->aux_sta, BIT(mvm->aux_queue),
 				       NL80211_IFTYPE_UNSPECIFIED);
 	if (ret)
 		return ret;
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index e9ff386..dbc8707 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -311,6 +311,16 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 		return -1;
 
 	/*
+	 * IWL_MVM_OFFCHANNEL_QUEUE is used for ROC packets that can be used
+	 * in 2 different types of vifs, P2P & STATION. P2P uses the offchannel
+	 * queue. STATION (HS2.0) uses the auxiliary context of the FW,
+	 * and hence needs to be sent on the aux queue
+	 */
+	if (IEEE80211_SKB_CB(skb)->hw_queue == IWL_MVM_OFFCHANNEL_QUEUE &&
+	    info->control.vif->type == NL80211_IFTYPE_STATION)
+		IEEE80211_SKB_CB(skb)->hw_queue = mvm->aux_queue;
+
+	/*
 	 * If the interface on which frame is sent is the P2P_DEVICE
 	 * or an AP/GO interface use the broadcast station associated
 	 * with it; otherwise use the AUX station.
-- 
1.8.3.2

