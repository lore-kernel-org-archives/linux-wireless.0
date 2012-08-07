Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7909 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab2HGBPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 21:15:19 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20512.27607.352426.424546@gargle.gargle.HOWL> (sfid-20120807_031524_032608_9785764A)
Date: Tue, 7 Aug 2012 06:43:59 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC 06/14] ath9k: Change rateset calculation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit "ath9k: Change rate control to use legacy rate as last MRR"
resulted in the mixing of HT/legacy rates in a single rateset,
which is undesirable. Revert this behavior.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c | 35 +++++++++--------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 2e517c0..e8f8e3d 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -582,8 +582,7 @@ static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv)
 }
 
 static u8 ath_rc_get_highest_rix(struct ath_rate_priv *ath_rc_priv,
-				 int *is_probing,
-				 bool legacy)
+				 int *is_probing)
 {
 	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
 	u32 best_thruput, this_thruput, now_msec;
@@ -605,8 +604,6 @@ static u8 ath_rc_get_highest_rix(struct ath_rate_priv *ath_rc_priv,
 		u8 per_thres;
 
 		rate = ath_rc_priv->valid_rate_index[index];
-		if (legacy && !(rate_table->info[rate].rate_flags & RC_LEGACY))
-			continue;
 		if (rate > ath_rc_priv->rate_max_phy)
 			continue;
 
@@ -770,7 +767,7 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	try_per_rate = 4;
 
 	rate_table = ath_rc_priv->rate_table;
-	rix = ath_rc_get_highest_rix(ath_rc_priv, &is_probe, false);
+	rix = ath_rc_get_highest_rix(ath_rc_priv, &is_probe);
 
 	if (conf_is_ht(&sc->hw->conf) &&
 	    (sta->ht_cap.cap & IEEE80211_HT_CAP_LDPC_CODING))
@@ -804,7 +801,13 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 				       try_per_rate, rix, 0);
 	}
 
-	for ( ; i < 3; i++) {
+	for ( ; i < 4; i++) {
+		/*
+		 * Use twice the number of tries for the last MRR segment.
+		 */
+		if (i + 1 == 4)
+			try_per_rate = 8;
+
 		ath_rc_get_lower_rix(ath_rc_priv, rix, &rix);
 
 		/*
@@ -815,26 +818,6 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	}
 
 	/*
-	 * Use twice the number of tries for the last MRR segment.
-	 */
-	try_per_rate = 8;
-
-	/*
-	 * If the last rate in the rate series is MCS and has
-	 * more than 80% of per thresh, then use a legacy rate
-	 * as last retry to ensure that the frame is tried in both
-	 * MCS and legacy rate.
-	 */
-	ath_rc_get_lower_rix(ath_rc_priv, rix, &rix);
-
-	if (WLAN_RC_PHY_HT(rate_table->info[rix].phy) &&
-	    (ath_rc_priv->per[rix] > 45))
-		rix = ath_rc_get_highest_rix(ath_rc_priv, &is_probe, true);
-
-	/* All other rates in the series have RTS enabled */
-	ath_rc_rate_set_series(rate_table, &rates[i], txrc,
-			       try_per_rate, rix, 1);
-	/*
 	 * NB:Change rate series to enable aggregation when operating
 	 * at lower MCS rates. When first rate in series is MCS2
 	 * in HT40 @ 2.4GHz, series should look like:
-- 
1.7.11.4

