Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57458 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637Ab1AaWHP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 17:07:15 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: remove max_brightness
Date: Mon, 31 Jan 2011 23:06:44 +0100
Message-Id: <1296511604-16921-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1296511604-16921-1-git-send-email-hauke@hauke-m.de>
References: <1296511604-16921-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/37-led-max-brightness.patch |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)
 create mode 100644 patches/37-led-max-brightness.patch

diff --git a/patches/37-led-max-brightness.patch b/patches/37-led-max-brightness.patch
new file mode 100644
index 0000000..ef684b5
--- /dev/null
+++ b/patches/37-led-max-brightness.patch
@@ -0,0 +1,12 @@
+--- a/drivers/net/wireless/iwlwifi/iwl-led.c
++++ b/drivers/net/wireless/iwlwifi/iwl-led.c
+@@ -149,7 +149,9 @@ void iwl_leds_init(struct iwl_priv *priv
+ 				   wiphy_name(priv->hw->wiphy));
+ 	priv->led.brightness_set = iwl_led_brightness_set;
+ 	priv->led.blink_set = iwl_led_blink_set;
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30)
+ 	priv->led.max_brightness = 1;
++#endif
+ 
+ 	switch (mode) {
+ 	case IWL_LED_DEFAULT:
-- 
1.7.1

