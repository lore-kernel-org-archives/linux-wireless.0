Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:42610 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759357Ab3HNDpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 23:45:18 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 08/14] ath9k: Fix RX debug statistics
Date: Wed, 14 Aug 2013 09:11:16 +0530
Message-Id: <1376451682-25862-8-git-send-email-sujith@msujith.org> (sfid-20130814_054524_939222_022A5363)
In-Reply-To: <1376451682-25862-1-git-send-email-sujith@msujith.org>
References: <1376451682-25862-1-git-send-email-sujith@msujith.org>
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

