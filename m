Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:45799 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbYFJPDJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 11:03:09 -0400
Date: Tue, 10 Jun 2008 18:02:27 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80211_hwsim - simulator of 802.11 radios for mac80211
Message-ID: <20080610150227.GA4913@jm.kir.nu> (sfid-20080610_170313_446773_6DC27805)
References: <20080610105058.GA6961@jm.kir.nu> <1213096575.3668.6.camel@johannes.berg> <20080610124724.GB6961@jm.kir.nu> <1213103378.3668.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213103378.3668.10.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2008 at 03:09:38PM +0200, Johannes Berg wrote:

> I don't think there are large pending changes, but there were large
> changes in the way channels are registered, tx control works etc.

OK.

> You should probably use the _irqsafe versions of rx and txstatus too.

Hmm.. That was interesting.. Changing txstatus to use _irqsafe is was
fine, but changing ieee80211_rx to ieee80211_rx_irqsafe triggers
something bad.. Loadavg jumps sky high the moment I kill hostapd and
ksoftirqd/0 and rmmod (which I ran after killing hostapd) are taking all
CPU.. I can hardly type a command at that point. Looks like something
goes horribly wrong with the extra queuing with ieee80211_rx_irqsafe.
Maybe sending something to a netdev that is down ends up in a busy loop
with a frame or something. In other words, I did not change to use
_irqsafe yet, but will do once I have more time to figure out what on
earth is going on here.

> > Yes, I've been thinking of something similar, too. I'll add a netdev
> > that gets all frames with radiotap header.
> 
> Maybe it could support injection on that too, so you can test against a
> userspace agent.

Yes, I added the global radiotap monitor to hwsim (ifname=hwsim#) and
left the hard_xmit function empty with a TODO comment.. The netdev from
outside mac80211 is quite useful since it can be set up before any of
the mac80211 netdevs and it is possible to capture all frames from the
beginning.. If needed, we could add some more flags to the radiotap
header for indicating what was done with the frame, but that is
something that can easily be added later.

> The design I had come up with a long time ago allowed userspace to
> control each radio by having each _radio_ have a raw netdev like this
> and not doing forwarding in the kernel but relying on some userspace
> tool, but I guess that much more complicated.

That might be useful for some of the tests. I was interested in adding
some kind of interface to make it easy to design test cases from user
space, but the current code was so simple that I did not want to make it
any more complex in the first version. Anyway, it might make sense to
provide option mechanism to allow more user space control since I'm also
interested in things like testing rate control with a programmable
signal strength/channel quality and I do not really want to see the
controller for that simulation in the kernel..

-- 
Jouni Malinen                                            PGP id EFC895FA
