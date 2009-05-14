Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48632 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbZENU4T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 16:56:19 -0400
Subject: Re: Scan while TX/RX'ing a lot of data
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com
In-Reply-To: <43e72e890905141207m3c27588ex13190b2ed6010e30@mail.gmail.com>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
	 <1242327298.4227.25.camel@localhost.localdomain>
	 <43e72e890905141207m3c27588ex13190b2ed6010e30@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 16:57:16 -0400
Message-Id: <1242334636.4227.134.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-05-14 at 12:07 -0700, Luis R. Rodriguez wrote:
> On Thu, May 14, 2009 at 11:54 AM, Dan Williams <dcbw@redhat.com> wrote:
> > On Thu, 2009-05-14 at 10:52 -0700, Luis R. Rodriguez wrote:
> >> I'm told Network Manager scans every 60 seconds. When TX'ing or RX'ing
> >> a lot of data you will see a big dip in throughput and sometimes it
> >> may cause issues with some connections. Jouni pointed out a possible
> >> nice option here: split the scans per channel through time. Now with
> >> nl80211 this is possible but right now Network Manager uses wext
> >> through wpa_supplicant in many distributions and this won't change for
> >> a bit (maybe by the next major distribution releases?). Since we're
> >> stuck with wext for the current distribution releases I'd like to hear
> >> feedback on a possible nice solution. Should we simply cancel scan?
> >
> > Libertas
> 
> libertas_tf (the mac80211 driver) ? Or the fullmac one?

The fullmac one.  The firmware initially didn't implement nullfunc
support so every scan would make the AP kick you off, much like what
happened before kvalo's patch from March that fixed the mac80211 TX
filter for nullfunc.

Splitting the scan up (the scan isn't really that latency-sensitive
anyway) worked fairly well.

> > splits scans up into 3 parts with a short return to the
> > operating channel between each part.  There's nothing that requires
> > cfg80211 for that to work...
> 
> We can do tricks in drivers but I'd like to see this handled in mac80211.

Right, could be handled in mac80211 too.

> > Something I've tossed around for a while is counting traffic on the
> > device and if its over a certain bitrate for a period of time, postpone
> > the scan for a while.  But after a certain amount of time, there's going
> > to be a scan no matter what.
> 
> Sure, makes sense. I take it the effort to make this more intelligent
> is part of the the roaming intelligence we need to enhance.
> 
> > The problem here is that at any time an application (say, wifi location
> > app) could ask for the list of access points.  If you don't scan
> > periodically, all APs other than your associated AP (and others on the
> > same channel) will gradually drop off because their beacons are
> > received.  Hard to wifi position or get area statistics if there's only
> > one AP in the list.
> 
> Makes sense.
> 
> > Secondarily, scanning is a tradeoff between better roaming latency and
> > continuous high throughput.  If you don't scan, you have no idea what's
> > around, and when you move and the current AP becomes marginal, you
> > *have* to take the hit no matter what, so you can scan and find a new AP
> > to associate with.
> 
> True however I'm inclined to believe that generally when you are
> sending or receiving a lot of data you are stationary so roaming might
> not be that urgent. For 802.11p (vehicle stuff) I suppose this may be
> a bit different but I have yet to see this take off.

I'll believe 11p when I see it somewhere :)  But anyway, yeah, there are
tricks we can play here, and I'm happy to entertain methods of making
the scanning hit less annoying.  I'm simply opposed to a checkbox in the
UI for "never scan while connected" because that's a pure cop-out: we
should be making things intelligent, not taking the half-assed approach
like people (nobody here of course) have been whining about for a long
time.  Scanning isn't something the user should have to care about or
turn on or off; it's something that NetworkManager (in concert with
usage information from the stack) should be able to handle
automatically.

Maybe if there was a way to figure out how full mac80211's QoS buckets
were, that would help?  Or get a frame counts from each of the 4 QoS
buckets individually?  That would allow NM to make more intelligent
decisions about stuff.  Maybe a more detailed nl80211 stats interface
would do the trick here.

> > I would have though that the periodic scanning would be more of an
> > annoyance when doing VOIP or SSH other latency sensitive tasks, but when
> > just downloading a file, a few second drop in transfer rate gets lost in
> > the bucket in the grand scheme of things.
> 
> Good point, how about we use pm_qos for disabling scan when we are
> sending a lot of data (whatever we define this to mean)? Then
> applications can just write to this pm_qos stuff and you won't see
> this.
> 
> I forget when pm_qos was introduced though.

Yeah, something like that, although it's sometimes hard to go from app
-> interface; if you have a wired interface connected at the same time,
but the thing you're sucking down data from is on the wifi interface,
we'd need some way to figure that out.  Hence the idea about exposing
the packet counts of the WMM queues or something like that.

Dan


