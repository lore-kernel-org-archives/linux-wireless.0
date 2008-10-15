Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:62143 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbYJORjh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 13:39:37 -0400
Received: by gxk9 with SMTP id 9so7172691gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2008 10:39:36 -0700 (PDT)
Message-ID: <43e72e890810151039s34ad8d79nd2744847dd254b4e@mail.gmail.com> (sfid-20081015_193945_074185_938BF563)
Date: Wed, 15 Oct 2008 10:39:35 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: New Regulatory Domain Api.
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224091577.28173.9.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <1223969808.2570.153.camel@debian.sh.intel.com>
	 <43e72e890810140204ne135e72kefe379dd3d26f7bc@mail.gmail.com>
	 <20081014203510.GD3349@tuxdriver.com>
	 <1224018957.3027.9.camel@johannes.berg>
	 <20081014211912.GF3349@tuxdriver.com>
	 <1224019662.3027.13.camel@johannes.berg>
	 <1224085609.4764.18.camel@californication>
	 <1224086374.735.4.camel@johannes.berg>
	 <1224091577.28173.9.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2008 at 10:26 AM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:

> I can see it useful when companies actually start building products with
> two or more cards in the system and have different cards for different
> tasks in it. So if you stick one card for one band and another one for
> the other band in there, then it would make sense to do a per-band
> regulatory hinting.

Sure, but custom solutions can require custom regulatory dbs and
people can do any crazy thing they want here, just as when they need
custom regulatory domains not allowed by the FCC in the USA for
example. Remember that by default the design is trying to cover the
usual scenario of users with 1 wireless card or 2 with one built in.
We decided on our discussions to respect the built-in card first. For
more cards we can take the intersection if we want to keep being more
restrictive. Its what makes sense if you think about it.

> Not sure if this really ever ends up in a product. However I can see the
> case where you have a laptop with a BG-card and then attach an A-card to
> it do access an A-network and then it doesn't work. It would be nice to
> just have this working. Currently this would not work.

Yes it does, it just doesn't work for your hardware as Intel put into
regulatory hardware capability and these are two *very* different
things. That is the problem.

My suggestion is to add a default minimal 5 GHz regulatory domain
definition to your driver on single band cards to deal with this. When
a dual band card is present then all of the full card's capabilities
will be used.

> Also the case when we unplug the first card, does the regulatory hint
> gets reset and the next card could bring in a new one? I can see use
> cases where you don't wanna use the built-in card, because it is just
> too limited.

For now nl80211 supports changing regulatory domains.

  Luis
