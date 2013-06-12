Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43351 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab3FLVBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 17:01:10 -0400
Message-ID: <1371070866.8601.42.camel@jlt4.sipsolutions.net> (sfid-20130612_230117_021752_746858C1)
Subject: Re: kmemleak report related to ieee80211_start_tx_ba_session,
 tid_start_tx locking issues?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 12 Jun 2013 23:01:06 +0200
In-Reply-To: <51B8E101.2050503@candelatech.com>
References: <51B8BC3E.40905@candelatech.com>
	  (sfid-20130612_202155_810155_8B14A60D) <1371069960.8601.35.camel@jlt4.sipsolutions.net>
	 <51B8E101.2050503@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-06-12 at 13:58 -0700, Ben Greear wrote:

> > When did this report get printed?
> 
> I have a system with 100 or so stations constantly trying to
> associate with a set of APs that can handle < 100.  This
> effectively causes constant churn of re-associations and
> associated logic...

Right ... I figured it was this.

> Good for shaking out bugs it seems :)
> 
> These and other leaks show up after a few minutes of
> running this test scenario.  It's not a huge number of
> leaks, however...so usually stations go away w/out leaking.

That's not all too surprising really, the work should run quickly I
guess.

Anyway I guess kmemleak doesn't actually let you pinpoint when the leak
occurred because it just scans periodically and not on every kfree, so
n/m my question.


> >   	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
> > +		kfree(sta->ampdu_mlme.tid_start_tx[i]);
> >   		tid_tx = rcu_dereference_raw(sta->ampdu_mlme.tid_tx[i]);
> >   		if (!tid_tx)
> >   			continue;
> 
> Looks reasonable to me.  I was about to start testing similar logic
> in sta_info_free(), but likely your patch is more proper.
> 
> I'll give it a try now.

Thanks.

johannes

