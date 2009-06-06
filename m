Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47254 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbZFFAEB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 20:04:01 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, j@w1.fi
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: [PATCH v2 10/15] ath9k: rename ath_rc_ratefind_ht() to ath_rc_get_highest_rix()
Date: Fri,  5 Jun 2009 20:03:44 -0400
Message-Id: <1244246629-28179-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1244246629-28179-1-git-send-email-lrodriguez@atheros.com>
References: <1244246629-28179-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The purpose is to find the highest rate we can use.

Cc: Derek Smithies <derek@indranet.co.nz>
Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 980040b..9907f2f 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -601,10 +601,11 @@ static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv,
 	return hi;
 }
 
-static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
-			     struct ath_rate_priv *ath_rc_priv,
-			     const struct ath_rate_table *rate_table,
-			     int *is_probing)
+/* Finds the highest rate index we can use */
+static u8 ath_rc_get_highest_rix(struct ath_softc *sc,
+			         struct ath_rate_priv *ath_rc_priv,
+				 const struct ath_rate_table *rate_table,
+				 int *is_probing)
 {
 	u32 dt, best_thruput, this_thruput, now_msec;
 	u8 rate, next_rate, best_rate, maxindex, minindex;
@@ -820,7 +821,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 	try_per_rate = sc->hw->max_rate_tries;
 
 	rate_table = sc->cur_rate_table;
-	rix = ath_rc_ratefind_ht(sc, ath_rc_priv, rate_table, &is_probe);
+	rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table, &is_probe);
 	nrix = rix;
 
 	if (is_probe) {
@@ -909,7 +910,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 			"disabling MRR\n");
 		rates[0].idx = rate_lowest_index(sband, sta);
 		rates[0].count = 4;
-		/* Disable MRR when ath_rc_ratefind_ht() found rate 0 */
+		/* Disable MRR when ath_rc_get_highest_rix() found rate 0 */
 		rates[1].idx = -1;
 	}
 }
-- 
1.6.0.6

