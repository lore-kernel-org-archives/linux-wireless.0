Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:55544 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab0HOTcK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 15:32:10 -0400
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 0C3D3D1A056
	for <linux-wireless@vger.kernel.org>; Sun, 15 Aug 2010 21:22:40 +0200 (CEST)
Date: Sun, 15 Aug 2010 21:21:52 +0200 (CEST)
From: dimitri.gorokhovik@free.fr
To: =?utf-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linville@tuxdriver.com, stefano brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
Message-ID: <1123777895.142301281900112563.JavaMail.root@zimbra3-e1.priv.proxad.net>
In-Reply-To: <1689108175.140731281899456474.JavaMail.root@zimbra3-e1.priv.proxad.net>
Subject: Re: [PATCH]: b43: is there such a thing as radio 0x2062 rev 2?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


----- "Gábor Stefanik" <netrolller.3d@gmail.com> a écrit :

> Does the card actually work if you make b43 believe that it has a
> BCM2063 radio?
The interface stays on (the WiFi LED lit), and I can scan and see 
the networks (Quality info seems OK as well with 2.6.35). However, 
I am still unable to connect to either an open or a protected 
network:

Aug 15 19:04:11 dimitri kernel: wlan0: authenticate with 00:17:33:1e:13:70 (try 1)
Aug 15 19:04:11 dimitri kernel: wlan0: authenticated
Aug 15 19:04:11 dimitri kernel: wlan0: associate with 00:17:33:1e:13:70 (try 1)
Aug 15 19:04:11 dimitri kernel: wlan0: RX AssocResp from 00:17:33:1e:13:70 (capab=0x411 status=0 aid=2)
Aug 15 19:04:11 dimitri kernel: wlan0: associated
Aug 15 19:04:16 dimitri kernel: No probe response from AP 00:17:33:1e:13:70 after 500ms, disconnecting.

> BTW, all BCM2062 radios seen so far are rev.2, and none have shown
> this error. Maybe your card actually has a BCM2063 radio, but for
> some reason b43 detects it as a BCM2062?
Sure, this is of course possible (I don't really believe my patch 
fixes the problem). The MAC address of the WiFi card is 
00:22:68:ba:e2:ef (maybe somebody knows know the manufacturing 
series).

For the record, I was able, only once, to run the unmodified driver
(2.6.32 x86+_64 debian kernel), but was never able to get it ever 
again after that. That time, the HDMI res negotiated on both my 
screens (though a dock) was rather unusual (something like 
11xx X 9xx) so I think my problem might be some sort of CEM 
problem.  

> 
> Also, does the Broadcom hybrid driver handle your card?
Last time I tried (more than a year ago), from memory, I believe,
I was able to scan, but I had the problems with Network Manager
support and didn't go for manual config.

Thanks,
Dimitri
> 
> Thanks,
> Gábor.
> 
> On Sun, Aug 15, 2010 at 8:27 PM,  <dimitri.gorokhovik@free.fr> wrote:
> > Hi,
> >
> > On a DELL D630 with BCM4312 (low-power PHY 4e4:4315 rev 01), I was
> able to fix the problem:
> >
> > Aug 15 17:14:45 dimitri kernel: b43-phy0 debug: RC calib: Failed to
> switch to channel 7, error = -5
> >
> > by bumping the radio's version (0x2062 rev 2) to 0x2063 (kept rev
> 2).
> >
> > Before the fix, the hardware detected as:
> >
> > Aug 15 17:14:45 dimitri kernel: b43-phy0: Broadcom 4312 WLAN found
> (core revision 15)
> > Aug 15 17:14:45 dimitri kernel: b43-phy0 debug: Found PHY: Analog 6,
> Type 5, Revision 1
> > Aug 15 17:14:45 dimitri kernel: b43-phy0 debug: Found Radio: Manuf
> 0x17F, Version 0x2062, Revision 2
> >
> > The problem manifested itself (permanently) as:
> >
> > Aug 15 18:18:10 dimitri kernel: b43-phy0: Loading firmware version
> 478.104 (2008-07-01 00:50:23)
> > Aug 15 18:18:10 dimitri kernel: b43-phy0 debug: b2062: Using crystal
> tab entry 19200 kHz.
> > Aug 15 18:18:10 dimitri kernel: b43-phy0 debug: RC calib: Failed to
> switch to channel 7, error = -5
> >
> >
> > The patch follows, tested on 2.6.32.18 and 2.6.35.2, both built for
> x86_64.
> >
> > ---
> > b43: Bump the radio version 0x2063-rev-2 to 0x2063.
> >
> > Signed-off-by: <dimitri.gorokhovik@free.fr>
> > ---
> > diff --git a/drivers/net/wireless/b43/main.c
> b/drivers/net/wireless/b43/main.c
> > index 7965b70..d245a23 100644
> > --- a/drivers/net/wireless/b43/main.c
> > +++ b/drivers/net/wireless/b43/main.c
> > @@ -4084,6 +4084,7 @@ static int b43_phy_versioning(struct b43_wldev
> *dev)
> >        case B43_PHYTYPE_LP:
> >                if (radio_ver != 0x2062 && radio_ver != 0x2063)
> >                        unsupported = 1;
> > +               radio_ver += radio_rev > 1;
> >                break;
> >        default:
> >                B43_WARN_ON(1);
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> -- 
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
