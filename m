Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47238 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbZFFAD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 20:03:57 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, j@w1.fi
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: [PATCH v2 05/15] ath9k: remove pointless wrapper ath_rc_rate_getidx()
Date: Fri,  5 Jun 2009 20:03:39 -0400
Message-Id: <1244246629-28179-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1244246629-28179-1-git-send-email-lrodriguez@atheros.com>
References: <1244246629-28179-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is just calling another helper, so just use the other
helper directly. This should make it clear that when do not
find the next rate we stick to the current one.

Cc: Derek Smithies <derek@indranet.co.nz>
Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |   21 ++++-----------------
 1 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 4427094..d855572 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -820,19 +820,6 @@ static void ath_rc_rate_set_rtscts(struct ath_softc *sc,
 	tx_info->control.rts_cts_rate_idx = cix;
 }
 
-static u8 ath_rc_rate_getidx(struct ath_softc *sc,
-			     struct ath_rate_priv *ath_rc_priv,
-			     const struct ath_rate_table *rate_table,
-			     u8 rix)
-{
-	u8 nextindex = 0;
-	if (ath_rc_get_nextlowervalid_txrate(rate_table,
-					     ath_rc_priv, rix, &nextindex))
-		return nextindex;
-	else
-		return rix;
-}
-
 static void ath_rc_ratefind(struct ath_softc *sc,
 			    struct ath_rate_priv *ath_rc_priv,
 			    struct ieee80211_tx_rate_control *txrc,
@@ -873,8 +860,8 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		/* Get the next tried/allowed rate. No RTS for the next series
 		 * after the probe rate
 		 */
-		nrix = ath_rc_rate_getidx(sc, ath_rc_priv,
-					  rate_table, nrix);
+		ath_rc_get_nextlowervalid_txrate(rate_table, ath_rc_priv,
+						 rix, &nrix);
 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
 				       try_per_rate, nrix, 0);
 
@@ -891,8 +878,8 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		if (i + 1 == 4)
 			try_per_rate = 4;
 
-		nrix = ath_rc_rate_getidx(sc, ath_rc_priv,
-					  rate_table, nrix);
+		ath_rc_get_nextlowervalid_txrate(rate_table, ath_rc_priv,
+						 rix, &nrix);
 		/* All other rates in the series have RTS enabled */
 		ath_rc_rate_set_series(rate_table, &rates[i], txrc,
 				       try_per_rate, nrix, 1);
-- 
1.6.0.6

