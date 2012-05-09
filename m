Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50343 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2EIJur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 05:50:47 -0400
Message-ID: <1336557043.4323.15.camel@jlt3.sipsolutions.net> (sfid-20120509_115121_807895_E469EBA6)
Subject: Re: [RFC] nl80211: don't require netdev UP for wdev
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Wed, 09 May 2012 11:50:43 +0200
In-Reply-To: <4FAA3BD2.9070203@tieto.com>
References: <1335479316-2933-1-git-send-email-thomas@cozybit.com>
	  (sfid-20120427_002914_313709_1CC9F96D) <1336554945.4323.12.camel@jlt3.sipsolutions.net>
	 <4FAA3BD2.9070203@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-09 at 11:41 +0200, Michal Kazior wrote:
> Johannes Berg wrote:

> > I don't think this patch is correct -- mac80211 will get updated even if
> > the device isn't even started which will likely cause trouble. Even if
> > not though, this all doesn't match any kind of multi-channel concept. We
> > treat the channel as part of the temporary setup, e.g. part of the
> > association. AP and mesh are the only ones that are different today I
> > think.
> 
> What about monitor mode?

It's ... special and confusing, unfortunately.
Basically, it's handled in mac80211 today, it rejects monitor channel
setting unless it's otherwise idle, and overrides it freely if other
requests come in.


> > We should do the same for AP mode as well, since the channel really
> > becomes relevant only upon start_ap(), before that there's no real
> > concept of a channel since you don't use it yet anyway.
> 
> Maybe we should do the same with monitor interface type, i.e. introduce 
> start_monitor() and have it pass the channel.

No, that's the special case that doesn't work that way -- monitor mode
interfaces are also great for debugging when they're just concurrently
running with other interfaces and don't have their own channel setting.

> But then I'm thinking we shouldn't really be changing interface types 
> explicitly, since they would be set implicitly by start_ap() and such. 
> We could then use the NL80211_IFTYPE_UNSPECIFIED when we're not associated.

>From some point of view, it should work that way, yes.

Given how entrenched interface types are we definitely can't get rid of
them though, and they're still needed to do concurrency management etc.
But changing everything to have explicit start/stop operations makes
on-the-fly interface type changes much easier.

johannes

