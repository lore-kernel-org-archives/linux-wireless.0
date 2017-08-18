Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44564 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751682AbdHRPwN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 11:52:13 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 18:49:10 +0300
Message-Id: <20170818154922.2904-13-luca@coelho.fi> (sfid-20170818_175215_653042_9C615AC9)
In-Reply-To: <20170818154922.2904-1-luca@coelho.fi>
References: <20170818154922.2904-1-luca@coelho.fi>
Subject: [PATCH 12/24] iwlwifi: mvm: don't send BAR on flushed frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we flush a queue, the packets will have a 'failed'
status but we shouldn't send a BAR. This check was missing.
Because of that, when we got an ampdu_action with
IEEE80211_AMPDU_TX_STOP_FLUSH, we started the following
ping pong with the firmware:

1) Set the station as 'draining'
2) Get a failed Tx status (DRAINED)
3) Send a BAR because of the failed Tx status

(loop of 2 and 3)

This loop wasn't endless since the BAR isn't sent on a
queue that would trigger a "nested" BAR.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 48f028366d51..52f9e8a76124 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1331,6 +1331,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 	while (!skb_queue_empty(&skbs)) {
 		struct sk_buff *skb = __skb_dequeue(&skbs);
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+		bool flushed = false;
 
 		skb_freed++;
 
@@ -1344,6 +1345,10 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 		case TX_STATUS_DIRECT_DONE:
 			info->flags |= IEEE80211_TX_STAT_ACK;
 			break;
+		case TX_STATUS_FAIL_FIFO_FLUSHED:
+		case TX_STATUS_FAIL_DRAIN_FLOW:
+			flushed = true;
+			break;
 		case TX_STATUS_FAIL_DEST_PS:
 			/* the FW should have stopped the queue and not
 			 * return this status
@@ -1366,7 +1371,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 		/* Single frame failure in an AMPDU queue => send BAR */
 		if (info->flags & IEEE80211_TX_CTL_AMPDU &&
 		    !(info->flags & IEEE80211_TX_STAT_ACK) &&
-		    !(info->flags & IEEE80211_TX_STAT_TX_FILTERED))
+		    !(info->flags & IEEE80211_TX_STAT_TX_FILTERED) && !flushed)
 			info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
 		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 
-- 
2.14.1
