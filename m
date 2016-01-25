Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40845 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100AbcAYHmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 02:42:53 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 07/26] staging: wilc1000: remove sleep and reduce close timeout
Date: Mon, 25 Jan 2016 16:35:11 +0900
Message-ID: <1453707330-13526-8-git-send-email-glen.lee@atmel.com> (sfid-20160125_084258_177794_9718F8F0)
In-Reply-To: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
References: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sleep is not necessary during handling tx queue so remove it and also reduce
close time to 5 sec since it is enough time to close.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 54fe9d7..236996f 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -391,9 +391,6 @@ static int linux_wlan_txq_task(void *vp)
 			}
 
 			if (ret == WILC_TX_ERR_NO_BUF) {
-				do {
-					msleep(TX_BACKOFF_WEIGHT_UNIT_MS << backoff_weight);
-				} while (0);
 				backoff_weight += TX_BACKOFF_WEIGHT_INCR_STEP;
 				if (backoff_weight > TX_BACKOFF_WEIGHT_MAX)
 					backoff_weight = TX_BACKOFF_WEIGHT_MAX;
@@ -1403,7 +1400,7 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 		release_firmware(wilc->firmware);
 
 	if (wilc && (wilc->vif[0]->ndev || wilc->vif[1]->ndev)) {
-		wilc_lock_timeout(wilc, &close_exit_sync, 12 * 1000);
+		wilc_lock_timeout(wilc, &close_exit_sync, 5 * 1000);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
 			if (wilc->vif[i]->ndev)
-- 
1.9.1

