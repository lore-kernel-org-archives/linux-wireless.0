Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50360 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934031Ab3ECTyM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 15:54:12 -0400
Received: from mailout-de.gmx.net ([10.1.76.16]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LtC3J-1USpUO00C3-012sm3 for
 <linux-wireless@vger.kernel.org>; Fri, 03 May 2013 21:54:11 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	radiotap@NetBSD.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 2/3] ath9k: remove useless flag conversation.
Date: Fri,  3 May 2013 21:53:54 +0200
Message-Id: <1367610836-3303-3-git-send-email-linux@rempel-privat.de> (sfid-20130503_215417_315707_54C3A125)
In-Reply-To: <1367610836-3303-1-git-send-email-linux@rempel-privat.de>
References: <1367527479.11375.19.camel@jlt4.sipsolutions.net>
 <1367610836-3303-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

some flags used only outside of ath9k - In this case we can use
"enum mac80211_rx_flags" and pass it upstream without extra
conversation.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |  5 +++--
 drivers/net/wireless/ath/ath9k/mac.c        | 11 +++++++----
 drivers/net/wireless/ath/ath9k/mac.h        |  1 +
 drivers/net/wireless/ath/ath9k/recv.c       |  5 +----
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 301bf72..5163abd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -469,6 +469,7 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 
 	rxs->rs_status = 0;
 	rxs->rs_flags =  0;
+	rxs->flag =  0;
 
 	rxs->rs_datalen = rxsp->status2 & AR_DataLen;
 	rxs->rs_tstamp =  rxsp->status3;
@@ -493,8 +494,8 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 	rxs->rs_isaggr = (rxsp->status11 & AR_RxAggr) ? 1 : 0;
 	rxs->rs_moreaggr = (rxsp->status11 & AR_RxMoreAggr) ? 1 : 0;
 	rxs->rs_antenna = (MS(rxsp->status4, AR_RxAntenna) & 0x7);
-	rxs->rs_flags  = (rxsp->status4 & AR_GI) ? ATH9K_RX_GI : 0;
-	rxs->rs_flags  |= (rxsp->status4 & AR_2040) ? ATH9K_RX_2040 : 0;
+	rxs->flag  |= (rxsp->status4 & AR_GI) ? RX_FLAG_SHORT_GI : 0;
+	rxs->flag  |= (rxsp->status4 & AR_2040) ? RX_FLAG_40MHZ : 0;
 
 	rxs->evm0 = rxsp->status6;
 	rxs->evm1 = rxsp->status7;
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 498fee0..a52081d 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -547,6 +547,7 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 
 	rs->rs_status = 0;
 	rs->rs_flags = 0;
+	rs->flag = 0;
 
 	rs->rs_datalen = ads.ds_rxstatus1 & AR_DataLen;
 	rs->rs_tstamp = ads.AR_RcvTimestamp;
@@ -586,10 +587,12 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 	rs->rs_moreaggr =
 		(ads.ds_rxstatus8 & AR_RxMoreAggr) ? 1 : 0;
 	rs->rs_antenna = MS(ads.ds_rxstatus3, AR_RxAntenna);
-	rs->rs_flags =
-		(ads.ds_rxstatus3 & AR_GI) ? ATH9K_RX_GI : 0;
-	rs->rs_flags |=
-		(ads.ds_rxstatus3 & AR_2040) ? ATH9K_RX_2040 : 0;
+
+	/* directly mapped flags for ieee80211_rx_status */
+	rs->flag |=
+		(ads.ds_rxstatus3 & AR_GI) ? RX_FLAG_SHORT_GI : 0;
+	rs->flag |=
+		(ads.ds_rxstatus3 & AR_2040) ? RX_FLAG_40MHZ : 0;
 
 	if (ads.ds_rxstatus8 & AR_PreDelimCRCErr)
 		rs->rs_flags |= ATH9K_RX_DELIM_CRC_PRE;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 5865f92..3f1e775 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -149,6 +149,7 @@ struct ath_rx_status {
 	u32 evm2;
 	u32 evm3;
 	u32 evm4;
+	u32 flag; /* see enum mac80211_rx_flags */
 };
 
 struct ath_htc_rx_status {
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 8be2b5d..b4b758d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -868,10 +868,7 @@ static int ath9k_process_rate(struct ath_common *common,
 	if (rx_stats->rs_rate & 0x80) {
 		/* HT rate */
 		rxs->flag |= RX_FLAG_HT;
-		if (rx_stats->rs_flags & ATH9K_RX_2040)
-			rxs->flag |= RX_FLAG_40MHZ;
-		if (rx_stats->rs_flags & ATH9K_RX_GI)
-			rxs->flag |= RX_FLAG_SHORT_GI;
+		rxs->flag |= rx_stats->flag;
 		rxs->rate_idx = rx_stats->rs_rate & 0x7f;
 		return 0;
 	}
-- 
1.8.1.2

