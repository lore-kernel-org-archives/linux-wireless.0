Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59124 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbaCAURo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:17:44 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 18/23] ath9k_htc: use ath9k_htc_beacon_init in ath9k_htc_beacon_config_adhoc
Date: Sat,  1 Mar 2014 21:16:01 +0100
Message-Id: <1393704966-13985-19-git-send-email-linux@rempel-privat.de> (sfid-20140301_214710_306857_ADCEC050)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 31 ++++++++++---------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index b23231f..8123715 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -152,16 +152,13 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
 					  struct ath_beacon_config *bss_conf)
 {
-	struct ath_common *common = ath9k_hw_common(priv->ah);
-	enum ath9k_int imask = 0;
-	u32 nexttbtt, intval, tsftu;
-	__be32 htc_imask = 0;
-	int ret __attribute__ ((unused));
-	u8 cmd_rsp;
+	struct ath_hw *ah = priv->ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 tsftu;
 	u64 tsf;
 
-	intval = bss_conf->beacon_interval;
-	nexttbtt = intval;
+	bss_conf->intval = bss_conf->beacon_interval;
+	bss_conf->nexttbtt = bss_conf->intval;
 
 	/*
 	 * Pull nexttbtt forward to reflect the current TSF.
@@ -169,30 +166,26 @@ static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
 	tsf = ath9k_hw_gettsf64(priv->ah);
 	tsftu = TSF_TO_TU(tsf >> 32, tsf) + FUDGE;
 	do {
-		nexttbtt += intval;
-	} while (nexttbtt < tsftu);
+		bss_conf->nexttbtt += bss_conf->intval;
+	} while (bss_conf->nexttbtt < tsftu);
 
 	/*
 	 * Only one IBSS interfce is allowed.
 	 */
-	if (intval > DEFAULT_SWBA_RESPONSE)
+	if (bss_conf->intval > DEFAULT_SWBA_RESPONSE)
 		priv->ah->config.sw_beacon_response_time = DEFAULT_SWBA_RESPONSE;
 	else
 		priv->ah->config.sw_beacon_response_time = MIN_SWBA_RESPONSE;
 
 	if (bss_conf->enable_beacon)
-		imask |= ATH9K_INT_SWBA;
+		ah->imask = ATH9K_INT_SWBA;
 
 	ath_dbg(common, CONFIG,
 		"IBSS Beacon config, intval: %d, nexttbtt: %u, resp_time: %d, imask: 0x%x\n",
-		bss_conf->beacon_interval, nexttbtt,
-		priv->ah->config.sw_beacon_response_time, imask);
+		bss_conf->beacon_interval, bss_conf->nexttbtt,
+		priv->ah->config.sw_beacon_response_time, ah->imask);
 
-	WMI_CMD(WMI_DISABLE_INTR_CMDID);
-	ath9k_hw_beaconinit(priv->ah, TU_TO_USEC(nexttbtt), TU_TO_USEC(intval));
-	priv->beacon.bmisscnt = 0;
-	htc_imask = cpu_to_be32(imask);
-	WMI_CMD_BUF(WMI_ENABLE_INTR_CMDID, &htc_imask);
+	ath9k_htc_beacon_init(priv, bss_conf, bss_conf->ibss_creator);
 }
 
 void ath9k_htc_beaconep(void *drv_priv, struct sk_buff *skb,
-- 
1.9.0

