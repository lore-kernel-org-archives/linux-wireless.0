Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42319 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbZGOAO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:14:28 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 20/21] ath9k: Use probe interval instead of rssi reduce interval
Date: Tue, 14 Jul 2009 20:14:12 -0400
Message-Id: <1247616853-11221-21-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
References: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Get rid of rssi reduce interval.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    6 +-----
 drivers/net/wireless/ath/ath9k/rc.h |    1 -
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 731967c..a97dd7b 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -148,7 +148,6 @@ static const struct ath_rate_table ar5416_11na_ratetable = {
 			4,  23, 40, 41, 41, 148400 },
 	},
 	50,  /* probe interval */
-	50,  /* rssi reduce interval */
 	WLAN_RC_HT_FLAG,  /* Phy rates allowed initially */
 };
 
@@ -298,7 +297,6 @@ static const struct ath_rate_table ar5416_11ng_ratetable = {
 			8,  27, 44, 45, 45, 148400 },
 		},
 	50,  /* probe interval */
-	50,  /* rssi reduce interval */
 	WLAN_RC_HT_FLAG,  /* Phy rates allowed initially */
 };
 
@@ -331,7 +329,6 @@ static const struct ath_rate_table ar5416_11a_ratetable = {
 			4,  7, 0 },
 	},
 	50,  /* probe interval */
-	50,  /* rssi reduce interval */
 	0,   /* Phy rates allowed initially */
 };
 
@@ -376,7 +373,6 @@ static const struct ath_rate_table ar5416_11g_ratetable = {
 			8,  11, 0 },
 	},
 	50,  /* probe interval */
-	50,  /* rssi reduce interval */
 	0,   /* Phy rates allowed initially */
 };
 
@@ -1070,7 +1066,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	/* Every so often, we reduce the thresholds
 	 * and PER (different for CCK and OFDM). */
 	if (now_msec - ath_rc_priv->per_down_time >=
-	    rate_table->rssi_reduce_interval) {
+	    rate_table->probe_interval) {
 		for (rate = 0; rate < size; rate++) {
 			ath_rc_priv->state[rate].per =
 				7 * ath_rc_priv->state[rate].per / 8;
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 6797df0..c794d6c 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -119,7 +119,6 @@ struct ath_rate_table {
 		u32 max_4ms_framelen;
 	} info[RATE_TABLE_SIZE];
 	u32 probe_interval;
-	u32 rssi_reduce_interval;
 	u8 initial_ratemax;
 };
 
-- 
1.6.0.6

