Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:61644 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbZFRF34 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 01:29:56 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2009 22:29:59 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 3/4] ath9k: Use probe interval instead of rssi reduce interval
Date: Thu, 18 Jun 2009 10:53:31 +0530
Message-ID: <1245302612-18112-3-git-send-email-vasanth@atheros.com>
In-Reply-To: <1245302612-18112-2-git-send-email-vasanth@atheros.com>
References: <1245302612-18112-1-git-send-email-vasanth@atheros.com>
 <1245302612-18112-2-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
1.5.5.1

