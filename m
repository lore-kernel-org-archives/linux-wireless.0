Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:64469 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318AbYIFP35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 11:29:57 -0400
Message-ID: <48C2A1F5.6020607@lwfinger.net> (sfid-20080906_173036_000353_A9ECEA54)
Date: Sat, 06 Sep 2008 10:29:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: gavron@wetwork.net
CC: Broadcom Wireless <bcm43xx-dev@berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Speed enhancement for BCM4306/2
References: <48C1BA91.7050106@lwfinger.net> <48C20928.10202@wetwork.net> <48C20BD7.6080605@lwfinger.net> <48C20F64.1000700@wetwork.net>
In-Reply-To: <48C20F64.1000700@wetwork.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gavron@wetwork.net wrote:
> 
> 
> 
> Ok, here's try #2.
> E
> /home/2.6.27/rc4-wl/drivers/net/wireless/b43legacy# diff -uN /tmp/phy.c 
> phy.c
> --- /tmp/phy.c    2008-09-05 21:56:20.000000000 -0700
> +++ phy.c    2008-09-05 22:03:28.000000000 -0700

For kernel patches, you need to be working in the base directory of 
the kernel sources. For your tree, that would be in 
/home/2.6.27/rc4-wl. That way the patches will apply with the 
effective command of 'patch -p1 < patch_file'. For kernel patches, I 
use quilt so that patches are easy to apply and remove.

> @@ -1010,7 +1010,7 @@
>         b43legacy_phy_initb5(dev);
>     else
>         b43legacy_phy_initb6(dev);
> -    if (phy->rev >= 2 || phy->gmode)
> +    if (phy->rev >= 2 && phy->gmode)
>         b43legacy_phy_inita(dev);
> 
>     if (phy->rev >= 2) {

The above hunk is correct.

> @@ -1027,15 +1027,17 @@
>     }
>     if (phy->rev >= 2 || phy->gmode) {

This does not match step 7 of the specs. It was not changed recently, 
but the code did not match what was on the web site. No, I don't know why.

>         tmp = b43legacy_phy_read(dev, 0x0400) & 0xFF;
> -        if (tmp == 3 || tmp == 5) {
> +        if (tmp == 4 || tmp == 5) {
>             b43legacy_phy_write(dev, 0x04C2, 0x1816);
> -            b43legacy_phy_write(dev, 0x04C3, 0x8006);
> +            b43legacy_phy_write(dev, 0x04C3, 0x8606);
>             if (tmp == 5)
>                 b43legacy_phy_write(dev, 0x04CC,
>                             (b43legacy_phy_read(dev,
>                              0x04CC) & 0x00FF) |
>                              0x1F00);
>         }
> +    }
> +    if (phy->rev >= 2)
>         b43legacy_phy_write(dev, 0x047E, 0x0078);
>     }
>     if (phy->radio_rev == 8) {

This hunk does not match the specs. In addition, I think there are too 
many right-hand curly braces for it to compile.

Larry

