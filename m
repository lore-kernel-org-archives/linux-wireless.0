Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52830 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab0JNRix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 13:38:53 -0400
Received: by ewy20 with SMTP id 20so3699892ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 10:38:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101014171739.GA28522@suse.de>
References: <AANLkTinQMRGkOvi4e4JMsHGV_BF_4Rf5oHCtZgQjwQ1g@mail.gmail.com>
	<20101014165111.GA22130@suse.de>
	<AANLkTin9PxzROyCQxiT5-ca4CUQK+kppS7gAibbbZ2=v@mail.gmail.com>
	<20101014171739.GA28522@suse.de>
Date: Thu, 14 Oct 2010 19:38:49 +0200
Message-ID: <AANLkTimz7xKtz15tVyytxgJ3mQJUNk-=ja-4cJBWJUV8@mail.gmail.com>
Subject: Re: Licensing wlc_phy_radio.h and brcm80211 (was: [PATCH 3/3] b43:
 N-PHY: add 2055 radio regs)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org,
	Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/10/14 Greg KH <gregkh@suse.de>:
> On Thu, Oct 14, 2010 at 07:06:00PM +0200, Rafał Miłecki wrote:
>> 2010/10/14 Greg KH <gregkh@suse.de>:
>> > On Thu, Oct 14, 2010 at 06:40:14PM +0200, Rafał Miłecki wrote:
>> >> W dniu 11 października 2010 18:24 użytkownik Gábor Stefanik
>> >> <netrolller.3d@gmail.com> napisał:
>> >> > Doesn't brcm80211 contain register names for B2055?
>> >>
>> >> I've checked brcm80211 and noticed defines in
>> >> drivers/staging/brcm80211/phy/wlc_phy_radio.h.
>> >>
>> >> Whole brcm80211 driver is licensed as:
>> >> MODULE_LICENSE("Dual BSD/GPL");
>> >>
>> >> Mentioned file contains following comments:
>> >> +/*
>> >> + * Copyright (c) 2010 Broadcom Corporation
>> >> + *
>> >> + * Permission to use, copy, modify, and/or distribute this software for any
>> >> + * purpose with or without fee is hereby granted, provided that the above
>> >> + * copyright notice and this permission notice appear in all copies.
>> >>
>> >> Our b43 driver is licensed as:
>> >> MODULE_LICENSE("GPL");
>> >> and I am not sure if permission above is actually GPL-compatible. The
>> >> best option would be to add defines from wlc_phy_radio.h and include
>> >> Broadcom's copyright. However comment above wants us to include info
>> >> about free copying/modifying/using which is not GPL-compatible.
>> >>
>> >> Is there any way to solve this issue?
>> >
>> > I don't understand, are you just wanting to use the names in the .h file
>> > for the registers?
>>
>> Yes. I want to put lines like:
>> #define RADIO_2056_RX0                                (0x6 << 12)
>> in my radio_2056.h
>
> I don't think that bitfields are copyrightable :)

What about rest of the code? brcm80211 seems to support even newer
devices we don't even try to support in b43 yet.

Can I treat code as pure-GPL and do not care about that
maybe-not-GPL-compatible statement in header?


>> > If so, why?  You don't want to support the same devices in the b43
>> > driver that the brcm80211 driver does, do you?
>>
>> I do. I see many advantages of that plus most of the code is already
>> here coming from RE.
>
> "RE"?

Reverse-engineering. (Almost?) whole b43 was written using
clean-room-reverse-engineering. Code is based on specs from
http://bcm-v4.sipsolutions.net/ .


-- 
Rafał
