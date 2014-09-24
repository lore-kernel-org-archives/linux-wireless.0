Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:35962 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaIXGRr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 02:17:47 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 5/5] ath9k: Fix offchannel queuing
Date: Wed, 24 Sep 2014 11:48:16 +0530
Message-Id: <1411539496-30595-6-git-send-email-sujith@msujith.org> (sfid-20140924_081757_146319_D12907DE)
In-Reply-To: <1411539496-30595-1-git-send-email-sujith@msujith.org>
References: <1411539496-30595-1-git-send-email-sujith@msujith.org>
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
index 00931b6..aae70a1 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2205,7 +2205,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ath_txq *txq = txctl->txq;
 	struct ath_atx_tid *tid = NULL;
 	struct ath_buf *bf;
-	bool queue;
+	bool queue, skip_uapsd = false;
 	int q, ret;
 
 	if (vif)
@@ -2246,14 +2246,14 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
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

