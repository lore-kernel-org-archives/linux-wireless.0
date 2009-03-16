Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58137 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759426AbZCPQ7F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 12:59:05 -0400
Subject: Re: [PATCH] cfg80211: drop wext channel list if too long
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1237019432.5235.61.camel@johannes.local>
References: <1236882244.25931.5.camel@johannes.local>
	 <20090313145445.GC5551@tuxdriver.com>
	 <1236964730.9657.10.camel@localhost.localdomain>
	 <1237019432.5235.61.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 16 Mar 2009 12:56:51 -0400
Message-Id: <1237222611.16956.17.camel@localhost.localdomain> (sfid-20090316_175919_378772_B1FE1200)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-03-14 at 09:30 +0100, Johannes Berg wrote:
> On Fri, 2009-03-13 at 13:18 -0400, Dan Williams wrote:
> 
> > It doesn't look like wpa_supplicant cares about the returned channel
> > list from SIOCGIWRANGE.
> > 
> > NM, however, uses the returned channel list to figure out a free
> > supported adhoc frequency to use when creating an adhoc network (like
> > for connection sharing).  If it can't find an intersection between an
> > internal "safe" frequency list and what the card supports (which it
> > wouldn't be able to with this patch), it will simply use 2462 or 5180
> > MHz.
> > 
> > Thus, I don't think you'll *break* anything specifically, but this patch
> > would cause the default frequency for an IBSS created by NM  to move
> > from channel 1 to channel 11.
> 
> In that case, let's just drop the patch, I have no problem with that.
> 
> We just couldn't figure out why some channels were missing in iwlist
> when they were in iw, but that's due to the 32 channel limit. Since most
> people probably don't use this particular functionality, I guess it
> doesn't really matter. Eventually NM should just use nl80211, or at
> least try to, because there it gets more information like "cannot do
> IBSS on channel XY", something that wext doesn't give you, but mac80211
> enforces.

Yup; nl80211 is the way to go here.  Or better yet, make wpa_supplicant
card capabilities over D-Bus so NM doesn't have to touch the driver
directly.

Dan


