Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:42697 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759357Ab3HNDpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 23:45:22 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 10/14] ath9k: Fix RX beacon processing
Date: Wed, 14 Aug 2013 09:11:18 +0530
Message-Id: <1376451682-25862-10-git-send-email-sujith@msujith.org> (sfid-20130814_054532_771672_4EFA5057)
In-Reply-To: <1376451682-25862-1-git-send-email-sujith@msujith.org>
References: <1376451682-25862-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Make sure that chained descriptors are handled correctly
before the packet is parsed to determine if it is a beacon.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 48 ++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 823b411..090c27e 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1037,13 +1037,28 @@ static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 #endif
 }
 
+static bool ath9k_is_mybeacon(struct ath_softc *sc, struct ieee80211_hdr *hdr)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (ieee80211_is_beacon(hdr->frame_control)) {
+		RX_STAT_INC(rx_beacons);
+		if (!is_zero_ether_addr(common->curbssid) &&
+		    ether_addr_equal(hdr->addr3, common->curbssid))
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * For Decrypt or Demic errors, we only mark packet status here and always push
  * up the frame up to let mac80211 handle the actual error case, be it no
  * decryption key or real decryption error. This let us keep statistics there.
  */
 static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
-				   struct ieee80211_hdr *hdr,
+				   struct sk_buff *skb,
 				   struct ath_rx_status *rx_stats,
 				   struct ieee80211_rx_status *rx_status,
 				   bool *decrypt_error, u64 tsf)
@@ -1051,6 +1066,7 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	struct ieee80211_hw *hw = sc->hw;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_hdr *hdr;
 	bool discard_current = sc->rx.discard_next;
 
 	/*
@@ -1083,6 +1099,8 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	if (rx_stats->rs_more)
 		return 0;
 
+	hdr = (struct ieee80211_hdr *) (skb->data + ah->caps.rx_status_len);
+
 	ath9k_process_tsf(rx_stats, rx_status, tsf);
 	ath_debug_stat_rx(sc, rx_stats);
 
@@ -1105,6 +1123,8 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	if (!ath9k_rx_accept(common, hdr, rx_status, rx_stats, decrypt_error))
 		return -EINVAL;
 
+	rx_stats->is_mybeacon = ath9k_is_mybeacon(sc, hdr);
+
 	if (ath9k_process_rate(common, hw, rx_stats, rx_status))
 		return -EINVAL;
 
@@ -1198,24 +1218,6 @@ static void ath9k_apply_ampdu_details(struct ath_softc *sc,
 	}
 }
 
-static bool ath9k_is_mybeacon(struct ath_softc *sc, struct sk_buff *skb)
-{
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_hdr *hdr;
-
-	hdr = (struct ieee80211_hdr *) (skb->data + ah->caps.rx_status_len);
-
-	if (ieee80211_is_beacon(hdr->frame_control)) {
-		RX_STAT_INC(rx_beacons);
-		if (!is_zero_ether_addr(common->curbssid) &&
-		    ether_addr_equal(hdr->addr3, common->curbssid))
-			return true;
-	}
-
-	return false;
-}
-
 int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 {
 	struct ath_buf *bf;
@@ -1225,7 +1227,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_hdr *hdr;
 	int retval;
 	struct ath_rx_status rs;
 	enum ath9k_rx_qtype qtype;
@@ -1269,15 +1270,10 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		else
 			hdr_skb = skb;
 
-		rs.is_mybeacon = ath9k_is_mybeacon(sc, hdr_skb);
-
-		hdr = (struct ieee80211_hdr *) (hdr_skb->data +
-						ah->caps.rx_status_len);
-
 		rxs = IEEE80211_SKB_RXCB(hdr_skb);
 		memset(rxs, 0, sizeof(struct ieee80211_rx_status));
 
-		retval = ath9k_rx_skb_preprocess(sc, hdr, &rs, rxs,
+		retval = ath9k_rx_skb_preprocess(sc, hdr_skb, &rs, rxs,
 						 &decrypt_error, tsf);
 		if (retval)
 			goto requeue_drop_frag;
-- 
1.8.3.4

