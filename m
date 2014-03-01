Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:51018 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbaCAURy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:17:54 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 22/23] ath9k_htc: use ath9k_cmn_beacon_config_ap
Date: Sat,  1 Mar 2014 21:16:05 +0100
Message-Id: <1393704966-13985-23-git-send-email-linux@rempel-privat.de> (sfid-20140301_214710_528561_F9F890BA)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 43 +++++--------------------
 1 file changed, 8 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 50937d0..cbaf4e0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -104,49 +104,22 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 }
 
 static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
-				       struct ath_beacon_config *bss_conf)
+				       struct ath_beacon_config *conf)
 {
-	struct ath_common *common = ath9k_hw_common(priv->ah);
-	u32 tsftu;
-	int ret __attribute__ ((unused));
-	u64 tsf;
-
-	bss_conf->intval = bss_conf->beacon_interval;
-	bss_conf->intval /= ATH9K_HTC_MAX_BCN_VIF;
-	bss_conf->nexttbtt = bss_conf->intval;
+	struct ath_hw *ah = priv->ah;
+	ah->imask = 0;
 
+	ath9k_cmn_beacon_config_ap(ah, conf, ATH9K_HTC_MAX_BCN_VIF);
 	/*
 	 * To reduce beacon misses under heavy TX load,
 	 * set the beacon response time to a larger value.
 	 */
-	if (bss_conf->intval > DEFAULT_SWBA_RESPONSE)
-		priv->ah->config.sw_beacon_response_time = DEFAULT_SWBA_RESPONSE;
+	if (conf->intval >= TU_TO_USEC(DEFAULT_SWBA_RESPONSE))
+		ah->config.sw_beacon_response_time = DEFAULT_SWBA_RESPONSE;
 	else
-		priv->ah->config.sw_beacon_response_time = MIN_SWBA_RESPONSE;
-
-	if (test_bit(OP_TSF_RESET, &priv->op_flags)) {
-		ath9k_hw_reset_tsf(priv->ah);
-		clear_bit(OP_TSF_RESET, &priv->op_flags);
-	} else {
-		/*
-		 * Pull nexttbtt forward to reflect the current TSF.
-		 */
-		tsf = ath9k_hw_gettsf64(priv->ah);
-		tsftu = TSF_TO_TU(tsf >> 32, tsf) + FUDGE;
-		do {
-			bss_conf->nexttbtt += bss_conf->intval;
-		} while (bss_conf->nexttbtt < tsftu);
-	}
-
-	if (bss_conf->enable_beacon)
-		priv->ah->imask = ATH9K_INT_SWBA;
-
-	ath_dbg(common, CONFIG,
-		"AP Beacon config, intval: %d, nexttbtt: %u, resp_time: %d imask: 0x%x\n",
-		bss_conf->beacon_interval, bss_conf->nexttbtt,
-		priv->ah->config.sw_beacon_response_time, priv->ah->imask);
+		ah->config.sw_beacon_response_time = MIN_SWBA_RESPONSE;
 
-	ath9k_htc_beacon_init(priv, bss_conf, false);
+	ath9k_htc_beacon_init(priv, conf, false);
 }
 
 static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
-- 
1.9.0

