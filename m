Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50980 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756215AbZKQXok (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 18:44:40 -0500
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Piotr Findeisen <piotr.findeisen@gmail.com>
Subject: Re: unsupported TL-WN422G (0cf3:1006)
Date: Wed, 18 Nov 2009 00:44:43 +0100
Cc: linux-wireless@vger.kernel.org
References: <4B02CD95.2010805@gmail.com> <200911171758.53596.s.L-H@gmx.de> <ddb82bf60911171406r2c328f69ic3789f8e937e41f7@mail.gmail.com>
In-Reply-To: <ddb82bf60911171406r2c328f69ic3789f8e937e41f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200911180044.45287.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Wednesday 18 November 2009, Piotr Findeisen wrote:
> Hi, Stefan!
> Thanks for your explanation!
> 
> On Tue, Nov 17, 2009 at 17:58, Stefan Lippers-Hollmann <s.L-H@gmx.de> wrote:
> 
> > If you take a look at the vendor's windows driver for TP-LINK WN422G *v2*,
> 
> how can I know I have v2 of the device?
> 
> >  it becomes obvious that the device does not use the ZyDAS zd1211/ Atheros
> > 5007UG cipset, but has switched to the new Atheros AR9271 chipset (which
> > technically is a 150 MBit/s 802.11n "lite" chipset family) instead.
[...]
> > %ATHER.DeviceDesc.1006% = ATHER_DEV_1006.ndi,     USB\VID_0CF3&PID_1006
                                                              ^^^^     ^^^^
Which means your device is TP-LINK WN422G v2 - and therefore AR9271.

> OK, I found this section on the CD with the drivers but my product id is
> 1006. How do you know it's AR9271 chipset and not, say, AR1006?
> I found /AR9271/i on the CD in driver files for Windows 2000, XP, XP64.
> Vista driver files don't have this substring anywhere (they have '9271' in
> netathur.inf 6 times, and '1006' is 6 times in analogus lines as well).
> 
> > At this moment a new driver called ath9k_htc is under (early) development:
> >        http://wireless.kernel.org/en/users/Drivers/ath9k_htc
> 
> What does 'early' mean in this context? Is it worth try or should i look for
> replacement?

Disclaimer, I neither have access to an AR9271 device, nor am familiar with
its development state, therefore I base this on the afforementioned driver
wiki page and the reference code.

It's not merged in 2.6.32, wireless-next (~= 2.6.33) or wireless-testing 
yet and http://wireless.kernel.org/en/users/Drivers/ath9k_htc#Status is 
pretty explicit about its state, namely that it doesn't actually transmit 
any data yet. Even though development seems to be pretty active and showing
quite some potential, it will likely take several months before it becomes 
enduser compatible.

Regards
	Stefan Lippers-Hollmann
