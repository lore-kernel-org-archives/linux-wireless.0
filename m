Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57234 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab1EIQtq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 12:49:46 -0400
Subject: Re: [PATCH] cfg80211: restrict AP beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4DC81A61.9080101@candelatech.com>
References: <1304959275.12202.4.camel@jlt3.sipsolutions.net>
	 <4DC81A61.9080101@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 18:49:43 +0200
Message-ID: <1304959783.12202.7.camel@jlt3.sipsolutions.net> (sfid-20110509_184949_638209_9036E1D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-09 at 09:46 -0700, Ben Greear wrote:
> On 05/09/2011 09:41 AM, Johannes Berg wrote:
> > From: Johannes Berg<johannes.berg@intel.com>
> >
> > Multiple virtual AP interfaces can currently try
> > to use different beacon intervals, but that just
> > leads to problems since it won't actually be done
> > that way by drivers. Return an error in this case
> > to make sure it won't be done wrong.
> 
> I think there is no problem with having different beacon
> intervals, as long as they are all a multiple of
> the smallest interval and the driver does things properly.
> 
> I'm not sure ath9k or ath5k currently supports this properly,
> but there was a patch floating around for a while that did
> this for ath9k I think...

Yes, in theory that's possible, but apparently no driver actually did
this correctly. Also, it didn't seem like anyone really cares, and we
need to enforce some restrictions because otherwise drivers will end up
doing it wrong, and you'll end up having a beacon interval of 200 while
advertising 150 for example, which will totally throw off powersaving
clients.

If you really care greatly about having different beacon intervals (and
I don't see why you would?) then maybe you can think how we can enforce
and advertise that to userspace. For now, I'm more comfortable just
restricting it.

johannes

