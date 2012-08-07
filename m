Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8008 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131Ab2HGBPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 21:15:54 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20512.27641.143700.249316@gargle.gargle.HOWL> (sfid-20120807_032551_138047_3433D3C9)
Date: Tue, 7 Aug 2012 06:44:33 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC 11/14] ath9k: Bail out properly before calculating rate index
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index a94c52b..0e3d20a 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1264,23 +1264,12 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	struct ath_softc *sc = priv;
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_hdr *hdr;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	int final_ts_idx = 0, tx_status = 0;
 	int long_retry = 0;
-	__le16 fc;
+	__le16 fc = hdr->frame_control;
 	int i;
 
-	hdr = (struct ieee80211_hdr *)skb->data;
-	fc = hdr->frame_control;
-	for (i = 0; i < sc->hw->max_rates; i++) {
-		struct ieee80211_tx_rate *rate = &tx_info->status.rates[i];
-		if (rate->idx < 0 || !rate->count)
-			break;
-
-		final_ts_idx = i;
-		long_retry = rate->count - 1;
-	}
-
 	if (!priv_sta || !ieee80211_is_data(fc))
 		return;
 
@@ -1292,6 +1281,15 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	if (tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED)
 		return;
 
+	for (i = 0; i < sc->hw->max_rates; i++) {
+		struct ieee80211_tx_rate *rate = &tx_info->status.rates[i];
+		if (rate->idx < 0 || !rate->count)
+			break;
+
+		final_ts_idx = i;
+		long_retry = rate->count - 1;
+	}
+
 	if (!(tx_info->flags & IEEE80211_TX_STAT_ACK))
 		tx_status = 1;
 
-- 
1.7.11.4

