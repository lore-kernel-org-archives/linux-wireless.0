Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38034 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752663AbdBCOkm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:40:42 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:38:06 +0200
Message-Id: <20170203143812.7525-20-luca@coelho.fi> (sfid-20170203_154046_840110_CE03C662)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 19/25] iwlwifi: mvm: align copy-break SKB payload for MQ RX
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a small frame is copied completely into the skb->head, the code
doesn't take alignment into account, making mac80211 copy it again
later on architectures that need the alignment. Avoid this by taking
the PAD flag from the device into account when copying.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 6c802cee900c..c154ab42c80d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -149,8 +149,17 @@ static void iwl_mvm_create_skb(struct sk_buff *skb, struct ieee80211_hdr *hdr,
 	unsigned int headlen, fraglen, pad_len = 0;
 	unsigned int hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
-	if (desc->mac_flags2 & IWL_RX_MPDU_MFLG2_PAD)
+	if (desc->mac_flags2 & IWL_RX_MPDU_MFLG2_PAD) {
 		pad_len = 2;
+
+		/*
+		 * If the device inserted padding it means that (it thought)
+		 * the 802.11 header wasn't a multiple of 4 bytes long. In
+		 * this case, reserve two bytes at the start of the SKB to
+		 * align the payload properly in case we end up copying it.
+		 */
+		skb_reserve(skb, pad_len);
+	}
 	len -= pad_len;
 
 	/* If frame is small enough to fit in skb->head, pull it completely.
-- 
2.11.0
