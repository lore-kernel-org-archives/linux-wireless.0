Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34847 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbZH1WSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 18:18:47 -0400
Subject: Re: [PATCH 1/2] cfg80211: initialize rate control after station
 inserted
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1251493298.3456.34.camel@johannes.local>
References: <1251416094-10420-1-git-send-email-reinette.chatre@intel.com>
	 <1251445557.4189.14.camel@johannes.local>
	 <1251474321.3805.73.camel@rc-desk>
	 <1251493298.3456.34.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 15:18:49 -0700
Message-Id: <1251497929.3805.173.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Fri, 2009-08-28 at 14:01 -0700, Johannes Berg wrote:
> > This work is motivated by an attempt to untangle the iwlwifi station
> > management to be able to use mac80211's sta notify callback. From 4965
> > and up the rate scaling in the device is done per station, so an entry
> > in the station table is required for the rate scaling initialization to
> > succeed. 
> 
> Interesting. I've been thinking about making it go the other way --
> remove rate scaling hooks completely. wl1271 apparently has rate scaling
> completely in the firmware, so the RS algorithm on the host is just
> overhead. I've been thinking putting 4965+ RS into the _driver_ makes
> more sense since it really does a lot in the firmware and not on the
> host.

Yes, it does do a lot in firmware. Unfortunately I am not too familiar
with the details (yet).

> Do you think we should try to go that route? I'd think it would probably
> be a hardware flag ("no RS algo please") and then we'd skip all the
> hooks and put things into the driver. The advantage is that we don't
> care about the mac80211 API any more, things get cleaner and we can just
> do all RS init from sta_notify().

It could do RS init from sta_notify and that would solve this problem. I
am not familiar with how the other hooks operate to know at this time
what it will take to do everything in the driver. Come to think of it,
as a test over here I can just make our RS init routine a no-op and then
do the init from sta notify. 

> 
> I've also been thinking if there's a way to make sta_notify() able to
> sleep but so far I don't see one unfortunately.

Having it sleep will help a lot. When a station is added we need to tell
the device about it. Since the call cannot sleep we cannot really tell
mac80211 if this failed because the failure will only be known at a
later time. I have not yet figured out how to deal with this case.


> > Right now iwlwifi is adding stations inside the rate scaling code in
> > order to work around this issue. I'd like to clean this up and only use
> > the sta notify callback.
> 
> Makes sense, thanks, I appreciate that -- should be a good cleanup to
> the driver and reduce the number of places that try to add a station and
> make the driver more streamlined.

Exactly.

> > >  -- all that seems to do is add race conditions,
> > > allowing other code to find not-yet-initialised stations.
> > 
> > I did not realize that this can happen. Can you please elaborate?
> 
> As soon as sta_insert() got called, a packet transmitted to that station
> can be processed, find the sta info, and it seems we could end up
> calling rate_control_get_rate() before the init was done, through a race
> condition.

oh - I see - that's bad. Although, that may explain why iwlwifi is
adding stations in get_rate() also. 

Reinette



