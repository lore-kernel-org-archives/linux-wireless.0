Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47307 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbaAGQEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 11:04:23 -0500
Message-ID: <1389110654.4645.30.camel@jlt4.sipsolutions.net> (sfid-20140107_170448_364092_B72786C5)
Subject: Re: [PATCH 1/2 V3] nl80211/cfg80211: Add support for drivers with
 AP SME that require PMF SA Query assistance
From: Johannes Berg <johannes@sipsolutions.net>
To: clanctot@codeaurora.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Tue, 07 Jan 2014 17:04:14 +0100
In-Reply-To: <639efbd4cc1a2cf8a93953dc037ed52e.squirrel@www.codeaurora.org>
References: <639efbd4cc1a2cf8a93953dc037ed52e.squirrel@www.codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[please fix your quoting. I'll reply anyway this time, but still, it's
odd to read if you get linebreaks but the quote marks only apply to the
first line]

On Fri, 2014-01-03 at 21:30 +0000, clanctot@codeaurora.org wrote:

> Yes, the device will detect the case of an unprotected Assoc Request from
> a station where there is already a PMF connection and, in this case, will
> pass up the frame to hostapd.  hostapd already has code to handle this
> case and will initiate the SA Query procedure.  This has been tested and
> it works correctly.

Documentation needed then.

> The station flag is added for hostapd to signal back to the device that SA
> Query has timed out (completed) and that the device should process Assoc
> Request frames from that station normally.

Seems reasonable I guess.

> > Also, which (upstream) driver is going to use this?
> These changes are of general utility for any device that implements AP SME
> and will also implement PMF.  We will be up-steaming a driver that will
> use these extensions in the future.

I'm curious, for what device? :)

> For existing PMF (MFP) code, there is no check for driver support of PMF.
> wpa_supplicant and hostapd just pass PMF information to the driver.  The
> driver just ignores the information if it does not support PMF.

Really? But anyway the driver might be confused if it sees a station
change with something changing that doesn't actually do anything for it?

> >> @@ -4090,7 +4091,7 @@ static int nl80211_new_station(struct sk_buff
> *skb, struct genl_info *info)
> >>  		return -EINVAL;
> >>  	/* When you run into this, adjust the code below for the new flag */
> >> -	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 7);
> >> +	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 8);
> >>  	switch (dev->ieee80211_ptr->iftype) {
> >>  	case NL80211_IFTYPE_AP:
> > Can this really be right? Is it simply invalid on a new station? Why
> does this even make sense - this is done for AP SME where this is never
> invoked?
> > Anyway you need to reject adding TDLS peers with this flag, for example,
> afaict.
> The idea here was that this new flag is used to signal a state transition
> for stations for which the SA Query procedure has already started.  So,
> yes, it is invalid for a “new station” operation.

Right, so then you should just reject it there? New station is never
even called for AP SME, I believe, so it wouldn't make sense at all to
specify the flag.

> But when the driver detects that an SA Query procedure is needed for an
> associated station, it passes the Association Request up to hostapd and
> remembers that the SA Query is in progress for that station.
> 
> This new flag allows hostapd to signal to the driver that SA Query has
> completed and the driver can clear the state for that station indicating
> that SA Query is in progress.  So this flag is only used in the “station
> change” operation.

Yeah, I get that.

> Perhaps there is a cleaner way to do this?  What we are trying to
> accomplish is to allow hostapd to signal to the driver that SA Query has
> completed and do this using an already existing nl80211/cfg80211 interface
> (and just adding a new flag).

I think that's OK, but you're adding it in a way that allows the flag to
be used with other operations and that'd be inconsistent with the flag
semantics, it seems?

johannes

