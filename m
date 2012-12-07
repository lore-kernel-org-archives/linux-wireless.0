Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58627 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424343Ab2LGUy2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 15:54:28 -0500
Message-ID: <1354913688.9124.2.camel@jlt4.sipsolutions.net> (sfid-20121207_215432_184544_CB854439)
Subject: Re: Wireless network problem with Access Point selection using ifup
From: Johannes Berg <johannes@sipsolutions.net>
To: markh@compro.net
Cc: dmarkh@cfl.rr.com, linux-wireless@vger.kernel.org
Date: Fri, 07 Dec 2012 21:54:48 +0100
In-Reply-To: <50C256A9.7010008@compro.net>
References: <50C0A743.3000305@compro.net>
	  (sfid-20121206_152423_356618_ADE5D3BC) <1354806200.18211.1.camel@jlt4.sipsolutions.net>
	 <50C1C103.1000803@cfl.rr.com> <50C256A9.7010008@compro.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-07 at 15:50 -0500, Mark Hounschell wrote:
> On 12/07/2012 05:12 AM, Mark Hounschell wrote:
> > On 12/06/2012 10:03 AM, Johannes Berg wrote:
> >> On Thu, 2012-12-06 at 09:10 -0500, Mark Hounschell wrote:
> >>>   I'm using
> >>> traditional ifup with static configurations.
> >>
> >> You should at least run wpa_supplicant, which will pick a better network
> >> and reconnect if the connection drops etc. Almost no device does that by
> >> itself any more.
> >
> >   wpa_supplicant is running.
> >
> > #ps ax | grep wpa
> >
> > wpa_supplicant -iwlan0 -c/var/run/wpa_supplicant-wlan0.conf
> > -Dnl80211,wext -P/var/run/wpa_supplicant/wlan0.pid -B
> >
> >
> > When the router in the middle of the house is chosen, as opposed to the
> > range extender in the very same room, the network works for a time but
> > eventually disassociates, usually reason 7, and never reconnects to
> > anything.
> >

> Thanks for responding. Do you think my problem is a wpa_supplicant 
> issue, a kernel issue, or a Dist issue?

I'd say it's a wpa_s issue, but I can't remember any time that it didn't
reconnect after getting disconnected, so maybe there's an issue with
your driver/device that causes it to need a reset or something ... hard
to tell more without at least the supplicant log.

johannes

