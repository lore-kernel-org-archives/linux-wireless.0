Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:38701 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaAND5z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 22:57:55 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] ath9k: Fix error reported by smatch
Date: Tue, 14 Jan 2014 09:22:36 +0530
Message-Id: <1389671556-8574-1-git-send-email-sujith@msujith.org> (sfid-20140114_045758_063731_3C678E25)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

debug_sta.c: ath_debug_rate_stats() error: buffer overflow 'rstats->ht_stats' 24 <= 24

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug_sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index d33cc88..d76e6e0 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -128,7 +128,7 @@ void ath_debug_rate_stats(struct ath_softc *sc,
 	rxs = IEEE80211_SKB_RXCB(skb);
 
 	if (IS_HT_RATE(rs->rs_rate)) {
-		if (rxs->rate_idx > ARRAY_SIZE(rstats->ht_stats))
+		if (rxs->rate_idx >= ARRAY_SIZE(rstats->ht_stats))
 			goto exit;
 
 		if (rxs->flag & RX_FLAG_40MHZ)
-- 
1.8.5.2

