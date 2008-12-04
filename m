Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48746 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbYLDEVX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 23:21:23 -0500
Date: Wed, 03 Dec 2008 22:21:20 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH V2] rtl8187: Improve wireless statistics for RTL8187
Message-ID: <49375ac0.z1uZDBLv3IxmmMgD%Larry.Finger@lwfinger.net> (sfid-20081204_052129_566678_07182639)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current wireless statistics for the RTL8187 poorly indicate the sig=
nal
strength and quality. With testing, I found that the AGC value is inver=
sely
correlated with the strength as in the RTL8187B. By implementing a simi=
lar
calculation, much more code becomes common to the two devices.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested by: Mart=C3=ADn Ernesto Barreyro <barreyromartin@gmail.com>
---

John,

This is 2.6.29 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -313,29 +313,14 @@ static void rtl8187_rx_cb(struct urb *ur
 		struct rtl8187_rx_hdr *hdr =3D
 			(typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
 		flags =3D le32_to_cpu(hdr->flags);
-		signal =3D hdr->signal & 0x7f;
+		/* As with the RTL8187B below, the AGC is used to calculate
+		 * signal strength and quality. In this case, the scaling
+		 * constants are derived from the output of p54usb.
+		 */
+		quality =3D 130 - ((41 * hdr->agc) >> 6);
+		signal =3D -4 - ((27 * hdr->agc) >> 6);
 		rx_status.antenna =3D (hdr->signal >> 7) & 1;
-		rx_status.noise =3D hdr->noise;
 		rx_status.mactime =3D le64_to_cpu(hdr->mac_time);
-		priv->quality =3D signal;
-		rx_status.qual =3D priv->quality;
-		priv->noise =3D hdr->noise;
-		rate =3D (flags >> 20) & 0xF;
-		if (rate > 3) { /* OFDM rate */
-			if (signal > 90)
-				signal =3D 90;
-			else if (signal < 25)
-				signal =3D 25;
-			signal =3D 90 - signal;
-		} else {	/* CCK rate */
-			if (signal > 95)
-				signal =3D 95;
-			else if (signal < 30)
-				signal =3D 30;
-			signal =3D 95 - signal;
-		}
-		rx_status.signal =3D signal;
-		priv->signal =3D signal;
 	} else {
 		struct rtl8187b_rx_hdr *hdr =3D
 			(typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
@@ -353,18 +338,18 @@ static void rtl8187_rx_cb(struct urb *ur
 		 */
 		flags =3D le32_to_cpu(hdr->flags);
 		quality =3D 170 - hdr->agc;
-		if (quality > 100)
-			quality =3D 100;
 		signal =3D 14 - hdr->agc / 2;
-		rx_status.qual =3D quality;
-		priv->quality =3D quality;
-		rx_status.signal =3D signal;
-		priv->signal =3D signal;
 		rx_status.antenna =3D (hdr->rssi >> 7) & 1;
 		rx_status.mactime =3D le64_to_cpu(hdr->mac_time);
-		rate =3D (flags >> 20) & 0xF;
 	}
=20
+	if (quality > 100)
+		quality =3D 100;
+	rx_status.qual =3D quality;
+	priv->quality =3D quality;
+	rx_status.signal =3D signal;
+	priv->signal =3D signal;
+	rate =3D (flags >> 20) & 0xF;
 	skb_trim(skb, flags & 0x0FFF);
 	rx_status.rate_idx =3D rate;
 	rx_status.freq =3D dev->conf.channel->center_freq;
@@ -1294,6 +1279,7 @@ static int __devinit rtl8187_probe(struc
=20
 	priv->mode =3D NL80211_IFTYPE_MONITOR;
 	dev->flags =3D IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
+		     IEEE80211_HW_SIGNAL_DBM |
 		     IEEE80211_HW_RX_INCLUDES_FCS;
=20
 	eeprom.data =3D dev;
@@ -1409,13 +1395,8 @@ static int __devinit rtl8187_probe(struc
 		(*channel++).hw_value =3D txpwr >> 8;
 	}
=20
-	if (priv->is_rtl8187b) {
+	if (priv->is_rtl8187b)
 		printk(KERN_WARNING "rtl8187: 8187B chip detected.\n");
-		dev->flags |=3D IEEE80211_HW_SIGNAL_DBM;
-	} else {
-		dev->flags |=3D IEEE80211_HW_SIGNAL_UNSPEC;
-		dev->max_signal =3D 65;
-	}
=20
 	/*
 	 * XXX: Once this driver supports anything that requires
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
