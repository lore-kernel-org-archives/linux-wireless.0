Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:49680 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117AbZGMUrS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 16:47:18 -0400
Received: by ewy26 with SMTP id 26so2838024ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 13:47:16 -0700 (PDT)
From: "=?iso-8859-1?q?Adri=E0_Cereto_Massagu=E9?=" <ssorgatem@gmail.com>
Reply-To: ssorgatem@esdebian.org
To: "Hin-Tak Leung" <hintak.leung@gmail.com>
Subject: Re: Add device string to zd1211rw
Date: Mon, 13 Jul 2009 22:46:50 +0200
Cc: dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
References: <328c675a0907121316r7dacda0fr94b3b56a6c023d86@mail.gmail.com> <3ace41890907131323t10c5bc15oac1714e63289abd@mail.gmail.com>
In-Reply-To: <3ace41890907131323t10c5bc15oac1714e63289abd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907132246.51260.ssorgatem@esdebian.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A Dilluns, 13 de juliol de 2009 22:23:05, Hin-Tak Leung va escriure:
> On Sun, Jul 12, 2009 at 9:16 PM, Adrián Cereto<ssorgatem@esdebian.org> 
wrote:
> > I have a wireless adapter with the following device string from lsusb:
> > "ID 083a:e501 Accton Technology Corp. ZD1211B"
> >
> > It's device string was not in the zd1211rw driver, so I wondered what
> > would happen if I added it to zd_usb.c... and voilà, now it works
> > great ;) (i'm writing this connected with that adapter)
> >
> > I've tried it with compat-wireless-2.6.30, with kernels 2.6.28 (ubuntu
> > 9.04) and 2.6.30 (debian sid), and it works. I've tried to do it with
> > the bleeding edge compat-wireless, but it wouldn't compile on any of
> > my machines (the stable version compiled just fine, though).
>
> compat-wireless latest-and-greatest is a bit broken lately, in the
> last week or so. You are not the only one affected - Luis is working
> on it, I think.
>
> > The only thing I did was to put the following line in the device
> > string list in drivers/net/wireless/zd1211rw/zd_usb.c:
> >
> >       { USB_DEVICE(0x083a, 0xe501), .driver_info = DEVICE_ZD1211B }
> >
> > Do I need to send you a patch?
> > (if it weren't such a minute modification I wouldn't doubt it)
> > I've never done it before, but i'll learn to do it if necessary ;).
>
> A patch is not necessary, but having the RF type line from your dmesg
> would be good.

I'm not sure if this is what you need, but here it is:

ssorgatem@sobremesakubuntu:~$ dmesg | grep -i zd1211rw
[   10.045331] zd1211rw 1-2:1.0: phy0
[   10.045390] usbcore: registered new interface driver zd1211rw
[   13.184194] zd1211rw 1-2:1.0: firmware version 4725
[   13.224200] zd1211rw 1-2:1.0: zd1211b chip 083a:e501 v4810 high 00-1a-2a 
AL2230_RF pa0 g--NS

I hope it helps.
> > If you need more testing on this device, count me.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

