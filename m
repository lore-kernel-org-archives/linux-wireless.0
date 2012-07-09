Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33577 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2GIJnv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 05:43:51 -0400
Message-ID: <1341827029.4455.27.camel@jlt3.sipsolutions.net> (sfid-20120709_114355_129075_55FF17FA)
Subject: Re: [RFC 1/3] mac80211: make scan_sdata pointer usable with RCU
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Jul 2012 11:43:49 +0200
In-Reply-To: <CA+XVXfeKw_C1i=xukZVgRV6woLnNdpDw=m3B_iXES28TrCJimg@mail.gmail.com> (sfid-20120709_113948_457126_F138ACE4)
References: <1341608733-7503-1-git-send-email-johannes@sipsolutions.net>
	 <1341608733-7503-2-git-send-email-johannes@sipsolutions.net>
	 <CA+XVXfdo7agXE9Osxzmda2ZWi-xQ6pvP66zktdiDJq3P6PULgg@mail.gmail.com>
	 <1341820743.4455.1.camel@jlt3.sipsolutions.net>
	 <CA+XVXfeAhP9EjKJr6Ch1GAuT8u4CV_WsDQiCCt6b4YGjHzZwrQ@mail.gmail.com>
	 <1341825002.4455.10.camel@jlt3.sipsolutions.net>
	 <CA+XVXfcqEgXW8yr5F3Rbvyf6g=Y+cZ+3kS0wooRX+pt3dQxC_A@mail.gmail.com>
	 <1341825800.4455.17.camel@jlt3.sipsolutions.net>
	 <CA+XVXfeKw_C1i=xukZVgRV6woLnNdpDw=m3B_iXES28TrCJimg@mail.gmail.com>
	 (sfid-20120709_113948_457126_F138ACE4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-09 at 12:39 +0300, Arik Nemtsov wrote:

> >> >> >> I noticed no synchronize_rcu() in the start/stop scan calls. Good/bad idea?
> >> >> >
> >> >> > Well, start() certainly wouldn't need it since you'd only get NULL :-)
> >> >> >
> >> >> > stop() in theory could use it, but it doesn't actually matter because as
> >> >> > long as the interface still exists the pointer is valid. We don't free
> >> >> > the interface in scan stop, so we don't need to make sure that the
> >> >> > pointer is cleared before we continue. And in the case that we *do* in
> >> >> > fact clear the interface (when it's going down) we have synchronize_rcu
> >> >> > already in those code paths due to say the interface list with RCU
> >> >> > protection.
> >> >>
> >> >> I meant protecting these (in patch 2/3):
> >> >>
> >> >> -            local->sched_scanning,
> >> >> +            rcu_dereference_protected(local->sched_scan_sdata,
> >> >> +                                      lockdep_is_held(&local->mtx)),
> >> >>
> >> >> The check is obviously racy here, but it was racy before as well I guess.
> >> >> I'm not sure why something line test_bit(SCHED_SCANNING) wasn't used
> >> >> in these places.
> >> >
> >> > I don't think I understand what you're trying to say ... why is this
> >> > racy? We hold the mutex that we always hold when we assign the pointer.
> >>
> >> I mean this check in ieee80211_rx_h_passive_scan():
> >>
> >>       if (test_bit(SCAN_HW_SCANNING, &local->scanning) ||
> >>           test_bit(SCAN_SW_SCANNING, &local->scanning) ||
> >>           test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning) ||
> >>           local->sched_scanning)
> >>               return ieee80211_scan_rx(rx->sdata, skb);
> >>
> >> since this is RCU, the pointer might be there a while longer after the
> >> scan finished..
> >
> > Oh. I was looking at the code after patch 3 and this no longer
> > exists ;-)
> >
> > But then my first argument applies -- as long as the interface is there,
> > the pointer is OK, and when the interface is removed we need to remove
> > it from the RCU-managed interface list so need to synchronize_rcu()
> > already. No?
> 
> The add/remove interface part is covered, yes.
> 
> What happens when starting/stopping sched scan? The rcu pointer is
> removed in ieee80211_request_sched_scan_stop(), but we may still think
> we are sched scanning for a while inside
> ieee80211_rx_h_passive_scan().
> 
> Probably nothing too bad will happen though..

Yes, well... Say we stick synchronize_rcu() into sched_scan_stop(). What
would actually change?
We'd still think we're sched scanning (in the RX handler) for exactly
the same amount of time, except the sched scan stop code would now wait
for it, while doing nothing. It has nothing to do after the wait (since
it doesn't free the RCU data or anything).

IOW -- nothing changes.

johannes

