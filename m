Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.232]:2354 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390AbXFMW7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 18:59:10 -0400
Received: by nz-out-0506.google.com with SMTP id n1so386544nzf
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2007 15:59:09 -0700 (PDT)
Message-ID: <c02c330c0706131559i28ce1126mdd01f84eb91f779b@mail.gmail.com>
Date: Thu, 14 Jun 2007 00:59:08 +0200
From: "Kasper F. Brandt" <poizan42@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] fix for endian bug in rtl8187
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

The following patch fixes a bug in the mac80211 rtl8187 driver that
would prevent it from initializing the hardware correctly on
big-endian machines.

--- a/drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c	2007-06-14
00:24:52.000000000 +0200
+++ b/drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c	2007-06-14
00:27:17.000000000 +0200
@@ -70,6 +70,7 @@
 {
 	struct rtl8187_priv *priv = dev->priv;
 	u16 reg80, reg82, reg84;
+	__le16 buf;

 	reg80 = rtl818x_ioread16(priv, &priv->map->RFPinsOutput);
 	reg82 = rtl818x_ioread16(priv, &priv->map->RFPinsEnable);
@@ -88,9 +89,11 @@
 	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, reg80);
 	udelay(10);

+	buf = cpu_to_le16(data);
+
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			addr, 0x8225, &data, sizeof(data), HZ / 2);
+			addr, 0x8225, &buf, sizeof(buf), HZ / 2);

 	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, reg80 | (1 << 2));
 	udelay(10);

------------------------------
- Kasper F. Brandt
