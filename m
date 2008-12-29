Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49120 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbYL2QSo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 11:18:44 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2008 08:18:44 -0800
Date: Mon, 29 Dec 2008 08:18:28 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Michael Buesch <mb@bu3sch.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Dan E <trg_info@mailhaven.com>, Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Hostapd doesn't like crda
Message-ID: <20081229161828.GT5944@tesla> (sfid-20081229_171847_985573_5ADB4480)
References: <200812272208.20153.mb@bu3sch.de> <200812291128.00512.mb@bu3sch.de> <20081229155613.GR5944@tesla> <200812291704.28163.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <200812291704.28163.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 29, 2008 at 08:04:27AM -0800, Michael Buesch wrote:
> On Monday 29 December 2008 16:56:13 Luis R. Rodriguez wrote:
> > On Mon, Dec 29, 2008 at 02:28:00AM -0800, Michael Buesch wrote:
> > > On Monday 29 December 2008 04:45:22 Dan E wrote:
> > > >
> > > > On Sun, 28 Dec 2008 00:08:14 +0200, "Jouni Malinen" <j@w1.fi> said:
> > > > > On Sat, Dec 27, 2008 at 10:08:20PM +0100, Michael Buesch wrote:
> > > > > > Please take a look at the following log:
> > > > > > http://bu3sch.de/misc/crda.JPG
> > > > > >
> > > > > > Note the ordering of the events.
> > > > > > Hostapd starts up and tells the kernel what country we're in.
> > > > > > Then the kernel calls CRDA, _but_ hostapd goes on with its business
> > > > > > before CRDA has finished its work.
> > > > >
> > > > > Yes, because the netlink message was completed and hostapd assumes
> > > > > everything is ready at that point. Ignoring the complexity in the kernel
> > > > > (+ CRDA as a helper), this looks like reasonable expectation to make for
> > > > > NL80211_CMD_REQ_SET_REG operation. There is no other mechanism that
> > > > > would notify hostapd (or any other program setting country for that
> > > > > matter) when the operation was actually fully completed and polling for
> > > > > channel changes up to a timeout is not very appealing either.
> > > > >
> > > > > Unfortunately, I don't see an easy fix for this.
> > > >
> > > > This sounds like it's broken by design.  Hostapd should not send
> > > > NL80211_CMD_REQ_SET_REG if it is unable to evaluate the result.  If it's
> > > > necessary to do "iw reg set foobar" in a script prior to invoking
> > > > hostapd, then why does hostapd even bother?
> > > >
> > >
> > > hostapd isn't broken. The CMD_REQ_SET_REG should block until regulatory
> > > settings are done. It currently doesn't, because that's hard to implement (probably
> > > by design).
> >
> > It means adding a timer and picking a reasonable value for the timeout,
> > then waiting for a response through nl80211 and disabling the timer from there and
> > then finally sending the reply back. This seems rather hackish but we can implement
> > if its desirable. I suppose the worst case scenerio would be CRDA and the
> > regulatory db in an NFS mount or something like that.
> 
> I think this wouldn't be hackish, but do we actually _know_ when crda has finished
> uploading regulatory information? Does it do it all in one step?

It would go in through another nl80211 command, NL80211_CMD_SET_REG. nl80211 eventually
calls set_regdom() and this will set it, so if all goes well we can remove the timer
at the end if its active (other means can call CRDA like for 802.11d or the wireless core
upon initialization).

> > An alternative would be for us to add a netlink event once the regultory rule is
> > set in place. If the first approach is the better path to take then this secondary
> > netlink event can be sent anyway as informational.
> 
> Would also be OK, but would also require knowledge about "did we finish already".
> Do we have this knowledge?

During set_regdom() we can always inspect last_request which tells us the details
of who last set the regulatory domain, and at the end of set_regdom() it can be
assumed it did so successfully, right after update_all_wiphy_regulatory().

  Luis
