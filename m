Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40850 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750847AbeDVI2B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Apr 2018 04:28:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 22 Apr 2018 11:27:39 +0300
Message-Id: <20180422082745.9743-7-luca@coelho.fi> (sfid-20180422_102818_575657_B77FC374)
In-Reply-To: <20180422082745.9743-1-luca@coelho.fi>
References: <20180422082745.9743-1-luca@coelho.fi>
Subject: [PATCH 06/12] iwlwifi: mvm: move skb padding reservation earlier
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Future changes will require moving the HE radiotap data into
the SKB head, but this means we need to have the alignment
reservation done before that. To prepare, move the alignment
reservation earlier here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 20 ++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 34791628cfb3..bb63e75a9b7f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -151,17 +151,9 @@ static void iwl_mvm_create_skb(struct sk_buff *skb, struct ieee80211_hdr *hdr,
 	unsigned int hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
 	if (desc->mac_flags2 & IWL_RX_MPDU_MFLG2_PAD) {
+		len -= 2;
 		pad_len = 2;
-
-		/*
-		 * If the device inserted padding it means that (it thought)
-		 * the 802.11 header wasn't a multiple of 4 bytes long. In
-		 * this case, reserve two bytes at the start of the SKB to
-		 * align the payload properly in case we end up copying it.
-		 */
-		skb_reserve(skb, pad_len);
 	}
-	len -= pad_len;
 
 	/* If frame is small enough to fit in skb->head, pull it completely.
 	 * If not, only pull ieee80211_hdr (including crypto if present, and
@@ -866,6 +858,16 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		return;
 	}
 
+	if (desc->mac_flags2 & IWL_RX_MPDU_MFLG2_PAD) {
+		/*
+		 * If the device inserted padding it means that (it thought)
+		 * the 802.11 header wasn't a multiple of 4 bytes long. In
+		 * this case, reserve two bytes at the start of the SKB to
+		 * align the payload properly in case we end up copying it.
+		 */
+		skb_reserve(skb, 2);
+	}
+
 	rx_status = IEEE80211_SKB_RXCB(skb);
 
 	if (iwl_mvm_rx_crypto(mvm, hdr, rx_status, desc,
-- 
2.17.0
