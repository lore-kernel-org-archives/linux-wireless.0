Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42622 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaAPNUG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 08:20:06 -0500
Message-ID: <1389878403.4345.4.camel@jlt4.sipsolutions.net> (sfid-20140116_142010_824817_0242688C)
Subject: Re: [PATCH] nl80211: Don't touch split_start when split dump is not
 used
From: Johannes Berg <johannes@sipsolutions.net>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 16 Jan 2014 14:20:03 +0100
In-Reply-To: <52D7DC0B.9060206@gmail.com> (sfid-20140116_141810_941825_A906EE4C)
References: <1389877607-3162-1-git-send-email-pontus.fuchs@gmail.com>
		 (sfid-20140116_140701_812750_DB719CBA) <1389878160.4345.3.camel@jlt4.sipsolutions.net>
	 <52D7DC0B.9060206@gmail.com> (sfid-20140116_141810_941825_A906EE4C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-16 at 14:18 +0100, Pontus Fuchs wrote:
> On 2014-01-16 14:16, Johannes Berg wrote:
> > On Thu, 2014-01-16 at 14:06 +0100, Pontus Fuchs wrote:
> >> When the netlink skb is exhausted split_start is left set. In the
> >> subsequent retry, with a larger buffer, the dump is continued from the
> >> failing point instead of from the beginning.
> >
> >> +static void split_start_inc(struct nl80211_dump_wiphy_state *state)
> >> +{
> >> +	if (state->split)
> >> +		state->split_start++;
> >> +}
> >
> > Wouldn't it be easier to just reset it in this case?
> 
> Sure. If you prefer that I can do that instead.

Just thinking that it'd be smaller and easier for stable, since it
should probably be tagged for there.

johannes

