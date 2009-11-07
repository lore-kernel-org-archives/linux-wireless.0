Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbZKGUTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:02 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 23/29] ath9k: rename ath_rx_prepare() to ath9k_rx_skb_preprocess()
Date: Sat,  7 Nov 2009 15:19:00 -0500
Message-Id: <1257625146-17971-24-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And change the return value to something more obvious.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 16ed929..c4a8663 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -288,16 +288,17 @@ static void ath9k_process_rssi(struct ath_common *common,
  * up the frame up to let mac80211 handle the actual error case, be it no
  * decryption key or real decryption error. This let us keep statistics there.
  */
-static int ath_rx_prepare(struct ath_common *common,
-			  struct ieee80211_hw *hw,
-			  struct sk_buff *skb, struct ath_rx_status *rx_stats,
-			  struct ieee80211_rx_status *rx_status,
-			  bool *decrypt_error)
+static int ath9k_rx_skb_preprocess(struct ath_common *common,
+				   struct ieee80211_hw *hw,
+				   struct sk_buff *skb,
+				   struct ath_rx_status *rx_stats,
+				   struct ieee80211_rx_status *rx_status,
+				   bool *decrypt_error)
 {
 	struct ath_hw *ah = common->ah;
 
 	if (!ath9k_rx_accept(common, skb, rx_status, rx_stats, decrypt_error))
-		goto rx_next;
+		return -EINVAL;
 
 	ath9k_process_rssi(common, hw, skb, rx_stats);
 
@@ -312,8 +313,6 @@ static int ath_rx_prepare(struct ath_common *common,
 	rx_status->qual = ath9k_compute_qual(hw, rx_stats);
 	rx_status->flag |= RX_FLAG_TSFT;
 
-	return 1;
-rx_next:
 	return 0;
 }
 
@@ -808,8 +807,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		if (flush)
 			goto requeue;
 
-		if (!ath_rx_prepare(common, hw, skb, rx_stats,
-				    rxs, &decrypt_error))
+		retval = ath9k_rx_skb_preprocess(common, hw, skb, rx_stats,
+						 rxs, &decrypt_error);
+		if (retval)
 			goto requeue;
 
 		/* Ensure we always have an skb to requeue once we are done
-- 
1.6.5.2.143.g8cc62

