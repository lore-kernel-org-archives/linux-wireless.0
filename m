Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27041 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031027AbbKEFge (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:36:34 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 32/38] staging: wilc1000: remove goto from wlan_initialize_threads
Date: Thu, 5 Nov 2015 14:36:33 +0900
Message-ID: <1446701799-24870-32-git-send-email-glen.lee@atmel.com> (sfid-20151105_063754_279894_9F04A3D5)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch remove goto feature from wlan_initialize_threads function.
Goto feature is 'wilc->close=0' & return result.
So, remove goto feature and it was replaced with the return value directly,
as well as removed unused ret variable.
Also, execute 'wilc->close=0' before return.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index c529a15..3c8155e 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -911,7 +911,6 @@ int wlan_initialize_threads(struct net_device *dev)
 {
 	perInterface_wlan_t *nic;
 	struct wilc *wilc;
-	int ret = 0;
 
 	nic = netdev_priv(dev);
 	wilc = nic->wilc;
@@ -922,16 +921,12 @@ int wlan_initialize_threads(struct net_device *dev)
 				     "K_TXQ_TASK");
 	if (!wilc->txq_thread) {
 		PRINT_ER("couldn't create TXQ thread\n");
-		ret = -ENOBUFS;
-		goto _fail_2;
+		wilc->close = 0;
+		return -ENOBUFS;
 	}
 	down(&wilc->txq_thread_started);
 
 	return 0;
-
-_fail_2:
-	wilc->close = 0;
-	return ret;
 }
 
 static void wlan_deinitialize_threads(struct net_device *dev)
-- 
1.9.1

