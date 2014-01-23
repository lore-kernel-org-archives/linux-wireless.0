Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:41442 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaAWJbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 04:31:18 -0500
Message-ID: <1390469474.4189.81.camel@porter.coelho.fi> (sfid-20140123_103124_008049_A224E96D)
Subject: Re: [PATCH 3/3] cfg80211: implement multi-interface CSA
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 23 Jan 2014 11:31:14 +0200
In-Reply-To: <1390465607.4142.7.camel@jlt4.sipsolutions.net>
References: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
	 <1390226968-18928-4-git-send-email-michal.kazior@tieto.com>
	 <1390458525.4189.46.camel@porter.coelho.fi>
	 <1390465607.4142.7.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-23 at 09:26 +0100, Johannes Berg wrote:
> On Thu, 2014-01-23 at 08:28 +0200, Luca Coelho wrote:
> 
> > Why is this necessary? I think it's easier to treat the CSA's
> > separately.  When wpa_supplicant decides to switch channel in one
> > interface, it asks cfg80211 to do so.  Then, if that interface change is
> > "approved" (ie. there's no internal reason why it would fail), cfg80211
> > sends a notification to userspace that the interface will switch.  Then
> > wpa_s decides whether any other interfaces need switching as well (ie.
> > if it's in the same channel context).
> 
> I don't think that makes sense. If userspace requested the CSA
> operation, the fact that it will happen should be known as soon as the
> request returns 0. No need for a notification (other than when the mlme
> code in mac80211 decided to switch by itself). You're mixing the cases
> of GO-follow-client-interface and switch-multiple-AP-BSSes, which I'm
> not sure is right.

I think all cases should be treated in the same way.  No need to treat
different scenarios differently.

I also like to think that, even though it's probably not a good idea, we
*could* have two different processes in userspace handling the different
interfaces (eg. two hostapd's).  If only the return value of the request
is used, any other instances will not know something is happening.

I don't see how a notification can hurt.  It is just good to align all
cases: mlme decided to switch or the userspace decided to switch.  In
both cases, whoever is listening will get the notification that
something is happening.


> The problem with using the approach you're suggesting to switch multiple
> AP interfaces is that when you do that, you open the system up to races
> much more than when requesting multiple interfaces at once. Also, I
> still think we need to enforce that the interface switch at the same
> time, which would practically be impossible with multiple switch
> commands.

This is needed (and may cause races) only for the
"no-more-available-contexts" scenario (eg. single channel).

We could "merge" the multiple switch commands in the kernel.  Either by
"dragging" all the interfaces together (as I suggested in another thread
-- still under debate) or by informing the userspace when the actual
switch will happen (with a notification).


Let's say we have 2 APs with a single channel (your scenario).  AP1
requests a channel switch with count 7.  AP2 gets a notification that
its channel must switch at count 7.  AP2 decides to either follow or to
shut itself down.

The same would happen for the GO-follow-client.  The client gets a
channel switch with count 7.  GO gets a notification that its channel
must switch at count 7.  GO decides to either follow or shut itself
down.

Or, another scenario: STA and AP1 with a single channel.  STA gets a
channel swith announcement from its AP2 on count 7.  AP1 gets a
notification that its channel must switch at count 7.  AP1 decides to
either follow or to shut itself down.

There is a higher risk of races with my proposal, but if the count used
is high enough, it shouldn't be too bad.  And, in any case, the
multiple-vifs in a single CSA request only solves the races in the first
scenario (2 APs).


> > > This makes it possible for userspace to request a
> > > multi-interface channel switch while allowing
> > > sanity checks wrt target interface/channel
> > > combination.
> > 
> > Okay, the sanity checks are an interesting issue.  But if the
> > combination is not good, the whole command will fail and none of the
> > interfaces will switch.  If wpa_s does this interface-by-interface,
> > separately, the triggering interface (ie. the one that decided to switch
> > in the first place) may succeed while the subsequent requests may fail
> > (eg. if the interface combination is not allowed in the new channel).
> > If the second one fails, wpa_s may make another decision, for instance
> > trying to switch the second interface to a *different* channel instead,
> > or not switch at all.
> 
> That makes no sense. You're talking about completely different
> scenarios, see above.

I'm trying to abstract the scenarios as much as possible and only talk
about the interfaces (whichever types they are).

--
Luca.

