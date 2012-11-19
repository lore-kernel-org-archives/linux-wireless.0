Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41697 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab2KSSiL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 13:38:11 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 126/493] rfkill: remove use of __devexit_p
Date: Mon, 19 Nov 2012 13:21:15 -0500
Message-Id: <1353349642-3677-126-git-send-email-wfp5p@virginia.edu> (sfid-20121119_193902_643277_193C156E)
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: Johannes Berg <johannes@sipsolutions.net> 
Cc: "John W. Linville" <linville@tuxdriver.com> 
Cc: "David S. Miller" <davem@davemloft.net> 
Cc: linux-wireless@vger.kernel.org 
Cc: netdev@vger.kernel.org 
---
 net/rfkill/rfkill-gpio.c      | 2 +-
 net/rfkill/rfkill-regulator.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 865adb6..78fc093 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -213,7 +213,7 @@ static int rfkill_gpio_remove(struct platform_device *pdev)
 
 static struct platform_driver rfkill_gpio_driver = {
 	.probe = rfkill_gpio_probe,
-	.remove = __devexit_p(rfkill_gpio_remove),
+	.remove = rfkill_gpio_remove,
 	.driver = {
 		   .name = "rfkill_gpio",
 		   .owner = THIS_MODULE,
diff --git a/net/rfkill/rfkill-regulator.c b/net/rfkill/rfkill-regulator.c
index 11da301..a87710d 100644
--- a/net/rfkill/rfkill-regulator.c
+++ b/net/rfkill/rfkill-regulator.c
@@ -137,7 +137,7 @@ static int __devexit rfkill_regulator_remove(struct platform_device *pdev)
 
 static struct platform_driver rfkill_regulator_driver = {
 	.probe = rfkill_regulator_probe,
-	.remove = __devexit_p(rfkill_regulator_remove),
+	.remove = rfkill_regulator_remove,
 	.driver = {
 		.name = "rfkill-regulator",
 		.owner = THIS_MODULE,
-- 
1.8.0

