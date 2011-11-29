Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49858 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab1K2Vv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 16:51:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/3] compat-wireless: fix patches/38-led-max-brightness.patch
Date: Tue, 29 Nov 2011 16:45:19 -0500
Message-Id: <1322603120-11263-2-git-send-email-linville@tuxdriver.com> (sfid-20111129_225132_668298_722463A8)
In-Reply-To: <1322603120-11263-1-git-send-email-linville@tuxdriver.com>
References: <1322603120-11263-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

More fall-out from the refactoring of iwlegacy...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 patches/38-led-max-brightness.patch |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/patches/38-led-max-brightness.patch b/patches/38-led-max-brightness.patch
index 64ecc9c..c34d979 100644
--- a/patches/38-led-max-brightness.patch
+++ b/patches/38-led-max-brightness.patch
@@ -1,18 +1,18 @@
---- a/drivers/net/wireless/iwlegacy/iwl-led.c
-+++ b/drivers/net/wireless/iwlegacy/iwl-led.c
-@@ -166,7 +166,9 @@ void iwl_legacy_leds_init(struct iwl_pri
- 				   wiphy_name(priv->hw->wiphy));
- 	priv->led.brightness_set = iwl_legacy_led_brightness_set;
- 	priv->led.blink_set = iwl_legacy_led_blink_set;
+--- a/drivers/net/wireless/iwlegacy/common.c
++++ b/drivers/net/wireless/iwlegacy/common.c
+@@ -402,7 +402,9 @@ il_leds_init(struct il_priv *il)
+ 	    kasprintf(GFP_KERNEL, "%s-led", wiphy_name(il->hw->wiphy));
+ 	il->led.brightness_set = il_led_brightness_set;
+ 	il->led.blink_set = il_led_blink_set;
 +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30)
- 	priv->led.max_brightness = 1;
+ 	il->led.max_brightness = 1;
 +#endif
  
  	switch (mode) {
- 	case IWL_LED_DEFAULT:
+ 	case IL_LED_DEFAULT:
 --- a/drivers/net/wireless/iwlwifi/iwl-led.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-led.c
-@@ -184,7 +184,9 @@ void iwl_leds_init(struct iwl_priv *priv
+@@ -184,7 +184,9 @@ void iwl_leds_init(struct iwl_priv *priv)
  				   wiphy_name(priv->hw->wiphy));
  	priv->led.brightness_set = iwl_led_brightness_set;
  	priv->led.blink_set = iwl_led_blink_set;
-- 
1.7.4.4

