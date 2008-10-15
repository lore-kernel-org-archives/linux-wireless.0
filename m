Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15095 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbYJPAIi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 20:08:38 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2008 17:08:38 -0700
Date: Wed, 15 Oct 2008 10:08:30 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Tomas Winkler <tomasw@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Zhu Yi <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: New Regulatory Domain Api.
Message-ID: <20081015170830.GA15902@tesla> (sfid-20081016_020843_391903_E68CF14E)
References: <1224019662.3027.13.camel@johannes.berg> <1224085609.4764.18.camel@californication> <1224086374.735.4.camel@johannes.berg> <1224091577.28173.9.camel@californication> <43e72e890810151039s34ad8d79nd2744847dd254b4e@mail.gmail.com> <1224092868.28173.21.camel@californication> <20081015112517.GF6509@tesla> <1224098748.28173.32.camel@californication> <20081015131622.GH6509@tesla> <1ba2fa240810151631t37edc367hfe59c76926c7b82e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1ba2fa240810151631t37edc367hfe59c76926c7b82e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2008 at 04:31:20PM -0700, Tomas Winkler wrote:
> On Wed, Oct 15, 2008 at 3:16 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Wed, Oct 15, 2008 at 12:25:48PM -0700, Marcel Holtmann wrote:
> >> > The problem here is not this though the problem here is the case
> >> > where people are using 2.6.28 without no iw or crda *and* have more
> >> > than two cards :)
> >>
> >> it might sound like an unlikely case and it will most likely only be the
> >> A-band usage anyway, but it is a valid case. People with old laptops do
> >> use newer wireless cards in PCMCIA or USB form factor to get better WiFi
> >> performance and/or stability. In some cases you can just replace your
> >> internal card, but with the switch from MiniPCI to half-MiniPCI this is
> >> not as likely anymore. So the use of a second external card becomes more
> >> likely.
> >
> > Right, and the proposed solution I had was to use an intersection
> > between two regulatory domains. This solution just doesn't currently
> > work well with Intel cards due to the capability <-> regulatory one to
> > one mapping.
> 
> This  might be viewed this way but this is not concept behind it.
> First Intel HW enforce regulatory domain written in the EEPROM, which
> makes it in your sense capability even it's not.

I see.

> Second Intel uses special regulatory domains called MOW1 and MOW2
> (most of the world 1 and 2) + possible restriction to BG. These 3
> domains/capabilities should be restrictive enough comply with most of
> the world regulatory restrictions.

Well to meet your current SKUs requirements :)

> There is no real hint for specific
> regulatory domain that can be applied form this, the concept is that
> you should be move relatively freely around the globe without changing
> anything.

The issue was your single band cards do not store 5 GHz band regulatory
information. Is this MOW1 or MOW2?

> You really have to use some other source to specify regulatory domain
> it's cannot be retrieved from the MOW SKU's.

Right, do you have any other source for location or that you can
make this implication from your devices?

> The only exception in
> Intel cards are JP and KR SKU's which are real regulatory domains.

What makes them "real" BTW?

> Just my two cents, probably didn't help to solve the problem,

It certainly helps more understand your situation. I had no idea
of MOW1 and MOW2. Can this be documented as part of the
regulatory_hint() code changes which will be added?

  Luis
