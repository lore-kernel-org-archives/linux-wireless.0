Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:35571 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347AbcC3OGb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:31 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 41/43] iwlwifi: mvm: fix inconsistent lock in dqa mode
Date: Wed, 30 Mar 2016 17:05:13 +0300
Message-Id: <1459346715-7954-41-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160703_281776_BF0E6609)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

When working in DQA mode, there is a lockdep log warning
about an inconsistent state of the mvmsta->lock and the
mvm->queue_info_lock. Fix this. This mode is not activated
for now.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index e157bd5..12614b7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -296,7 +296,7 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	spin_lock(&mvm->queue_info_lock);
+	spin_lock_bh(&mvm->queue_info_lock);
 
 	/*
 	 * Non-QoS, QoS NDP and MGMT frames should go to a MGMT queue, if one
@@ -324,7 +324,7 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	if (queue >= 0)
 		mvm->queue_info[queue].setup_reserved = false;
 
-	spin_unlock(&mvm->queue_info_lock);
+	spin_unlock_bh(&mvm->queue_info_lock);
 
 	/* TODO: support shared queues for same RA */
 	if (queue < 0)
@@ -402,12 +402,12 @@ static void iwl_mvm_tx_deferred_stream(struct iwl_mvm *mvm,
 
 	__skb_queue_head_init(&deferred_tx);
 
+	/* Disable bottom-halves when entering TX path */
+	local_bh_disable();
 	spin_lock(&mvmsta->lock);
 	skb_queue_splice_init(&tid_data->deferred_tx_frames, &deferred_tx);
 	spin_unlock(&mvmsta->lock);
 
-	/* Disable bottom-halves when entering TX path */
-	local_bh_disable();
 	while ((skb = __skb_dequeue(&deferred_tx)))
 		if (no_queue || iwl_mvm_tx_skb(mvm, skb, sta))
 			ieee80211_free_txskb(mvm->hw, skb);
-- 
2.5.0

