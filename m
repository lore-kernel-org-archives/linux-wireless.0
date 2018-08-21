Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42950 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726253AbeHUJ4Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 05:56:25 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 09:36:54 +0300
Message-Id: <20180821063657.30071-13-luca@coelho.fi> (sfid-20180821_083743_759052_B0E0C70D)
In-Reply-To: <20180821063657.30071-1-luca@coelho.fi>
References: <20180821063657.30071-1-luca@coelho.fi>
Subject: [PATCH 12/15] iwlwifi: mvm: fix BAR seq ctrl reporting
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

There is a bug in FW where the sequence control may be
incorrect, and the driver overrides it with the value
of the ieee80211 header.

However, in BAR there is no sequence control in the header,
which result with arbitrary sequence.

This access to an unknown location is bad and it makes the
logs very confusing - so fix it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 796f010204d5..31a81a4c6e78 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1480,6 +1480,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 	while (!skb_queue_empty(&skbs)) {
 		struct sk_buff *skb = __skb_dequeue(&skbs);
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+		struct ieee80211_hdr *hdr = (void *)skb->data;
 		bool flushed = false;
 
 		skb_freed++;
@@ -1524,11 +1525,11 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 			info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
 		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 
-		/* W/A FW bug: seq_ctl is wrong when the status isn't success */
-		if (status != TX_STATUS_SUCCESS) {
-			struct ieee80211_hdr *hdr = (void *)skb->data;
+		/* W/A FW bug: seq_ctl is wrong upon failure / BAR frame */
+		if (ieee80211_is_back_req(hdr->frame_control))
+			seq_ctl = 0;
+		else if (status != TX_STATUS_SUCCESS)
 			seq_ctl = le16_to_cpu(hdr->seq_ctrl);
-		}
 
 		if (unlikely(!seq_ctl)) {
 			struct ieee80211_hdr *hdr = (void *)skb->data;
-- 
2.18.0
