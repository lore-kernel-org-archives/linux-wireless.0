Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52772 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab0JFKU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 06:20:59 -0400
Received: by fxm4 with SMTP id 4so1020392fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Oct 2010 03:20:58 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: hoist sta->lock from reorder release timer
Date: Wed, 6 Oct 2010 12:20:50 +0200
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ben Greear <greearb@candelatech.com>,
	Ming Lei <tom.leiming@gmail.com>
References: <201010061200.54364.chunkeey@googlemail.com> <1286359826.3655.85.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286359826.3655.85.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010061220.50800.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 06 October 2010 12:10:26 Johannes Berg wrote:
> On Wed, 2010-10-06 at 12:00 +0200, Christian Lamparter wrote:
> 
> > The timer itself is part of the station's private struct.
> > The clean-up routine will deactivate the timer as soon as
> > the station is removed. Therefore the extra sta->lock
> > protection should not be necessary.
> 
> >  	rcu_read_lock();
> > -	spin_lock(&sta->lock);
> >  	ieee80211_release_reorder_timeout(sta, *ptid);
> > -	spin_unlock(&sta->lock);
> >  	rcu_read_unlock();
> 
> There's a comment on ieee80211_release_reorder_timeout() saying that the
> lock must be held -- which is probably not true? We don't generally hold
> that lock on the RX path...?

That comment is more or less a 1:1 copy from the comment about
struct tid_ampdu_rx (in sta_info.h).

> * This structure is protected by RCU and the per-station
> * spinlock. Assignments to the array holding it must hold
> * the spinlock, only the RX path can access it under RCU
> * lock-free.

thing is: we now have the reorder_lock which protects the
reorder buffer against "destructive access". So, is it "ok"
to trim the comments a bit?
