Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:46576 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbZJBTIc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 15:08:32 -0400
Received: by bwz6 with SMTP id 6so1279800bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2009 12:08:34 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Malte Gell <malte.gell@gmx.de>
Subject: Re: [PATCH] ar9170usb: LEDs are confused
Date: Fri, 2 Oct 2009 21:08:14 +0200
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, linville@tuxdriver.com,
	"Hin-Tak Leung" <hintak.leung@gmail.com>
References: <200910011654.10963.chunkeey@googlemail.com> <200910021246.34699.chunkeey@googlemail.com> <200910021345.55567.malte.gell@gmx.de>
In-Reply-To: <200910021345.55567.malte.gell@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200910022108.15155.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 02 October 2009 13:45:55 Malte Gell wrote:
> Christian Lamparter <chunkeey@googlemail.com> wrote
> > > The Netgear (WN?) 111 even only has one blue LED as far as I know.
> > 
> > the question is if it's the only device with this deficit, or not?
> Is it feasable to write to the well known stick makers (Netgear, AVM, 
> Belkin, Asus...) and just ask them? 

No idea, but from my past experience about Linux support from resellers,
I somehow doubt it... Instead it was always more fruitful to ask around
in various (vendor) support forums for _help_.

Of course, the situation might have improved, so if you're considering
to write to the resellers, then please do! :)
> > > > FYI: you can assign the LEDs under "/sys/class/leds/"
> > > Very good to know. This needs a udev rule, right?
> > 
> > yes, should be possible one way or another...
>  
> > If you do find an easy ACTION== rule, then let us know!
> 
> Do I hear irony? Is it not easy? Isn't it just a link that needs to be made / 
> changed? Does it matter, when to do this, e.g. after the module ist loaded or 
> the network system is started?
If you take a look at the ledtriggers values in /sys/call/leds/
"none rfkill0 phy0rx phy0tx [phy0assoc] phy0radio", 
you instantly see that the phyXname trigger is dynamic.

in my opinion, finding a simple udev rule is harder than simply
modify the driver code :-D.
> > > But, what about a USB ID based decission in the driver how to handle the
> > > LED? I have a Fritz WLAN N, USB ID:  057c:8401
> > 
> > The first post had a patch attached:
> > http://patchwork.kernel.org/patch/50977/
> 
> Have not tried it, is it well tested?
Hin-Tak Leung has (or had?) some comments about the ONLY_ONE_LED (WN111 v2)
implementation. Other than that, no: I haven't received any horror stories to date.

> If it works, will the patch become official part of compat-wireless?
Sure! But best of all: the change will eventually tickle down into
2.6.x vanilla.

Regards,
	Chr
