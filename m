Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5253 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761315Ab2FHRiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 13:38:13 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/9] ath9k: choose legacy rate as last rate of MRR series
Date: Fri, 8 Jun 2012 23:09:00 +0530
Message-ID: <1339177148-21672-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120608_193816_236217_EFD70A92)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Choose legacy rate as the last rate of Multi Rate Retry series
if and only if the last selected rate is MCS and having higher
PER rate. The current code fills a legacy rate as last one even
though the previous rates in the series are having good PER value.
This could limit the aggregation that affects the uplink performance.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 92a6c0a..e034add 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -770,7 +770,7 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	struct ieee80211_tx_rate *rates = tx_info->control.rates;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	__le16 fc = hdr->frame_control;
-	u8 try_per_rate, i = 0, rix, high_rix;
+	u8 try_per_rate, i = 0, rix;
 	int is_probe = 0;
 
 	if (rate_control_send_low(sta, priv_sta, txrc))
@@ -791,7 +791,6 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	rate_table = ath_rc_priv->rate_table;
 	rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table,
 				     &is_probe, false);
-	high_rix = rix;
 
 	/*
 	 * If we're in HT mode and both us and our peer supports LDPC.
@@ -839,16 +838,16 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	try_per_rate = 8;
 
 	/*
-	 * Use a legacy rate as last retry to ensure that the frame
-	 * is tried in both MCS and legacy rates.
+	 * If the last rate in the rate series is MCS and has
+	 * more than 80% of per thresh, then use a legacy rate
+	 * as last retry to ensure that the frame is tried in both
+	 * MCS and legacy rate.
 	 */
-	if ((rates[2].flags & IEEE80211_TX_RC_MCS) &&
-	    (!(tx_info->flags & IEEE80211_TX_CTL_AMPDU) ||
-	    (ath_rc_priv->per[high_rix] > 45)))
+	ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &rix);
+	if (WLAN_RC_PHY_HT(rate_table->info[rix].phy) &&
+	    (ath_rc_priv->per[rix] > 45))
 		rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table,
 				&is_probe, true);
-	else
-		ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &rix);
 
 	/* All other rates in the series have RTS enabled */
 	ath_rc_rate_set_series(rate_table, &rates[i], txrc,
-- 
1.7.10.3

