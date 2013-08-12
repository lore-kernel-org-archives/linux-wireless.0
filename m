Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:43286 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab3HLJpp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 05:45:45 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 15/15] ath9k: Remove unused function argument
Date: Mon, 12 Aug 2013 15:11:42 +0530
Message-Id: <1376300502-2741-16-git-send-email-sujith@msujith.org> (sfid-20130812_120909_111146_F987944E)
In-Reply-To: <1376300502-2741-1-git-send-email-sujith@msujith.org>
References: <1376300502-2741-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index a00e1b6..49e9cce 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -885,7 +885,6 @@ static int ath9k_process_rate(struct ath_common *common,
 
 static void ath9k_process_rssi(struct ath_common *common,
 			       struct ieee80211_hw *hw,
-			       struct ieee80211_hdr *hdr,
 			       struct ath_rx_status *rx_stats)
 {
 	struct ath_softc *sc = hw->priv;
@@ -1150,7 +1149,7 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 		ath_start_rx_poll(sc, 3);
 	}
 
-	ath9k_process_rssi(common, hw, hdr, rx_stats);
+	ath9k_process_rssi(common, hw, rx_stats);
 
 	rx_status->band = hw->conf.chandef.chan->band;
 	rx_status->freq = hw->conf.chandef.chan->center_freq;
-- 
1.8.3.4

