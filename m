Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52015 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbaCAUR7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:17:59 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 23/23] ath9k_htc: move DEFAULT_SWBA_RESPONSE check to ath9k_htc_beacon_init
Date: Sat,  1 Mar 2014 21:16:06 +0100
Message-Id: <1393704966-13985-24-git-send-email-linux@rempel-privat.de> (sfid-20140301_214708_975233_5E66EFF5)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... to remove some more dups.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index cbaf4e0..e8b6ec3 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -74,6 +74,11 @@ static void ath9k_htc_beacon_init(struct ath9k_htc_priv *priv,
 	__be32 htc_imask = 0;
 	u8 cmd_rsp;
 
+	if (conf->intval >= TU_TO_USEC(DEFAULT_SWBA_RESPONSE))
+		ah->config.sw_beacon_response_time = DEFAULT_SWBA_RESPONSE;
+	else
+		ah->config.sw_beacon_response_time = MIN_SWBA_RESPONSE;
+
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
 	if (reset_tsf)
 		ath9k_hw_reset_tsf(ah);
@@ -110,15 +115,6 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 	ah->imask = 0;
 
 	ath9k_cmn_beacon_config_ap(ah, conf, ATH9K_HTC_MAX_BCN_VIF);
-	/*
-	 * To reduce beacon misses under heavy TX load,
-	 * set the beacon response time to a larger value.
-	 */
-	if (conf->intval >= TU_TO_USEC(DEFAULT_SWBA_RESPONSE))
-		ah->config.sw_beacon_response_time = DEFAULT_SWBA_RESPONSE;
-	else
-		ah->config.sw_beacon_response_time = MIN_SWBA_RESPONSE;
-
 	ath9k_htc_beacon_init(priv, conf, false);
 }
 
@@ -129,14 +125,6 @@ static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
 	ah->imask = 0;
 
 	ath9k_cmn_beacon_config_adhoc(ah, conf);
-	/*
-	 * Only one IBSS interfce is allowed.
-	 */
-	if (conf->intval >= TU_TO_USEC(DEFAULT_SWBA_RESPONSE))
-		ah->config.sw_beacon_response_time = DEFAULT_SWBA_RESPONSE;
-	else
-		ah->config.sw_beacon_response_time = MIN_SWBA_RESPONSE;
-
 	ath9k_htc_beacon_init(priv, conf, conf->ibss_creator);
 }
 
-- 
1.9.0

