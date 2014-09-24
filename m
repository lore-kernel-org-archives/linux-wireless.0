Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:46978 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaIXGRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 02:17:52 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 4/5] ath9k: Use normal queues for offchannel frames
Date: Wed, 24 Sep 2014 11:48:15 +0530
Message-Id: <1411539496-30595-5-git-send-email-sujith@msujith.org> (sfid-20140924_081759_837904_C1052A8C)
In-Reply-To: <1411539496-30595-1-git-send-email-sujith@msujith.org>
References: <1411539496-30595-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

There is no reason why frames marked with
IEEE80211_TX_CTL_TX_OFFCHAN have to be sent using
the UAPSD queue. Since mac80211 makes sure that
RoC is done before pushing an offchannel frame
to the driver, we can use the normal TX queues
for transmission.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 2c8327f..00931b6 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2253,8 +2253,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (txctl->an && queue)
 		tid = ath_get_skb_tid(sc, txctl->an, skb);
 
-	if (info->flags & (IEEE80211_TX_CTL_PS_RESPONSE |
-			   IEEE80211_TX_CTL_TX_OFFCHAN)) {
+	if (info->flags & IEEE80211_TX_CTL_PS_RESPONSE) {
 		ath_txq_unlock(sc, txq);
 		txq = sc->tx.uapsdq;
 		ath_txq_lock(sc, txq);
-- 
2.1.0

