Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from linknet-ip-202.77.119.130.link.net.id ([202.77.119.130]:59114
	"EHLO ppac-jak-id-1.inter-touch.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754960Ab1GDGLE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 02:11:04 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH 8/8] ath5k: do not call ieee80211_stop_queue for queues not managed by mac80211
Date: Mon,  4 Jul 2011 12:47:47 +0700
Message-Id: <1309758467-1712-8-git-send-email-nbd@openwrt.org> (sfid-20110704_081121_488798_9E004FEA)
In-Reply-To: <1309758467-1712-7-git-send-email-nbd@openwrt.org>
References: <1309758467-1712-1-git-send-email-nbd@openwrt.org>
 <1309758467-1712-2-git-send-email-nbd@openwrt.org>
 <1309758467-1712-3-git-send-email-nbd@openwrt.org>
 <1309758467-1712-4-git-send-email-nbd@openwrt.org>
 <1309758467-1712-5-git-send-email-nbd@openwrt.org>
 <1309758467-1712-6-git-send-email-nbd@openwrt.org>
 <1309758467-1712-7-git-send-email-nbd@openwrt.org>
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

