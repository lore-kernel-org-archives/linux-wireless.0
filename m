Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36630 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab1B0Nyy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 08:54:54 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: change number of patch:
Date: Sun, 27 Feb 2011 14:54:44 +0100
Message-Id: <1298814885-11894-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

37-vsnprintk.patch also uses the number 37, so one of them has to be renamed.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/37-led-max-brightness.patch |   24 ------------------------
 patches/38-led-max-brightness.patch |   24 ++++++++++++++++++++++++
 2 files changed, 24 insertions(+), 24 deletions(-)
 delete mode 100644 patches/37-led-max-brightness.patch
 create mode 100644 patches/38-led-max-brightness.patch

diff --git a/patches/37-led-max-brightness.patch b/patches/37-led-max-brightness.patch
deleted file mode 100644
index ca62ca9..0000000
--- a/patches/37-led-max-brightness.patch
+++ /dev/null
@@ -1,24 +0,0 @@
---- a/drivers/net/wireless/iwlegacy/iwl-led.c
-+++ b/drivers/net/wireless/iwlegacy/iwl-led.c
-@@ -149,7 +149,9 @@ void iwl_legacy_leds_init(struct iwl_pri
- 				   wiphy_name(priv->hw->wiphy));
- 	priv->led.brightness_set = iwl_legacy_led_brightness_set;
- 	priv->led.blink_set = iwl_legacy_led_blink_set;
-+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30)
- 	priv->led.max_brightness = 1;
-+#endif
- 
- 	switch (mode) {
- 	case IWL_LED_DEFAULT:
---- a/drivers/net/wireless/iwlwifi/iwl-led.c
-+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
-@@ -149,7 +149,9 @@ void iwl_leds_init(struct iwl_priv *priv
- 				   wiphy_name(priv->hw->wiphy));
- 	priv->led.brightness_set = iwl_led_brightness_set;
- 	priv->led.blink_set = iwl_led_blink_set;
-+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30)
- 	priv->led.max_brightness = 1;
-+#endif
- 
- 	switch (mode) {
- 	case IWL_LED_DEFAULT:
diff --git a/patches/38-led-max-brightness.patch b/patches/38-led-max-brightness.patch
new file mode 100644
index 0000000..ca62ca9
--- /dev/null
+++ b/patches/38-led-max-brightness.patch
@@ -0,0 +1,24 @@
+--- a/drivers/net/wireless/iwlegacy/iwl-led.c
++++ b/drivers/net/wireless/iwlegacy/iwl-led.c
+@@ -149,7 +149,9 @@ void iwl_legacy_leds_init(struct iwl_pri
+ 				   wiphy_name(priv->hw->wiphy));
+ 	priv->led.brightness_set = iwl_legacy_led_brightness_set;
+ 	priv->led.blink_set = iwl_legacy_led_blink_set;
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30)
+ 	priv->led.max_brightness = 1;
++#endif
+ 
+ 	switch (mode) {
+ 	case IWL_LED_DEFAULT:
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

