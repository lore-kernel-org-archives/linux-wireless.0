Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48148 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab0JFLnc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 07:43:32 -0400
Received: by fxm4 with SMTP id 4so1048933fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Oct 2010 04:43:31 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: hoist sta->lock from reorder release timer
Date: Wed, 6 Oct 2010 13:43:21 +0200
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ben Greear <greearb@candelatech.com>,
	Ming Lei <tom.leiming@gmail.com>
References: <201010061200.54364.chunkeey@googlemail.com> <201010061220.50800.chunkeey@googlemail.com> <1286361705.3655.121.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286361705.3655.121.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010061343.23463.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 06 October 2010 12:41:45 Johannes Berg wrote:
> On Wed, 2010-10-06 at 12:20 +0200, Christian Lamparter wrote:
> > On Wednesday 06 October 2010 12:10:26 Johannes Berg wrote:
> > > On Wed, 2010-10-06 at 12:00 +0200, Christian Lamparter wrote:
> > > 
> > > > The timer itself is part of the station's private struct.
> > > > The clean-up routine will deactivate the timer as soon as
> > > > the station is removed. Therefore the extra sta->lock
> > > > protection should not be necessary.
> > > 
> > > >  	rcu_read_lock();
> > > > -	spin_lock(&sta->lock);
> > > >  	ieee80211_release_reorder_timeout(sta, *ptid);
> > > > -	spin_unlock(&sta->lock);
> > > >  	rcu_read_unlock();
> > > 
> > > There's a comment on ieee80211_release_reorder_timeout() saying that the
> > > lock must be held -- which is probably not true? We don't generally hold
> > > that lock on the RX path...?
> > 
> > That comment is more or less a 1:1 copy from the comment about
> > struct tid_ampdu_rx (in sta_info.h).
> 
> Kinda.
> 
> > > * This structure is protected by RCU and the per-station
> > > * spinlock. Assignments to the array holding it must hold
> > > * the spinlock, only the RX path can access it under RCU
> > > * lock-free.
> > 
> > thing is: we now have the reorder_lock which protects the
> > reorder buffer against "destructive access". So, is it "ok"
> > to trim the comments a bit?
> 
> Well, so if this patch is OK, it would be, but looking at
> tid_agg_rx->head_seq_num and buf_size for example, they're not always
> protected by the reorder lock (though they could easily be).
> 
> In fact, there are more races, like for example
> ieee80211_release_reorder_frames not being invoked with the reorder lock
> held from ieee80211_rx_h_ctrl, which could lead to issues?
> 
> Basically the thing is that until your patch, the data in the struct
> didn't actually need locking because it was accessed by the RX path only
> which is not concurrent.
> 
I see. So basically all rx handlers are affected by these rx->sta races.

John, can you please revert (or at least drop from the upcoming 2.6.37-rcX cycle):

(mac80211: fix release_reorder_timeout in scan)
mac80211: fix rcu-unsafe pointer dereference
mac80211: AMPDU rx reorder timeout timer
(mac80211: remove unused rate function parameter)
mac80211: put rx handlers into separate functions
