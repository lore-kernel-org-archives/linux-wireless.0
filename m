Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:49970 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbcCYMU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2016 08:20:56 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/11] staging: wilc1000: removes unused local variable
Date: Fri, 25 Mar 2016 21:16:56 +0900
Message-ID: <1458908216-12100-11-git-send-email-leo.kim@atmel.com> (sfid-20160325_132059_950983_2F7F17A0)
In-Reply-To: <1458908216-12100-1-git-send-email-leo.kim@atmel.com>
References: <1458908216-12100-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused local variable.
This variable is operation definition that back off from sending packets
for some time.
However, that has been deleted operation code.
That is removes all relative code.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index fae03e8..a858552 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -309,12 +309,6 @@ static int linux_wlan_txq_task(void *vp)
 	struct wilc_vif *vif;
 	struct wilc *wl;
 	struct net_device *dev = vp;
-#define TX_BACKOFF_WEIGHT_INCR_STEP (1)
-#define TX_BACKOFF_WEIGHT_DECR_STEP (1)
-#define TX_BACKOFF_WEIGHT_MAX (7)
-#define TX_BACKOFF_WEIGHT_MIN (0)
-#define TX_BACKOFF_WEIGHT_UNIT_MS (10)
-	int backoff_weight = TX_BACKOFF_WEIGHT_MIN;
 
 	vif = netdev_priv(dev);
 	wl = vif->wilc;
@@ -338,18 +332,6 @@ static int linux_wlan_txq_task(void *vp)
 				if (netif_queue_stopped(wl->vif[1]->ndev))
 					netif_wake_queue(wl->vif[1]->ndev);
 			}
-
-			if (ret == WILC_TX_ERR_NO_BUF) {
-				backoff_weight += TX_BACKOFF_WEIGHT_INCR_STEP;
-				if (backoff_weight > TX_BACKOFF_WEIGHT_MAX)
-					backoff_weight = TX_BACKOFF_WEIGHT_MAX;
-			} else {
-				if (backoff_weight > TX_BACKOFF_WEIGHT_MIN) {
-					backoff_weight -= TX_BACKOFF_WEIGHT_DECR_STEP;
-					if (backoff_weight < TX_BACKOFF_WEIGHT_MIN)
-						backoff_weight = TX_BACKOFF_WEIGHT_MIN;
-				}
-			}
 		} while (ret == WILC_TX_ERR_NO_BUF && !wl->close);
 	}
 	return 0;
-- 
1.9.1

