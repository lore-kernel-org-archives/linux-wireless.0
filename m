Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:63125 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752519AbZL3Kgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2009 05:36:52 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Wireless list <linux-wireless@vger.kernel.org>,
	rt2x00 users list <users@rt2x00.serialmonkey.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 5/6] rt2x00: Fix LED configuration setting for rt2800.
Date: Wed, 30 Dec 2009 11:36:33 +0100
Message-Id: <1262169394-11647-6-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1262169394-11647-5-git-send-email-gwingerde@gmail.com>
References: <1262169394-11647-1-git-send-email-gwingerde@gmail.com>
 <1262169394-11647-2-git-send-email-gwingerde@gmail.com>
 <1262169394-11647-3-git-send-email-gwingerde@gmail.com>
 <1262169394-11647-4-git-send-email-gwingerde@gmail.com>
 <1262169394-11647-5-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2800_blink_set uses an illegal value to set the LED_CFG_G_LED_MODE
field of the LED_CFG register. This field is only 2 bits large, so
should be initialized with value that fits. Use default value from
the vendor driver.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 9a02589..ca700a4 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -358,7 +358,7 @@ static int rt2800_blink_set(struct led_classdev *led_cdev,
 	rt2x00_set_field32(&reg, LED_CFG_OFF_PERIOD, *delay_off);
 	rt2x00_set_field32(&reg, LED_CFG_SLOW_BLINK_PERIOD, 3);
 	rt2x00_set_field32(&reg, LED_CFG_R_LED_MODE, 3);
-	rt2x00_set_field32(&reg, LED_CFG_G_LED_MODE, 12);
+	rt2x00_set_field32(&reg, LED_CFG_G_LED_MODE, 3);
 	rt2x00_set_field32(&reg, LED_CFG_Y_LED_MODE, 3);
 	rt2x00_set_field32(&reg, LED_CFG_LED_POLAR, 1);
 	rt2800_register_write(led->rt2x00dev, LED_CFG, reg);
-- 
1.6.6

