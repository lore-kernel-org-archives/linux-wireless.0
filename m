Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:43913 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbZLXLsh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 06:48:37 -0500
Received: by iwn1 with SMTP id 1so5724607iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 24 Dec 2009 03:48:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BLU113-W211E9D9EFD5458887F8CFFBE820@phx.gbl>
References: <BLU113-W7635FBD7855C5257B07E4BE820@phx.gbl> <69e28c910912210614v31edf6cej9abeddb17ab130d@mail.gmail.com>
	<BLU113-W10113EE534A08128E43979BE820@phx.gbl> <4B2F9534.8020908@lwfinger.net>
	<BLU113-W211E9D9EFD5458887F8CFFBE820@phx.gbl>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 24 Dec 2009 22:48:17 +1100
Message-ID: <646765f40912240348s64747772la4f80a945ab935d7@mail.gmail.com>
Subject: Re: I need a card that works reasonably easily with Debain- reccs?
To: Mike Marchywka <marchywka@hotmail.com>
Cc: larry.finger@lwfinger.net, netrolller.3d@gmail.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 22, 2009 at 09:29, Mike Marchywka <marchywka@hotmail.com> wrote:
>
>
>
> This is the info for the card,
> 04:06.0 Ethernet controller [0200]: Marvell Technology Group Ltd. 88w8335 [Libertas] 802.11b/g Wireless [11ab:1faa] (rev 03)

Oh yes, the WG311 v3

I have grappled with one of these cards in the past. There's been a
couple of efforts (one on my part) to get a working open source driver
off the ground, however none have (yet) borne fruit.

Essentially, your only option is to either use a very specific kernel
version and Marvell's official open source driver, or write your own
from the bits and pieces of the others around.

The Marvell driver can be found here: *note the version number*.
http://git.infradead.org/users/dwmw2/marvell-db64660-2.6.12.6.git

The (non-working) remains of one of the efforts can be found here:
http://git.infradead.org/mrv8k-2.6.git

If you're interested, I can dig up the other bits and pieces I have
and send them to you. (None of these actually work, and the mrv8k
driver is the most complete.)

Also, the hardware may be similar enough to the Marvell TopDog
hardware supported by the in-tree mwl8k driver that it can be used as
a base.

Personally, my solution to the issue of there being no drivers for
this card was to try (and succeed) in making another wireless card I
have work.

> but now that you have me going I would like to find a driver for this too,
>
> 04:07.0 Communication controller [0780]: Conexant Systems, Inc. HSF 56k Data/Fax Modem [14f1:2f20]

You'll have to ask elsewhere for info on that, it doesn't seem to be a
wireless card =)

However, it does seem to be a PCI 56k Modem, which causes the big red
warning lights to flash: it's likely to be a "winmodem" which means
that it's a very *very* dumb card containing a trumped up DAC and ADC
and the absolute minimum hardware to talk on a POTS line. In terms of
drivers, this means that almost all the meat of a modem is implemented
in software, so the driver needs to handle most of the conversion from
data to be sent to the tones to send out on the POTS line *in
software*. There are a couple of winmodem drivers floating around out
there, but, as I understand it, there is no standard for these
devices, so every brand (and possibly model) works differently.

Hopefully you have one of the better supported cards.

Good Luck!

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
