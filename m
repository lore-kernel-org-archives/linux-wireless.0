Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [12.19.149.2] ([12.19.149.2]:29266 "EHLO mail.atheros.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab0HYOR0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 10:17:26 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 25 Aug 2010 07:17:22 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Aeolus.Yang@Atheros.com>,
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: [PATCH 2/2] ath9k: Change the default LED pattern.
Date: Wed, 25 Aug 2010 19:42:00 +0530
Message-ID: <1282745520-21156-2-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1282745520-21156-1-git-send-email-vnatarajan@atheros.com>
References: <1282745520-21156-1-git-send-email-vnatarajan@atheros.com>
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

