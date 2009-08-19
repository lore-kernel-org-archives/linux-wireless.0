Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49192 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbZHSTwz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 15:52:55 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 12:52:58 -0700
Date: Wed, 19 Aug 2009 12:52:56 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v5 00/33] wireless: kconfig updates
Message-ID: <20090819195255.GA8441@mosca>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
 <20090819150138.GB5905@tuxdriver.com>
 <20090819180235.GA7126@mosca>
 <20090819183506.GG5905@tuxdriver.com>
 <43e72e890908191150h6fa8a811u30c57420afd17e08@mail.gmail.com>
 <b6c5339f0908191208m2aef3305lcb4cadabeb72733f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <b6c5339f0908191208m2aef3305lcb4cadabeb72733f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 19, 2009 at 12:08:38PM -0700, Bob Copeland wrote:
> On Wed, Aug 19, 2009 at 2:50 PM, Luis R.
> Rodriguez<lrodriguez@atheros.com> wrote:
> 
> > Well so to group all of Intel stuff we do need this, at least I can't
> > think of a way to do it. If we don't want to group intel stuff then we
> > can remove it. Is there a downside to this grouping, for example?
> 
> One (admittedly hand-wavy) argument against vendor grouping is that you
> don't always know who made the chip.  So you have CompanyA buying CompanyB's
> IP, making a product, and then we write a driver for CompanyA's device
> called awifi2000.  Meanwhile CompanyB sells it to CompanyC too so their
> "C Wifi Plus" product happens to work with the awifi2000 driver.  Now you
> have to reorg the menus to put it under CompanyB.
> 
> I imagine this is a lot less likely with wireless, if you know enough to
> write a driver, you usually know who made it.  But ISTR it happened a lot
> with v4l stuff since there are more commodity parts on those cards.

Right, good point. This happend with Intersil stuff, which was bought by
Globespan Virata, who then quickly sold it to Conexant, and then Conexant
seems to have sold off some stuff to STEricson. What I did in this case
was just label this as:

 "Intersil / Conexant / STEricsson"

Now granted Globespan also was part of this tree but I'm not aware of them
doing anything with the IP except selling it.

I expect developers, distribution developers, and users to configure the
kernel. So I already do expect at least some familiarity with your hardware
and configuring your kernel. "IP" tends to get rebranded on products, the
old "prism" named seemed to vanish in later products, for example, but as
you indicated we kept the tradition in the old prism54 driver name and
labelled the Conexant based devices as p54.

I can't think of any other way to group this stuff to help developers,
distributions and users than by grouping by manufacturer. Novice users
could just boot a distro kernel and run 'make localmodconfig' [1] and
find out what they really had, so I see the group'ing part more of a
logical aid for those maintaining the drivers and the tree.

But again, just my take on it.

[1] http://lwn.net/Articles/347611/

  Luis
