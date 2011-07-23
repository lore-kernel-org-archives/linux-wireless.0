Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:42541 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1GWUco (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 16:32:44 -0400
Received: by fxd18 with SMTP id 18so6911886fxd.11
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jul 2011 13:32:43 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Harshal Chhaya <harshal@gmail.com>
Subject: Re: carl9170: Beacons at lower Tx power than data frames?
Date: Sat, 23 Jul 2011 22:35:16 +0200
Cc: linux-wireless@vger.kernel.org, Sujith <m.sujith@gmail.com>
References: <CAJ8GFOiTwtS7Ddjo8GR3uJMFtkBY+cFuNo3d4mX_4EwOLN9PxQ@mail.gmail.com> <201107151622.43671.chunkeey@googlemail.com> <CAJ8GFOiQfMvZAHh4ahCx5_ovqh4_83+a3QADVuNVRohaKyAR6A@mail.gmail.com>
In-Reply-To: <CAJ8GFOiQfMvZAHh4ahCx5_ovqh4_83+a3QADVuNVRohaKyAR6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201107232235.16710.chunkeey@googlemail.com> (sfid-20110723_223247_729130_F7EE75A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 23 July 2011 21:22:35 Harshal Chhaya wrote:
> On Fri, Jul 15, 2011 at 9:22 AM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > On Thursday 14 July 2011 21:37:29 Harshal Chhaya wrote:
> >> I am working on an AP design that uses a TI-OMAP3 host processor with
> >> an Atheros AR9170 + AR9101 WLAN chipset. We are currently using
> >> carl9170 version 1.9.2 and carl9170 firmware version 1.9.4.
> > One question: have you considered ath9k_htc? I would certainly recommend
> > it over any ar9170 device.
> 
> I was under the impression that AP mode support is better in carl9170
> than in ath9k_htc. I had considered using AR9271 (which is a more
> recent chipset than the AR9170) but decided against it based on my
> understanding (which is based on the info on the wiki pages).
Interesting... Sujith, can you please take a look at the wiki if ath9k_htc's AP/P2P
infos are still up to date?
 
> If AR9271 (and ath9k_htc) are more stable and preferable to the AR9170
> w/ carl9170, please let me know.
AR9271 recevied a lot more testing, so it's ought to perform better.

> Also, to clarify: my application is a wireless network that needs to
> support 60-70 802.11g clients connecting to the AP using WPA2-PEAP.
> All of the clients are battery powered and use the power save
> mechanisms of 802.11.
60-70 clients is a lot. This would rule out ath9k_htc since the firmwares
only supports 7/8 stations at a time and I think that's a reasonable limit
for any wireless network. Also, with so many stations the hardware crypto
will not have enough space to store all station keys and has to switch to
software de- and encryption. 
 
> Do you see any issues using AR9170 and carl9170 in this scenario?
Sorry, but I've no data about this scenario. However some time ago
Ben <greearb@candelatech.com> played around 128 stations on a ath9k
network. But I don't know if he tested any USB solutions at that time.
 
> Also, I am running openWRT on an TI-OMAP3 processor @ 600 MHz.
Any word about the USB hcd? Does it support sending unaligned data dma,
or is it necessary to align all buffer addresses to a 4-byte boundary?

> [...]
> The patch definitely helped stabilize the network. Thanks a lot for
> looking into this and providing the patch.
great, but it's a little to late for a tested-by tag. The patch is already on
its way to mainline ;).

> However, I still see problems when I enable both WPA2 and power-save
> on the clients.
> 
> Here is what I have tried so far:
> 
> 30 802.11g clients
> 
> open mode + power save - no problems, can send data to all 30 for hrs
> wpa2 + disable power save - no problems, can send data to all 30 for hrs
> wpa2 + enable power save - clients connect but then randomly
> disconnect every few seconds.
Is this with or without the hardware crypto enabled? Usually it's enabled by
default. But in your case I would give it a try to go without one. Just load
the module with:

nohwcrypt=1

this will help to rule out any hw limitations in this regard.

Regards,
	Chr
