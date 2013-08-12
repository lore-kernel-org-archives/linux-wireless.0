Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:57046 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab3HLJpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 05:45:22 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 02/15] ath9k: Use a subroutine to check for "mybeacon"
Date: Mon, 12 Aug 2013 15:11:29 +0530
Message-Id: <1376300502-2741-3-git-send-email-sujith@msujith.org> (sfid-20130812_114529_829285_C828ABBA)
In-Reply-To: <1376300502-2741-1-git-send-email-sujith@msujith.org>
References: <1376300502-2741-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 36 ++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 2dd851a..0c23053 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1160,6 +1160,24 @@ static void ath9k_apply_ampdu_details(struct ath_softc *sc,
 	}
 }
 
+static bool ath9k_is_mybeacon(struct ath_softc *sc, struct sk_buff *skb)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_hdr *hdr;
+
+	hdr = (struct ieee80211_hdr *) (skb->data + ah->caps.rx_status_len);
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
 int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 {
 	struct ath_buf *bf;
@@ -1175,7 +1193,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	enum ath9k_rx_qtype qtype;
 	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
 	int dma_type;
-	u8 rx_status_len = ah->caps.rx_status_len;
 	u64 tsf = 0;
 	u32 tsf_lower = 0;
 	unsigned long flags;
@@ -1216,18 +1233,10 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		else
 			hdr_skb = skb;
 
-		hdr = (struct ieee80211_hdr *) (hdr_skb->data + rx_status_len);
-		rxs = IEEE80211_SKB_RXCB(hdr_skb);
-		if (ieee80211_is_beacon(hdr->frame_control)) {
-			RX_STAT_INC(rx_beacons);
-			if (!is_zero_ether_addr(common->curbssid) &&
-			    ether_addr_equal(hdr->addr3, common->curbssid))
-				rs.is_mybeacon = true;
-			else
-				rs.is_mybeacon = false;
-		}
-		else
-			rs.is_mybeacon = false;
+		rs.is_mybeacon = ath9k_is_mybeacon(sc, hdr_skb);
+
+		hdr = (struct ieee80211_hdr *) (hdr_skb->data +
+						ah->caps.rx_status_len);
 
 		if (ieee80211_is_data_present(hdr->frame_control) &&
 		    !ieee80211_is_qos_nullfunc(hdr->frame_control))
@@ -1235,6 +1244,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 
 		ath_debug_stat_rx(sc, &rs);
 
+		rxs = IEEE80211_SKB_RXCB(hdr_skb);
 		memset(rxs, 0, sizeof(struct ieee80211_rx_status));
 
 		rxs->mactime = (tsf & ~0xffffffffULL) | rs.rs_tstamp;
-- 
1.8.3.4

