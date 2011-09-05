Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:42901 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752396Ab1IEKyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 06:54:40 -0400
Received: by mail-wy0-f171.google.com with SMTP id 13so5564498wyh.16
        for <linux-wireless@vger.kernel.org>; Mon, 05 Sep 2011 03:54:39 -0700 (PDT)
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Shahar Levi <shahar_levi@ti.com>
Subject: [PATCH] wl12xx: Includes OFDM rates in IBSS mode
Date: Mon,  5 Sep 2011 13:54:36 +0300
Message-Id: <1315220076-30153-1-git-send-email-shahar_levi@ti.com> (sfid-20110905_125446_177598_414D44B7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IBSS mode includes only 11B rates.
Includes OFDM rates in IBSS mode. Note that IBSS connection is
without ERP protection.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/conf.h |    5 +++--
 drivers/net/wireless/wl12xx/main.c |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 43bccc8..381c236 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -459,11 +459,12 @@ struct conf_rx_settings {
 	CONF_HW_BIT_RATE_2MBPS | CONF_HW_BIT_RATE_5_5MBPS)
 
 /*
- * Default rates for working as IBSS. use 11b rates
+ * Default rates for working as IBSS. use 11b + OFDM rates
+ * Note that IBSS connection is without ERP protection
  */
 #define CONF_TX_IBSS_DEFAULT_RATES  (CONF_HW_BIT_RATE_1MBPS |       \
 		CONF_HW_BIT_RATE_2MBPS | CONF_HW_BIT_RATE_5_5MBPS | \
-		CONF_HW_BIT_RATE_11MBPS);
+		CONF_HW_BIT_RATE_11MBPS | CONF_TX_OFDM_RATES);
 
 struct conf_tx_rate_class {
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index d66b079..eb10539 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3705,7 +3705,7 @@ sta_not_found:
 									 rates);
 			wl->basic_rate = wl1271_tx_min_rate_get(wl);
 
-			/* by default, use 11b rates */
+			/* by default, use 11b + OFDM rates */
 			wl->rate_set = CONF_TX_IBSS_DEFAULT_RATES;
 			ret = wl1271_acx_sta_rate_policies(wl);
 			if (ret < 0)
-- 
1.7.1

