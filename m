Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:38520 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbZCYCJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 22:09:06 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: replace MAC80211_LEDS with P54_LEDS in p54.h
Date: Wed, 25 Mar 2009 03:11:44 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903250311.45352.chunkeey@web.de> (sfid-20090325_030911_552644_B36C7B4D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm very sorry, as this change belongs to the other patch:
"[PATCH] p54: fix SoftLED compile dependencies".
however I must have somehow lost "git add" for that file.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 2dda5fe..ecf8b6e 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -14,9 +14,9 @@
  * published by the Free Software Foundation.
  */
 
-#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_P54_LEDS
 #include <linux/leds.h>
-#endif /* CONFIG_MAC80211_LEDS */
+#endif /* CONFIG_P54_LEDS */
 
 enum p54_control_frame_types {
 	P54_CONTROL_TYPE_SETUP = 0,
@@ -116,7 +116,7 @@ enum fw_state {
 	FW_STATE_RESETTING,
 };
 
-#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_P54_LEDS
 
 #define P54_LED_MAX_NAME_LEN 31
 
@@ -129,7 +129,7 @@ struct p54_led_dev {
 	unsigned int registered;
 };
 
-#endif /* CONFIG_MAC80211_LEDS */
+#endif /* CONFIG_P54_LEDS */
 
 struct p54_common {
 	struct ieee80211_hw *hw;
@@ -177,10 +177,10 @@ struct p54_common {
 	u8 privacy_caps;
 	u8 rx_keycache_size;
 	/* LED management */
-	#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_P54_LEDS
 	struct p54_led_dev assoc_led;
 	struct p54_led_dev tx_led;
-	#endif /* CONFIG_MAC80211_LEDS */
+#endif /* CONFIG_P54_LEDS */
 	u16 softled_state;		/* bit field of glowing LEDs */
 };
 
