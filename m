Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35507 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbZFEFlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 01:41:49 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: [PATCH 10/15] ath9k: rename ath_rc_ratefind_ht() to ath_rc_get_highest_rix()
Date: Fri,  5 Jun 2009 01:41:37 -0400
Message-Id: <1244180502-4323-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
References: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
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
index 7cea944..16e41b1 100644
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
@@ -908,7 +909,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		DPRINTF(sc, ATH_DBG_RATE, "lowest rate being used, "
 			"disabling MRR\n");
 		rates[0].idx = rate_lowest_index(sband, sta);
-		/* Disable MRR when ath_rc_ratefind_ht() found rate 0 */
+		/* Disable MRR when ath_rc_get_highest_rix() found rate 0 */
 		rates[1].idx = -1;
 	}
 }
-- 
1.6.0.6

