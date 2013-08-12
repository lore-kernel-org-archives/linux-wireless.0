Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:54916 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab3HLJpe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 05:45:34 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 09/15] ath9k: Fix RX debug statistics
Date: Mon, 12 Aug 2013 15:11:36 +0530
Message-Id: <1376300502-2741-10-git-send-email-sujith@msujith.org> (sfid-20130812_114539_393486_5A43E50E)
In-Reply-To: <1376300502-2741-1-git-send-email-sujith@msujith.org>
References: <1376300502-2741-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The various error bits that ath_debug_stat_rx()
checks are valid only for the last descriptor for
a chained packet, handle this correctly.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index e18adde..2d0017c 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1084,6 +1084,7 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 		return 0;
 
 	ath9k_process_tsf(rx_stats, rx_status, tsf);
+	ath_debug_stat_rx(sc, rx_stats);
 
 	/*
 	 * Process PHY errors and return so that the packet
@@ -1270,8 +1271,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		    !ieee80211_is_qos_nullfunc(hdr->frame_control))
 			sc->rx.num_pkts++;
 
-		ath_debug_stat_rx(sc, &rs);
-
 		rxs = IEEE80211_SKB_RXCB(hdr_skb);
 		memset(rxs, 0, sizeof(struct ieee80211_rx_status));
 
-- 
1.8.3.4

