Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:57999 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab0JNRSS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 13:18:18 -0400
Date: Thu, 14 Oct 2010 10:17:39 -0700
From: Greg KH <gregkh@suse.de>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org,
	Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>
Subject: Re: Licensing wlc_phy_radio.h and brcm80211 (was: [PATCH 3/3] b43:
 N-PHY: add 2055 radio regs)
Message-ID: <20101014171739.GA28522@suse.de>
References: <AANLkTinQMRGkOvi4e4JMsHGV_BF_4Rf5oHCtZgQjwQ1g@mail.gmail.com>
 <20101014165111.GA22130@suse.de>
 <AANLkTin9PxzROyCQxiT5-ca4CUQK+kppS7gAibbbZ2=v@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTin9PxzROyCQxiT5-ca4CUQK+kppS7gAibbbZ2=v@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 14, 2010 at 07:06:00PM +0200, Rafał Miłecki wrote:
> 2010/10/14 Greg KH <gregkh@suse.de>:
> > On Thu, Oct 14, 2010 at 06:40:14PM +0200, Rafał Miłecki wrote:
> >> W dniu 11 października 2010 18:24 użytkownik Gábor Stefanik
> >> <netrolller.3d@gmail.com> napisał:
> >> > Doesn't brcm80211 contain register names for B2055?
> >>
> >> I've checked brcm80211 and noticed defines in
> >> drivers/staging/brcm80211/phy/wlc_phy_radio.h.
> >>
> >> Whole brcm80211 driver is licensed as:
> >> MODULE_LICENSE("Dual BSD/GPL");
> >>
> >> Mentioned file contains following comments:
> >> +/*
> >> + * Copyright (c) 2010 Broadcom Corporation
> >> + *
> >> + * Permission to use, copy, modify, and/or distribute this software for any
> >> + * purpose with or without fee is hereby granted, provided that the above
> >> + * copyright notice and this permission notice appear in all copies.
> >>
> >> Our b43 driver is licensed as:
> >> MODULE_LICENSE("GPL");
> >> and I am not sure if permission above is actually GPL-compatible. The
> >> best option would be to add defines from wlc_phy_radio.h and include
> >> Broadcom's copyright. However comment above wants us to include info
> >> about free copying/modifying/using which is not GPL-compatible.
> >>
> >> Is there any way to solve this issue?
> >
> > I don't understand, are you just wanting to use the names in the .h file
> > for the registers?
> 
> Yes. I want to put lines like:
> #define RADIO_2056_RX0				(0x6 << 12)
> in my radio_2056.h

I don't think that bitfields are copyrightable :)

> > If so, why?  You don't want to support the same devices in the b43
> > driver that the brcm80211 driver does, do you?
> 
> I do. I see many advantages of that plus most of the code is already
> here coming from RE.

"RE"?

> Finishing N-PHY support in b43 does not need much work plus:
> 1) We support SSB devices
> 2) We support older (LP/G-phy) devices
> 3) We share infrastructure (easier to maintain)
> 4) We probably could support modes like AP

If that would be a simpler task than trying to clean up the brcm80211
driver, that seems quite reasonable.

Henry, Brett, Nohee, what do you think about this?

thanks,

greg k-h
