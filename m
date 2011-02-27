Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36635 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab1B0Nyz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 08:54:55 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: do not set blink_set for kernel <= 2.6.24
Date: Sun, 27 Feb 2011 14:54:45 +0100
Message-Id: <1298814885-11894-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1298814885-11894-1-git-send-email-hauke@hauke-m.de>
References: <1298814885-11894-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

blink_set is not available on struct led_classdev in kernel <= 2.6.24.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/39-remove_blink_set.patch |   56 +++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)
 create mode 100644 patches/39-remove_blink_set.patch

diff --git a/patches/39-remove_blink_set.patch b/patches/39-remove_blink_set.patch
new file mode 100644
index 0000000..d8afee3
--- /dev/null
+++ b/patches/39-remove_blink_set.patch
@@ -0,0 +1,56 @@
+--- a/drivers/net/wireless/iwlegacy/iwl-led.c
++++ b/drivers/net/wireless/iwlegacy/iwl-led.c
+@@ -128,6 +128,7 @@ static void iwl_legacy_led_brightness_se
+ 	iwl_legacy_led_cmd(priv, on, 0);
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25))
+ static int iwl_legacy_led_blink_set(struct led_classdev *led_cdev,
+ 			     unsigned long *delay_on,
+ 			     unsigned long *delay_off)
+@@ -136,6 +137,7 @@ static int iwl_legacy_led_blink_set(stru
+ 
+ 	return iwl_legacy_led_cmd(priv, *delay_on, *delay_off);
+ }
++#endif
+ 
+ void iwl_legacy_leds_init(struct iwl_priv *priv)
+ {
+@@ -148,7 +150,9 @@ void iwl_legacy_leds_init(struct iwl_pri
+ 	priv->led.name = kasprintf(GFP_KERNEL, "%s-led",
+ 				   wiphy_name(priv->hw->wiphy));
+ 	priv->led.brightness_set = iwl_legacy_led_brightness_set;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25))
+ 	priv->led.blink_set = iwl_legacy_led_blink_set;
++#endif
+ #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30)
+ 	priv->led.max_brightness = 1;
+ #endif
+--- a/drivers/net/wireless/iwlwifi/iwl-led.c
++++ b/drivers/net/wireless/iwlwifi/iwl-led.c
+@@ -128,6 +128,7 @@ static void iwl_led_brightness_set(struc
+ 	iwl_led_cmd(priv, on, 0);
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25))
+ static int iwl_led_blink_set(struct led_classdev *led_cdev,
+ 			     unsigned long *delay_on,
+ 			     unsigned long *delay_off)
+@@ -136,6 +137,7 @@ static int iwl_led_blink_set(struct led_
+ 
+ 	return iwl_led_cmd(priv, *delay_on, *delay_off);
+ }
++#endif
+ 
+ void iwl_leds_init(struct iwl_priv *priv)
+ {
+@@ -148,7 +150,9 @@ void iwl_leds_init(struct iwl_priv *priv
+ 	priv->led.name = kasprintf(GFP_KERNEL, "%s-led",
+ 				   wiphy_name(priv->hw->wiphy));
+ 	priv->led.brightness_set = iwl_led_brightness_set;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25))
+ 	priv->led.blink_set = iwl_led_blink_set;
++#endif
+ #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30)
+ 	priv->led.max_brightness = 1;
+ #endif
-- 
1.7.1

