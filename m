Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11329 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbZFQE1S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 00:27:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 21:27:21 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 1/1] ath9k: Handle different TX and RX streams properly.
Date: Wed, 17 Jun 2009 09:57:07 +0530
Message-ID: <1245212828-7342-2-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1245212828-7342-1-git-send-email-senthilkumar@atheros.com>
References: <1245212828-7342-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes an issue when the TX and RX streams are different.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2ebd0ed..ebe559c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -874,6 +874,7 @@ static void setup_ht_cap(struct ath_softc *sc,
 {
 #define	ATH9K_HT_CAP_MAXRXAMPDU_65536 0x3	/* 2 ^ 16 */
 #define	ATH9K_HT_CAP_MPDUDENSITY_8 0x6		/* 8 usec */
+	u8 tx_streams, rx_streams;
 
 	ht_info->ht_supported = true;
 	ht_info->cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
@@ -886,21 +887,22 @@ static void setup_ht_cap(struct ath_softc *sc,
 
 	/* set up supported mcs set */
 	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
+	tx_streams = !(sc->tx_chainmask & (sc->tx_chainmask - 1)) ? 1 : 2;
+	rx_streams = !(sc->rx_chainmask & (sc->rx_chainmask - 1)) ? 1 : 2;
 
-	switch(sc->rx_chainmask) {
-	case 1:
-		ht_info->mcs.rx_mask[0] = 0xff;
-		break;
-	case 3:
-	case 5:
-	case 7:
-	default:
-		ht_info->mcs.rx_mask[0] = 0xff;
-		ht_info->mcs.rx_mask[1] = 0xff;
-		break;
+	if (tx_streams != rx_streams) {
+		DPRINTF(sc, ATH_DBG_CONFIG, "TX streams %d, RX streams: %d\n",
+			tx_streams, rx_streams);
+		ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;
+		ht_info->mcs.tx_params |= ((tx_streams - 1) <<
+				IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
 	}
 
-	ht_info->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+	ht_info->mcs.rx_mask[0] = 0xff;
+	if (rx_streams >= 2)
+		ht_info->mcs.rx_mask[1] = 0xff;
+
+	ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_DEFINED;
 }
 
 static void ath9k_bss_assoc_info(struct ath_softc *sc,
-- 
1.6.0.4

