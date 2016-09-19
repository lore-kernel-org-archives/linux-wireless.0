Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55818 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932567AbcISHak (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:30:40 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:06 +0300
Message-Id: <20160919073028.22065-3-luca@coelho.fi> (sfid-20160919_093046_220371_7F405444)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 03/25] iwlwifi: mvm: cleanup skb queue functions use
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Use skb_queue_empty() and not skb_peek_tail() to check for
empty list.
Avoid a redundant check as well - loop will take care of it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index d6d9ec4..b386628 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -418,10 +418,11 @@ static void iwl_mvm_release_frames(struct iwl_mvm *mvm,
 
 		ssn = ieee80211_sn_inc(ssn);
 
-		/* holes are valid since nssn indicates frames were received. */
-		if (skb_queue_empty(skb_list) || !skb_peek_tail(skb_list))
-			continue;
-		/* Empty the list. Will have more than one frame for A-MSDU */
+		/*
+		 * Empty the list. Will have more than one frame for A-MSDU.
+		 * Empty list is valid as well since nssn indicates frames were
+		 * received.
+		 */
 		while ((skb = __skb_dequeue(skb_list))) {
 			iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb,
 							reorder_buf->queue,
@@ -434,7 +435,7 @@ static void iwl_mvm_release_frames(struct iwl_mvm *mvm,
 	if (reorder_buf->num_stored && !reorder_buf->removed) {
 		u16 index = reorder_buf->head_sn % reorder_buf->buf_size;
 
-		while (!skb_peek_tail(&reorder_buf->entries[index]))
+		while (skb_queue_empty(&reorder_buf->entries[index]))
 			index = (index + 1) % reorder_buf->buf_size;
 		/* modify timer to match next frame's expiration time */
 		mod_timer(&reorder_buf->reorder_timer,
@@ -462,7 +463,7 @@ void iwl_mvm_reorder_timer_expired(unsigned long data)
 	for (i = 0; i < buf->buf_size ; i++) {
 		index = (buf->head_sn + i) % buf->buf_size;
 
-		if (!skb_peek_tail(&buf->entries[index]))
+		if (skb_queue_empty(&buf->entries[index]))
 			continue;
 		if (!time_after(jiffies, buf->reorder_time[index] +
 				RX_REORDER_BUF_TIMEOUT_MQ))
-- 
2.9.3
