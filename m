Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:17327 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757498Ab0LMOCo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 09:02:44 -0500
Subject: Re: [RFC v2 1/2] cfg80211/nl80211: add support for scheduled scans
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1292011406.3531.17.camel@jlt3.sipsolutions.net>
References: <1291993632-6921-1-git-send-email-luciano.coelho@nokia.com>
	 <1291993632-6921-2-git-send-email-luciano.coelho@nokia.com>
	 <1292011406.3531.17.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 16:04:14 +0200
Message-ID: <1292249054.2951.256.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-10 at 21:03 +0100, ext Johannes Berg wrote:
> On Fri, 2010-12-10 at 17:07 +0200, luciano.coelho@nokia.com wrote:
> > With this feature we
> > can scan automatically for specific SSIDs (or any if not specified) at
> > certain intervals.
> 
> I'd hope that "if not specified" actually means a passive scan like in
> normal scanning, and you need to specify the wildcard if you want to
> scan for it?

Good point.  Actually, from the cfg/mac80211 point of view, this doesn't
really matter.  It's just a matter of documenting it so that all the
drivers do it properly and in the same way.

I removed that part of the comment in the commit log and clarified this
in the NL80211 documentation.

For the wl12xx I need to check how exactly this works.  As I understand
it, you can either filter on the specified SSIDs or send directed
probe_reqs (ie. with SSID IEs).

Would it make sense to make passive scans (with no SSID specified) and
still filter per SSID? If yes, we should add a new nested attribute to
NL80211 where we can pass the SSID filters.

Actually, I think having a separate NL80211 attribute for SSID filters
is a good idea.  What if I remove this whole filtering thingy for now
and add it with a separate patch later?


> > +	u8 max_sched_scan_ssids;
> 
> shouldn't this be advertised in nl80211 as well?

I think this should be the same as for normal scans.  What I have been
using it for was for the filtering SSIDs.  I need to rethink the
filtering concept.


> > @@ -647,6 +648,11 @@ static void wdev_cleanup_work(struct work_struct *work)
> >  		___cfg80211_scan_done(rdev, true);
> >  	}
> >  
> > +	if (rdev->sched_scan_req &&
> > +	    rdev->sched_scan_req->dev == wdev->netdev) {
> > +		nl80211_sched_scan_stopped(rdev, wdev->netdev);
> > +	}
> 
> Hmm, are you sure that shouldn't be a warning like the scan case? If the
> driver didn't stop -- maybe this is still going on? I think instead the
> netdev down notifier should actually ask the device to stop the sched
> scan (core.c).

Yes, good point.  This should work more like "disconnect", which is an
long term process.  I have created __cfg80211_stop_sched_scan() and now
I call that from core.c at netdev down and from
nl80211_stop_sched_scan().  Looks cleaner, thanks!


> > +	if (!rdev->ops->sched_scan_start) {
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	if (rdev->sched_scan_req) {
> > +		return -EINPROGRESS;
> > +	}
> 
> bit too many braces for my taste :)

Heh, I was probably in an embracing mood when I wrote this.  Removed.


> > +	if (ie_len > wiphy->max_scan_ie_len)
> > +		return -EINVAL;
> 
> So # SSIDs is different, but IE len is the same? Isn't that a bad
> assumption to make?

Yes, you're right.  As I wrote above, this was about SSID *filters* not
about SSIDs per scan.  I'll remove the wiphy->max_sched_scan_ssids for
now and use max_scan_ssids instead.


> > +	request->dev = dev;
> > +	request->wiphy = &rdev->wiphy;
> > +
> > +	rdev->sched_scan_req = request;
> > +
> > +	err = rdev->ops->sched_scan_start(&rdev->wiphy, dev, request);
> > +	if (!err) {
> > +		nl80211_send_sched_scan(rdev, dev,
> > +					NL80211_CMD_START_SCHED_SCAN);
> > +		dev_hold(dev);
> 
> I don't think you want the dev_hold here. That's a trick I used to warn
> about scans that didn't finish when the interface went down. Here,
> instead, since it's a longer-running process, you should do what I said
> above -- stop the sched scan when the interface is going down.

Right, it's not needed.  I've removed it now.


> > +	err = rdev->ops->sched_scan_stop(&rdev->wiphy, dev);
> > +	if (err)
> > +		goto out;
> 
> return err; instead? There's no cleanup code at the out label :)

Yes, I'm just used to return at the end of the function whenever
possible.  We agreed on using this as a coding style for the wl12xx
driver.  And if you look at its code, you can see that we sometimes even
goto out from an if even when there's no code between the if block and
the label.  Duh!

Fixed.


> > +	nl80211_send_sched_scan(rdev, dev, NL80211_CMD_STOP_SCHED_SCAN);
> > +
> > +	nl80211_sched_scan_stopped(rdev, dev);
> 
> Shouldn't the former be part of the latter function? And actually,
> you'll want to roll it all into a helper function that you can call from
> the netdev down notifier :)

Sure, done as part of the change I described above.


-- 
Cheers,
Luca.

