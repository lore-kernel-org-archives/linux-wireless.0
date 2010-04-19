Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:45932 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab0DSR5o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 13:57:44 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH v2 6/9] ath9k: initialize the number of tx/rx streams correctly
Date: Mon, 19 Apr 2010 19:57:34 +0200
Message-Id: <1271699857-12366-6-git-send-email-nbd@openwrt.org>
In-Reply-To: <1271699857-12366-5-git-send-email-nbd@openwrt.org>
References: <1271699857-12366-1-git-send-email-nbd@openwrt.org>
 <1271699857-12366-2-git-send-email-nbd@openwrt.org>
 <1271699857-12366-3-git-send-email-nbd@openwrt.org>
 <1271699857-12366-4-git-send-email-nbd@openwrt.org>
 <1271699857-12366-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9300 based hardware can 3x3 MCS rates, this should be set in the
HT capabilities.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/init.c |   39 +++++++++++++++++++++++---------
 1 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index ca6e781..2c0630e 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -175,6 +175,18 @@ static const struct ath_ops ath9k_common_ops = {
 	.write = ath9k_iowrite32,
 };
 
+static int count_streams(unsigned int chainmask, int max)
+{
+	int streams = 0;
+
+	do {
+		if (++streams == max)
+			break;
+	} while ((chainmask = chainmask & (chainmask - 1)));
+
+	return streams;
+}
+
 /**************************/
 /*     Initialization     */
 /**************************/
@@ -182,8 +194,10 @@ static const struct ath_ops ath9k_common_ops = {
 static void setup_ht_cap(struct ath_softc *sc,
 			 struct ieee80211_sta_ht_cap *ht_info)
 {
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	u8 tx_streams, rx_streams;
+	int i, max_streams;
 
 	ht_info->ht_supported = true;
 	ht_info->cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
@@ -197,25 +211,28 @@ static void setup_ht_cap(struct ath_softc *sc,
 	ht_info->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
 	ht_info->ampdu_density = IEEE80211_HT_MPDU_DENSITY_8;
 
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		max_streams = 3;
+	else
+		max_streams = 2;
+
 	/* set up supported mcs set */
 	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
-	tx_streams = !(common->tx_chainmask & (common->tx_chainmask - 1)) ?
-		     1 : 2;
-	rx_streams = !(common->rx_chainmask & (common->rx_chainmask - 1)) ?
-		     1 : 2;
+	tx_streams = count_streams(common->tx_chainmask, max_streams);
+	rx_streams = count_streams(common->rx_chainmask, max_streams);
+
+	ath_print(common, ATH_DBG_CONFIG,
+		  "TX streams %d, RX streams: %d\n",
+		  tx_streams, rx_streams);
 
 	if (tx_streams != rx_streams) {
-		ath_print(common, ATH_DBG_CONFIG,
-			  "TX streams %d, RX streams: %d\n",
-			  tx_streams, rx_streams);
 		ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;
 		ht_info->mcs.tx_params |= ((tx_streams - 1) <<
 				IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
 	}
 
-	ht_info->mcs.rx_mask[0] = 0xff;
-	if (rx_streams >= 2)
-		ht_info->mcs.rx_mask[1] = 0xff;
+	for (i = 0; i < rx_streams; i++)
+		ht_info->mcs.rx_mask[i] = 0xff;
 
 	ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_DEFINED;
 }
-- 
1.6.4.2

