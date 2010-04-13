Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:63986 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0DMRsj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 13:48:39 -0400
Received: by ewy20 with SMTP id 20so2711890ewy.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Apr 2010 10:48:38 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Duarte Nuno Gomes <dnunogomes@gmail.com>
Subject: Re: p54pci does not work
Date: Tue, 13 Apr 2010 19:48:30 +0200
Cc: linux-wireless@vger.kernel.org
References: <u2u719bd8781004122247kb48bedet36ea07db3819d202@mail.gmail.com>
In-Reply-To: <u2u719bd8781004122247kb48bedet36ea07db3819d202@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201004131948.31080.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 13 April 2010 07:47:42 Duarte Nuno Gomes wrote:
> hi,

hello, (received two slightly _different_? mails)

> im a p54pci module user.
yeah, me too.

> 02:01.0 Network controller: Intersil Corporation ISL3890 [Prism GT/Prism
> Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)
almost all p54pci devices are using a wildcard pciids.
unless open up your box to take a look at the actual hardware,
your card is one among many _similar_ cards.
(e.g.: generic ISL3886 or ISL3880)

> i use isl3886pci firmware ( 2.13.12.0.arm ) and used the latest
> compat-wireless-2.6.34-rc4-test1
oh, I didn't know they are now making compat-wireless-testX releases.
Thanks for the heads-up!

> latest firmware , 2.17.2.0.arm wont work
sure, this is why this fw is not directly linked on the wiki page.
Why? Has anyone told you to use specifically 2.17.2.0.arm?

> it works all ok ... when i visit some websites ( www.rcmadeira.pt.vu is one
> of them ), my connection just disconnects and i cannot resume it . i need to
> shutdown and re lauch kernel in order to work with wireless again.

hrmf, works here no matter how much i try.
But let's not get carry away, I guess the problem you are describing
has more to do with the amount of data which is transfered.
Ideally, you should be able to reproduce this _hang_ with any network
benchmarking tools (like iperf / nttcp / netperf (or whatever you prefer)).

> here is what dmesg outputs
> 
> No probe response from AP 00:24:17:6c:a5:0e after 500ms, disconnecting.
> Phy0 : cannot boot firmware !

are you getting these messages in this order? (some timestamps,
and maybe p54pci dmesg output while initializing would be jolly nice)

> i've tryed modprobe -r p54pci and modprobe p54pci , wont work. needs a
> complete shutdown.
> 
> its an annoying bug... i cannot browse sucessfully for some hours , some
> will fail , making me reboot and reboot and reboot ...
> 
> if u need addicional information , please let me know to
> dnunogomes@gmail.com
> Hope it will be corrected soon
> i would like to receive any update about this , thanks !
I'm not sure about that, usually the firmware booting mechanism only fails
when there is a real hardware (compatibility) problem.

could you please describe your:

 * PC (CPU, Mainboard (or at least the chipset),
   amount of installed RAM, IOMMU (if enabled), other PCI cards, etc...).

 * Wireless setup (Which band (2.4 or 5GHz) ? Do you use WPA/WPA2 with CCMP/TKIP,
   (you can turn off the hw crypto accelerator by loading p54common with the module
    parameter nohwcrypt=1 )

 * whenever competing products from Atheros/Broadcom/Intel...
   are working without a hitch.

etc...

Regards,
	Chr
