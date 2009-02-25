Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39117 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbZBYFBq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 00:01:46 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2009 21:01:45 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Remove ununsed ack duration stuff with long/short preamble
Date: Wed, 25 Feb 2009 10:28:23 +0530
Message-ID: <1235537903-5551-2-git-send-email-vasanth@atheros.com> (sfid-20090225_060151_452238_32899C91)
In-Reply-To: <1235537903-5551-1-git-send-email-vasanth@atheros.com>
References: <1235537903-5551-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |   27 ---------------------------
 drivers/net/wireless/ath9k/rc.h |    2 --
 2 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index cf0559f..18d19c3 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1656,27 +1656,6 @@ static struct rate_control_ops ath_rate_ops = {
 	.free_sta = ath_rate_free_sta,
 };
 
-static void ath_setup_rate_table(struct ath_softc *sc,
-				 struct ath_rate_table *rate_table)
-{
-	int i;
-
-	for (i = 0; i < rate_table->rate_cnt; i++) {
-		u8 cix = rate_table->info[i].ctrl_rate;
-
-		rate_table->info[i].lpAckDuration =
-			ath9k_hw_computetxtime(sc->sc_ah, rate_table,
-					       WLAN_CTRL_FRAME_SIZE,
-					       cix,
-					       false);
-		rate_table->info[i].spAckDuration =
-			ath9k_hw_computetxtime(sc->sc_ah, rate_table,
-					       WLAN_CTRL_FRAME_SIZE,
-					       cix,
-					       true);
-	}
-}
-
 void ath_rate_attach(struct ath_softc *sc)
 {
 	sc->hw_rate_table[ATH9K_MODE_11B] =
@@ -1697,12 +1676,6 @@ void ath_rate_attach(struct ath_softc *sc)
 		&ar5416_11ng_ratetable;
 	sc->hw_rate_table[ATH9K_MODE_11NG_HT40MINUS] =
 		&ar5416_11ng_ratetable;
-
-	ath_setup_rate_table(sc, &ar5416_11b_ratetable);
-	ath_setup_rate_table(sc, &ar5416_11a_ratetable);
-	ath_setup_rate_table(sc, &ar5416_11g_ratetable);
-	ath_setup_rate_table(sc, &ar5416_11na_ratetable);
-	ath_setup_rate_table(sc, &ar5416_11ng_ratetable);
 }
 
 int ath_rate_control_register(void)
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index d688ec5..a6dc82d 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -120,8 +120,6 @@ struct ath_rate_table {
 		u8 sgi_index;
 		u8 ht_index;
 		u32 max_4ms_framelen;
-		u16 lpAckDuration;
-		u16 spAckDuration;
 	} info[RATE_TABLE_SIZE];
 	u32 probe_interval;
 	u32 rssi_reduce_interval;
-- 
1.5.5.1

