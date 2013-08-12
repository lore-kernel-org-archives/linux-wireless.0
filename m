Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:46026 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab3HLJp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 05:45:28 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 06/15] ath9k: Fix TSF processing
Date: Mon, 12 Aug 2013 15:11:33 +0530
Message-Id: <1376300502-2741-7-git-send-email-sujith@msujith.org> (sfid-20130812_120909_417497_6AFEFA3E)
In-Reply-To: <1376300502-2741-1-git-send-email-sujith@msujith.org>
References: <1376300502-2741-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

There is no need to calculate the mactime for chained
descriptor packets, so make sure that this is done
only for the last fragment of valid packets.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index b04a971..9fabd5f 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -913,6 +913,22 @@ static void ath9k_process_rssi(struct ath_common *common,
 	ah->stats.avgbrssi = rssi;
 }
 
+static void ath9k_process_tsf(struct ath_rx_status *rs,
+			      struct ieee80211_rx_status *rxs,
+			      u64 tsf)
+{
+	u32 tsf_lower = tsf & 0xffffffff;
+
+	rxs->mactime = (tsf & ~0xffffffffULL) | rs->rs_tstamp;
+	if (rs->rs_tstamp > tsf_lower &&
+	    unlikely(rs->rs_tstamp - tsf_lower > 0x10000000))
+		rxs->mactime -= 0x100000000ULL;
+
+	if (rs->rs_tstamp < tsf_lower &&
+	    unlikely(tsf_lower - rs->rs_tstamp > 0x10000000))
+		rxs->mactime += 0x100000000ULL;
+}
+
 /*
  * For Decrypt or Demic errors, we only mark packet status here and always push
  * up the frame up to let mac80211 handle the actual error case, be it no
@@ -922,7 +938,7 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 				   struct ieee80211_hdr *hdr,
 				   struct ath_rx_status *rx_stats,
 				   struct ieee80211_rx_status *rx_status,
-				   bool *decrypt_error)
+				   bool *decrypt_error, u64 tsf)
 {
 	struct ieee80211_hw *hw = sc->hw;
 	struct ath_hw *ah = sc->sc_ah;
@@ -959,6 +975,8 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	if (rx_stats->rs_more)
 		return 0;
 
+	ath9k_process_tsf(rx_stats, rx_status, tsf);
+
 	/*
 	 * everything but the rate is checked here, the rate check is done
 	 * separately to avoid doing two lookups for a rate for each frame.
@@ -1196,7 +1214,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
 	int dma_type;
 	u64 tsf = 0;
-	u32 tsf_lower = 0;
 	unsigned long flags;
 	dma_addr_t new_buf_addr;
 
@@ -1208,7 +1225,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	qtype = hp ? ATH9K_RX_QUEUE_HP : ATH9K_RX_QUEUE_LP;
 
 	tsf = ath9k_hw_gettsf64(ah);
-	tsf_lower = tsf & 0xffffffff;
 
 	do {
 		bool decrypt_error = false;
@@ -1249,15 +1265,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		rxs = IEEE80211_SKB_RXCB(hdr_skb);
 		memset(rxs, 0, sizeof(struct ieee80211_rx_status));
 
-		rxs->mactime = (tsf & ~0xffffffffULL) | rs.rs_tstamp;
-		if (rs.rs_tstamp > tsf_lower &&
-		    unlikely(rs.rs_tstamp - tsf_lower > 0x10000000))
-			rxs->mactime -= 0x100000000ULL;
-
-		if (rs.rs_tstamp < tsf_lower &&
-		    unlikely(tsf_lower - rs.rs_tstamp > 0x10000000))
-			rxs->mactime += 0x100000000ULL;
-
 		if (rs.rs_status & ATH9K_RXERR_PHY) {
 			ath9k_dfs_process_phyerr(sc, hdr, &rs, rxs->mactime);
 
@@ -1268,7 +1275,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		}
 
 		retval = ath9k_rx_skb_preprocess(sc, hdr, &rs, rxs,
-						 &decrypt_error);
+						 &decrypt_error, tsf);
 		if (retval)
 			goto requeue_drop_frag;
 
-- 
1.8.3.4

