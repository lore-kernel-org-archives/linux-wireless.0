Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42321 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbZGOAO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:14:28 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: [PATCH 08/21] ath9k: rename ath_rc_get_nextlowervalid_txrate()
Date: Tue, 14 Jul 2009 20:14:00 -0400
Message-Id: <1247616853-11221-9-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
References: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What this does is get us our next lower rate so call it that,
ath_rc_get_lower_rix().

Cc: Derek Smithies <derek@indranet.co.nz>
Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 03e7df4..c8f800e 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -501,9 +501,9 @@ static int ath_rc_valid_phyrate(u32 phy, u32 capflag, int ignore_cw)
 }
 
 static inline int
-ath_rc_get_nextlowervalid_txrate(const struct ath_rate_table *rate_table,
-				 struct ath_rate_priv *ath_rc_priv,
-				 u8 cur_valid_txrate, u8 *next_idx)
+ath_rc_get_lower_rix(const struct ath_rate_table *rate_table,
+		     struct ath_rate_priv *ath_rc_priv,
+		     u8 cur_valid_txrate, u8 *next_idx)
 {
 	int8_t i;
 
@@ -852,8 +852,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		/* Get the next tried/allowed rate. No RTS for the next series
 		 * after the probe rate
 		 */
-		ath_rc_get_nextlowervalid_txrate(rate_table, ath_rc_priv,
-						 rix, &nrix);
+		ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &nrix);
 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
 				       try_per_rate, nrix, 0);
 
@@ -870,8 +869,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		if (i + 1 == 4)
 			try_per_rate = 4;
 
-		ath_rc_get_nextlowervalid_txrate(rate_table, ath_rc_priv,
-						 rix, &nrix);
+		ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &nrix);
 		/* All other rates in the series have RTS enabled */
 		ath_rc_rate_set_series(rate_table, &rates[i], txrc,
 				       try_per_rate, nrix, 1);
@@ -1156,8 +1154,8 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	if (ath_rc_priv->state[tx_rate].per >= 55 && tx_rate > 0 &&
 	    rate_table->info[tx_rate].ratekbps <=
 	    rate_table->info[ath_rc_priv->rate_max_phy].ratekbps) {
-		ath_rc_get_nextlowervalid_txrate(rate_table, ath_rc_priv,
-				 (u8)tx_rate, &ath_rc_priv->rate_max_phy);
+		ath_rc_get_lower_rix(rate_table, ath_rc_priv,
+				     (u8)tx_rate, &ath_rc_priv->rate_max_phy);
 
 		/* Don't probe for a little while. */
 		ath_rc_priv->probe_time = now_msec;
-- 
1.6.0.6

