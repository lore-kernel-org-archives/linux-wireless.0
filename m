Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.185]:4860 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYJOSLl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 14:11:41 -0400
Received: by rn-out-0910.google.com with SMTP id k40so1307717rnd.17
        for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2008 11:11:38 -0700 (PDT)
Message-ID: <43e72e890810151111h3b0c772ay5fa49709a4451454@mail.gmail.com> (sfid-20081015_201148_212339_676D4405)
Date: Wed, 15 Oct 2008 11:11:38 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: New Regulatory Domain Api.
Cc: "Marcel Holtmann" <holtmann@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224092724.735.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081014203510.GD3349@tuxdriver.com>
	 <1224018957.3027.9.camel@johannes.berg>
	 <20081014211912.GF3349@tuxdriver.com>
	 <1224019662.3027.13.camel@johannes.berg>
	 <1224085609.4764.18.camel@californication>
	 <1224086374.735.4.camel@johannes.berg>
	 <1224091577.28173.9.camel@californication>
	 <43e72e890810151039s34ad8d79nd2744847dd254b4e@mail.gmail.com>
	 <1224092724.735.21.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2008 at 10:45 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-10-15 at 10:39 -0700, Luis R. Rodriguez wrote:
>
>> We decided on our discussions to respect the built-in card first. For
>> more cards we can take the intersection if we want to keep being more
>> restrictive. Its what makes sense if you think about it.
>
> I'm not really too sure the intersection makes most sense, we mostly
> used the first hint because it's likely to be from the built-in card,
> ergo announcing a region for which the whole product was certified. If
> you add a card, we basically don't trust it currently.

Right but we do trust it if its the only card present. And as for
conflicts -- this is exactly why we let users set the regulatory
domain too. Intersection is just a default catious policy we can take
to deal with conflicts of different sorts. Can you think of a better
solution? Remember the real issue here is when regulatory domain
information is tainted by having just capability information instead
on a regulatory hint.

>> My suggestion is to add a default minimal 5 GHz regulatory domain
>> definition to your driver on single band cards to deal with this. When
>> a dual band card is present then all of the full card's capabilities
>> will be used.
>
> Unfortunately, there's no such thing as a default minimal 5 GHz
> regulatory domain.

For World, yes, you are right, but for "all SKUs we sell our products
in", this can make sense if all SKUs do support 5GHz.

> This might work with systems built purely out of
> Intel cards, but to be honest, I wouldn't want to see this because it
> would mean that if you add a dual-band prism54 USB then it'll start
> sending on those 5 GHz channels regardless of where you are and what
> you're allowed to do.

Well dual band p54 wouldn't have this AFAICT. But yeah I agree -- this
is why I think its better to promote patches for NM/distributions to
set the regulatory domain through nl80211 (or iw) for the country the
user resides on. Maybe for now something as simple as adding as part
of the init scripts an iw line which sets the regulatory domain on an
alpha2 if the distribution can determine it? This really later should
be part of NM or something else which can definitely make use of a
real alpha2 the user set.

  Luis
