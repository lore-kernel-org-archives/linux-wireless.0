Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34162 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933885AbeF2H5K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 03:57:10 -0400
Message-ID: <1530259024.3481.6.camel@sipsolutions.net> (sfid-20180629_095714_424953_5968EE90)
Subject: Re: [PATCH] mac80211: add stop/start logic for software TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 29 Jun 2018 09:57:04 +0200
In-Reply-To: <878t71n611.fsf@toke.dk>
References: <1529997415-20551-1-git-send-email-mpubbise@codeaurora.org>
         <878t71n611.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-06-26 at 13:25 +0200, Toke Høiland-Jørgensen wrote:
> Manikanta Pubbisetty <mpubbise@codeaurora.org> writes:
> 
> > We can still invoke netif stop/wake APIs when wake_tx_queue is
> > implemented but this could lead to packet drops in network layer;
> > adding stop/start logic for software TXQs in mac80211 instead makes
> > more sense; the change proposed adds the same in mac80211.
> 
> I agree with the approach; having packets queued in mac80211 while the
> queues are stopped also means that CoDel can react to them when they are
> resumed again.
> 
> 
> > +	list_for_each_entry_rcu(sta, &local->sta_list, list) {
> > +		if (!atomic_read(&sta->txqs_paused))
> > +			continue;
> > +
> > +		atomic_set(&sta->txqs_paused, 0);
> 
> I'm not terribly well-versed in the kernel atomics, but doesn't the
> split of read and set kinda defeat the point of using them? Also, as
> this is under RCU, why do you need an atomic in the first place?

RCU doesn't do any locking, but the usage of atomic_t is indeed rather
pointless since all you do is "atomic_set()" and "atomic_read()" - which
are actually not special at all, they're just writing/reading the
variable respectively! The only thing that's really special is
atomic_inc(), atomic_dec() and friends.

If you explain what you were trying to achieve here then we can probably
help you.

I'll also review the rest of the patch now, but I'll already note you
should fix the kernel-doc complaint from the kbuild test robot.

johannes
