Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53676 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388018AbeGWRFM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 13:05:12 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 5/9] ath9k: clear potentially stale EOSP status bit in intermediate queues
Date: Mon, 23 Jul 2018 18:02:56 +0200
Message-Id: <20180723160300.58024-5-nbd@nbd.name> (sfid-20180723_180332_621297_56DEDF15)
In-Reply-To: <20180723160300.58024-1-nbd@nbd.name>
References: <20180723160300.58024-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prevents spurious ieee80211_sta_eosp calls.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index cab24b43ac88..56a0d1b7527a 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -969,7 +969,8 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
 		bf->bf_lastbf = bf;
 
 		tx_info = IEEE80211_SKB_CB(skb);
-		tx_info->flags &= ~IEEE80211_TX_CTL_CLEAR_PS_FILT;
+		tx_info->flags &= ~(IEEE80211_TX_CTL_CLEAR_PS_FILT |
+				    IEEE80211_TX_STATUS_EOSP);
 
 		/*
 		 * No aggregation session is running, but there may be frames
-- 
2.17.0
