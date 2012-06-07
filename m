Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33832 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab2FGSg6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 14:36:58 -0400
Message-ID: <1339094215.4630.7.camel@jlt3.sipsolutions.net> (sfid-20120607_203710_507564_555516DC)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
 n_queues))
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: Andre Heider <a.heider@gmail.com>, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Date: Thu, 07 Jun 2012 20:36:55 +0200
In-Reply-To: <20120607180325.7752b3c0@milhouse>
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	 <1339014959.4523.0.camel@jlt3.sipsolutions.net>
	 <CAHsu+b-ByqBaci9W-oS3OPEK3LdRcuGphtQPOTQ02hPWNpWgQw@mail.gmail.com>
	 <1339053364.4517.0.camel@jlt3.sipsolutions.net>
	 <CAHsu+b9UjkF6VM_YjJkHVDQzrZqsWqmG-XJKFNeSCdWGbdEngw@mail.gmail.com>
	 <20120607180325.7752b3c0@milhouse>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-07 at 18:03 +0200, Michael Büsch wrote:


> > >    mac80211: fix single queue drivers
> > 
> > Just checked again, that commit was already part of my tree, so I
> > still run into this issue.
> > 
> > A couple of printk()'s report that local->hw.queues is 4 in
> > ieee80211_set_default_queues() while n_queues in
> > ieee80211_check_queues() is 1...
> 
> b43 messes with the queue count at runtime. I guess that's the reason.

Oh, right, I forgot all about that, bugger. That would seem to be the
reason since setting it to 4 initially will create the mapping 0->0,
1->1, 2->2, 3->3 and then if it's 1 later, the expected mapping would be
0,1,2,3->0 instead.

> I don't know if this can be fixed now, though. The problem is that we
> first need to load the firmware before we know the queue count.

Yes it can (and I think it should) be: The firmware is now requested
from the probe routines, and b43_request_firmware() only registers with
mac80211 when the firmware has successfully loaded from disk. The only
problem is that b43_request_firmware() doesn't actually bring the core
up before registering since that wasn't necessary until now. It would've
been easier if the firmware packaging contained the flag instead of the
SHM :-)

However, it's also possible to actually *use* the new mac80211 feature.
That would also help with IEEE80211_TX_CTL_SEND_AFTER_DTIM, you could
ask mac80211 to use a separate HW queue for it (for tx_ring_mcast.) This
may be quicker.

johannes

