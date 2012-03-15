Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51937 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759503Ab2COTFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 15:05:41 -0400
Subject: Re: [RFC 2/2] mac80211:  Support getting sta_info stats via
 ethtool.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4F623D19.7090105@candelatech.com>
References: <1331833159-12694-1-git-send-email-greearb@candelatech.com>
	 <1331833159-12694-2-git-send-email-greearb@candelatech.com>
	 (sfid-20120315_183942_222982_FD61EFBD) <1331837740.3432.39.camel@jlt3.sipsolutions.net>
	 <4F623D19.7090105@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 20:05:40 +0100
Message-ID: <1331838340.3432.43.camel@jlt3.sipsolutions.net> (sfid-20120315_200545_362843_6411A859)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-15 at 12:03 -0700, Ben Greear wrote:

> >> +	list_for_each_entry(sta,&sdata->local->sta_list, list) {
> >
> > That's not right -- these stats are per netdev so you should only
> > aggregate for the netdev, no?
> 
> Ummm, maybe so.  I had trouble figuring out how to find
> the sta entries that are associated with a netdev, and I'd
> like to sum up all station entries for an AP interfaces.
> 
> If you know of any code that uses this, a pointer would
> be welcome.

Just compare sta->sdata?

> >> +		BUG_ON(i != STA_STATS_LEN);
> >
> > That I really don't like much.
> 
> Ok, I'll remove it from a final patch.  It catches bugs
> in the meantime (miss a comma between strings and
> it blows up spectacularly :P).

Heh. Some verification would be nice I guess, but I can't really figure
out a good way either.

johannes

