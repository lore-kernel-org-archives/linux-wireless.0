Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29237 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbaEFQQU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 12:16:20 -0400
From: Loic Poulain <loic.poulain@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Loic Poulain <loic.poulain@intel.com>
Subject: [PATCH] rfkill-gpio: Use gpio cansleep version
Date: Tue,  6 May 2014 18:14:09 +0200
Message-Id: <1399392849-6021-1-git-send-email-loic.poulain@intel.com> (sfid-20140506_181633_900836_B6680023)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If gpio controller requires waiting for read and write
GPIO values, then we have to use the gpio cansleep api.
Fix the rfkill_gpio_set_power which calls only the
nonsleep version (causing kernel warning).
There is no problem to use the cansleep version here
because we are not in IRQ handler or similar context
(cf rfkill_set_block).

Signed-off-by: Loic Poulain <loic.poulain@intel.com>
---
 net/rfkill/rfkill-gpio.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index bd2a5b9..db6579d 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -47,16 +47,24 @@ static int rfkill_gpio_set_power(void *data, bool blocked)
 {
 	struct rfkill_gpio_data *rfkill = data;
 
+	if (!blocked) {
+		if (!IS_ERR(rfkill->clk) && !rfkill->clk_enabled)
+			clk_enable(rfkill->clk);
+	}
+
+	if (gpiod_cansleep(rfkill->shutdown_gpio))
+		gpiod_set_value_cansleep(rfkill->shutdown_gpio, !blocked);
+	else
+		gpiod_set_value(rfkill->shutdown_gpio, !blocked);
+
+	if (gpiod_cansleep(rfkill->reset_gpio))
+		gpiod_set_value_cansleep(rfkill->reset_gpio, !blocked);
+	else
+		gpiod_set_value(rfkill->reset_gpio, !blocked);
+
 	if (blocked) {
-		gpiod_set_value(rfkill->shutdown_gpio, 0);
-		gpiod_set_value(rfkill->reset_gpio, 0);
 		if (!IS_ERR(rfkill->clk) && rfkill->clk_enabled)
 			clk_disable(rfkill->clk);
-	} else {
-		if (!IS_ERR(rfkill->clk) && !rfkill->clk_enabled)
-			clk_enable(rfkill->clk);
-		gpiod_set_value(rfkill->reset_gpio, 1);
-		gpiod_set_value(rfkill->shutdown_gpio, 1);
 	}
 
 	rfkill->clk_enabled = blocked;
-- 
1.8.3.2

