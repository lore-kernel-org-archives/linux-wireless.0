Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:54941 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbYKUFy2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 00:54:28 -0500
Received: by mu-out-0910.google.com with SMTP id g7so812629muf.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2008 21:54:27 -0800 (PST)
Message-ID: <b25312890811202154o3c739267jd989e595f268acac@mail.gmail.com> (sfid-20081121_065438_339850_C9E683EA)
Date: Fri, 21 Nov 2008 07:54:26 +0200
From: "Rami Rosen" <roszenrami@gmail.com>
To: "Cyril Hrubis" <metan@ucw.cz>
Subject: Re: zd1211rw breaks s2ram
Cc: linux-wireless@vger.kernel.org, dsd@gentoo.org, kune@deine-taler.de
In-Reply-To: <20081121003918.GA6037@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081121003918.GA6037@atrey.karlin.mff.cuni.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

>When i run "ifconfig wlan0 up", I get 'ADDRCONF(NETDEV_UP): wlan0: link
>is not ready' in dmesg,

This message comes from IPv6; I suggest you ignore it. I also have this message
when using zd1211rw and it works fine. Disabling IPv6 on your machine,
if possible, will avoid this error.

To be more specific, this message is from addrconf_notify()
in net/ipv6/addrconf.c; this method is called when there is event of changing
flags of an interface.

Regards,
Rami Rosen




On Fri, Nov 21, 2008 at 2:39 AM, Cyril Hrubis <metan@ucw.cz> wrote:
> Hi,
> on my asus eee 1000h notebook, an Usb wifi with driver zd1211rw breaks
> s2ram. Notebook hangs before suspending (with console on the screen)
> and doesn't react to anyting but the power button. The dongle is
> identified as:
>
> idVendor           0x0ace ZyDAS
> idProduct          0x1215 WLA-54L WiFi
> bcdDevice           48.10
> iManufacturer          16 ZyDAS
> iProduct               32 USB2.0 WLAN
>
> I'm using firmware version 4725 (that's default one in Gentoo), kernel
> is vanilla 2.6.28-rc5.
>
> When i run "ifconfig wlan0 up", I get 'ADDRCONF(NETDEV_UP): wlan0: link
> is not ready' in dmesg, however scanning seems works fine.
>
> --
> metan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
