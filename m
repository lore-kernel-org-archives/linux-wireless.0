Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:41615 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYJUGul (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 02:50:41 -0400
Subject: Re: New Regulatory Domain Api.
From: Marcel Holtmann <holtmann@linux.intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890810202329g732a97ccxf176bdf4e035ccda@mail.gmail.com>
References: <20081015112517.GF6509@tesla>
	 <1224487340.24677.192.camel@debian.sh.intel.com>
	 <1224520999.9386.72.camel@californication>
	 <1224552899.24677.245.camel@debian.sh.intel.com>
	 <43e72e890810201842o44db616ekd8d5bc66cd1006f@mail.gmail.com>
	 <1224554323.24677.248.camel@debian.sh.intel.com>
	 <43e72e890810201937l3be24156t2172590138fda132@mail.gmail.com>
	 <1224561748.24677.274.camel@debian.sh.intel.com>
	 <43e72e890810202158m197b52a8y98844fdc9e1ccfd8@mail.gmail.com>
	 <1224569252.9386.77.camel@californication>
	 <43e72e890810202329g732a97ccxf176bdf4e035ccda@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 08:51:30 +0200
Message-Id: <1224571890.9386.85.camel@californication> (sfid-20081021_085044_842338_7905F406)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> >> Old userspace still works, we can however require new userspace for
> >> new features. A compliant regulatory infrastructure is a feature.
> >
> > how does an old userspace with a new kernel works?
> 
> It works by allowing by default only what is allowed in the world
> regulatory domain.
> 
> > If we essentially
> > disable hardware by not having the userspace in place, then that is not
> > a solution.
> 
> We are not disabling hardware, we are adding a common regulatory
> infrastructure to new cfg80211/mac80211 based drivers. We are not
> touching the old drivers.

the old drivers will change over time and adapt the new infrastructure.
So this is not even a valid point.

> > We have to be able to install a new or development kernel on
> > an old distro without having to install crda/iw or updating udev or
> > whatever.
> 
> And you can use new kernels on old distributions with old wireless
> drivers, however new mac80211 based drivers can reasonably require new
> userspace utilities, and in this case we have a new userspace
> requirement *only* when cfg80211/mac80211 based drivers do not provide
> their own regutory_hint() or in the particular case outlined in this
> thread. Additionally this new feature allows users who want to be more
> compliant to do so by s specifying a country.

No we can't have a new (or updated) driver require new userspace. If you
install a 2.6.30 kernel on an Ubuntu Hardy system, it should make the
hardware work without installing an extra userspace component. And yes,
it works for the first card if it provides a regulatory hint, but it
should also work for the second card.

> Udev was used based on your suggestion BTW, I was the one suggesting
> to not use it because of the possibility of no udevd  present.

And in that case we have /sbin/hotplug. That is also not what I am
talking about here.

Regards

Marcel


