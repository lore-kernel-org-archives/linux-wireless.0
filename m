Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:28242 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323AbbJ2DQf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:16:35 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 08/12] staging: wilc1000: wilc_wlan_init: add argument net_device
Date: Thu, 29 Oct 2015 12:18:48 +0900
Message-ID: <1446088732-12301-8-git-send-email-glen.lee@atmel.com> (sfid-20151029_041637_617270_59C4AC91)
In-Reply-To: <1446088732-12301-1-git-send-email-glen.lee@atmel.com>
References: <1446088732-12301-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument struct net_device and pass the function dev.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 5a480a1..16224ce 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1870,7 +1870,7 @@ void wilc_bus_set_default_speed(void)
 	/* Restore bus speed to default.  */
 	g_wlan.hif_func.hif_set_default_bus_speed();
 }
-u32 init_chip(void)
+u32 init_chip(struct net_device *dev)
 {
 	u32 chipid;
 	u32 reg, ret = 0;
@@ -2028,7 +2028,7 @@ int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 	}
 #endif
 
-	if (!init_chip()) {
+	if (!init_chip(dev)) {
 		/* EIO	5 */
 		ret = -5;
 		goto _fail_;
-- 
1.9.1

