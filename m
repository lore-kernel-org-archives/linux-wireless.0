Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49859 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1K2Vv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 16:51:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/3] compat-wireless: fix patches/39-remove_blink_set.patch
Date: Tue, 29 Nov 2011 16:45:20 -0500
Message-Id: <1322603120-11263-3-git-send-email-linville@tuxdriver.com> (sfid-20111129_225130_590695_65C3FCEA)
In-Reply-To: <1322603120-11263-1-git-send-email-linville@tuxdriver.com>
References: <1322603120-11263-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

More fall-out from the refactoring of iwlegacy...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 patches/39-remove_blink_set.patch |   40 ++++++++++++++++++------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/patches/39-remove_blink_set.patch b/patches/39-remove_blink_set.patch
index a39b634..54527bd 100644
--- a/patches/39-remove_blink_set.patch
+++ b/patches/39-remove_blink_set.patch
@@ -1,34 +1,34 @@
---- a/drivers/net/wireless/iwlegacy/iwl-led.c
-+++ b/drivers/net/wireless/iwlegacy/iwl-led.c
-@@ -145,6 +145,7 @@ static void iwl_legacy_led_brightness_se
- 	iwl_legacy_led_cmd(priv, on, 0);
+--- a/drivers/net/wireless/iwlegacy/common.c
++++ b/drivers/net/wireless/iwlegacy/common.c
+@@ -380,6 +380,7 @@ il_led_brightness_set(struct led_classdev *led_cdev,
+ 	il_led_cmd(il, on, 0);
  }
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25))
- static int iwl_legacy_led_blink_set(struct led_classdev *led_cdev,
- 			     unsigned long *delay_on,
- 			     unsigned long *delay_off)
-@@ -153,6 +154,7 @@ static int iwl_legacy_led_blink_set(stru
+ static int
+ il_led_blink_set(struct led_classdev *led_cdev, unsigned long *delay_on,
+ 		 unsigned long *delay_off)
+@@ -388,6 +389,7 @@ il_led_blink_set(struct led_classdev *led_cdev, unsigned long *delay_on,
  
- 	return iwl_legacy_led_cmd(priv, *delay_on, *delay_off);
+ 	return il_led_cmd(il, *delay_on, *delay_off);
  }
 +#endif
  
- void iwl_legacy_leds_init(struct iwl_priv *priv)
- {
-@@ -165,7 +167,9 @@ void iwl_legacy_leds_init(struct iwl_pri
- 	priv->led.name = kasprintf(GFP_KERNEL, "%s-led",
- 				   wiphy_name(priv->hw->wiphy));
- 	priv->led.brightness_set = iwl_legacy_led_brightness_set;
+ void
+ il_leds_init(struct il_priv *il)
+@@ -401,7 +403,9 @@ il_leds_init(struct il_priv *il)
+ 	il->led.name =
+ 	    kasprintf(GFP_KERNEL, "%s-led", wiphy_name(il->hw->wiphy));
+ 	il->led.brightness_set = il_led_brightness_set;
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25))
- 	priv->led.blink_set = iwl_legacy_led_blink_set;
+ 	il->led.blink_set = il_led_blink_set;
 +#endif
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30)
- 	priv->led.max_brightness = 1;
+ 	il->led.max_brightness = 1;
  #endif
 --- a/drivers/net/wireless/iwlwifi/iwl-led.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-led.c
-@@ -163,6 +163,7 @@ static void iwl_led_brightness_set(struc
+@@ -163,6 +163,7 @@ static void iwl_led_brightness_set(struct led_classdev *led_cdev,
  	iwl_led_cmd(priv, on, 0);
  }
  
@@ -36,7 +36,7 @@
  static int iwl_led_blink_set(struct led_classdev *led_cdev,
  			     unsigned long *delay_on,
  			     unsigned long *delay_off)
-@@ -171,6 +172,7 @@ static int iwl_led_blink_set(struct led_
+@@ -171,6 +172,7 @@ static int iwl_led_blink_set(struct led_classdev *led_cdev,
  
  	return iwl_led_cmd(priv, *delay_on, *delay_off);
  }
@@ -44,7 +44,7 @@
  
  void iwl_leds_init(struct iwl_priv *priv)
  {
-@@ -183,7 +185,9 @@ void iwl_leds_init(struct iwl_priv *priv
+@@ -183,7 +185,9 @@ void iwl_leds_init(struct iwl_priv *priv)
  	priv->led.name = kasprintf(GFP_KERNEL, "%s-led",
  				   wiphy_name(priv->hw->wiphy));
  	priv->led.brightness_set = iwl_led_brightness_set;
-- 
1.7.4.4

