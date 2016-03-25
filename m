Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:49943 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbcCYMUq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2016 08:20:46 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/11] staging: wilc1000: removes define USE_TX_BACKOFF_DELAY_IF_NO_BUFFERS
Date: Fri, 25 Mar 2016 21:16:55 +0900
Message-ID: <1458908216-12100-10-git-send-email-leo.kim@atmel.com> (sfid-20160325_132053_805738_8785649E)
In-Reply-To: <1458908216-12100-1-git-send-email-leo.kim@atmel.com>
References: <1458908216-12100-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes define USE_TX_BACKOFF_DELAY_IF_NO_BUFFERS and
use it's feature codes.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 127a967..fae03e8 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -303,22 +303,18 @@ int wilc_wlan_get_num_conn_ifcs(struct wilc *wilc)
 	return ret_val;
 }
 
-#define USE_TX_BACKOFF_DELAY_IF_NO_BUFFERS
-
 static int linux_wlan_txq_task(void *vp)
 {
 	int ret, txq_count;
 	struct wilc_vif *vif;
 	struct wilc *wl;
 	struct net_device *dev = vp;
-#if defined USE_TX_BACKOFF_DELAY_IF_NO_BUFFERS
 #define TX_BACKOFF_WEIGHT_INCR_STEP (1)
 #define TX_BACKOFF_WEIGHT_DECR_STEP (1)
 #define TX_BACKOFF_WEIGHT_MAX (7)
 #define TX_BACKOFF_WEIGHT_MIN (0)
 #define TX_BACKOFF_WEIGHT_UNIT_MS (10)
 	int backoff_weight = TX_BACKOFF_WEIGHT_MIN;
-#endif
 
 	vif = netdev_priv(dev);
 	wl = vif->wilc;
@@ -334,9 +330,6 @@ static int linux_wlan_txq_task(void *vp)
 				schedule();
 			break;
 		}
-#if !defined USE_TX_BACKOFF_DELAY_IF_NO_BUFFERS
-		ret = wilc_wlan_handle_txq(dev, &txq_count);
-#else
 		do {
 			ret = wilc_wlan_handle_txq(dev, &txq_count);
 			if (txq_count < FLOW_CONTROL_LOWER_THRESHOLD) {
@@ -358,7 +351,6 @@ static int linux_wlan_txq_task(void *vp)
 				}
 			}
 		} while (ret == WILC_TX_ERR_NO_BUF && !wl->close);
-#endif
 	}
 	return 0;
 }
-- 
1.9.1

