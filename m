Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55311 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104AbaEGJiQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 05:38:16 -0400
From: Loic Poulain <loic.poulain@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux-gpio@vger.kernel.org,
	Loic Poulain <loic.poulain@intel.com>
Subject: [PATCHv2] rfkill-gpio: Use gpio cansleep version
Date: Wed,  7 May 2014 11:38:11 +0200
Message-Id: <1399455491-4491-1-git-send-email-loic.poulain@intel.com> (sfid-20140507_113820_302076_EE1C1BB8)
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
 v2: use cansleep unconditionnaly

 net/rfkill/rfkill-gpio.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index bd2a5b9..1cb42d0 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -47,17 +47,14 @@ static int rfkill_gpio_set_power(void *data, bool blocked)
 {
 	struct rfkill_gpio_data *rfkill = data;
 
-	if (blocked) {
-		gpiod_set_value(rfkill->shutdown_gpio, 0);
-		gpiod_set_value(rfkill->reset_gpio, 0);
-		if (!IS_ERR(rfkill->clk) && rfkill->clk_enabled)
-			clk_disable(rfkill->clk);
-	} else {
-		if (!IS_ERR(rfkill->clk) && !rfkill->clk_enabled)
-			clk_enable(rfkill->clk);
-		gpiod_set_value(rfkill->reset_gpio, 1);
-		gpiod_set_value(rfkill->shutdown_gpio, 1);
-	}
+	if (!blocked && !IS_ERR(rfkill->clk) && !rfkill->clk_enabled)
+		clk_enable(rfkill->clk);
+
+	gpiod_set_value_cansleep(rfkill->shutdown_gpio, !blocked);
+	gpiod_set_value_cansleep(rfkill->reset_gpio, !blocked);
+
+	if (blocked && !IS_ERR(rfkill->clk) && rfkill->clk_enabled)
+		clk_disable(rfkill->clk);
 
 	rfkill->clk_enabled = blocked;
 
-- 
1.8.3.2

