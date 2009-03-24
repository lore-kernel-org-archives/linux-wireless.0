Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:58555 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbZCXPWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 11:22:00 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] ar9170: single module build
Date: Tue, 24 Mar 2009 16:21:55 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
References: <200903212311.49348.chunkeey@web.de> <200903240126.12692.chunkeey@web.de> <1237880461.6147.24.camel@johannes.local>
In-Reply-To: <1237880461.6147.24.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200903241621.56084.chunkeey@web.de> (sfid-20090324_162206_521868_D35224B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch restores all-in-one module build procedure for ar9170.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
On Tuesday 24 March 2009 08:41:01 Johannes Berg wrote:
> > And the ath5k<->ath9k merge could provide some "helper" function for this
> > driver as well... (wishful thinking, but anyway...)
> 
> _Very_ wishful thinking -- only very small parts of the design are
> really shared, the PHY stuff, which happens to be relevant to the
> eeprom.
small? regd.c, eeprom.c, ani.c, calib.c, phy.c (including some register
definitions) and code for LED/Bluetooth Coex?/Rfkill?

that's nearly a third of ath9k. However: Agreed!
Lets wait and see what Atheros' is doing/planing.

> > Meanwhile, what about a config option that can be enabled to
> > integrate everything into the front-end module (ar9170usb)?
> > ( However, I don't think this config solution will stand a chance ;-) 
> >   and we all come to the same "all-in-one works best" conclusion.  )
> This seems like a pointless option. Why not just change the Kconfig file
> to remove the common option and link both files into one binary,
> removing all EXPORT_SYMBOLs?
Done!
---
On Tuesday 24 March 2009 00:35:22 Luis R. Rodriguez wrote:
> The MACs are completely different so if there is some code sharing possible
> it may be difficult to find but it would certainly be welcomed!
MAC with its firmware is a zd12xx derivate, true... 
the PHY chips are AR9101/AR9102/AR9104, right?

>Future Atheros 11n USB devices will use a different MAC and therefore expect
>them to be different. I am not sure if in the future we can share but
>I won't know for sure for a little while.
That's really good to hear!
---
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 5e7c9ac..50e7fba 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -57,6 +57,6 @@ obj-$(CONFIG_P54_COMMON)	+= p54/
 
 obj-$(CONFIG_ATH5K)	+= ath5k/
 obj-$(CONFIG_ATH9K)	+= ath9k/
-obj-$(CONFIG_AR9170_COMMON)	+= ar9170/
+obj-$(CONFIG_AR9170_USB)	+= ar9170/
 
 obj-$(CONFIG_MAC80211_HWSIM)	+= mac80211_hwsim.o
diff --git a/drivers/net/wireless/ar9170/Kconfig b/drivers/net/wireless/ar9170/Kconfig
index f661187..de4281f 100644
--- a/drivers/net/wireless/ar9170/Kconfig
+++ b/drivers/net/wireless/ar9170/Kconfig
@@ -1,17 +1,6 @@
-config AR9170_COMMON
-	tristate "Atheros AR9170 support"
-	depends on WLAN_80211 && MAC80211 && EXPERIMENTAL
-	help
-	  This is common code for AR9170 based devices.
-	  This module does nothing by itself - the USB/(SPI) frontends
-	  also need to be enabled in order to support any devices.
-
-	  Say Y if you have the hardware, or M to build a module called
-	  ar9170common.
-
 config AR9170_USB
-	tristate "Atheros AR9170 USB support"
-	depends on AR9170_COMMON && USB
+	tristate "Atheros AR9170 802.11n USB support"
+	depends on USB && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	select FW_LOADER
 	help
 	  This is a driver for the Atheros "otus" 802.11n USB devices.
@@ -24,5 +13,5 @@ config AR9170_USB
 
 config AR9170_LEDS
 	bool
-	depends on AR9170_COMMON && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = AR9170_COMMON)
+	depends on AR9170_USB && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = AR9170_USB)
 	default y
diff --git a/drivers/net/wireless/ar9170/Makefile b/drivers/net/wireless/ar9170/Makefile
index 59b174d..8d91c7e 100644
--- a/drivers/net/wireless/ar9170/Makefile
+++ b/drivers/net/wireless/ar9170/Makefile
@@ -1,5 +1,3 @@
-ar9170common-objs += main.o cmd.o mac.o phy.o led.o
-ar9170usb-objs += usb.o
+ar9170usb-objs := usb.o main.o cmd.o mac.o phy.o led.o
 
-obj-$(CONFIG_AR9170_COMMON) += ar9170common.o
 obj-$(CONFIG_AR9170_USB) += ar9170usb.o
diff --git a/drivers/net/wireless/ar9170/cmd.c b/drivers/net/wireless/ar9170/cmd.c
index fd5625c..f57a620 100644
--- a/drivers/net/wireless/ar9170/cmd.c
+++ b/drivers/net/wireless/ar9170/cmd.c
@@ -127,4 +127,3 @@ int ar9170_echo_test(struct ar9170 *ar, u32 v)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(ar9170_echo_test);
diff --git a/drivers/net/wireless/ar9170/main.c b/drivers/net/wireless/ar9170/main.c
index f8c2357..5996ff9 100644
--- a/drivers/net/wireless/ar9170/main.c
+++ b/drivers/net/wireless/ar9170/main.c
@@ -37,14 +37,6 @@
  *    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-/*
- * BIG FAT TODO:
- *
- * By the looks of things: these devices share a lot of things like
- * EEPROM layout/design and PHY code with other Atheros WIFI products.
- * So this driver/library will eventually become ath9k code... or vice versa ;-)
- */
-
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/etherdevice.h>
@@ -56,9 +48,6 @@
 static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
-MODULE_AUTHOR("Johannes Berg <johannes@sipsolutions.net>");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Atheros shared code for AR9170 wireless devices");
 
 #define RATE(_bitrate, _hw_rate, _txpidx, _flags) {	\
 	.bitrate	= (_bitrate),			\
@@ -247,7 +236,6 @@ void ar9170_handle_tx_status(struct ar9170 *ar, struct sk_buff *skb,
 	skb_pull(skb, sizeof(struct ar9170_tx_control));
 	ieee80211_tx_status_irqsafe(ar->hw, skb);
 }
-EXPORT_SYMBOL_GPL(ar9170_handle_tx_status);
 
 static struct sk_buff *ar9170_find_skb_in_queue(struct ar9170 *ar,
 						const u8 *mac,
@@ -630,13 +618,6 @@ static void ar9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 	ieee80211_rx_irqsafe(ar->hw, skb, &status);
 }
 
-/*
- * TODO:
- * It looks like AR9170 supports more than just the USB transport interface.
- * Unfortunately, there is no available information what parts of the
- * precendent and following code fragments is device specific and what not.
- * For now, everything stays here, until some SPI chips pop up.
- */
 void ar9170_rx(struct ar9170 *ar, struct sk_buff *skb)
 {
 	unsigned int i, tlen, resplen;
@@ -694,7 +675,6 @@ void ar9170_rx(struct ar9170 *ar, struct sk_buff *skb)
 		printk(KERN_ERR "%s: buffer remains!\n",
 		       wiphy_name(ar->hw->wiphy));
 }
-EXPORT_SYMBOL_GPL(ar9170_rx);
 
 #define AR9170_FILL_QUEUE(queue, ai_fs, cwmin, cwmax, _txop)		\
 do {									\
@@ -1582,7 +1562,6 @@ void *ar9170_alloc(size_t priv_size)
 
 	return ar;
 }
-EXPORT_SYMBOL_GPL(ar9170_alloc);
 
 static int ar9170_read_eeprom(struct ar9170 *ar)
 {
@@ -1680,7 +1659,6 @@ err_unreg:
 err_out:
 	return err;
 }
-EXPORT_SYMBOL_GPL(ar9170_register);
 
 void ar9170_unregister(struct ar9170 *ar)
 {
@@ -1691,21 +1669,3 @@ void ar9170_unregister(struct ar9170 *ar)
 	ieee80211_unregister_hw(ar->hw);
 	mutex_destroy(&ar->mutex);
 }
-EXPORT_SYMBOL_GPL(ar9170_unregister);
-
-static int __init ar9170_init(void)
-{
-	if (modparam_nohwcrypt)
-		printk(KERN_INFO "ar9170: cryptographic acceleration "
-				 "disabled.\n");
-
-	return 0;
-}
-
-static void __exit ar9170_exit(void)
-{
-
-}
-
-module_init(ar9170_init);
-module_exit(ar9170_exit);
diff --git a/drivers/net/wireless/ar9170/usb.c b/drivers/net/wireless/ar9170/usb.c
index ede511e..ad29684 100644
--- a/drivers/net/wireless/ar9170/usb.c
+++ b/drivers/net/wireless/ar9170/usb.c
@@ -47,9 +47,10 @@
 #include "hw.h"
 #include "usb.h"
 
+MODULE_AUTHOR("Johannes Berg <johannes@sipsolutions.net>");
 MODULE_AUTHOR("Christian Lamparter <chunkeey@web.de>");
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("USB Driver for Atheros AR9170 based devices");
+MODULE_DESCRIPTION("Atheros AR9170 802.11n USB wireless");
 MODULE_FIRMWARE("ar9170-1.fw");
 MODULE_FIRMWARE("ar9170-2.fw");
 
