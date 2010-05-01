Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64438 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab0EAUpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 16:45:43 -0400
Received: by bwz19 with SMTP id 19so689607bwz.21
        for <linux-wireless@vger.kernel.org>; Sat, 01 May 2010 13:45:40 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "David H. Lynch Jr." <dhlii@dlasys.net>
Subject: Re: ar9170-fw II
Date: Sat, 1 May 2010 22:45:36 +0200
Cc: linux-wireless@vger.kernel.org
References: <4BDC001F.9050202@dlasys.net> <201005011919.32016.chunkeey@googlemail.com> <4BDC719E.3060505@dlasys.net>
In-Reply-To: <4BDC719E.3060505@dlasys.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201005012245.36589.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 01 May 2010 20:23:26 David H. Lynch Jr. wrote:
> On 05/01/2010 01:19 PM, Christian Lamparter wrote:
> >
> > Well, for starters the ar9170 uses a ZyDas MAC (aka ZD1221)
> > and a AR900x PHY/Radio. Therefore the phy code and registers
> > are very similar to those #definitions you can find in ath9k.
> > And for the MAC code&  registers you can look into zd1211rw,
> > or look into drivers/staging/otus (original vendor driver,
> > shares some code with their windows drivers)
> >
> > AFAICT, there are no technical documents about the AR9170
> > solution available w/o signing a NDA with Atheros
> > (probably because the devices are still produced and sold in high quantities?).
> >    
> Thanks;
>
> I did just discover a reasonably good 150p spec. In what I received from 
> my client. If I can I will share it. I am under an NDA, but the client also
> told me that they received no cooperation from atheros.

hmm, only 150 pages? That's sounds a bit thin, as a matter of
fact I know that the ath5k docs (rf+mac+eeprom) are at least
around 300-400 pages.

Well, we'll see. But just in case, we already have a small
library of hardware docs (but most from different vendors):
http://wireless.kernel.org/en/developers/Documentation/specs

and we would welcome such an addition ;-)

> >> What is available for the ar9170 itself ?
> >> How does the firmware and the linux driver communicate?
> >>    Is there an overview of the firmware - what is where ?
> >>      
> > not really, apart from the headers of the original firmware
> > and vendor drivers.
> >
> > But if you really need to implement some of your 'features'
> > (what are they, if I may ask?)
>
> I think I can tell you what I am supposed add - I need to be able 
> to provide userspace apps with precise timing information for each packet.
> Since i am working on GPL'd code and the results are going to be 
> provided to third parties whatever I do is GPL'd too.

if by precise timing you mean "exact mac time in TU/usecs when frame
was received at the radio", then you might have a _problem_.
You see, the firmware already receives fully packed frames from
the MAC processor and only _forwards_ them all [as is] in
one big DMA to the USB subsystem.
(this is done in src/wlan.c handle_rx())

So, unless the HW has a _magic_ flag to enable this capability...
you are sort of screwed :-/.

> Why gets into the NDA. 
> Right now i have an NDA with a new client and though I am 
> exercising care. But they seem fairly mellow. I am probably just being 
> overly cautious.
k, understood.
