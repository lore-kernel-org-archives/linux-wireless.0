Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:62205 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948AbaJUQFE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 12:05:04 -0400
Received: by mail-wi0-f173.google.com with SMTP id fb4so10656269wid.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2014 09:05:02 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 6/8] iwlwifi: mvm: ROC - bug fixes around time events and locking
Date: Tue, 21 Oct 2014 19:04:37 +0300
Message-Id: <1413907479-9073-6-git-send-email-egrumbach@gmail.com> (sfid-20141021_180514_685990_48680D8B)
In-Reply-To: <CANUX_P0iZO6AGwcsKO3+xZZcH5ns+vMUimo+BxHNpyBhhURKRw@mail.gmail.com>
References: <CANUX_P0iZO6AGwcsKO3+xZZcH5ns+vMUimo+BxHNpyBhhURKRw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Don't add the time event to the list. We added it several
times the same time event, which leads to an infinite loop
when walking the list.

Since we (currently) don't support more than one ROC for STA
vif at a time, enforce this and don't add the time event
to any list.

We were also missing the locking of the mutex which led to
a lockdep splat - fix that.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   | 25 ++++++++++++++++---------
 drivers/net/wireless/iwlwifi/mvm/time-event.c |  2 +-
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 892a6bc..585fe5b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -526,7 +526,8 @@ static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 	}
 
 	if (IEEE80211_SKB_CB(skb)->hw_queue == IWL_MVM_OFFCHANNEL_QUEUE &&
-	    !test_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status))
+	    !test_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status) &&
+	    !test_bit(IWL_MVM_STATUS_ROC_AUX_RUNNING, &mvm->status))
 		goto drop;
 
 	/* treat non-bufferable MMPDUs as broadcast if sta is sleeping */
@@ -2374,14 +2375,19 @@ static int iwl_mvm_send_aux_roc_cmd(struct iwl_mvm *mvm,
 	/* Set the node address */
 	memcpy(aux_roc_req.node_addr, vif->addr, ETH_ALEN);
 
+	lockdep_assert_held(&mvm->mutex);
+
+	spin_lock_bh(&mvm->time_event_lock);
+
+	if (WARN_ON(te_data->id == HOT_SPOT_CMD)) {
+		spin_unlock_bh(&mvm->time_event_lock);
+		return -EIO;
+	}
+
 	te_data->vif = vif;
 	te_data->duration = duration;
 	te_data->id = HOT_SPOT_CMD;
 
-	lockdep_assert_held(&mvm->mutex);
-
-	spin_lock_bh(&mvm->time_event_lock);
-	list_add_tail(&te_data->list, &mvm->time_event_list);
 	spin_unlock_bh(&mvm->time_event_lock);
 
 	/*
@@ -2437,22 +2443,23 @@ static int iwl_mvm_roc(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(mvm, "enter (%d, %d, %d)\n", channel->hw_value,
 			   duration, type);
 
+	mutex_lock(&mvm->mutex);
+
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		/* Use aux roc framework (HS20) */
 		ret = iwl_mvm_send_aux_roc_cmd(mvm, channel,
 					       vif, duration);
-		return ret;
+		goto out_unlock;
 	case NL80211_IFTYPE_P2P_DEVICE:
 		/* handle below */
 		break;
 	default:
 		IWL_ERR(mvm, "vif isn't P2P_DEVICE: %d\n", vif->type);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_unlock;
 	}
 
-	mutex_lock(&mvm->mutex);
-
 	for (i = 0; i < NUM_PHY_CTX; i++) {
 		phy_ctxt = &mvm->phy_ctxts[i];
 		if (phy_ctxt->ref == 0 || mvmvif->phy_ctxt == phy_ctxt)
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index b7f9e61..6dfad23 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -305,8 +305,8 @@ static int iwl_mvm_aux_roc_te_handle_notif(struct iwl_mvm *mvm,
 		te_data->running = false;
 		te_data->vif = NULL;
 		te_data->uid = 0;
+		te_data->id = TE_MAX;
 	} else if (le32_to_cpu(notif->action) == TE_V2_NOTIF_HOST_EVENT_START) {
-		set_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status);
 		set_bit(IWL_MVM_STATUS_ROC_AUX_RUNNING, &mvm->status);
 		te_data->running = true;
 		ieee80211_ready_on_channel(mvm->hw); /* Start TE */
-- 
1.9.1

