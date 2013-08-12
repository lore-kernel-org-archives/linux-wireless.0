Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:35864 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990Ab3HLJpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 05:45:36 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 10/15] ath9k: Fix RX packet counter
Date: Mon, 12 Aug 2013 15:11:37 +0530
Message-Id: <1376300502-2741-11-git-send-email-sujith@msujith.org> (sfid-20130812_120909_216408_580E82A2)
In-Reply-To: <1376300502-2741-1-git-send-email-sujith@msujith.org>
References: <1376300502-2741-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Handle chained descriptors and increment the RX counter
only for valid packets. Since this is used only by MCI,
use CONFIG_ATH9K_BTCOEX_SUPPORT.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 2d0017c..823b411 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1119,6 +1119,13 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 		rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
 	sc->rx.discard_next = false;
+
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+	if (ieee80211_is_data_present(hdr->frame_control) &&
+	    !ieee80211_is_qos_nullfunc(hdr->frame_control))
+		sc->rx.num_pkts++;
+#endif
+
 	return 0;
 }
 
@@ -1267,10 +1274,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		hdr = (struct ieee80211_hdr *) (hdr_skb->data +
 						ah->caps.rx_status_len);
 
-		if (ieee80211_is_data_present(hdr->frame_control) &&
-		    !ieee80211_is_qos_nullfunc(hdr->frame_control))
-			sc->rx.num_pkts++;
-
 		rxs = IEEE80211_SKB_RXCB(hdr_skb);
 		memset(rxs, 0, sizeof(struct ieee80211_rx_status));
 
-- 
1.8.3.4

