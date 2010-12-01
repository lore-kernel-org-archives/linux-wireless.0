Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44136 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab0LAPDo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 10:03:44 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: fix build for kernel <= 2.6.29
Date: Wed,  1 Dec 2010 16:03:30 +0100
Message-Id: <1291215810-1140-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1291215810-1140-1-git-send-email-hauke@hauke-m.de>
References: <1291215810-1140-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The max_brightness member in struct led_classdev was added in kernel
2.6.30, so use LED_FULL for older kernel versions.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.37.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.37.c b/compat/compat-2.6.37.c
index a522b4e..8636c65 100644
--- a/compat/compat-2.6.37.c
+++ b/compat/compat-2.6.37.c
@@ -281,7 +281,11 @@ void led_blink_set(struct led_classdev *led_cdev,
 	if (current_brightness)
 		led->blink_brightness = current_brightness;
 	if (!led->blink_brightness)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30)
 		led->blink_brightness = led_cdev->max_brightness;
+#else
+		led->blink_brightness = LED_FULL;
+#endif
 
 	led_stop_software_blink(led);
 	led->blink_delay_on = *delay_on;
-- 
1.7.1

