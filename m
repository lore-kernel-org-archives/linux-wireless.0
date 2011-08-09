Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42243 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab1HIN2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 09:28:52 -0400
Subject: Re: [RFC 2/2] mac80211: config hw when going back on-channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
In-Reply-To: <4E4135C4.4020607@candelatech.com>
References: <1311607763-12603-1-git-send-email-eliad@wizery.com>
	 <1311607763-12603-3-git-send-email-eliad@wizery.com>
	 <4E2DA564.5070305@candelatech.com>
	 <1312892091.4109.27.camel@jlt3.sipsolutions.net>
	 <4E4135C4.4020607@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 15:28:48 +0200
Message-ID: <1312896528.4109.43.camel@jlt3.sipsolutions.net> (sfid-20110809_152855_836127_0CE446FC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 06:27 -0700, Ben Greear wrote:
> On 08/09/2011 05:14 AM, Johannes Berg wrote:
> > On Mon, 2011-07-25 at 10:18 -0700, Ben Greear wrote:
> >> On 07/25/2011 08:29 AM, Eliad Peller wrote:
> >>> The hw is currently not configured when going
> >>> back on-channel.
> >>
> >> I am less sure about this patch.  With the existing code,
> >> I think it should catch going from on channel to off
> >> and do the hw config properly.
> >>
> >> With your change it will also reconfig the hardware, but it will
> >> reconfig even if we were already on-channel (if, for instance,
> >> local->tmp_channel is oper-channel), right?
> >
> > I think even if we're already on the same channel, we might still have
> > the off-channel flag (IEEE80211_CONF_OFFCHANNEL) set? So the patch might
> > still be needed to clear that?
> 
> Well, maybe so, but if we are not off-channel and still have the off-channel
> flag set, that would seem to be another bug.

Hm, true. Not sure about this then.

johannes

