Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36226 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbXIUCKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 22:10:51 -0400
Date: Thu, 20 Sep 2007 21:11:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Support for turning the radio off from  software.
Message-ID: <46f32836.SaYVr1nG4+WJSJ9K%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for turning the radio off in software.
That's useful in environments, where you don't want the RF
to radiate any signals, but don't want to bring the interface down.

This patch is based on a similar patch of b43 by Michael Buesch.

Signed-off-by: Larry Finger <larry.finger@lwfinger.net>

 drivers/net/wireless/b43legacy/b43legacy.h |   11 +++++++-
 drivers/net/wireless/b43legacy/main.c      |   16 +++++++++++
 drivers/net/wireless/b43legacy/phy.c       |   14 +---------
 drivers/net/wireless/b43legacy/radio.c     |   39 ++++++++++++++++++++++++-----
 4 files changed, 61 insertions(+), 19 deletions(-)

Index: wireless-dev/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ wireless-dev/drivers/net/wireless/b43legacy/b43legacy.h
@@ -411,7 +411,6 @@ struct b43legacy_phy {
 	u8 calibrated:1;
 	u8 radio_rev;		/* Radio revision */
 
-	bool radio_on;		/* Radio switched on/off */
 	bool locked;		/* Only used in b43legacy_phy_{un}lock() */
 	bool dyn_tssi_tbl;	/* tssi2dbm is kmalloc()ed. */
 
@@ -420,6 +419,16 @@ struct b43legacy_phy {
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
 
Index: wireless-dev/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-dev/drivers/net/wireless/b43legacy/main.c
@@ -2672,6 +2672,22 @@ static int b43legacy_dev_config(struct i
 		b43legacy_set_beacon_int(dev, conf->beacon_int);
 
 
+	if (!!conf->radio_enabled != phy->radio_on) {
+		if (conf->radio_enabled) {
+			b43legacy_radio_turn_on(dev);
+			b43legacyinfo(dev->wl, "Radio turned on by software\n");
+			if (!dev->radio_hw_enable)
+				b43legacyinfo(dev->wl, "The hardware RF-kill"
+					      " button still turns the radio"
+					      " physically off. Press the"
+					      " button to turn it on.\n");
+		} else {
+			b43legacy_radio_turn_off(dev);
+			b43legacyinfo(dev->wl, "Radio turned off by"
+				      " software\n");
+		}
+	}
+
 	spin_lock_irqsave(&wl->irq_lock, flags);
 	b43legacy_interrupt_enable(dev, savedirqs);
 	mmiowb();
Index: wireless-dev/drivers/net/wireless/b43legacy/phy.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/phy.c
+++ wireless-dev/drivers/net/wireless/b43legacy/phy.c
@@ -462,12 +462,7 @@ static void b43legacy_phy_initb2(struct 
 		val -= 0x0202;
 	}
 	b43legacy_phy_write(dev, 0x03E4, 0x3000);
-	if (phy->channel == 0xFF)
-		b43legacy_radio_selectchannel(dev,
-					B43legacy_RADIO_DEFAULT_CHANNEL_BG,
-					0);
-	else
-		b43legacy_radio_selectchannel(dev, phy->channel, 0);
+	b43legacy_radio_selectchannel(dev, phy->channel, 0);
 	if (phy->radio_ver != 0x2050) {
 		b43legacy_radio_write16(dev, 0x0075, 0x0080);
 		b43legacy_radio_write16(dev, 0x0079, 0x0081);
@@ -516,12 +511,7 @@ static void b43legacy_phy_initb4(struct 
 		val -= 0x0202;
 	}
 	b43legacy_phy_write(dev, 0x03E4, 0x3000);
-	if (phy->channel == 0xFF)
-		b43legacy_radio_selectchannel(dev,
-					B43legacy_RADIO_DEFAULT_CHANNEL_BG,
-					0);
-	else
-		b43legacy_radio_selectchannel(dev, phy->channel, 0);
+	b43legacy_radio_selectchannel(dev, phy->channel, 0);
 	if (phy->radio_ver != 0x2050) {
 		b43legacy_radio_write16(dev, 0x0075, 0x0080);
 		b43legacy_radio_write16(dev, 0x0079, 0x0081);
Index: wireless-dev/drivers/net/wireless/b43legacy/radio.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/radio.c
+++ wireless-dev/drivers/net/wireless/b43legacy/radio.c
@@ -1767,6 +1767,17 @@ int b43legacy_radio_selectchannel(struct
 {
 	struct b43legacy_phy *phy = &dev->phy;
 
+	if (channel == 0xFF) {
+		switch (phy->type) {
+		case B43legacy_PHYTYPE_B:
+		case B43legacy_PHYTYPE_G:
+			channel = B43legacy_RADIO_DEFAULT_CHANNEL_BG;
+			break;
+		default:
+			B43legacy_WARN_ON(1);
+		}
+	}
+
 /* TODO: Check if channel is valid - return -EINVAL if not */
 	if (synthetic_pu_workaround)
 		b43legacy_synth_pu_workaround(dev, channel);
@@ -2070,6 +2081,7 @@ void b43legacy_radio_turn_on(struct b43l
 {
 	struct b43legacy_phy *phy = &dev->phy;
 	int err;
+	u8 channel;
 
 	might_sleep();
 
@@ -2083,15 +2095,24 @@ void b43legacy_radio_turn_on(struct b43l
 		b43legacy_phy_write(dev, 0x0015, 0xCC00);
 		b43legacy_phy_write(dev, 0x0015,
 				    (phy->gmode ? 0x00C0 : 0x0000));
+		if (phy->radio_off_context.valid) {
+			/* Restore the RFover values. */
+			b43legacy_phy_write(dev, B43legacy_PHY_RFOVER,
+					    phy->radio_off_context.rfover);
+			b43legacy_phy_write(dev, B43legacy_PHY_RFOVERVAL,
+					    phy->radio_off_context.rfoverval);
+			phy->radio_off_context.valid = 0;
+		}
+		channel = phy->channel;
 		err = b43legacy_radio_selectchannel(dev,
 					B43legacy_RADIO_DEFAULT_CHANNEL_BG, 1);
-		B43legacy_WARN_ON(err != 0);
+		err |= b43legacy_radio_selectchannel(dev, channel, 0);
+		B43legacy_WARN_ON(err);
 		break;
 	default:
 		B43legacy_BUG_ON(1);
 	}
 	phy->radio_on = 1;
-	b43legacydbg(dev->wl, "Radio turned on\n");
 	b43legacy_leds_update(dev, 0);
 }
 
@@ -2100,10 +2121,16 @@ void b43legacy_radio_turn_off(struct b43
 	struct b43legacy_phy *phy = &dev->phy;
 
 	if (phy->type == B43legacy_PHYTYPE_G && dev->dev->id.revision >= 5) {
-		b43legacy_phy_write(dev, 0x0811, b43legacy_phy_read(dev, 0x0811)
-				    | 0x008C);
-		b43legacy_phy_write(dev, 0x0812, b43legacy_phy_read(dev, 0x0812)
-				    & 0xFF73);
+		u16 rfover, rfoverval;
+
+		rfover = b43legacy_phy_read(dev, B43legacy_PHY_RFOVER);
+		rfoverval = b43legacy_phy_read(dev, B43legacy_PHY_RFOVERVAL);
+		phy->radio_off_context.rfover = rfover;
+		phy->radio_off_context.rfoverval = rfoverval;
+		phy->radio_off_context.valid = 1;
+		b43legacy_phy_write(dev, B43legacy_PHY_RFOVER, rfover | 0x008C);
+		b43legacy_phy_write(dev, B43legacy_PHY_RFOVERVAL,
+				    rfoverval & 0xFF73);
 	} else
 		b43legacy_phy_write(dev, 0x0015, 0xAA00);
 	phy->radio_on = 0;
