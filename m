Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41260 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2EILkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 07:40:13 -0400
Message-ID: <1336563608.4323.16.camel@jlt3.sipsolutions.net> (sfid-20120509_134018_257914_FEF6D30C)
Subject: Re: [RFC] nl80211: don't require netdev UP for wdev
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Wed, 09 May 2012 13:40:08 +0200
In-Reply-To: <4FAA43F0.6050401@tieto.com>
References: <1335479316-2933-1-git-send-email-thomas@cozybit.com>
	   (sfid-20120427_002914_313709_1CC9F96D) <1336554945.4323.12.camel@jlt3.sipsolutions.net>
	  <4FAA3BD2.9070203@tieto.com>
	 <1336557043.4323.15.camel@jlt3.sipsolutions.net>
	 <4FAA43F0.6050401@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-09 at 12:16 +0200, Michal Kazior wrote:

> > No, that's the special case that doesn't work that way -- monitor mode
> > interfaces are also great for debugging when they're just concurrently
> > running with other interfaces and don't have their own channel setting.
> 
> We can make monitor interface to be a slave to other non-monitor 
> interface by passing an extra parameter in start_monitor(). We could 
> then have such a monitor interface follow channel changes of a given 
> non-monitor interface (or rather it wouldn't be using a channel on it's 
> own).

That's not how it works though, a monitor interface will simply report
all frames mac80211 receives, globally.

> >> But then I'm thinking we shouldn't really be changing interface types
> >> explicitly, since they would be set implicitly by start_ap() and such.
> >> We could then use the NL80211_IFTYPE_UNSPECIFIED when we're not associated.
> >
> >  From some point of view, it should work that way, yes.
> >
> > Given how entrenched interface types are we definitely can't get rid of
> > them though, and they're still needed to do concurrency management etc.
> 
> Well, I don't think we can get completely rid of them, too. Or do you 
> mean something else?

We can't even implicitly change them due to concurrency management etc.

johannes

