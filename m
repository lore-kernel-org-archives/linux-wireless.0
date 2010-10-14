Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52789 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab0JNObr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 10:31:47 -0400
Subject: Re: [PATCH 3/6] Add a function for evaluating rate changes for
 possible notification
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTinq=B13gPd3obqAkBDQv4Ufz5Upp2UPVw9bpED2@mail.gmail.com>
References: <20101013224851.B8E5D20465@glenhelen.mtv.corp.google.com>
	 <1287064265.4641.435.camel@jlt3.sipsolutions.net>
	 <AANLkTinq=B13gPd3obqAkBDQv4Ufz5Upp2UPVw9bpED2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 16:32:30 +0200
Message-ID: <1287066750.4641.439.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-14 at 07:24 -0700, Paul Stewart wrote:

> >> +             if (!(ifmgd->flags & IEEE80211_STA_TX_RATE_CHANGED) ||
> >> +                 bss_conf->cqm_bitrate_thold == 0)
> >> +                     continue;
> >
> > why would this work item even be running with a threshold of zero?
> 
> This would be in the case where the userspace reset the threshold back
> to zero (no longer interested in bitrate change events) but a work
> task was already scheduled it's a small window and I can remove that
> conditional if it suits.

Makes sense, I was just wondering. Maybe just add a comment?

> > However, I think all of this is really expensive. For many devices,
> > you'll effectively be triggering an evaluation of the bitrate for every
> > packet. This will work well with minstrel, since it properly uses and
> > advertises the "best throughput" rate, but not necessarily with other
> > algorithms.
> 
> I could throttle-down the execution rate of this work proc to a
> minimum periodicity, at the expense of timely information.  Is this
> along the lines of what you'd like done?

If I'd had a good idea I probably would've mentioned it. I guess that
would work, but I don't really know. I'm just worried that there is a
lot of calculation going on all the time, like all those divisions.
Those are _really_ expensive on embedded systems.

I wonder if "rate" is really the best interface for this. Since it's a
threshold event, does it matter? Maybe there should instead be events
for MCS changes and legacy rate changes so we can avoid all those
calculations?

johannes

