Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:59204 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbYDKE6C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2008 00:58:02 -0400
Message-ID: <47FEEFCE.6040006@lwfinger.net> (sfid-20080411_055808_596577_394B25C4)
Date: Thu, 10 Apr 2008 23:57:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] Add Realtek 8187B support
References: <200804081931.07638.herton@mandriva.com.br> <47FD8C0E.3060807@lwfinger.net> <200804100143.32854.herton@mandriva.com.br>
In-Reply-To: <200804100143.32854.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> 
> Can you open your dongle and see if you really have a RTL8187B? (as you
> said you had to force the ID). May be it wasn't really a 8187b device but
> another variant. I did many tests this week with a 8187b that continues to
> work ok.

I don't want to open it as it should still be under warranty. I'm
pretty sure it is an 8187b. When I tried it with the 8187 driver, it
gets an rf calibration error. By using your driver with the patch
below, it loaded and worked, at least for a while. It probably was a
natural death, but I felt I should issue a warning, jest in case.

I was going to hold the following patch until I had more to 
contribute; however, I don't know if I will be able to participate. 
Please apply the patch, as it lets devices like mine, where the 
iProduct string identifies is as an RTL8187B device, but the idProduct 
value is 0x8187, not 0x8189.

Thanks,

Larry

Index: wireless-testing/drivers/net/wireless/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl8187_dev.c
@@ -946,7 +946,8 @@ static int __devinit rtl8187_probe(struc
  	}

  	priv = dev->priv;
-       priv->is_rtl8187b = (id->driver_info == DEVICE_RTL8187B);
+	priv->is_rtl8187b = (id->driver_info == DEVICE_RTL8187B) ||
+			    !memcmp(udev->product, "RTL8187B", 8);

  	SET_IEEE80211_DEV(dev, &intf->dev);
  	usb_set_intfdata(intf, dev);



