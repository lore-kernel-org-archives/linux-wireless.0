Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:13500 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754604Ab0ESBcG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 21:32:06 -0400
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0413122721
	for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 10:32:03 +0900 (JST)
Subject: [PATCH v2 02/20] ath5k: wake queues on reset
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 19 May 2010 10:30:49 +0900
Message-ID: <20100519013049.22206.42069.stgit@tt-desk>
In-Reply-To: <20100519012528.22206.77550.stgit@tt-desk>
References: <20100519012528.22206.77550.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can wake all queues after a chip reset since everything should be set up and
we are ready to transmit. If we don't do that we might end up starting up with
stopped queues, not beeing able to transmit. (This started to happen after
"ath5k: clean up queue manipulation" but since periodic calibration also
stopped and started the queues this effect was hidden most of the time).

This way we can also get rid of the superfluous ath5k_reset_wake() function.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index fbd5fc7..9f9107b 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -222,7 +222,6 @@ static int ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
 static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 		struct ath5k_txq *txq);
 static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan);
-static int ath5k_reset_wake(struct ath5k_softc *sc);
 static int ath5k_start(struct ieee80211_hw *hw);
 static void ath5k_stop(struct ieee80211_hw *hw);
 static int ath5k_add_interface(struct ieee80211_hw *hw,
@@ -2770,7 +2769,7 @@ ath5k_tasklet_reset(unsigned long data)
 {
 	struct ath5k_softc *sc = (void *)data;
 
-	ath5k_reset_wake(sc);
+	ath5k_reset(sc, sc->curchan);
 }
 
 /*
@@ -2941,23 +2940,13 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 	ath5k_beacon_config(sc);
 	/* intrs are enabled by ath5k_beacon_config */
 
+	ieee80211_wake_queues(sc->hw);
+
 	return 0;
 err:
 	return ret;
 }
 
-static int
-ath5k_reset_wake(struct ath5k_softc *sc)
-{
-	int ret;
-
-	ret = ath5k_reset(sc, sc->curchan);
-	if (!ret)
-		ieee80211_wake_queues(sc->hw);
-
-	return ret;
-}
-
 static int ath5k_start(struct ieee80211_hw *hw)
 {
 	return ath5k_init(hw->priv);

