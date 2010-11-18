Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48209 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759428Ab0KRQoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 11:44:12 -0500
Received: by vws13 with SMTP id 13so1778350vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 08:44:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290098156.12596.2.camel@maggie>
References: <1288823326-9686-1-git-send-email-zajec5@gmail.com>
	<1288823326-9686-2-git-send-email-zajec5@gmail.com>
	<20101116212321.GF10774@tuxdriver.com>
	<1290013976.2513.14.camel@maggie>
	<20101118162748.GB2468@tuxdriver.com>
	<1290098156.12596.2.camel@maggie>
Date: Thu, 18 Nov 2010 17:44:12 +0100
Message-ID: <AANLkTimh_8X1uRPudmQLDOTeA_X0ciR9BbDgyahLDMSs@mail.gmail.com>
Subject: Re: [PATCH] ssb: fail registration for unknown SPROM revision
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/18 Michael Büsch <mb@bu3sch.de>:
> On Thu, 2010-11-18 at 11:27 -0500, John W. Linville wrote:
>> On Wed, Nov 17, 2010 at 06:12:56PM +0100, Michael Büsch wrote:
>> > On Tue, 2010-11-16 at 16:23 -0500, John W. Linville wrote:
>> > > > -               ssb_printk(KERN_WARNING PFX "Unsupported SPROM"
>> > > > -                          "  revision %d detected. Will extract"
>> > > > -                          " v1\n", out->revision);
>> > > > -               out->revision = 1;
>> > > > -               sprom_extract_r123(out, in);
>> > > > +               ssb_printk(KERN_ERR PFX "Unsupported SPROM revision %d"
>> > > > +                          " detected\n", out->revision);
>> > > > +               return -EINVAL;
>> > > >         }
>> > > >
>> > > >         if (out->boardflags_lo == 0xFFFF)
>> > >
>> > > I think this is going to make my b43 PCI-E card not work...I'll try
>> > > it and get back to you...
>> >
>> > Hm, what version does it report?
>
>> [ 1036.293865] ssb: Unsupported SPROM  revision 255 detected. Will extract v1
>
> So what about specialcasing 255 instead of defaulting to 1 in general?
>
> if (rev == 255)
> rev = 1;
>
> 255 basically means "Vendor forgot to set this field". So it would only
> default to 1 for those broken sproms.

Will work as long as there won't appear new vendor who will forget to
set this and will use new SPROM...

But hopefully it won't happen and it should not hurt too much to
register device with incorrectly parsed SPROM.

-- 
Rafał
