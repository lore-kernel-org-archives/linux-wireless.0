Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41753 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab1KXSjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 13:39:07 -0500
Subject: Re: [PATCH v2 0/3] mac80211: timeout tx agg sessions in way
 similar to rx agg sessions
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <CALGY4fv6NTRDPUEa-7h+DqaHZwdKnNG4fEmzyHrYZukz3B1gqA@mail.gmail.com> (sfid-20111124_193358_972023_10DAB172)
References: <1322016630-27332-1-git-send-email-mar.kolya@gmail.com>
	 <1322158678.5366.27.camel@jlt3.sipsolutions.net>
	 <CALGY4fv6NTRDPUEa-7h+DqaHZwdKnNG4fEmzyHrYZukz3B1gqA@mail.gmail.com>
	 (sfid-20111124_193358_972023_10DAB172)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 19:39:04 +0100
Message-ID: <1322159944.5366.42.camel@jlt3.sipsolutions.net> (sfid-20111124_193911_596534_7ABB278D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-24 at 13:33 -0500, Nikolay Martynov wrote:

> > Looks OK to me. Did you run it through sparse too? :-)
> >
>   Please forgive my lack of experience, but could you please point me
> to some docs where I can read about sparse and how to use it? I'd
> really appreciate this.

Sure, FWIW, I'm just asking because I received lots of patches recently
that later got sparse warnings. I guess you normally run something like

make M=net/mac80211

To run sparse, you add C=1 (just run sparse if cc runs) or C=2 (run
sparse on all files). Obviously you need to install sparse first, your
distribution probably has packages.

>   Also, I one more thing I forgot to mention in original cover letter.
> Some time before this patch I've posted patch for ath9k: "[PATCH v3]
> ath9k: improve ath_tx_aggr_stop to avoid TID stuck in cleanup state".
> I've noticed that bug fixed in ath9k patch is triggered much more
> often when this patch to mac80211 applied. Probably because of some
> timing issues when TID is being closed from both ends at about same
> time.
>   What I mean to say is that this patch to mac80211 should probably be
> applied after that patch to ath9k to avoid making ath9k less stable.

You should send that info to the list not just me, I've added the list
back.

>   And one more thing, if you do not mind.
> 'ieee80211_stop_tx_ba_session' tests tx_tid->state for
> HT_AGG_STATE_STOPPING holding only spinlock on sta->lock.
> '___ieee80211_stop_tx_ba_session' sets this bit when spin lock on
> sta->lock is not being held. It seems to be that this could lead to
> problems if these two functions get called at about same time (which
> could easily happen when this patch is applied). Although actual
> window when lock is not help is really small. But I think the way it
> is currently done could still lead to problems. I think
> 'set_bit(HT_AGG_STATE_STOPPING, &tid_tx->state);' should be moved up
> to be covered by spin lock. I can include this as a part of next
> version of my patch. I'd really appreciate your thoughts about this.

Yeah that does indeed seem like an issue -- please send a separate patch
outside of this series and add Cc: stable@vger.kernel.org (to the patch
description not to the actual email, if you're not familiar with the
stable submission rules please check for those)

johannes

