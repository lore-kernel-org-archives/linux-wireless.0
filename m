Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:46622 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730AbXIJPxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 11:53:13 -0400
Date: Mon, 10 Sep 2007 10:52:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Fix most of the sparse warnings
Message-ID: <46e56847.e8NGY1BRpVwK0qe+%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix most of the sparse warnings in b43legacy. Several are generated
in phy.c that cannot easily be fixed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-dev/drivers/net/wireless/b43legacy/leds.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/leds.c
+++ wireless-dev/drivers/net/wireless/b43legacy/leds.c
@@ -33,14 +33,13 @@
 static void b43legacy_led_changestate(struct b43legacy_led *led)
 {
 	struct b43legacy_wldev *dev = led->dev;
-	const int index = b43legacy_led_index(led);
-	const u16 mask = (1 << index);
+	const int index = led->index;
 	u16 ledctl;
 
 	B43legacy_WARN_ON(!(index >= 0 && index < B43legacy_NR_LEDS));
 	B43legacy_WARN_ON(!led->blink_interval);
 	ledctl = b43legacy_read16(dev, B43legacy_MMIO_GPIO_CONTROL);
-	ledctl = (ledctl & mask) ? (ledctl & ~mask) : (ledctl | mask);
+	ledctl ^= (1 << index);
 	b43legacy_write16(dev, B43legacy_MMIO_GPIO_CONTROL, ledctl);
 }
 
@@ -72,7 +71,7 @@ static void b43legacy_led_blink_start(st
 static void b43legacy_led_blink_stop(struct b43legacy_led *led, int sync)
 {
 	struct b43legacy_wldev *dev = led->dev;
-	const int index = b43legacy_led_index(led);
+	const int index = led->index;
 	u16 ledctl;
 
 	if (!led->blink_interval)
@@ -142,6 +141,7 @@ int b43legacy_leds_init(struct b43legacy
 
 	for (i = 0; i < B43legacy_NR_LEDS; i++) {
 		led = &(dev->leds[i]);
+		led->index = i;
 		led->dev = dev;
 		setup_timer(&led->blink_timer,
 			    b43legacy_led_blink,
Index: wireless-dev/drivers/net/wireless/b43legacy/leds.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/leds.h
+++ wireless-dev/drivers/net/wireless/b43legacy/leds.h
@@ -6,14 +6,14 @@
 
 
 struct b43legacy_led {
-	u8 behaviour:7;
-	u8 activelow:1;
-
+	u8 behaviour;
+	bool activelow;
+	/* Index in the "leds" array in b43legacy_wldev */
+	u8 index;
 	struct b43legacy_wldev *dev;
 	struct timer_list blink_timer;
 	unsigned long blink_interval;
 };
-#define b43legacy_led_index(led)	((int)((led) - (led)->dev->leds))
 
 /* Delay between state changes when blinking in jiffies */
 #define B43legacy_LEDBLINK_SLOW		(HZ / 1)
Index: wireless-dev/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-dev/drivers/net/wireless/b43legacy/main.c
@@ -848,7 +848,7 @@ static void handle_irq_noise(struct b43l
 	B43legacy_WARN_ON(!dev->noisecalc.calculation_running);
 	if (dev->noisecalc.channel_at_start != phy->channel)
 		goto drop_calculation;
-	*((u32 *)noise) = cpu_to_le32(b43legacy_jssi_read(dev));
+	*((__le32 *)noise) = cpu_to_le32(b43legacy_jssi_read(dev));
 	if (noise[0] == 0x7F || noise[1] == 0x7F ||
 	    noise[2] == 0x7F || noise[3] == 0x7F)
 		goto generate_new;
@@ -1434,8 +1434,7 @@ static int do_request_fw(struct b43legac
 			 const char *name,
 			 const struct firmware **fw)
 {
-	const size_t plen = sizeof(modparam_fwpostfix) + 32;
-	char path[plen];
+	char path[sizeof(modparam_fwpostfix) + 32];
 	struct b43legacy_fw_header *hdr;
 	u32 size;
 	int err;
Index: wireless-dev/drivers/net/wireless/b43legacy/xmit.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/xmit.c
+++ wireless-dev/drivers/net/wireless/b43legacy/xmit.c
@@ -125,10 +125,12 @@ void b43legacy_generate_plcp_hdr(struct 
 	__u8 *raw = plcp->raw;
 
 	if (b43legacy_is_ofdm_rate(bitrate)) {
-		*data = b43legacy_plcp_get_ratecode_ofdm(bitrate);
+		u16 d;
+
+		d = b43legacy_plcp_get_ratecode_ofdm(bitrate);
 		B43legacy_WARN_ON(octets & 0xF000);
-		*data |= (octets << 5);
-		*data = cpu_to_le32(*data);
+		d |= (octets << 5);
+		*data = cpu_to_le32(d);
 	} else {
 		u32 plen;
 
@@ -442,7 +444,7 @@ void b43legacy_rx(struct b43legacy_wldev
 	phystat0 = le16_to_cpu(rxhdr->phy_status0);
 	phystat3 = le16_to_cpu(rxhdr->phy_status3);
 	jssi = rxhdr->jssi;
-	macstat = le32_to_cpu(rxhdr->mac_status);
+	macstat = le16_to_cpu(rxhdr->mac_status);
 	mactime = le16_to_cpu(rxhdr->mac_time);
 	chanstat = le16_to_cpu(rxhdr->channel);
 

