Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49566 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab0K1MRD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Nov 2010 07:17:03 -0500
Subject: [PATCH] compat: use LED blinking HW offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
In-Reply-To: <1290945916-95814-1-git-send-email-nbd@openwrt.org>
References: <1290945916-95814-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Nov 2010 13:17:00 +0100
Message-ID: <1290946620.3467.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Felix's patch backported my software blink emulation,
but if the kernel is 2.6.25 or newer we can also try
the HW offload first.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 compat/compat-2.6.37.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- compat.orig/compat/compat-2.6.37.c	2010-11-28 13:05:01.000000000 +0100
+++ compat/compat/compat-2.6.37.c	2010-11-28 13:05:56.000000000 +0100
@@ -253,9 +253,16 @@ void led_blink_set(struct led_classdev *
 		   unsigned long *delay_on,
 		   unsigned long *delay_off)
 {
-	struct led_timer *led = led_get_timer(led_cdev);
+	struct led_timer *led;
 	int current_brightness;
 
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25))
+	if (led_cdev->blink_set &&
+	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
+		return;
+#endif
+
+	led = led_get_timer(led_cdev);
 	if (!led) {
 		led = led_new_timer(led_cdev);
 		if (!led)


