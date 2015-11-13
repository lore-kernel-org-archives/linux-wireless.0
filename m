Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38087 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921AbbKMKd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 05:33:28 -0500
Received: by wmec201 with SMTP id c201so24396811wme.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2015 02:33:27 -0800 (PST)
From: Borja Salazar <borja.salazar@fon.com>
To: linux-wireless@vger.kernel.org
Cc: janusz.dziedzic@tieto.com, sujith@msujith.org,
	ath9k-devel@lists.ath9k.org, ath9k-devel@qca.qualcomm.com,
	Kalle Valo <kvalo@codeaurora.org>,
	Borja Salazar <borja.salazar@fon.com>
Subject: [PATCH v2] ath9k: incorrect queue may be stopped/awaken
Date: Fri, 13 Nov 2015 11:33:06 +0100
Message-Id: <1447410786-31874-1-git-send-email-borja.salazar@fon.com> (sfid-20151113_113339_840112_B9A69B46)
In-Reply-To: <CALhHN=ov0kqqgGGHwPMOq3VaVsg9oD59Ed_NNsdcKVyS2+go2Q@mail.gmail.com>
References: <CALhHN=ov0kqqgGGHwPMOq3VaVsg9oD59Ed_NNsdcKVyS2+go2Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When channel context is enabled, we could be
stopping/awakening an incorrect queue.

Signed-off-by: Borja Salazar <borja.salazar@fon.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3e3dac3..9b17a59 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -147,7 +147,12 @@ static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ath_frame_info *fi = get_frame_info(skb);
-	int q = fi->txq;
+	int q;
+
+	if (ath9k_is_chanctx_enabled())
+		q = fi->txq;
+	else
+		q = info->hw_queue;
 
 	if (q < 0)
 		return;
@@ -158,10 +163,7 @@ static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
 
 	if (txq->stopped &&
 	    txq->pending_frames < sc->tx.txq_max_pending[q]) {
-		if (ath9k_is_chanctx_enabled())
-			ieee80211_wake_queue(sc->hw, info->hw_queue);
-		else
-			ieee80211_wake_queue(sc->hw, q);
+		ieee80211_wake_queue(sc->hw, q);
 		txq->stopped = false;
 	}
 }
@@ -2299,17 +2301,17 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * info are no longer valid (overwritten by the ath_frame_info data.
 	 */
 
-	q = skb_get_queue_mapping(skb);
+	if (ath9k_is_chanctx_enabled())
+		q = skb_get_queue_mapping(skb);
+	else
+		q = info->hw_queue;
 
 	ath_txq_lock(sc, txq);
 	if (txq == sc->tx.txq_map[q]) {
 		fi->txq = q;
 		if (++txq->pending_frames > sc->tx.txq_max_pending[q] &&
 		    !txq->stopped) {
-			if (ath9k_is_chanctx_enabled())
-				ieee80211_stop_queue(sc->hw, info->hw_queue);
-			else
-				ieee80211_stop_queue(sc->hw, q);
+			ieee80211_stop_queue(sc->hw, q);
 			txq->stopped = true;
 		}
 	}
-- 
2.3.6

