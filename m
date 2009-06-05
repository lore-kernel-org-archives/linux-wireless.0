Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35508 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbZFEFlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 01:41:49 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: [PATCH 06/15] ath9k: rename ath_rc_get_nextlowervalid_txrate()
Date: Fri,  5 Jun 2009 01:41:33 -0400
Message-Id: <1244180502-4323-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
References: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
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
index 6ccd565..eaa22e4 100644
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
 
@@ -860,8 +860,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		/* Get the next tried/allowed rate. No RTS for the next series
 		 * after the probe rate
 		 */
-		ath_rc_get_nextlowervalid_txrate(rate_table, ath_rc_priv,
-						 rix, &nrix);
+		ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &nrix);
 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
 				       try_per_rate, nrix, 0);
 
@@ -878,8 +877,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		if (i + 1 == 4)
 			try_per_rate = 4;
 
-		ath_rc_get_nextlowervalid_txrate(rate_table, ath_rc_priv,
-						 rix, &nrix);
+		ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &nrix);
 		/* All other rates in the series have RTS enabled */
 		ath_rc_rate_set_series(rate_table, &rates[i], txrc,
 				       try_per_rate, nrix, 1);
@@ -1176,8 +1174,8 @@ static void ath_rc_update_ht(struct ath_softc *sc,
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

