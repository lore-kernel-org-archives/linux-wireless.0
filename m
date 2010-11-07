Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([187.115.55.249]:51853 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab0KGBHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 21:07:42 -0400
Date: Sat, 6 Nov 2010 23:07:31 -0200
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	seno <senada@t-online.de>
Subject: Re: [PATCH 9/9] rtl8187: restore anaparam registers after reset
 with 8187B
Message-ID: <20101106230731.3524ae6b@mandriva.com.br>
In-Reply-To: <20101105194549.GD3836@barata.holoscopio.com>
References: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
	<1288659579-4986-10-git-send-email-herton@mandriva.com.br>
	<20101104153057.GA4610@barata.holoscopio.com>
	<20101104135037.4a465ea8@gotham.conectiva>
	<20101105194549.GD3836@barata.holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Fri, 5 Nov 2010 17:45:50 -0200
Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> escreveu:
[snip]
> 
> Hello, again.
> 
> I've done some more tests around here and I also get throughput
> improvements with the last patch when my AP is in my desk. It does
> happen that I have what seems to be a badly assembled card in my
> notebook. I can try to get one I can plug outside in the external USB
> port.
> 
> However, the tests I've done with my card with the AP a little further
> away (about 2.7 meters), I cannot ping the machine for more than the
> first seconds. Without the last patch, I get 50% loss, and, sometimes,
> iperf works and gives me more than 2Kbits/s (that's right, that
> little).
> 
> I have also tried with the AP whithin about 1 meter of distance.
> Without the patch, I get no loss and iperf gives me something between
> 1Mbit/s and 2Mbit/s. With the patch, sometimes I get 4Mbit/s,
> sometimes less than 10Kbit/s. In any occasion, with lots of losses
> using ping.

It's strange that with or without the patch you get too low transfer
values. In this case we should have another bug with your device. I don't
know now what could be happening, but first thing that I thought is that
this could be related to antenna selection (and I'm curious about analog
parameters on the eeprom of device too). Please try following debug patch
and post results (also post what type of RTL8187 the driver detects/prints
on kernel log too, may help). And if is something related to antena selection,
try change the if condition on the patch and see if that helps.

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index eeee244..d8271f0 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1538,6 +1538,18 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 #endif
 	rtl8187_rfkill_init(dev);
 
+	eeprom_93cx6_read(&eeprom, 0x3F, &reg);
+	printk("EEPROM_SW_REVD == 0x%04x\n", reg);
+
+	eeprom_93cx6_read(&eeprom, 0xe, &reg);
+	printk("ANA_PARM eeprom value: 0x%04x", reg);
+	eeprom_93cx6_read(&eeprom, 0xd, &reg);
+	printk("%04x\n", reg);
+	eeprom_93cx6_read(&eeprom, 0x19, &reg);
+	printk("ANA_PARM2 eeprom value: 0x%04x", reg);
+	eeprom_93cx6_read(&eeprom, 0x1a, &reg);
+	printk("%04x\n", reg);
+
 	return 0;
 
  err_free_dmabuf:
diff --git a/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c b/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
index 5c6666f..15c0165 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
@@ -877,7 +877,6 @@ static void rtl8225z2_b_rf_init(struct ieee80211_hw *dev)
 
 	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_CCK, 0x03);
 	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_OFDM, 0x07);
-	rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);
 
 	rtl8225_write_phy_ofdm(dev, 0x80, 0x12);
 	for (i = 0; i < ARRAY_SIZE(rtl8225z2_agc); i++) {
@@ -894,6 +893,17 @@ static void rtl8225z2_b_rf_init(struct ieee80211_hw *dev)
 	rtl8225_write_phy_ofdm(dev, 0xa4, 0xb6);
 	rtl8225_write_phy_ofdm(dev, 0x85, 0xfc);
 	rtl8225_write_phy_cck(dev, 0xc1, 0x88);
+
+	if (0) {
+		rtl8225_write_phy_cck(dev, 0x10, 0xdb);
+		rtl8225_write_phy_ofdm(dev, 0x26, 0x10);
+		rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x00);
+	} else {
+		rtl8225_write_phy_cck(dev, 0x10, 0x9b);
+		rtl8225_write_phy_ofdm(dev, 0x26, 0x90);
+		rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);
+	}
+	msleep(1);
 }
 
 static void rtl8225_rf_stop(struct ieee80211_hw *dev)


> 
> For reference, my "AP" is, in fact, a netbook using hostapd and a rt73
> USB dongle. I am going to send the patches for experimentation in an
> environment with many devices far away from the AP. As soon as I get
> the results (it may take a while), I'll send them to the list.
> 
> Anyway, although I am not very confident about this last patch,
> perhaps it should go forward and we get can revert it later if people
> does complain about it. Or we should add a comment stating in the
> code that it does improve throughput, but may cause packet losses
> when the devices are distant. Any thoughts on how to turn this on or
> off depending on the case too?
> 
> Regards,
> Cascardo.

--
[]'s
Herton
