Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57121 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1I0OyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 10:54:20 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k: Update rate control for better performance at higer rates
Date: Tue, 27 Sep 2011 20:24:01 +0530
Message-ID: <1317135241-3523-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110927_165423_612737_EE2C2929)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rate control algorithm is updated as follows in order to improve
the performance at higher rates. Probe the next allowed phy state
only when current rate is max phy and current PER is lower enough.
If the current rate is at max phy and current rate's expected throughput
is lower than next lower rate's expected throughput then drop the rate.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 8448281..5ee2abe 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -657,11 +657,12 @@ static u8 ath_rc_get_highest_rix(struct ath_softc *sc,
 	rate = best_rate;
 
 	/*
-	 * Must check the actual rate (ratekbps) to account for
-	 * non-monoticity of 11g's rate table
+	 * Probe only when current rate is max phy and current PER
+	 * is lower enough (less or equal to target PER)
 	 */
 
-	if (rate >= ath_rc_priv->rate_max_phy) {
+	if ((rate == ath_rc_priv->rate_max_phy) &&
+	    (ath_rc_priv->per[rate] <= 12)) {
 		rate = ath_rc_priv->rate_max_phy;
 
 		/* Probe the next allowed phy state */
@@ -1085,6 +1086,22 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 		ath_rc_priv->probe_time = now_msec;
 	}
 
+	/*
+	 * When at max allow rate, if current rate expected throuhgput is lower
+	 * then next lower rate expected throughput ,then drop one rate
+	 */
+	if (tx_rate == ath_rc_priv->rate_max_phy) {
+		u8 next_txrate;
+		if (ath_rc_get_lower_rix(rate_table, ath_rc_priv,
+				(u8)tx_rate, &next_txrate)) {
+			if ((rate_table->info[tx_rate].user_ratekbps *
+			     (100 - ath_rc_priv->per[tx_rate])) <
+			    (rate_table->info[next_txrate].user_ratekbps *
+			     (100 - 12)))
+				ath_rc_priv->rate_max_phy = next_txrate;
+		}
+	}
+
 	/* Make sure the rates below this have lower PER */
 	/* Monotonicity is kept only for rates below the current rate. */
 	if (ath_rc_priv->per[tx_rate] < last_per) {
-- 
1.7.6.4

