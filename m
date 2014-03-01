Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59469 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbaCAURn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:17:43 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 19/23] ath9k_htc: use ath9k_cmn_beacon_config_adhoc
Date: Sat,  1 Mar 2014 21:16:02 +0100
Message-Id: <1393704966-13985-20-git-send-email-linux@rempel-privat.de> (sfid-20140301_214709_407507_7865EBAF)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 35 +++++--------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 8123715..50937d0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -150,42 +150,21 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 }
 
 static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
-					  struct ath_beacon_config *bss_conf)
+					  struct ath_beacon_config *conf)
 {
 	struct ath_hw *ah = priv->ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	u32 tsftu;
-	u64 tsf;
-
-	bss_conf->intval = bss_conf->beacon_interval;
-	bss_conf->nexttbtt = bss_conf->intval;
-
-	/*
-	 * Pull nexttbtt forward to reflect the current TSF.
-	 */
-	tsf = ath9k_hw_gettsf64(priv->ah);
-	tsftu = TSF_TO_TU(tsf >> 32, tsf) + FUDGE;
-	do {
-		bss_conf->nexttbtt += bss_conf->intval;
-	} while (bss_conf->nexttbtt < tsftu);
+	ah->imask = 0;
 
+	ath9k_cmn_beacon_config_adhoc(ah, conf);
 	/*
 	 * Only one IBSS interfce is allowed.
 	 */
-	if (bss_conf->intval > DEFAULT_SWBA_RESPONSE)
-		priv->ah->config.sw_beacon_response_time = DEFAULT_SWBA_RESPONSE;
+	if (conf->intval >= TU_TO_USEC(DEFAULT_SWBA_RESPONSE))
+		ah->config.sw_beacon_response_time = DEFAULT_SWBA_RESPONSE;
 	else
-		priv->ah->config.sw_beacon_response_time = MIN_SWBA_RESPONSE;
-
-	if (bss_conf->enable_beacon)
-		ah->imask = ATH9K_INT_SWBA;
-
-	ath_dbg(common, CONFIG,
-		"IBSS Beacon config, intval: %d, nexttbtt: %u, resp_time: %d, imask: 0x%x\n",
-		bss_conf->beacon_interval, bss_conf->nexttbtt,
-		priv->ah->config.sw_beacon_response_time, ah->imask);
+		ah->config.sw_beacon_response_time = MIN_SWBA_RESPONSE;
 
-	ath9k_htc_beacon_init(priv, bss_conf, bss_conf->ibss_creator);
+	ath9k_htc_beacon_init(priv, conf, conf->ibss_creator);
 }
 
 void ath9k_htc_beaconep(void *drv_priv, struct sk_buff *skb,
-- 
1.9.0

