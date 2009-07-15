Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58176 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094AbZGOAO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:14:29 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: [PATCH 05/21] ath9k: remove unused min rate calculation code
Date: Tue, 14 Jul 2009 20:13:57 -0400
Message-Id: <1247616853-11221-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
References: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is not used, and when we need to get the lowest rate
we should simply use mac80211's own rate_lowest_index(sband, sta).

Cc: Derek Smithies <derek@indranet.co.nz>
Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |   33 +++++++++------------------------
 1 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index a23b66b..7b37b27 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -817,28 +817,17 @@ static void ath_rc_rate_set_rtscts(struct ath_softc *sc,
 static u8 ath_rc_rate_getidx(struct ath_softc *sc,
 			     struct ath_rate_priv *ath_rc_priv,
 			     const struct ath_rate_table *rate_table,
-			     u8 rix, u16 stepdown,
-			     u16 min_rate)
+			     u8 rix, u16 stepdown)
 {
 	u32 j;
 	u8 nextindex = 0;
 
-	if (min_rate) {
-		for (j = RATE_TABLE_SIZE; j > 0; j--) {
-			if (ath_rc_get_nextlowervalid_txrate(rate_table,
-						ath_rc_priv, rix, &nextindex))
-				rix = nextindex;
-			else
-				break;
-		}
-	} else {
-		for (j = stepdown; j > 0; j--) {
-			if (ath_rc_get_nextlowervalid_txrate(rate_table,
-						ath_rc_priv, rix, &nextindex))
-				rix = nextindex;
-			else
-				break;
-		}
+	for (j = stepdown; j > 0; j--) {
+		if (ath_rc_get_nextlowervalid_txrate(rate_table,
+					ath_rc_priv, rix, &nextindex))
+			rix = nextindex;
+		else
+			break;
 	}
 	return rix;
 }
@@ -882,7 +871,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		 * after the probe rate
 		 */
 		nrix = ath_rc_rate_getidx(sc, ath_rc_priv,
-					  rate_table, nrix, 1, 0);
+					  rate_table, nrix, 1);
 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
 				       try_per_rate, nrix, 0);
 
@@ -895,16 +884,12 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 
 	/* Fill in the other rates for multirate retry */
 	for ( ; i < 4; i++) {
-		u8 min_rate;
-
 		/* Use twice the number of tries for the last MRR segment. */
 		if (i + 1 == 4)
 			try_per_rate = 4;
 
-		min_rate = (((i + 1) == 4) && 0);
-
 		nrix = ath_rc_rate_getidx(sc, ath_rc_priv,
-					  rate_table, nrix, 1, min_rate);
+					  rate_table, nrix, 1);
 		/* All other rates in the series have RTS enabled */
 		ath_rc_rate_set_series(rate_table, &rates[i], txrc,
 				       try_per_rate, nrix, 1);
-- 
1.6.0.6

