Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20853 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090AbZEMSNY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 14:13:24 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 11:13:26 -0700
Date: Wed, 13 May 2009 11:13:29 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <bcopeland@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2 2/5] mac80211: inform devices when we are suspending
	on the stop callback
Message-ID: <20090513181329.GA19693@tesla>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com> <1242206461-30793-3-git-send-email-lrodriguez@atheros.com> <1242208388.14227.46.camel@johannes.local> <43e72e890905131020y66111b1nb89a3f17596efca6@mail.gmail.com> <b6c5339f0905131100v5ea764cejf005734ce9289290@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <b6c5339f0905131100v5ea764cejf005734ce9289290@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 11:00:45AM -0700, Bob Copeland wrote:
> On Wed, May 13, 2009 at 1:20 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Wed, May 13, 2009 at 2:53 AM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> >> On Wed, 2009-05-13 at 05:20 -0400, Luis R. Rodriguez wrote:
> >>> We inform the drivers so they can take appropriate actions during
> >>> suspend for WoW support.
> >>
> >>> -static void ar9170_op_stop(struct ieee80211_hw *hw)
> >>> +static void ar9170_op_stop(struct ieee80211_hw *hw, bool suspend)
> 
> Just curious, why can't the bus suspend method just turn the radio back on?
> You have to set up the wow parameters later anyway.

That's possible too.

> I think it'd be cleaner if the stack knew about WoW somehow rather than
> doing stuff behind its back in the driver.  Then suspend/resume could do
> the right thing (e.g. ops->wow_enable() instead of stop) if the driver was
> WoW-capable.

Agreed, however ath9k is the only card I know how WoW works so far. If
other devices would follow this logic then I think it makes sense to use
something like a cfg callback for wow_enable() -- but then again this is
only done for ath9k for suspend so doing it at suspend saves us a callback.

Thoughts?

  Luis
