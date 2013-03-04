Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447Ab3CDOBU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 09:01:20 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/11] iwlwifi: mvm: don't warn on normal BAR sending
Date: Mon,  4 Mar 2013 15:00:51 +0100
Message-Id: <1362405651-26456-11-git-send-email-johannes@sipsolutions.net> (sfid-20130304_150129_808442_373B5346)
In-Reply-To: <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
References: <1362405609.21028.12.camel@jlt4.sipsolutions.net>
 <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This flow happens when we get a failed single Tx response
on an AMPDU queue. In this case, the frame won't be sent
any more. So we need to move the window on the recipient
side. This is done by a BAR.

Now if we are in the following case: 10, 12 and 13 are ACKed
and 11 isn't.

 10  11  12  13.
 V   X   V   V

Then, 11 will be sent 16 times as an MPDU (as oppsed to
A-MPDU). If this failed, we are entering the flow described
above. So we need to send a BAR with ssn = 12.
But in this case, the scheduler will tell us to free frames
up to 13 (included).

So, it is perfectly possible to get a failed single Tx
response on an AMPDU queue that makes the scheduler's ssn
jump by more than 1 single packet.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 6b67ce3..6645efe 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -607,12 +607,8 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 
 		/* Single frame failure in an AMPDU queue => send BAR */
 		if (txq_id >= IWL_FIRST_AMPDU_QUEUE &&
-		    !(info->flags & IEEE80211_TX_STAT_ACK)) {
-			/* there must be only one skb in the skb_list */
-			WARN_ON_ONCE(skb_freed > 1 ||
-				     !skb_queue_empty(&skbs));
+		    !(info->flags & IEEE80211_TX_STAT_ACK))
 			info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
-		}
 
 		/* W/A FW bug: seq_ctl is wrong when the queue is flushed */
 		if (status == TX_STATUS_FAIL_FIFO_FLUSHED) {
-- 
1.8.0

