Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47054 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759729Ab2JaTUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 15:20:22 -0400
Message-ID: <1351711256.5419.2.camel@jlt4.sipsolutions.net> (sfid-20121031_202024_722038_8759DAC1)
Subject: Re: WARNING in agg-tx.c (3.5.7+, not tainted)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 31 Oct 2012 20:20:56 +0100
In-Reply-To: <5091798A.7010104@candelatech.com>
References: <509173D0.9010701@candelatech.com>
	  (sfid-20121031_195414_905498_198D44C4) <1351710647.6281.10.camel@jlt4.sipsolutions.net>
	 <5091798A.7010104@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-31 at 12:18 -0700, Ben Greear wrote:

> >> 	mutex_lock(&sta->ampdu_mlme.mtx);
> >> 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
> >>
> >> 	if (WARN_ON(!tid_tx)) {
> >> #ifdef CONFIG_MAC80211_HT_DEBUG
> >> 		printk(KERN_DEBUG "addBA was not requested!\n");
> >> #endif
> >
> > Hm should probably be a WARN(), but ...
> >
> >>From the backtrace it looks like maybe you were tearing down the
> > interface? So maybe it's possible that you were remove it or something,
> > and the driver had just accepted the session? Hmm.
> 
> I've got 400 interfaces churning, some being reset due to lack of
> fast enough DHCP response, etc.  Could easily be related to that
> drv-remove-interface bug as well..

I didn't even think of that, but yeah, that seems possible.

> it is much more easily reproduced
> in this scenario.  Will re-run some tests with your suggested patch
> applied...

Ok cool.

johannes

