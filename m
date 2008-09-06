Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:54426 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751501AbYIFX2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 19:28:30 -0400
Message-ID: <48C3121C.9090309@lwfinger.net> (sfid-20080907_012832_747343_77D00D9E)
Date: Sat, 06 Sep 2008 18:28:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: gavron@wetwork.net
CC: Broadcom Wireless <bcm43xx-dev@berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Speed enhancement for BCM4306/2
References: <48C1BA91.7050106@lwfinger.net> <48C20928.10202@wetwork.net> <48C20BD7.6080605@lwfinger.net> <48C20F64.1000700@wetwork.net> <48C2A1F5.6020607@lwfinger.net> <48C30B3E.2040302@wetwork.net>
In-Reply-To: <48C30B3E.2040302@wetwork.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gavron@wetwork.net wrote:
> I haven't tried a build yet, but please let me know if I'm on the right 
> track.
> 
> E
> # diff -uN /tmp/phy.c drivers/net/wireless/b43legacy/phy.c
> --- /tmp/phy.c    2008-09-06 15:13:33.000000000 -0700
> +++ drivers/net/wireless/b43legacy/phy.c    2008-09-06 
> 15:54:03.000000000 -0700
> @@ -1010,7 +1010,7 @@
>         b43legacy_phy_initb5(dev);
>     else
>         b43legacy_phy_initb6(dev);
> -    if (phy->rev >= 2 || phy->gmode)
> +    if (phy->rev >= 2 && phy->gmode)
>         b43legacy_phy_inita(dev);
> 
>     if (phy->rev >= 2) {
> @@ -1021,21 +1021,26 @@
>         b43legacy_phy_write(dev, 0x0811, 0x0000);
>         b43legacy_phy_write(dev, 0x0015, 0x00C0);
>     }
> -    if (phy->rev > 5) {
> +    if (phy->rev >= 3) {

AFAIK, this change is an error in the specs. I have since changed it. 
Sorry I didn't catch it earlier.

Otherwise, this patch seems to be correct. All you need now are the 
fixes for b43legacy_phy_initb5() and b43legacy_phy_initb6().

Larry
