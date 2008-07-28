Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbYG1PAE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 11:00:04 -0400
Subject: Re: [PATCH 1/6] mac80211: allow no mac address until firmware load
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240807280744r5ea8c58aqf53cc99abb4cf084@mail.gmail.com>
References: <48763814.27052c0a.1794.2095@mx.google.com>
	 <200807281544.33509.mb@bu3sch.de>
	 <1217253465.28198.20.camel@localhost.localdomain>
	 <200807281625.58188.mb@bu3sch.de>
	 <1ba2fa240807280744r5ea8c58aqf53cc99abb4cf084@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 10:57:45 -0400
Message-Id: <1217257065.28198.25.camel@localhost.localdomain> (sfid-20080728_170035_354698_591D1D26)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-07-28 at 17:44 +0300, Tomas Winkler wrote:
> On Mon, Jul 28, 2008 at 5:25 PM, Michael Buesch <mb@bu3sch.de> wrote:
> > On Monday 28 July 2008 15:57:45 Dan Williams wrote:
> >> > (What are the udev problems, btw?)
> >>
> >> People seem to want persistent device names.  Since the kernel doesn't
> >> provide stable device/bus enumeration, there are udev hacks (see
> >> attached from Fedora 9) that read the MAC address of the card on
> >> hot-plug and then assign it to a cached device name so that every time I
> >> plug in my Netgear MA401 it gets "eth2".
> >
> > Yeah well. But using a pseudo-random MAC as a base to build a persistent
> > naming scheme on sounds pretty fragile to me. ;)
> >
> > I think cards that don't supply MAC early simply cannot support
> > a really working persistent naming scheme well. udev should probably
> > just enumerate eth0 - ethX as it sees the devices. That's as good
> > as mixing a numbering scheme into a pseudo MAC, IMO. And it's
> > less confusing and it pushes a lot of policy decisions into userspace.
> 
> Can devices supply something depending on its bus numbering that will
> not change unless it's plugged out.

No, because it's precisely the bus numbering that the kernel might
change on you.  You're not guaranteed persistent device enumeration in
the kernel, and the only thing you could rely on is some sort of UUID of
the hardware itself, which in the case of network devices is the MAC
address.  If you have no MAC address then you don't get a persistent
name.

Dan


