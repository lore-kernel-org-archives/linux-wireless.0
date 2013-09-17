Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54237 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab3IQKF0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 06:05:26 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.12] ath9k: don't use BAW tracking on PS responses for non-AMPDU packets
Date: Tue, 17 Sep 2013 12:05:15 +0200
Message-Id: <1379412315-85130-1-git-send-email-nbd@openwrt.org> (sfid-20130917_120529_765660_4481D02E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When .release_buffered_frames was implemented, only A-MPDU packets were
buffered internally. Now that this has changed, the BUF_AMPDU flag needs
to be checked before calling ath_tx_addto_baw

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 5849960..9b3736e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1556,8 +1556,10 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 			__skb_unlink(bf->bf_mpdu, tid_q);
 			list_add_tail(&bf->list, &bf_q);
 			ath_set_rates(tid->an->vif, tid->an->sta, bf);
-			ath_tx_addto_baw(sc, tid, bf);
-			bf->bf_state.bf_type &= ~BUF_AGGR;
+			if (bf_isampdu(bf)) {
+				ath_tx_addto_baw(sc, tid, bf);
+				bf->bf_state.bf_type &= ~BUF_AGGR;
+			}
 			if (bf_tail)
 				bf_tail->bf_next = bf;
 
-- 
1.8.0.2

