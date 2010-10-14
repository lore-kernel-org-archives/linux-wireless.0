Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756177Ab0JNWJi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 18:09:38 -0400
Subject: Re: Licensing wlc_phy_radio.h and brcm80211 (was: [PATCH 3/3] b43:
 N-PHY: add 2055 radio regs)
From: Dan Williams <dcbw@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	=?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org,
	Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>
In-Reply-To: <20101014171739.GA28522@suse.de>
References: <AANLkTinQMRGkOvi4e4JMsHGV_BF_4Rf5oHCtZgQjwQ1g@mail.gmail.com>
	 <20101014165111.GA22130@suse.de>
	 <AANLkTin9PxzROyCQxiT5-ca4CUQK+kppS7gAibbbZ2=v@mail.gmail.com>
	 <20101014171739.GA28522@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 17:12:40 -0500
Message-ID: <1287094360.22636.6.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-14 at 10:17 -0700, Greg KH wrote:
> On Thu, Oct 14, 2010 at 07:06:00PM +0200, Rafał Miłecki wrote:
> > 2010/10/14 Greg KH <gregkh@suse.de>:
> > > On Thu, Oct 14, 2010 at 06:40:14PM +0200, Rafał Miłecki wrote:
> > >> W dniu 11 października 2010 18:24 użytkownik Gábor Stefanik
> > >> <netrolller.3d@gmail.com> napisał:
> > >> > Doesn't brcm80211 contain register names for B2055?
> > >>
> > >> I've checked brcm80211 and noticed defines in
> > >> drivers/staging/brcm80211/phy/wlc_phy_radio.h.
> > >>
> > >> Whole brcm80211 driver is licensed as:
> > >> MODULE_LICENSE("Dual BSD/GPL");
> > >>
> > >> Mentioned file contains following comments:
> > >> +/*
> > >> + * Copyright (c) 2010 Broadcom Corporation
> > >> + *
> > >> + * Permission to use, copy, modify, and/or distribute this software for any
> > >> + * purpose with or without fee is hereby granted, provided that the above
> > >> + * copyright notice and this permission notice appear in all copies.
> > >>
> > >> Our b43 driver is licensed as:
> > >> MODULE_LICENSE("GPL");
> > >> and I am not sure if permission above is actually GPL-compatible. The
> > >> best option would be to add defines from wlc_phy_radio.h and include
> > >> Broadcom's copyright. However comment above wants us to include info
> > >> about free copying/modifying/using which is not GPL-compatible.
> > >>
> > >> Is there any way to solve this issue?
> > >
> > > I don't understand, are you just wanting to use the names in the .h file
> > > for the registers?
> > 
> > Yes. I want to put lines like:
> > #define RADIO_2056_RX0				(0x6 << 12)
> > in my radio_2056.h
> 
> I don't think that bitfields are copyrightable :)

Right.  If you're just looking to include constants then you can copy
and paste them all over the place.  It might be nice give Broadcom a
shout-out in the header, but pure numbers like this (command
definitions, register values, bitfields, constants, etc) simply aren't
copyrightable, just like you can't copyright a telephone book.

Dan


