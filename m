Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20952 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab0LAN03 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 08:26:29 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 05:26:15 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH 1/1] ath9k: Remove dead code in recv.c
Date: Wed, 1 Dec 2010 18:55:57 +0530
Message-ID: <1291209957-3645-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

The structure struct ieee80211_rx_status *rxs is no longer needed to be
passed to ath_rx_send_to_mac80211 function

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 429fa81..1ff08ef 100644
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
 
@@ -1729,7 +1728,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			bf->bf_buf_addr = 0;
 			ath_print(common, ATH_DBG_FATAL,
 				  "dma_mapping_error() on RX\n");
-			ath_rx_send_to_mac80211(hw, sc, skb, rxs);
+			ath_rx_send_to_mac80211(hw, sc, skb);
 			break;
 		}
 
@@ -1755,7 +1754,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if (ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB)
 			ath_ant_comb_scan(sc, &rs);
 
-		ath_rx_send_to_mac80211(hw, sc, skb, rxs);
+		ath_rx_send_to_mac80211(hw, sc, skb);
 
 requeue:
 		if (edma) {
-- 
1.7.0.4

