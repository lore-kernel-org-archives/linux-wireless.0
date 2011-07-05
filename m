Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53675 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab1GEDLq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 23:11:46 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	mickflemm@gmail.com
Subject: [PATCH v2 8/8] ath5k: do not call ieee80211_stop_queue for queues not managed by mac80211
Date: Tue,  5 Jul 2011 10:11:24 +0700
Message-Id: <1309835484-26653-8-git-send-email-nbd@openwrt.org> (sfid-20110705_051157_458788_84C40165)
In-Reply-To: <1309835484-26653-7-git-send-email-nbd@openwrt.org>
References: <1309835484-26653-1-git-send-email-nbd@openwrt.org>
 <1309835484-26653-2-git-send-email-nbd@openwrt.org>
 <1309835484-26653-3-git-send-email-nbd@openwrt.org>
 <1309835484-26653-4-git-send-email-nbd@openwrt.org>
 <1309835484-26653-5-git-send-email-nbd@openwrt.org>
 <1309835484-26653-6-git-send-email-nbd@openwrt.org>
 <1309835484-26653-7-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using ieee80211_stop_queue, check the configured tx queue
limit before calling ieee80211_get_buffered_bc.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/base.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index efec14f..d889f33 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1555,7 +1555,8 @@ ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 		goto drop_packet;
 	}
 
-	if (txq->txq_len >= txq->txq_max)
+	if (txq->txq_len >= txq->txq_max &&
+	    txq->qnum <= AR5K_TX_QUEUE_ID_DATA_MAX)
 		ieee80211_stop_queue(hw, txq->qnum);
 
 	spin_lock_irqsave(&sc->txbuflock, flags);
@@ -1931,6 +1932,10 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 	skb = ieee80211_get_buffered_bc(sc->hw, vif);
 	while (skb) {
 		ath5k_tx_queue(sc->hw, skb, sc->cabq);
+
+		if (sc->cabq->txq_len >= sc->cabq->txq_max)
+			break;
+
 		skb = ieee80211_get_buffered_bc(sc->hw, vif);
 	}
 
-- 
1.7.3.2

