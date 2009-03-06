Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42577 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbZCFPMT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 10:12:19 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2009 07:12:18 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Set IEEE80211_TX_CTL_RATE_CTRL_PROBE in rate control for probe rates
Date: Fri, 6 Mar 2009 20:38:37 +0530
Message-ID: <1236352117-18466-2-git-send-email-vasanth@atheros.com> (sfid-20090306_161221_600264_7323DA07)
In-Reply-To: <1236352117-18466-1-git-send-email-vasanth@atheros.com>
References: <1236352117-18466-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 8327356..a35b525 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -750,7 +750,8 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 static void ath_rc_rate_set_series(struct ath_rate_table *rate_table,
 				   struct ieee80211_tx_rate *rate,
 				   struct ieee80211_tx_rate_control *txrc,
-				   u8 tries, u8 rix, int rtsctsenable)
+				   u8 tries, u8 rix, int rtsctsenable,
+				   bool is_probe)
 {
 	rate->count = tries;
 	rate->idx = rix;
@@ -765,6 +766,8 @@ static void ath_rc_rate_set_series(struct ath_rate_table *rate_table,
 		rate->flags |= IEEE80211_TX_RC_SHORT_GI;
 	if (WLAN_RC_PHY_HT(rate_table->info[rix].phy))
 		rate->flags |= IEEE80211_TX_RC_MCS;
+	if (is_probe)
+		rate->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 }
 
 static void ath_rc_rate_set_rtscts(struct ath_softc *sc,
@@ -854,7 +857,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		/* set one try for probe rates. For the
 		 * probes don't enable rts */
 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
-				       1, nrix, 0);
+				       1, nrix, 0, is_probe);
 
 		try_per_rate = (ATH_11N_TXMAXTRY/4);
 		/* Get the next tried/allowed rate. No RTS for the next series
@@ -863,12 +866,12 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		nrix = ath_rc_rate_getidx(sc, ath_rc_priv,
 					  rate_table, nrix, 1, 0);
 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
-				       try_per_rate, nrix, 0);
+				       try_per_rate, nrix, 0, is_probe);
 	} else {
 		try_per_rate = (ATH_11N_TXMAXTRY/4);
 		/* Set the choosen rate. No RTS for first series entry. */
 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
-				       try_per_rate, nrix, 0);
+				       try_per_rate, nrix, 0, is_probe);
 	}
 
 	/* Fill in the other rates for multirate retry */
@@ -884,7 +887,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 					  rate_table, nrix, 1, min_rate);
 		/* All other rates in the series have RTS enabled */
 		ath_rc_rate_set_series(rate_table, &rates[i], txrc,
-				       try_num, nrix, 1);
+				       try_num, nrix, 1, is_probe);
 	}
 
 	/*
-- 
1.5.5.1

