Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:35049 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025Ab0LGPxZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 10:53:25 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 07:53:11 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH v2] ath9k: Remove dead code in recv.c
Date: Tue, 7 Dec 2010 21:23:16 +0530
Message-ID: <1291737196-6341-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

The structure struct ieee80211_rx_status *rxs is no longer needed to be
passed to ath_rx_send_to_mac80211 function

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 262c815..a14515a 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -660,8 +660,7 @@ static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb)
 }
 
 static void ath_rx_send_to_mac80211(struct ieee80211_hw *hw,
-				    struct ath_softc *sc, struct sk_buff *skb,
-				    struct ieee80211_rx_status *rxs)
+				    struct ath_softc *sc, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
 
@@ -1618,7 +1617,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	/*
-	 * The hw can techncically differ from common->hw when using ath9k
+	 * The hw can technically differ from common->hw when using ath9k
 	 * virtual wiphy so to account for that we iterate over the active
 	 * wiphys and find the appropriate wiphy and therefore hw.
 	 */
@@ -1727,7 +1726,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			bf->bf_buf_addr = 0;
 			ath_print(common, ATH_DBG_FATAL,
 				  "dma_mapping_error() on RX\n");
-			ath_rx_send_to_mac80211(hw, sc, skb, rxs);
+			ath_rx_send_to_mac80211(hw, sc, skb);
 			break;
 		}
 
@@ -1753,7 +1752,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if (ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB)
 			ath_ant_comb_scan(sc, &rs);
 
-		ath_rx_send_to_mac80211(hw, sc, skb, rxs);
+		ath_rx_send_to_mac80211(hw, sc, skb);
 
 requeue:
 		if (edma) {
-- 
1.7.0.4

