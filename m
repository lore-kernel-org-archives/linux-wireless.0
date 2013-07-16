Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:60806 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595Ab3GPJF1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 05:05:27 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <ymir.kr@gmail.com>, <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix NULL dereference for injected packets
Date: Tue, 16 Jul 2013 11:04:54 +0200
Message-ID: <1373965494-17726-1-git-send-email-michal.kazior@tieto.com> (sfid-20130716_110532_674782_BFF507B0)
In-Reply-To: <CAMQ0DfRpqk6ufb4rAifjy651oM9-GZyDpMLL+mGVzzVSVjVyJA@mail.gmail.com>
References: <CAMQ0DfRpqk6ufb4rAifjy651oM9-GZyDpMLL+mGVzzVSVjVyJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tx processing functions dereference vif and caused
NULL to be dereferenced for injected frames.

Don't call these functions at all for injected
frames. It doesn't make much sense to do so
anyway.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5082503..cdc08a0 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1687,10 +1687,14 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 	}
 
-	ath10k_tx_h_qos_workaround(hw, control, skb);
-	ath10k_tx_h_update_wep_key(skb);
-	ath10k_tx_h_add_p2p_noa_ie(ar, skb);
-	ath10k_tx_h_seq_no(skb);
+	/* it makes no sense to process injected frames like that */
+	if (info->control.vif &&
+	    info->control.vif->type != NL80211_IFTYPE_MONITOR) {
+		ath10k_tx_h_qos_workaround(hw, control, skb);
+		ath10k_tx_h_update_wep_key(skb);
+		ath10k_tx_h_add_p2p_noa_ie(ar, skb);
+		ath10k_tx_h_seq_no(skb);
+	}
 
 	memset(ATH10K_SKB_CB(skb), 0, sizeof(*ATH10K_SKB_CB(skb)));
 	ATH10K_SKB_CB(skb)->htt.vdev_id = vdev_id;
-- 
1.7.9.5

