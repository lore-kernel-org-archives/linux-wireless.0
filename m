Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50321 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab0JFKlr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 06:41:47 -0400
Subject: Re: [PATCH] mac80211: hoist sta->lock from reorder release timer
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ben Greear <greearb@candelatech.com>,
	Ming Lei <tom.leiming@gmail.com>
In-Reply-To: <201010061220.50800.chunkeey@googlemail.com>
References: <201010061200.54364.chunkeey@googlemail.com>
	 <1286359826.3655.85.camel@jlt3.sipsolutions.net>
	 <201010061220.50800.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 12:41:45 +0200
Message-ID: <1286361705.3655.121.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 12:20 +0200, Christian Lamparter wrote:
> On Wednesday 06 October 2010 12:10:26 Johannes Berg wrote:
> > On Wed, 2010-10-06 at 12:00 +0200, Christian Lamparter wrote:
> > 
> > > The timer itself is part of the station's private struct.
> > > The clean-up routine will deactivate the timer as soon as
> > > the station is removed. Therefore the extra sta->lock
> > > protection should not be necessary.
> > 
> > >  	rcu_read_lock();
> > > -	spin_lock(&sta->lock);
> > >  	ieee80211_release_reorder_timeout(sta, *ptid);
> > > -	spin_unlock(&sta->lock);
> > >  	rcu_read_unlock();
> > 
> > There's a comment on ieee80211_release_reorder_timeout() saying that the
> > lock must be held -- which is probably not true? We don't generally hold
> > that lock on the RX path...?
> 
> That comment is more or less a 1:1 copy from the comment about
> struct tid_ampdu_rx (in sta_info.h).

Kinda.

> > * This structure is protected by RCU and the per-station
> > * spinlock. Assignments to the array holding it must hold
> > * the spinlock, only the RX path can access it under RCU
> > * lock-free.
> 
> thing is: we now have the reorder_lock which protects the
> reorder buffer against "destructive access". So, is it "ok"
> to trim the comments a bit?

Well, so if this patch is OK, it would be, but looking at
tid_agg_rx->head_seq_num and buf_size for example, they're not always
protected by the reorder lock (though they could easily be).

In fact, there are more races, like for example
ieee80211_release_reorder_frames not being invoked with the reorder lock
held from ieee80211_rx_h_ctrl, which could lead to issues?

Basically the thing is that until your patch, the data in the struct
didn't actually need locking because it was accessed by the RX path only
which is not concurrent.

So now we have to carefully analyse what we can do. The comment about
the sta->lock has probably never been really correct...

johannes

