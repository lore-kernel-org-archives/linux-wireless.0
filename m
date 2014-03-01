Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59748 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbaCAUR0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:17:26 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 17/23] ath9k_htc: use ath9k_htc_beacon_init in ath9k_htc_beacon_config_ap
Date: Sat,  1 Mar 2014 21:16:00 +0100
Message-Id: <1393704966-13985-18-git-send-email-linux@rempel-privat.de> (sfid-20140301_214710_677419_450C31DA)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 31 +++++++++----------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index b9b03c1..b23231f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -107,22 +107,19 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 				       struct ath_beacon_config *bss_conf)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
-	enum ath9k_int imask = 0;
-	u32 nexttbtt, intval, tsftu;
-	__be32 htc_imask = 0;
+	u32 tsftu;
 	int ret __attribute__ ((unused));
-	u8 cmd_rsp;
 	u64 tsf;
 
-	intval = bss_conf->beacon_interval;
-	intval /= ATH9K_HTC_MAX_BCN_VIF;
-	nexttbtt = intval;
+	bss_conf->intval = bss_conf->beacon_interval;
+	bss_conf->intval /= ATH9K_HTC_MAX_BCN_VIF;
+	bss_conf->nexttbtt = bss_conf->intval;
 
 	/*
 	 * To reduce beacon misses under heavy TX load,
 	 * set the beacon response time to a larger value.
 	 */
-	if (intval > DEFAULT_SWBA_RESPONSE)
+	if (bss_conf->intval > DEFAULT_SWBA_RESPONSE)
 		priv->ah->config.sw_beacon_response_time = DEFAULT_SWBA_RESPONSE;
 	else
 		priv->ah->config.sw_beacon_response_time = MIN_SWBA_RESPONSE;
@@ -137,25 +134,19 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 		tsf = ath9k_hw_gettsf64(priv->ah);
 		tsftu = TSF_TO_TU(tsf >> 32, tsf) + FUDGE;
 		do {
-			nexttbtt += intval;
-		} while (nexttbtt < tsftu);
+			bss_conf->nexttbtt += bss_conf->intval;
+		} while (bss_conf->nexttbtt < tsftu);
 	}
 
 	if (bss_conf->enable_beacon)
-		imask |= ATH9K_INT_SWBA;
+		priv->ah->imask = ATH9K_INT_SWBA;
 
 	ath_dbg(common, CONFIG,
 		"AP Beacon config, intval: %d, nexttbtt: %u, resp_time: %d imask: 0x%x\n",
-		bss_conf->beacon_interval, nexttbtt,
-		priv->ah->config.sw_beacon_response_time, imask);
+		bss_conf->beacon_interval, bss_conf->nexttbtt,
+		priv->ah->config.sw_beacon_response_time, priv->ah->imask);
 
-	ath9k_htc_beaconq_config(priv);
-
-	WMI_CMD(WMI_DISABLE_INTR_CMDID);
-	ath9k_hw_beaconinit(priv->ah, TU_TO_USEC(nexttbtt), TU_TO_USEC(intval));
-	priv->beacon.bmisscnt = 0;
-	htc_imask = cpu_to_be32(imask);
-	WMI_CMD_BUF(WMI_ENABLE_INTR_CMDID, &htc_imask);
+	ath9k_htc_beacon_init(priv, bss_conf, false);
 }
 
 static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
-- 
1.9.0

