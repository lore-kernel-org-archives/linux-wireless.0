Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:18972 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbYGALBC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 07:01:02 -0400
Received: by ug-out-1314.google.com with SMTP id h2so378401ugf.16
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2008 04:01:00 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt61 and TSF reporting?
Date: Tue, 1 Jul 2008 13:05:18 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1214907990.7763.40.camel@johannes.berg> <200807011247.57739.IvDoorn@gmail.com> <1214909314.7763.43.camel@johannes.berg>
In-Reply-To: <1214909314.7763.43.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807011305.18802.IvDoorn@gmail.com> (sfid-20080701_130111_936313_44188E4F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 01 July 2008, Johannes Berg wrote:
> Hi,
> 
> > The specsheets say nothing about TSF timestamps anywhere else then
> > the registers (which is accessed by the get_tsf() callback function).
> > To be more exact, the specsheets say _nothing_ about the RXD descriptors at all,
> > which means they are not helpful for that. ;)
> 
> Heh.
> 
> > However there are a few RXD fields which are labeled as "reserved" which could
> > mean the field is present, just not documented.
> > 
> > You could try printing the values of those words to see if they contain valid data,
> > and to be more exact the TSF data (this can be done in the function rt61pci_fill_rxdone(...))
> > The undocumented/reserved words are: 6 to 15
> > 
> > Do you want me to come up with a patch for this?
> > 
> > Note that these undocumented fields only are present in rt2500pci and rt61pci.
> 
> Ok cool, I'll play with that, I should be able to make a patch myself,
> thanks.

Oh wait, just found a reference about those RXD words:

 * The following fields are for DMA block and HOST usage only.
 * Can't be touched by ASIC MAC block.

In other words, they are for driver usage only. :S

> > Neither rt2500usb or rt73usb contain them, which means that they can't report the TSF
> > based on descriptor information.
> 
> So I guess they just don't transfer those reserved fields on USB.

Which means they are pretty much screwed for TSF handling since get_tsf() has been disabled
for USB drivers due to the atomic requirements of that callback function.. :S

Ivo
