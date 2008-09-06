Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:59300 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbYIFEtd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 00:49:33 -0400
Message-ID: <48C20BD7.6080605@lwfinger.net> (sfid-20080906_064942_920356_025AF937)
Date: Fri, 05 Sep 2008 23:49:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: gavron@wetwork.net
CC: Broadcom Wireless <bcm43xx-dev@berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Speed enhancement for BCM4306/2
References: <48C1BA91.7050106@lwfinger.net> <48C20928.10202@wetwork.net>
In-Reply-To: <48C20928.10202@wetwork.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gavron@wetwork.net wrote:
> Is this close?
> E
> --- /tmp/phy_g.c    2008-09-05 21:06:57.000000000 -0700
> +++ phy_g.c    2008-09-05 21:36:18.000000000 -0700
> @@ -2198,7 +2198,7 @@
>     else
>         b43_phy_initb6(dev);
> 
> -    if (phy->rev >= 2 || phy->gmode)
> +    if (phy->rev >= 2 && phy->gmode)
>         b43_phy_inita(dev);
> 
>     if (phy->rev >= 2) {
> @@ -2216,9 +2216,9 @@
>     if (phy->gmode || phy->rev >= 2) {
>         tmp = b43_phy_read(dev, B43_PHY_VERSION_OFDM);
>         tmp &= B43_PHYVER_VERSION;
> -        if (tmp == 3 || tmp == 5) {
> +        if (tmp == 4 || tmp == 5) {
>             b43_phy_write(dev, B43_PHY_OFDM(0xC2), 0x1816);
> -            b43_phy_write(dev, B43_PHY_OFDM(0xC3), 0x8006);
> +            b43_phy_write(dev, B43_PHY_OFDM(0xC3), 0x8606);
>         }
>         if (tmp == 5) {
>             b43_phy_write(dev, B43_PHY_OFDM(0xCC),
> @@ -2226,7 +2226,7 @@
>                        & 0x00FF) | 0x1F00);
>         }
>     }
> -    if ((phy->rev <= 2 && phy->gmode) || phy->rev >= 2)
> +    if ((phy->rev >=2)
>         b43_phy_write(dev, B43_PHY_OFDM(0x7E), 0x78);
>     if (phy->radio_rev == 8) {
>         b43_phy_write(dev, B43_PHY_EXTG(0x01),

It is close, but I think you are working on b43. My changes are for 
b43legacy and all changes will be in drivers/net/wireless/b43legacy/phy.c

Larry
