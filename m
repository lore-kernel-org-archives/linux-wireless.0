Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47261 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZFFAEB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 20:04:01 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, j@w1.fi
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: [PATCH v2 04/15] ath9k: remove unused stepdown when looking for the next rate
Date: Fri,  5 Jun 2009 20:03:38 -0400
Message-Id: <1244246629-28179-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1244246629-28179-1-git-send-email-lrodriguez@atheros.com>
References: <1244246629-28179-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is not used, remove this.

Cc: Derek Smithies <derek@indranet.co.nz>
Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 93e480c..4427094 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -823,19 +823,14 @@ static void ath_rc_rate_set_rtscts(struct ath_softc *sc,
 static u8 ath_rc_rate_getidx(struct ath_softc *sc,
 			     struct ath_rate_priv *ath_rc_priv,
 			     const struct ath_rate_table *rate_table,
-			     u8 rix, u16 stepdown)
+			     u8 rix)
 {
-	u32 j;
 	u8 nextindex = 0;
-
-	for (j = stepdown; j > 0; j--) {
-		if (ath_rc_get_nextlowervalid_txrate(rate_table,
-					ath_rc_priv, rix, &nextindex))
-			rix = nextindex;
-		else
-			break;
-	}
-	return rix;
+	if (ath_rc_get_nextlowervalid_txrate(rate_table,
+					     ath_rc_priv, rix, &nextindex))
+		return nextindex;
+	else
+		return rix;
 }
 
 static void ath_rc_ratefind(struct ath_softc *sc,
@@ -879,7 +874,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		 * after the probe rate
 		 */
 		nrix = ath_rc_rate_getidx(sc, ath_rc_priv,
-					  rate_table, nrix, 1);
+					  rate_table, nrix);
 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
 				       try_per_rate, nrix, 0);
 
@@ -897,7 +892,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 			try_per_rate = 4;
 
 		nrix = ath_rc_rate_getidx(sc, ath_rc_priv,
-					  rate_table, nrix, 1);
+					  rate_table, nrix);
 		/* All other rates in the series have RTS enabled */
 		ath_rc_rate_set_series(rate_table, &rates[i], txrc,
 				       try_per_rate, nrix, 1);
-- 
1.6.0.6

