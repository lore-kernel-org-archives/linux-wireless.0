Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58161 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab1AaTMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 14:12:16 -0500
Subject: Re: [PATCH] mac80211:  Recalculate channel-type on iface removal.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4D4707CD.60903@candelatech.com>
References: <1296499072-6721-1-git-send-email-greearb@candelatech.com>
	 <1296499462.3812.41.camel@jlt3.sipsolutions.net>
	 <4D470416.9020403@candelatech.com>
	 <1296500220.3812.43.camel@jlt3.sipsolutions.net>
	 <4D4707CD.60903@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 20:12:16 +0100
Message-ID: <1296501136.3812.45.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-31 at 11:04 -0800, Ben Greear wrote:

> >> The set-channel-type logic will complain, and I imagine the interfaces
> >> will bounce around and attempt to re-associate, but I think it can
> >> get into the mixed state.
> >
> > I think we should try to avoid that.
> 
> Ok.  I haven't actually tested that case yet.  It's possible
> that we can't actually get in that case..but I haven't found
> anything that prevents it while reading code.  Assuming there is a problem,
> what would be the preferred fix?  Maybe force to NO_HT if an interface
> tries to associate with HT40+/- mis-match?

I think ieee80211_enable_ht() checks this?

> Do you want me to repost this patch without the WARN_ON_ONCE
> changes?

For now, I think that'd be nicer. I suspect it doesn't actually matter
since the above means we can't get into that situation. Still we may
want WARN_ON_ONCE to prevent being flooded, but I guess it should be a
separate patch?

johannes

