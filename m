Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14628 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbaIPMwd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2014 08:52:33 -0400
From: Loic Poulain <loic.poulain@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Loic Poulain <loic.poulain@intel.com>
Subject: [PATCH] net: rfkill: gpio: Fix clock status
Date: Tue, 16 Sep 2014 14:53:58 +0200
Message-Id: <1410872038-4604-1-git-send-email-loic.poulain@intel.com> (sfid-20140916_145237_027446_AC82936F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clock is disabled when the device is blocked.
So, clock_enabled is the logical negation of "blocked".

Signed-off-by: Loic Poulain <loic.poulain@intel.com>
---
 net/rfkill/rfkill-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 14c98e4..408e51f 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -54,7 +54,7 @@ static int rfkill_gpio_set_power(void *data, bool blocked)
 	if (blocked && !IS_ERR(rfkill->clk) && rfkill->clk_enabled)
 		clk_disable(rfkill->clk);
 
-	rfkill->clk_enabled = blocked;
+	rfkill->clk_enabled = !blocked;
 
 	return 0;
 }
-- 
1.8.3.2

