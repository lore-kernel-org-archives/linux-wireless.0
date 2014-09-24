Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:42539 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaIXEh0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 00:37:26 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com
Subject: [RFC 4/4] ath9k: Fix offchannel queuing
Date: Wed, 24 Sep 2014 10:07:32 +0530
Message-Id: <1411533452-22921-5-git-send-email-sujith@msujith.org> (sfid-20140924_063728_898990_9B0E3F9D)
In-Reply-To: <1411533452-22921-1-git-send-email-sujith@msujith.org>
References: <1411533452-22921-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Clearing IEEE80211_TX_CTL_PS_RESPONSE in a frame
that is not in the current context doesn't seem right.
Instead make sure that we don't add such frames
to the UAPSD queue by using a local variable.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 4d00f59..3e3a41c 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2205,7 +2205,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ath_txq *txq = txctl->txq;
 	struct ath_atx_tid *tid = NULL;
 	struct ath_buf *bf;
-	bool queue;
+	bool queue, skip_uapsd;
 	int q, ret;
 
 	if (vif)
@@ -2243,14 +2243,14 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	     sc->cur_chan->stopped) && !txctl->force_channel) {
 		if (!txctl->an)
 			txctl->an = &avp->mcast_node;
-		info->flags &= ~IEEE80211_TX_CTL_PS_RESPONSE;
 		queue = true;
+		skip_uapsd = true;
 	}
 
 	if (txctl->an && queue)
 		tid = ath_get_skb_tid(sc, txctl->an, skb);
 
-	if (info->flags & IEEE80211_TX_CTL_PS_RESPONSE) {
+	if (!skip_uapsd && (info->flags & IEEE80211_TX_CTL_PS_RESPONSE)) {
 		ath_txq_unlock(sc, txq);
 		txq = sc->tx.uapsdq;
 		ath_txq_lock(sc, txq);
-- 
2.1.0

