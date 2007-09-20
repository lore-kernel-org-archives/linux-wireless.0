Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:34387
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbXITUQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 16:16:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Support for turning the radio off from software.
Date: Thu, 20 Sep 2007 22:14:18 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709202214.18759.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for turning the radio off in software.
That's useful in environments, where you don't want the RF
to radiate any signals, but don't want to bring the interface down.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <larry.finger@lwfinger.net>

Index: wireless-dev/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43/b43.h	2007-09-20 19:39:06.000000000 +0200
+++ wireless-dev/drivers/net/wireless/b43/b43.h	2007-09-20 21:11:02.000000000 +0200
@@ -459,7 +459,6 @@ struct b43_phy {
 	u16 radio_ver;		/* Radio version */
 	u8 radio_rev;		/* Radio revision */
 
-	bool radio_on;		/* Radio switched on/off */
 	bool locked;		/* Only used in b43_phy_{un}lock() */
 	bool dyn_tssi_tbl;	/* tssi2dbm is kmalloc()ed. */
 
@@ -468,6 +467,16 @@ struct b43_phy {
 	bool aci_wlan_automatic;
 	bool aci_hw_rssi;
 
+	/* Radio switched on/off */
+	bool radio_on;
+	struct {
+		/* Values saved when turning the radio off.
+		 * They are needed when turning it on again. */
+		bool valid;
+		u16 rfover;
+		u16 rfoverval;
+	} radio_off_context;
+
 	u16 minlowsig[2];
 	u16 minlowsigpos[2];
 
Index: wireless-dev/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-09-20 20:06:24.000000000 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-09-20 21:30:40.000000000 +0200
@@ -2874,6 +2874,21 @@ static int b43_dev_config(struct ieee802
 	if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP))
 		b43_set_beacon_int(dev, conf->beacon_int);
 
+	if (!!conf->radio_enabled != phy->radio_on) {
+		if (conf->radio_enabled) {
+			b43_radio_turn_on(dev);
+			b43info(dev->wl, "Radio turned on by software\n");
+			if (!dev->radio_hw_enable) {
+				b43info(dev->wl, "The hardware RF-kill button "
+					"still turns the radio physically off. "
+					"Press the button to turn it on.\n");
+			}
+		} else {
+			b43_radio_turn_off(dev);
+			b43info(dev->wl, "Radio turned off by software\n");
+		}
+	}
+
 	spin_lock_irqsave(&wl->irq_lock, flags);
 	b43_interrupt_enable(dev, savedirqs);
 	mmiowb();
@@ -3217,6 +3232,8 @@ static void setup_struct_phy_for_init(st
 	phy->aci_wlan_automatic = 0;
 	phy->aci_hw_rssi = 0;
 
+	phy->radio_off_context.valid = 0;
+
 	lo = phy->lo_control;
 	if (lo) {
 		memset(lo, 0, sizeof(*(phy->lo_control)));
Index: wireless-dev/drivers/net/wireless/b43/phy.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43/phy.c	2007-09-20 19:28:43.000000000 +0200
+++ wireless-dev/drivers/net/wireless/b43/phy.c	2007-09-20 21:16:19.000000000 +0200
@@ -1205,10 +1205,7 @@ static void b43_phy_initb2(struct b43_wl
 		val -= 0x0202;
 	}
 	b43_phy_write(dev, 0x03E4, 0x3000);
-	if (phy->channel == 0xFF)
-		b43_radio_selectchannel(dev, B43_DEFAULT_CHANNEL_BG, 0);
-	else
-		b43_radio_selectchannel(dev, phy->channel, 0);
+	b43_radio_selectchannel(dev, phy->channel, 0);
 	if (phy->radio_ver != 0x2050) {
 		b43_radio_write16(dev, 0x0075, 0x0080);
 		b43_radio_write16(dev, 0x0079, 0x0081);
@@ -1256,10 +1253,7 @@ static void b43_phy_initb4(struct b43_wl
 		val -= 0x0202;
 	}
 	b43_phy_write(dev, 0x03E4, 0x3000);
-	if (phy->channel == 0xFF)
-		b43_radio_selectchannel(dev, B43_DEFAULT_CHANNEL_BG, 0);
-	else
-		b43_radio_selectchannel(dev, phy->channel, 0);
+	b43_radio_selectchannel(dev, phy->channel, 0);
 	if (phy->radio_ver != 0x2050) {
 		b43_radio_write16(dev, 0x0075, 0x0080);
 		b43_radio_write16(dev, 0x0079, 0x0081);
@@ -4110,6 +4104,20 @@ int b43_radio_selectchannel(struct b43_w
 	u16 freq;
 	u16 channelcookie;
 
+	if (channel == 0xFF) {
+		switch (phy->type) {
+		case B43_PHYTYPE_A:
+			channel = B43_DEFAULT_CHANNEL_A;
+			break;
+		case B43_PHYTYPE_B:
+		case B43_PHYTYPE_G:
+			channel = B43_DEFAULT_CHANNEL_BG;
+			break;
+		default:
+			B43_WARN_ON(1);
+		}
+	}
+
 	/* First we set the channel radio code to prevent the
 	 * firmware from sending ghost packets.
 	 */
@@ -4302,6 +4310,7 @@ void b43_radio_turn_on(struct b43_wldev 
 {
 	struct b43_phy *phy = &dev->phy;
 	int err;
+	u8 channel;
 
 	might_sleep();
 
@@ -4321,14 +4330,23 @@ void b43_radio_turn_on(struct b43_wldev 
 		b43_phy_write(dev, 0x0015, 0x8000);
 		b43_phy_write(dev, 0x0015, 0xCC00);
 		b43_phy_write(dev, 0x0015, (phy->gmode ? 0x00C0 : 0x0000));
+		if (phy->radio_off_context.valid) {
+			/* Restore the RFover values. */
+			b43_phy_write(dev, B43_PHY_RFOVER,
+				      phy->radio_off_context.rfover);
+			b43_phy_write(dev, B43_PHY_RFOVERVAL,
+				      phy->radio_off_context.rfoverval);
+			phy->radio_off_context.valid = 0;
+		}
+		channel = phy->channel;
 		err = b43_radio_selectchannel(dev, B43_DEFAULT_CHANNEL_BG, 1);
+		err |= b43_radio_selectchannel(dev, channel, 0);
 		B43_WARN_ON(err);
 		break;
 	default:
 		B43_WARN_ON(1);
 	}
 	phy->radio_on = 1;
-	b43dbg(dev->wl, "Radio turned on\n");
 }
 
 void b43_radio_turn_off(struct b43_wldev *dev)
@@ -4342,10 +4360,16 @@ void b43_radio_turn_off(struct b43_wldev
 		b43_phy_write(dev, 0x0011, b43_phy_read(dev, 0x0011) | 0x0008);
 	}
 	if (phy->type == B43_PHYTYPE_G && dev->dev->id.revision >= 5) {
-		b43_phy_write(dev, 0x0811, b43_phy_read(dev, 0x0811) | 0x008C);
-		b43_phy_write(dev, 0x0812, b43_phy_read(dev, 0x0812) & 0xFF73);
+		u16 rfover, rfoverval;
+
+		rfover = b43_phy_read(dev, B43_PHY_RFOVER);
+		rfoverval = b43_phy_read(dev, B43_PHY_RFOVERVAL);
+		phy->radio_off_context.rfover = rfover;
+		phy->radio_off_context.rfoverval = rfoverval;
+		phy->radio_off_context.valid = 1;
+		b43_phy_write(dev, B43_PHY_RFOVER, rfover | 0x008C);
+		b43_phy_write(dev, B43_PHY_RFOVERVAL, rfoverval & 0xFF73);
 	} else
 		b43_phy_write(dev, 0x0015, 0xAA00);
 	phy->radio_on = 0;
-	b43dbg(dev->wl, "Radio turned off\n");
 }
