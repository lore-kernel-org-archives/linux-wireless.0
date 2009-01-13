Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:29423 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854AbZAMWHf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 17:07:35 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 14:07:35 -0800
Date: Tue, 13 Jan 2009 14:07:09 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
CC: Ivo van Doorn <ivdoorn@gmail.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rt2400-devel@lists.sourceforge.net"
	<rt2400-devel@lists.sourceforge.net>
Subject: Re: [PATCH] rt2x00: Provide regulatory hint with rt2500pci/usb
Message-ID: <20090113220708.GS4416@tesla> (sfid-20090113_230740_308941_180CFC85)
References: <200901042021.10904.IvDoorn@gmail.com> <4963C186.2070408@kpnplanet.nl> <20090106204923.GC21980@tesla> <200901062251.28850.IvDoorn@gmail.com> <4963D704.5030502@kpnplanet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4963D704.5030502@kpnplanet.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 06, 2009 at 02:11:16PM -0800, Gertjan van Wingerde wrote:
> On 01/06/09 22:51, Ivo van Doorn wrote:
> > On Tuesday 06 January 2009, Luis R. Rodriguez wrote:
> >>>>
> >>>> Gertjan, do you know if there is any hardware with valid GEO data in the EEPROM?
> >>>>
> >>>>
> >>> As mentioned in my previous email, I do have devices that have valid GEO
> >>> data in the EEPROM. So, we should be able to use that.
> >>> Also, for the dual band cards, it does seem that at least the numerical
> >>> values are similar for both bands (although I'm not sure that same
> >>> numerical values means same regulatory domain). This is at least the
> >>> case on all the cards that I own.
> >>>
> >> If that's the case and since dual band cards will most likely have 2ghz support
> >> why not just provide regulatory_hint() based on the 2ghz band all the time?
> >>
> >
> > Sounds like the most reasonable solution to me as well.
> 
> I had a *slightly* more sophisticated model in mind: Check for dual-band
> devices whether the EEPROM values match. If they do, provide the
> regulatory_hint(), if they don't then just log an error, stating that
> the EEPROM cannot make up its mind in which geography it belongs. Just
> to prevent some unexpected behavior for devices that don't have sane
> EEPROM values.

The documentation advises for the EEPROM to not be relied on though
so if you expect the EEPROM regulatory domain code to be valid you
are going against the documentation.

> However, that is all based on the assumption that we can match the
> numerical values of the two band geography domains. So far I haven't
> been able to establish that, and, moreover, the a-band field allows for
> values 0-10 where the bg-band field allows for values 0-7. So, we have
> to start matching these values against their defined allowed channels,
> and against the regulatory definitions, to see if we can actually match
> the values.

Yeah -- pretty messy...

BTW you may want to look at the patch:

[PATCH 05/12] cfg80211: add regulatory_set_custom_rd()

Which you can also use if you have very custom regulatory domains which
you must follow. We are using that for world regulatory domains which
are custom, for example. I would advise against using this for a country
regulatory hint but if you have no other option then that can be used.

I'm still inclined to believe the documentation though -- again you may
want to check with the vendor.

  Luis
