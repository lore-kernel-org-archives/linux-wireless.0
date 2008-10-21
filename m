Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42789 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbYJUSVZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 14:21:25 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2008 11:21:25 -0700
Date: Tue, 21 Oct 2008 04:21:18 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Tomas Winkler <tomasw@gmail.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: New Regulatory Domain Api.
Message-ID: <20081021112118.GC8224@tesla> (sfid-20081021_202147_252453_04CECA61)
References: <1224561748.24677.274.camel@debian.sh.intel.com> <43e72e890810202158m197b52a8y98844fdc9e1ccfd8@mail.gmail.com> <1224569252.9386.77.camel@californication> <43e72e890810202329g732a97ccxf176bdf4e035ccda@mail.gmail.com> <1224571890.9386.85.camel@californication> <20081021171328.GG17268@tuxdriver.com> <1224611033.9386.98.camel@californication> <20081021174800.GJ17268@tuxdriver.com> <20081021110203.GA8224@tesla> <20081021180512.GK17268@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20081021180512.GK17268@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2008 at 11:05:12AM -0700, John W. Linville wrote:
> On Tue, Oct 21, 2008 at 04:02:03AM -0700, Luis R. Rodriguez wrote:
> > On Tue, Oct 21, 2008 at 10:48:00AM -0700, John W. Linville wrote:
> > > On Tue, Oct 21, 2008 at 07:43:53PM +0200, Marcel Holtmann wrote:
> > >
> > > > > > No we can't have a new (or updated) driver require new userspace. If you
> > > > > > install a 2.6.30 kernel on an Ubuntu Hardy system, it should make the
> > > > > > hardware work without installing an extra userspace component. And yes,
> > > > > > it works for the first card if it provides a regulatory hint, but it
> > > > > > should also work for the second card.
> > > > >
> > > > > That is what WIRELESS_OLD_REGULATORY is for, no?
> > > >
> > > > but that would go away with 2.6.29 if it proceeds as planned.
> > >
> > > I don't see a huge maintenance burden to it the way it is implemented
> > > now.  I know Luis will hate the idea, but perhaps we could just let
> > > it linger indefinitely?
> >
> > This thread has about 65 messages on it, and no patches yet from Intel.
> > I rather we talk productively about trying to resolve it with actual
> > code like Johannes or I am. OLD_REGULATORY should still go IMO.
> 
> Ok, but it isn't clear to me that any patch will resolve the issue of
> someone running a new kernel on an old userland unless OLD_REGULATORY
> is enabled...?

IMHO its a worthy compromise to use only the world regulatory domain
by default it no crda is present for *new drivers*, yes its restrictive,
but that is the idea. It also pushes distributions to embrace crda, and
realisticaly who is not going to have it? What prevents old distributions
from using this? We're not breaking old drivers, we're enhacing new
drivers so the logic behind this argument is just flawed.

If it is deemed we don't care about this compromise for new drivers
that is a different story. A middle solution is to move a few common
db.txt regulatory domains staticaly into the kernel but of course this
is also biased towards those countries.

On my v2 approach to regulatory support I had added a whole bunch
of generic countries staticaly into the kernel and then people opposed
to that so we moved it now to userspace as they these can change dynamically
and now people complain? Make up your mind. This has been reviewed for
a while now and when a particular case comes up and people complain
without patches we consider it?

  Luis
