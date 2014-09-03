Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50869 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbaICT5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:57:18 -0400
Received: by mail-wi0-f173.google.com with SMTP id cc10so1633872wib.6
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:57:17 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 32/36] iwlwifi: mvm: clarify stop_count, remove transport_stopped
Date: Wed,  3 Sep 2014 22:56:20 +0300
Message-Id: <1409774184-24665-32-git-send-email-egrumbach@gmail.com> (sfid-20140903_215753_160138_6D8DAA32)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The queue handling is a bit unclear - we have an array for
stop_count[IWL_MAX_HW_QUEUES] but indices really are the
mac80211 queue numbers. Change the array to be only of the
right size for mac80211 queues (IEEE80211_MAX_QUEUES) and
rename it to be clearer.

While at it, also remove the unused transport queue stop
bitmap in mvm.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c  | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h | 3 +--
 drivers/net/wireless/iwlwifi/mvm/ops.c | 9 +++------
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index c958a7d..21d60602 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -244,10 +244,10 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 			mvm->queue_to_mac80211[i] = i;
 		else
 			mvm->queue_to_mac80211[i] = IWL_INVALID_MAC80211_QUEUE;
-		atomic_set(&mvm->queue_stop_count[i], 0);
 	}
 
-	mvm->transport_queue_stop = 0;
+	for (i = 0; i < IEEE80211_MAX_QUEUES; i++)
+		atomic_set(&mvm->mac80211_queue_stop_count[i], 0);
 
 	mvm->ucode_loaded = true;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index b529cf6..e292de9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -562,9 +562,8 @@ struct iwl_mvm {
 
 	struct mvm_statistics_rx rx_stats;
 
-	unsigned long transport_queue_stop;
 	u8 queue_to_mac80211[IWL_MAX_HW_QUEUES];
-	atomic_t queue_stop_count[IWL_MAX_HW_QUEUES];
+	atomic_t mac80211_queue_stop_count[IEEE80211_MAX_QUEUES];
 
 	const char *nvm_file_name;
 	struct iwl_nvm_data *nvm_data;
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index d7ec07d..87f278c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -703,14 +703,13 @@ static void iwl_mvm_stop_sw_queue(struct iwl_op_mode *op_mode, int queue)
 	if (WARN_ON_ONCE(mq == IWL_INVALID_MAC80211_QUEUE))
 		return;
 
-	if (atomic_inc_return(&mvm->queue_stop_count[mq]) > 1) {
+	if (atomic_inc_return(&mvm->mac80211_queue_stop_count[mq]) > 1) {
 		IWL_DEBUG_TX_QUEUES(mvm,
 				    "queue %d (mac80211 %d) already stopped\n",
 				    queue, mq);
 		return;
 	}
 
-	set_bit(mq, &mvm->transport_queue_stop);
 	ieee80211_stop_queue(mvm->hw, mq);
 }
 
@@ -722,15 +721,13 @@ static void iwl_mvm_wake_sw_queue(struct iwl_op_mode *op_mode, int queue)
 	if (WARN_ON_ONCE(mq == IWL_INVALID_MAC80211_QUEUE))
 		return;
 
-	if (atomic_dec_return(&mvm->queue_stop_count[mq]) > 0) {
+	if (atomic_dec_return(&mvm->mac80211_queue_stop_count[mq]) > 0) {
 		IWL_DEBUG_TX_QUEUES(mvm,
-				    "queue %d (mac80211 %d) already awake\n",
+				    "queue %d (mac80211 %d) still stopped\n",
 				    queue, mq);
 		return;
 	}
 
-	clear_bit(mq, &mvm->transport_queue_stop);
-
 	ieee80211_wake_queue(mvm->hw, mq);
 }
 
-- 
1.9.1

