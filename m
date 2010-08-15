Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41538 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab0HOSwf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 14:52:35 -0400
Received: by qwh6 with SMTP id 6so4346391qwh.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 Aug 2010 11:52:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1944322236.136661281896820874.JavaMail.root@zimbra3-e1.priv.proxad.net>
References: <1682961998.136221281896329090.JavaMail.root@zimbra3-e1.priv.proxad.net>
 <1944322236.136661281896820874.JavaMail.root@zimbra3-e1.priv.proxad.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 15 Aug 2010 20:52:14 +0200
Message-ID: <AANLkTink6t1cPNi80sFX-fadLF7ztGbUteH+EM=TgwH4@mail.gmail.com>
Subject: Re: [PATCH]: b43: is there such a thing as radio 0x2062 rev 2?
To: dimitri.gorokhovik@free.fr
Cc: linville@tuxdriver.com, stefano.brivio@polimi.it,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Does the card actually work if you make b43 believe that it has a BCM2063 radio?

BTW, all BCM2062 radios seen so far are rev.2, and none have shown
this error. Maybe your card actually has a BCM2063 radio, but for some
reason b43 detects it as a BCM2062?

Also, does the Broadcom hybrid driver handle your card?

Thanks,
Gábor.

On Sun, Aug 15, 2010 at 8:27 PM,  <dimitri.gorokhovik@free.fr> wrote:
> Hi,
>
> On a DELL D630 with BCM4312 (low-power PHY 4e4:4315 rev 01), I was able to fix the problem:
>
> Aug 15 17:14:45 dimitri kernel: b43-phy0 debug: RC calib: Failed to switch to channel 7, error = -5
>
> by bumping the radio's version (0x2062 rev 2) to 0x2063 (kept rev 2).
>
> Before the fix, the hardware detected as:
>
> Aug 15 17:14:45 dimitri kernel: b43-phy0: Broadcom 4312 WLAN found (core revision 15)
> Aug 15 17:14:45 dimitri kernel: b43-phy0 debug: Found PHY: Analog 6, Type 5, Revision 1
> Aug 15 17:14:45 dimitri kernel: b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2062, Revision 2
>
> The problem manifested itself (permanently) as:
>
> Aug 15 18:18:10 dimitri kernel: b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
> Aug 15 18:18:10 dimitri kernel: b43-phy0 debug: b2062: Using crystal tab entry 19200 kHz.
> Aug 15 18:18:10 dimitri kernel: b43-phy0 debug: RC calib: Failed to switch to channel 7, error = -5
>
>
> The patch follows, tested on 2.6.32.18 and 2.6.35.2, both built for x86_64.
>
> ---
> b43: Bump the radio version 0x2063-rev-2 to 0x2063.
>
> Signed-off-by: <dimitri.gorokhovik@free.fr>
> ---
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index 7965b70..d245a23 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -4084,6 +4084,7 @@ static int b43_phy_versioning(struct b43_wldev *dev)
>        case B43_PHYTYPE_LP:
>                if (radio_ver != 0x2062 && radio_ver != 0x2063)
>                        unsupported = 1;
> +               radio_ver += radio_rev > 1;
>                break;
>        default:
>                B43_WARN_ON(1);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
