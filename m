Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8899 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbbKCHSW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 02:18:22 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/5] staging: wilc1000: send_config_pkt: use netdev print
Date: Tue, 3 Nov 2015 16:20:59 +0900
Message-ID: <1446535262-19817-2-git-send-email-glen.lee@atmel.com> (sfid-20151103_081825_245596_D44DB9BD)
In-Reply-To: <1446535262-19817-1-git-send-email-glen.lee@atmel.com>
References: <1446535262-19817-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch use netdev_xxx print format instead of custom print api and printk.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 74fb556..637e8ca 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -593,15 +593,16 @@ s32 send_config_pkt(struct net_device *dev, u8 mode, struct wid *wids,
 
 	if (mode == GET_CFG) {
 		for (counter = 0; counter < count; counter++) {
-			PRINT_INFO(CORECONFIG_DBG, "Sending CFG packet [%d][%d]\n", !counter,
-				   (counter == count - 1));
+			netdev_info(dev, "Sending CFG packet [%d][%d]\n",
+				    !counter, (counter == count - 1));
 			if (!wilc_wlan_cfg_get(dev,
 					       !counter,
 					       wids[counter].id,
 					       (counter == count - 1),
 					       drv)) {
 				ret = -1;
-				printk("[Sendconfigpkt]Get Timed out\n");
+				netdev_err(dev,
+					   "[Sendconfigpkt]Get Timed out\n");
 				break;
 			}
 		}
@@ -615,7 +616,8 @@ s32 send_config_pkt(struct net_device *dev, u8 mode, struct wid *wids,
 		}
 	} else if (mode == SET_CFG) {
 		for (counter = 0; counter < count; counter++) {
-			PRINT_D(CORECONFIG_DBG, "Sending config SET PACKET WID:%x\n", wids[counter].id);
+			netdev_info(dev, "Sending config SET PACKET WID:%x\n",
+				    wids[counter].id);
 			if (!wilc_wlan_cfg_set(dev,
 					       !counter,
 					       wids[counter].id,
@@ -624,7 +626,8 @@ s32 send_config_pkt(struct net_device *dev, u8 mode, struct wid *wids,
 					       (counter == count - 1),
 					       drv)) {
 				ret = -1;
-				printk("[Sendconfigpkt]Set Timed out\n");
+				netdev_err(dev,
+					   "[Sendconfigpkt]Set Timed out\n");
 				break;
 			}
 		}
-- 
1.9.1

