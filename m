Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46966 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S935605AbeE3HUT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 03:20:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 30 May 2018 10:20:04 +0300
Message-Id: <20180530072005.633-10-luca@coelho.fi> (sfid-20180530_092031_813889_FFBA9410)
In-Reply-To: <20180530072005.633-1-luca@coelho.fi>
References: <20180530072005.633-1-luca@coelho.fi>
Subject: [PATCH 09/10] iwlwifi: mvm: fix race in queue notification wait
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Initially in this code, the race didn't matter since it didn't
do anything. Latest with the commit I marked this as fixing it
started to matter as something got done here that needed other
data that got freed as soon as the queue notification wait was
returning.

In the scenario we saw, apparently the IWL_MVM_RXQ_NOTIF_DEL_BA
event was sent to all queues, but processing the last event we
returned from iwl_mvm_sync_rx_queues_internal() and then from
iwl_mvm_free_reorder() and continued some processing before
wl_mvm_del_ba() was even invoked on the other CPU. Thus, when
the latter finally ran, it found that mvm->baid_map[baid] was
no longer valid.

Correct the race by moving the counter decrement and wake_up()
to be done only after all the per-event processing completed.
Note that in the commit I marked as being fixed the wake_up()
didn't exist yet (and the code was otherwise problematic) but
this particular problem already existed in a way.

Fixes: b915c10174fb ("iwlwifi: mvm: add reorder buffer per queue")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 2b1f0dc73c25..129c4c09648d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -590,14 +590,10 @@ void iwl_mvm_rx_queue_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	notif = (void *)pkt->data;
 	internal_notif = (void *)notif->payload;
 
-	if (internal_notif->sync) {
-		if (mvm->queue_sync_cookie != internal_notif->cookie) {
-			WARN_ONCE(1,
-				  "Received expired RX queue sync message\n");
-			return;
-		}
-		if (!atomic_dec_return(&mvm->queue_sync_counter))
-			wake_up(&mvm->rx_sync_waitq);
+	if (internal_notif->sync &&
+	    mvm->queue_sync_cookie != internal_notif->cookie) {
+		WARN_ONCE(1, "Received expired RX queue sync message\n");
+		return;
 	}
 
 	switch (internal_notif->type) {
@@ -609,6 +605,10 @@ void iwl_mvm_rx_queue_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	default:
 		WARN_ONCE(1, "Invalid identifier %d", internal_notif->type);
 	}
+
+	if (internal_notif->sync &&
+	    !atomic_dec_return(&mvm->queue_sync_counter))
+		wake_up(&mvm->rx_sync_waitq);
 }
 
 /*
-- 
2.17.0
