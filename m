Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48621 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbZENUtp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 16:49:45 -0400
Subject: Re: Scan while TX/RX'ing a lot of data
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com
In-Reply-To: <1242327995.5799.4.camel@johannes.local>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
	 <1242327298.4227.25.camel@localhost.localdomain>
	 <1242327995.5799.4.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 14 May 2009 16:50:31 -0400
Message-Id: <1242334231.4227.126.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-05-14 at 21:06 +0200, Johannes Berg wrote:
> On Thu, 2009-05-14 at 14:54 -0400, Dan Williams wrote:
> 
> > Libertas splits scans up into 3 parts with a short return to the
> > operating channel between each part.  There's nothing that requires
> > cfg80211 for that to work...
> 
> Yeah that was my idea too, just return to the operating channel after
> having scanned a channel or two and wait for the next beacon, and
> possibly receive traffic if indicated in that beacon. It takes a bit of
> synchronisation and isn't easy to implement, but it's definitely
> possible.
> 
> > The problem here is that at any time an application (say, wifi location
> > app) could ask for the list of access points.  If you don't scan
> > periodically, all APs other than your associated AP (and others on the
> > same channel) will gradually drop off because their beacons are
> > received.  Hard to wifi position or get area statistics if there's only
> > one AP in the list.
> 
> The other thing we should do is bump the AP list timeout, I think -- 10
> seconds is very small. But then again we really need such apps to query
> NM anyway.
> 
> > Secondarily, scanning is a tradeoff between better roaming latency and
> > continuous high throughput.  If you don't scan, you have no idea what's
> > around, and when you move and the current AP becomes marginal, you
> > *have* to take the hit no matter what, so you can scan and find a new AP
> > to associate with.
> 
> Yeah, that too.
> 
> > I would have though that the periodic scanning would be more of an
> > annoyance when doing VOIP or SSH other latency sensitive tasks, but when
> > just downloading a file, a few second drop in transfer rate gets lost in
> > the bucket in the grand scheme of things.
> 
> ssh isn't too bad, at least not after I fixed the timings... before I
> got very annoyed with ar9170. OTOH with VoIP it would suck to have a
> small hiccup every 2 minutes -- maybe then we should postpone
> indefinitely and only do it if the signal strength fluctuates?

If there was a reliable mechanism to figure out whether there was a
certain QoS level of traffic flowing through the card, this would be
easier to do automatically.  AFAIK all the APIs these days are
socket-based, and that doesn't help us get from app -> interface without
a lot of intermediate steps.  How does mac80211 figure out what to put
into each of the 4 buckets for wifi QoS / WMM?

Dan

