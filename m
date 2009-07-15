Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42323 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbZGOAO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:14:28 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: [PATCH 12/21] ath9k: rename ath_rc_ratefind_ht() to ath_rc_get_highest_rix()
Date: Tue, 14 Jul 2009 20:14:04 -0400
Message-Id: <1247616853-11221-13-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
References: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The purpose is to find the highest rate we can use.

Cc: Derek Smithies <derek@indranet.co.nz>
Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 112a0ec..96d46d6 100644
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
@@ -812,7 +813,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 	try_per_rate = sc->hw->max_rate_tries;
 
 	rate_table = sc->cur_rate_table;
-	rix = ath_rc_ratefind_ht(sc, ath_rc_priv, rate_table, &is_probe);
+	rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table, &is_probe);
 	nrix = rix;
 
 	if (is_probe) {
-- 
1.6.0.6

