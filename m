Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:15593 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932325AbXJPNUz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 09:20:55 -0400
From: Bruno Randolf <bruno@thinktube.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 2/3] better readability for skb dumps
Date: Tue, 16 Oct 2007 22:20:37 +0900
Message-Id: <1192540838-26985-3-git-send-email-bruno@thinktube.com> (sfid-20071016_142059_945089_8533BAE6)
In-Reply-To: <1192540838-26985-2-git-send-email-bruno@thinktube.com>
References: <1192540838-26985-1-git-send-email-bruno@thinktube.com>
 <1192540838-26985-2-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

print "RX  " and "TX  " in front of hexdump

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---
 drivers/net/wireless/ath5k/base.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 2f2ae33..15004b2 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -478,7 +478,7 @@ accept:
 		rxs.rate = ds->ds_rxstat.rs_rate;
 		rxs.flag |= ath_rx_decrypted(sc, ds, skb);
 
-		ath_dump_skb(skb, "r");
+		ath_dump_skb(skb, "RX  ");
 
 		__ieee80211_rx(sc->hw, skb, &rxs);
 		sc->led_rxrate = ds->ds_rxstat.rs_rate;
@@ -1221,7 +1221,7 @@ static int ath_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	int hdrlen;
 	int pad;
 
-	ath_dump_skb(skb, "t");
+	ath_dump_skb(skb, "TX  ");
 
 	if (sc->opmode == IEEE80211_IF_TYPE_MNTR)
 		DPRINTF(sc, ATH_DEBUG_XMIT, "tx in monitor (scan?)\n");
@@ -1623,7 +1623,7 @@ static int ath_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ath_softc *sc = hw->priv;
 	int ret;
 
-	ath_dump_skb(skb, "b");
+	ath_dump_skb(skb, "BC  ");
 
 	mutex_lock(&sc->lock);
 
-- 
1.5.3.4

