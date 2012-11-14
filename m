Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44376 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932782Ab2KNJhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 04:37:19 -0500
Message-ID: <1352885873.9510.21.camel@jlt4.sipsolutions.net> (sfid-20121114_103724_688457_4440419C)
Subject: Re: WARNING in agg-tx.c (3.5.7+, not tainted)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 14 Nov 2012 10:37:53 +0100
In-Reply-To: <5091B7CC.8030003@candelatech.com>
References: <509173D0.9010701@candelatech.com>
	   (sfid-20121031_195414_905498_198D44C4) <1351710647.6281.10.camel@jlt4.sipsolutions.net>
	  <5091798A.7010104@candelatech.com>
	 <1351711256.5419.2.camel@jlt4.sipsolutions.net>
	 <5091B7CC.8030003@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-31 at 16:44 -0700, Ben Greear wrote:

> >>>> 	mutex_lock(&sta->ampdu_mlme.mtx);
> >>>> 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
> >>>>
> >>>> 	if (WARN_ON(!tid_tx)) {
> >>>> #ifdef CONFIG_MAC80211_HT_DEBUG
> >>>> 		printk(KERN_DEBUG "addBA was not requested!\n");
> >>>> #endif
> >>>
> >>> Hm should probably be a WARN(), but ...
> >>>
> >>> From the backtrace it looks like maybe you were tearing down the
> >>> interface? So maybe it's possible that you were remove it or something,
> >>> and the driver had just accepted the session? Hmm.
> >>
> >> I've got 400 interfaces churning, some being reset due to lack of
> >> fast enough DHCP response, etc.  Could easily be related to that
> >> drv-remove-interface bug as well..

> Unfortunately, it still happens even with the other patch applied.

Ok.

> I have only seen it once in several hours of testing, and it doesn't
> seem to cause any lasting harm.
> 
> But, I have at least some sort of test case for it, so
> if you have a suggested patch, I'll be happy to test it.

I don't, sorry, and I haven't really had the time to investigate. It's
probably a race condition with the driver, something like this:

 - BA session start request
 - frame sent to the peer
 - driver asked
 - driver says OK, which gets queued on the workqueue
 - meanwhile, workqueue is doing something else
   (since you have lots of interfaces)
 - now you ifdown before the workqueue comes around to the new item
 - removing the interface removes the station, which in turn removes the
   aggregation session data
 - now the workqueue flush (which you found slow in your other thread)
   comes and runs the new item, which warns because the station data
   aggregation data is long gone

Something like that, I suspect.

johannes

