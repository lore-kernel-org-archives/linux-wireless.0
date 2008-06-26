Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:43537 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbYFZVCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 17:02:30 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "Hin-Tak Leung" <hintak_leung@yahoo.co.uk>
Subject: Re: [RFC][PATCH] Realtek 8187B wireless support with product =?iso-8859-1?q?id=090x8197/0x8189?=
Date: Thu, 26 Jun 2008 17:40:09 -0300
Cc: Pavel Roskin <proski@gnu.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Matthew Garrett <mjg@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	andreamrl@tiscali.it, linville@redhat.com
References: <779389.39286.qm@web23108.mail.ird.yahoo.com> <1214505894.18729.11.camel@dv> <4863F1DE.3080503@yahoo.co.uk>
In-Reply-To: <4863F1DE.3080503@yahoo.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806261740.17878.herton@mandriva.com.br> (sfid-20080626_230234_984862_0C046D35)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Thursday 26 June 2008 16:45:34 Hin-Tak Leung escreveu:
> Pavel Roskin wrote:
> > On Thu, 2008-06-26 at 13:33 -0500, Larry Finger wrote:
> >> Do I understand correctly that it might be better to check for the
> >> existence of endpoint 02 for an 8187 device? Or would it be better to
> >> look for endpoint 12 to set it as an 8187B?
> >
> > It's probably OK either way, but I would look at some number that takes
> > more than just 2 values (true and false).  Say, the number of endpoints
> > would be such number.  This way, it there is some elusive 8187A or
> > 8187C, it may have a different number and won't be mistaken for known
> > chipsets.
> >
> > Of course, we cannot guarantee anything.  It's just a matter of general
> > sanity that may or may not help.  But sometimes it helps.
>
> Larry's 8187 indeed looks like a 8187B i.e. the OEM being naughty and needs
> some serious lashing there... where does it come from - what brand and what
> is it bundled with?
>
> The 8187/8187b code actually *uses* the
> endpoints to send management frames for association - that's a functional
> difference and it is not possible to drive a 8187 as if it is a 8187b or
> vice versa. In the absence of
> more authoritative answers like reading from a register or something,
> counting the endpoints - I would actually go a bit further and demand the
> used endpoints being there and in the right direction and propertes
> (int/bulk) - would seem to be a good idea. As for what to do "if things
> don't add up", at least a warning through dmesg "give the OEM some lashing
> for calling a 8187b 0x8187".
>
> I think Larry's question could be re-phrased as: if there is a preculiar
> device with *both* end point 2 and endpoint 12, what to treat it as?
>
> I would be inclined to treat it as the newer chip - but some big warning,
> or even refusing to carry on, is probably in order.
>
> Herton's code also seem to distinguish revC/revD/revE of different 8187B's
> - I don't seem to have seen those distinctions in the original vendor code,
> but maybe I haven't look hard enough :-).

The vendor driver I have here uses this revision information of 8187B inside 
rtl8225z2_SetTXPowerLevel function, for changing of radio registers. Do you 
have this too? It only checks if it's a 8187B of revB or not.

Also not using endpoint 12 for management frames was indeed a bug in original 
patch. As a curious thing, I tried too to debug the rtl8187b using the 
windows driver under ndiswrapper while analysing the traffic of commands with 
usbmon, I noted that the windows driver does a different setup, in fact the 
initialization is almost the same but later it starts to write data to index 
1304, ie:

c6d1eb80 286218884 S Co:1:003:0 s 40 04 0000 1304 0002 2 = 700b
c6d1eb80 286219207 C Co:1:003:0 0 2 >
c6d1eb80 286220241 S Co:1:003:0 s 40 04 0000 1304 0002 2 = 01ee
c6d1eb80 286220583 C Co:1:003:0 0 2 >
c6d1eb80 286221617 S Co:1:003:0 s 40 04 0000 1304 0002 2 = d244
c6d1eb80 286221957 C Co:1:003:0 0 2 >
c6d1eb80 286222990 S Co:1:003:0 s 40 04 0000 1304 0002 2 = 1344
c6d1eb80 286223330 C Co:1:003:0 0 2 >

The linux driver from realtek doesn't do this until where I could see. I tried 
to emulate the same behaviour but didn't got good results so I dropped it. 
Also when debugging this and checking registers I noticed other small errors 
in original patch too, the following is not a ready to apply patch (and not
diffed against latest wireless-testing), just to get the idea and I'll comment
the parts:

diff -p -up linux-2.6.24/drivers/net/wireless/rtl8187.h.orig linux-2.6.24/drivers/net/wireless/rtl8187.h
--- linux-2.6.24/drivers/net/wireless/rtl8187.h.orig	2008-06-25 13:22:17.000000000 -0400
+++ linux-2.6.24/drivers/net/wireless/rtl8187.h	2008-06-25 13:22:54.000000000 -0400
@@ -76,7 +76,7 @@ struct rtl8187_tx_hdr {
 struct rtl8187b_tx_hdr {
 	__le32 flags;
 	__le16 rts_duration;
-	__le16 len;
+	__le16 plcp_len;
 	__le32 unused_1;
 	__le16 unused_2;
 	__le16 tx_duration;
diff -p -up linux-2.6.24/drivers/net/wireless/rtl8187_dev.c.orig linux-2.6.24/drivers/net/wireless/rtl8187_dev.c
--- linux-2.6.24/drivers/net/wireless/rtl8187_dev.c.orig	2008-06-25 13:24:34.000000000 -0400
+++ linux-2.6.24/drivers/net/wireless/rtl8187_dev.c	2008-06-25 15:25:07.000000000 -0400
@@ -377,8 +377,8 @@ static int rtl8187_init_hw(struct ieee80
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, RTL8225_ANAPARAM_ON);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8225_ANAPARAM2_ON);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, RTL8187_RTL8225_ANAPARAM_ON);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8187_RTL8225_ANAPARAM2_ON);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
@@ -397,8 +397,8 @@ static int rtl8187_init_hw(struct ieee80
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, RTL8225_ANAPARAM_ON);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8225_ANAPARAM2_ON);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, RTL8187_RTL8225_ANAPARAM_ON);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8187_RTL8225_ANAPARAM2_ON);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
@@ -506,9 +506,9 @@ static int rtl8187b_init_hw(struct ieee8
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	reg |= RTL818X_CONFIG3_ANAPARAM_WRITE | RTL818X_CONFIG3_GNT_SELECT;
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, 0x727f3f52);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, 0x45090658);
-	rtl818x_iowrite8(priv, &priv->map->ANAPARAM3, 0);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8187B_RTL8225_ANAPARAM2_ON);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, RTL8187B_RTL8225_ANAPARAM_ON);
+	rtl818x_iowrite8(priv, &priv->map->ANAPARAM3, RTL8187B_RTL8225_ANAPARAM3_ON);
 
 	rtl818x_iowrite8(priv, (u8 *)0xFF61, 0x10);
 	reg = rtl818x_ioread8(priv, (u8 *)0xFF62);
@@ -566,6 +566,8 @@ static int rtl8187b_init_hw(struct ieee8
 
 	rtl818x_iowrite32(priv, &priv->map->RF_TIMING, 0x00004001);
 
+	rtl818x_iowrite8_idx(priv, (u8 *)0xFF4E, 1, 2);
+
 	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF72, 0x569A, 2);
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
diff -p -up linux-2.6.24/drivers/net/wireless/rtl8187_rtl8225.c.orig linux-2.6.24/drivers/net/wireless/rtl8187_rtl8225.c
--- linux-2.6.24/drivers/net/wireless/rtl8187_rtl8225.c.orig	2008-06-25 13:28:37.000000000 -0400
+++ linux-2.6.24/drivers/net/wireless/rtl8187_rtl8225.c	2008-06-25 15:29:33.000000000 -0400
@@ -306,7 +306,7 @@ void rtl8225_rf_set_tx_power(struct ieee
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8225_ANAPARAM2_ON);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8187_RTL8225_ANAPARAM2_ON);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
@@ -489,10 +489,10 @@ static const u8 rtl8225z2_ofdm[] = {
 	0x00, 0x60, 0x00, 0x00, 0x00, 0x5c, 0x00, 0x00,
 	0x40, 0x00, 0x40, 0x00, 0x00, 0x00, 0xa8, 0x26,
 	0x32, 0x33, 0x07, 0xa5, 0x6f, 0x55, 0xc8, 0xb3,
-	0x0a, 0xe1, 0x2C, 0x8a, 0x86, 0x83, 0x34, 0x0f,
+	0x0a, 0xe1, 0x2c, 0x4a, 0x86, 0x83, 0x34, 0x0f,
 	0x4f, 0x24, 0x6f, 0xc2, 0x6b, 0x40, 0x80, 0x00,
 	0xc0, 0xc1, 0x58, 0xf1, 0x00, 0xe4, 0x90, 0x3e,
-	0x6d, 0x3c, 0xfb, 0x07
+	0x6d, 0x3c, 0xfb, 0xc7
 };
 
 static const u8 rtl8225z2_tx_power_cck_ch14[] = {
@@ -557,7 +557,7 @@ void rtl8225z2_8187_rf_set_tx_power(stru
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8225_ANAPARAM2_ON);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8187_RTL8225_ANAPARAM2_ON);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
@@ -866,7 +866,7 @@ void rtl8225z2_8187b_rf_init(struct ieee
 
 	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_CCK, 0x03);
 	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_OFDM, 0x07);
-	rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);
+	rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03); msleep(1);
 
 	rtl8225_write_phy_ofdm(dev, 0x80, 0x12);
 	for (i = 0; i < ARRAY_SIZE(rtl8225z2_agc); i++) {
@@ -879,6 +879,10 @@ void rtl8225z2_8187b_rf_init(struct ieee
 	for (i = 0; i < ARRAY_SIZE(rtl8225z2_ofdm); i++) {
 		rtl8225_write_phy_ofdm(dev, i, rtl8225z2_ofdm[i]);
 	}
+	rtl8225_write_phy_cck(dev, 0xc1, 0x88); msleep(1);
+	rtl8225_write_phy_ofdm(dev, 0x97, 0x46); msleep(1);
+	rtl8225_write_phy_ofdm(dev, 0xa4, 0x86); msleep(1);
+	rtl8225_write_phy_ofdm(dev, 0x85, 0xfb); msleep(1);
 
 	rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
 	rtl818x_iowrite8(priv, &priv->map->SLOT, 9);
@@ -889,15 +893,13 @@ void rtl8225z2_8187b_rf_init(struct ieee
 	rtl818x_iowrite8(priv, (u8 *)0xFF2D, 0x5B);
 	rtl818x_iowrite8(priv, (u8 *)0xFF79, 0x5B);
 	rtl818x_iowrite32(priv, (__le32 *)0xFFF0, (7 << 12) | (3 << 8) | 28);
+	rtl818x_iowrite8(priv, &priv->map->ACM_CONTROL, 0);
 	rtl818x_iowrite32(priv, (__le32 *)0xFFF4, (7 << 12) | (3 << 8) | 28);
+	rtl818x_iowrite8(priv, &priv->map->ACM_CONTROL, 0);
 	rtl818x_iowrite32(priv, (__le32 *)0xFFF8, (7 << 12) | (3 << 8) | 28);
+	rtl818x_iowrite8(priv, &priv->map->ACM_CONTROL, 0);
 	rtl818x_iowrite32(priv, (__le32 *)0xFFFC, (7 << 12) | (3 << 8) | 28);
 	rtl818x_iowrite8(priv, &priv->map->ACM_CONTROL, 0);
-
-	rtl8225_write_phy_ofdm(dev, 0x97, 0x46); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0xa4, 0xb6); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x85, 0xfc); msleep(1);
-	rtl8225_write_phy_cck(dev, 0xc1, 0x88); msleep(1);
 }
 
 void rtl8225_rf_stop(struct ieee80211_hw *dev)
@@ -910,8 +912,19 @@ void rtl8225_rf_stop(struct ieee80211_hw
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8225_ANAPARAM2_OFF);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, RTL8225_ANAPARAM_OFF);
+	if (!priv->is_rtl8187b) {
+		rtl818x_iowrite32(priv, &priv->map->ANAPARAM2,
+				  RTL8187_RTL8225_ANAPARAM2_OFF);
+		rtl818x_iowrite32(priv, &priv->map->ANAPARAM,
+				  RTL8187_RTL8225_ANAPARAM_OFF);
+	} else {
+		rtl818x_iowrite32(priv, &priv->map->ANAPARAM2,
+				  RTL8187B_RTL8225_ANAPARAM2_OFF);
+		rtl818x_iowrite32(priv, &priv->map->ANAPARAM,
+				  RTL8187B_RTL8225_ANAPARAM_OFF);
+		rtl818x_iowrite32(priv, &priv->map->ANAPARAM3,
+				  RTL8187B_RTL8225_ANAPARAM3_OFF);
+	}
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 }
diff -p -up linux-2.6.24/drivers/net/wireless/rtl8187_rtl8225.h.orig linux-2.6.24/drivers/net/wireless/rtl8187_rtl8225.h
--- linux-2.6.24/drivers/net/wireless/rtl8187_rtl8225.h.orig	2008-06-25 15:13:28.000000000 -0400
+++ linux-2.6.24/drivers/net/wireless/rtl8187_rtl8225.h	2008-06-25 15:20:41.000000000 -0400
@@ -15,10 +15,17 @@
 #ifndef RTL8187_RTL8225_H
 #define RTL8187_RTL8225_H
 
-#define RTL8225_ANAPARAM_ON	0xa0000a59
-#define RTL8225_ANAPARAM2_ON	0x860c7312
-#define RTL8225_ANAPARAM_OFF	0xa00beb59
-#define RTL8225_ANAPARAM2_OFF	0x840dec11
+#define RTL8187_RTL8225_ANAPARAM_ON	0xa0000a59
+#define RTL8187_RTL8225_ANAPARAM2_ON	0x860c7312
+#define RTL8187_RTL8225_ANAPARAM_OFF	0xa00beb59
+#define RTL8187_RTL8225_ANAPARAM2_OFF	0x840dec11
+
+#define RTL8187B_RTL8225_ANAPARAM_ON	0x45090658
+#define RTL8187B_RTL8225_ANAPARAM2_ON	0x727f3f52
+#define RTL8187B_RTL8225_ANAPARAM3_ON	0x00
+#define RTL8187B_RTL8225_ANAPARAM_OFF	0x55480658
+#define RTL8187B_RTL8225_ANAPARAM2_OFF	0x72003f50
+#define RTL8187B_RTL8225_ANAPARAM3_OFF	0x00
 
 void rtl8225_write(struct ieee80211_hw *, u8 addr, u16 data);
 u16  rtl8225_read(struct ieee80211_hw *, u8 addr);


There are main 6 changes on the diff above:

- len is probably plcp_len field like on r818{0,5}, on vendor driver it was
specified as 'length'
- To turn ANAPARAM off we need especial value like when turning on, for
ANAPARAM*_OFF values I used the stock values from the hardware after
a cold boot
- The write to the address 0xFFF0 seems to need always a write to ACM_CONTROL
after this with value '0', the vendor driver both on win/linux does this, was
another mistake that I didn't see:
 	rtl818x_iowrite32(priv, (__le32 *)0xFFF0, (7 << 12) | (3 << 8) | 28);
+	rtl818x_iowrite8(priv, &priv->map->ACM_CONTROL, 0);

- Win driver writes to 0xFF4E and , so I added the same thing:
+	rtl818x_iowrite8_idx(priv, (u8 *)0xFF4E, 1, 2);
and does things in another order, so I moved code:
+	rtl8225_write_phy_cck(dev, 0xc1, 0x88); msleep(1);
+	rtl8225_write_phy_ofdm(dev, 0x97, 0x46); msleep(1);
+	rtl8225_write_phy_ofdm(dev, 0xa4, 0x86); msleep(1);
+	rtl8225_write_phy_ofdm(dev, 0x85, 0xfb); msleep(1);

- I changed "static const u8 rtl8225z2_ofdm[]" because of when looking the usb
traffic with usbmon and ndiswrapper it was different in that values, the win
driver has the values.
- I placed msleep(1) after write TX_ANTENNA, as all already in kernel realtek
code need this why rtl8187b does not? Better to play safe.

As I don't have docs I have to appeal to this kind of things... sorry for the
everything in one patch, I wasn't available to look more into this, but better
post what I have found until now.

-- 
[]'s
Herton
