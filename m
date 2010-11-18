Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:59433 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756767Ab0KRQrt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 11:47:49 -0500
Subject: Re: [PATCH] ssb: fail registration for unknown SPROM revision
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
In-Reply-To: <AANLkTimh_8X1uRPudmQLDOTeA_X0ciR9BbDgyahLDMSs@mail.gmail.com> (sfid-20101118_174421_892253_3B53C8D3)
References: <1288823326-9686-1-git-send-email-zajec5@gmail.com>
	 <1288823326-9686-2-git-send-email-zajec5@gmail.com>
	 <20101116212321.GF10774@tuxdriver.com> <1290013976.2513.14.camel@maggie>
	 <20101118162748.GB2468@tuxdriver.com> <1290098156.12596.2.camel@maggie>
	 <AANLkTimh_8X1uRPudmQLDOTeA_X0ciR9BbDgyahLDMSs@mail.gmail.com>
	 (sfid-20101118_174421_892253_3B53C8D3)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 17:47:45 +0100
Message-ID: <1290098865.12596.6.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-18 at 17:44 +0100, Rafał Miłecki wrote: 
> 2010/11/18 Michael Büsch <mb@bu3sch.de>:
> >> [ 1036.293865] ssb: Unsupported SPROM  revision 255 detected. Will extract v1
> >
> > So what about specialcasing 255 instead of defaulting to 1 in general?
> >
> > if (rev == 255)
> > rev = 1;
> >
> > 255 basically means "Vendor forgot to set this field". So it would only
> > default to 1 for those broken sproms.
> 
> Will work as long as there won't appear new vendor who will forget to
> set this and will use new SPROM...

The old code will break for that, too.

> But hopefully it won't happen and it should not hurt too much to
> register device with incorrectly parsed SPROM.

If it would really succeed to initialize the device, this would be a
regulatory issue, because the sprom contains various power amplifier
calibration data. I think it should rather fail and be fixed correctly
instead of incorrectly using rev1 in that case.

-- 
Greetings Michael.

