Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45351 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab0HYOOn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 10:14:43 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1OoGkU-0007jt-8P
	for linux-wireless@vger.kernel.org; Wed, 25 Aug 2010 10:14:42 -0400
Received: from linville-8530p.local (linville-8530p.local [127.0.0.1])
	by linville-8530p.local (8.14.4/8.14.4) with ESMTP id o7PEEIUE003382
	for <linux-wireless@vger.kernel.org>; Wed, 25 Aug 2010 10:14:18 -0400
Received: (from linville@localhost)
	by linville-8530p.local (8.14.4/8.14.4/Submit) id o7PEEIaR003381
	for linux-wireless@vger.kernel.org; Wed, 25 Aug 2010 10:14:18 -0400
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.org>, <Aeolus.Yang@atheros.com>,
	<Senthilkumar.Balasubramanian@atheros.com>
Subject: [PATCH 2/2] ath9k: Change the default LED pattern.
Date: Wed, 25 Aug 2010 19:34:52 +0530
Message-ID: <1282745092-19825-2-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1282745092-19825-1-git-send-email-vnatarajan@atheros.com>
References: <1282745092-19825-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All major Atheros customers require the led to be in continuous
ON state rather than the blinking pattern.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c3ae6f9..5912aec 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -35,7 +35,7 @@ int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption");
 
-int led_blink = 1;
+int led_blink;
 module_param_named(blink, led_blink, int, 0444);
 MODULE_PARM_DESC(blink, "Enable LED blink on activity");
 
-- 
1.6.3.3


