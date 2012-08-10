Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63277 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2HJLSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 07:18:17 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20516.60847.547871.63036@gargle.gargle.HOWL> (sfid-20120810_132552_245017_95F1F16E)
Date: Fri, 10 Aug 2012 16:47:03 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/15] ath9k: Bail out properly before calculating rate index
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

