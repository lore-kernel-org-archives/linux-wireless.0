Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:51679 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbcFQTQF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2016 15:16:05 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Tim Shepard <shep@alum.mit.edu>
Cc: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 1/2] ath9k: use mac80211 intermediate software queues
References: <E1bDxpG-0004Ic-00@www.xplot.org>
Date: Fri, 17 Jun 2016 21:15:58 +0200
In-Reply-To: <E1bDxpG-0004Ic-00@www.xplot.org> (Tim Shepard's message of "Fri,
	17 Jun 2016 13:45:01 -0400")
Message-ID: <87h9cr4oep.fsf@toke.dk> (sfid-20160617_211609_836909_DCDF081D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tim Shepard <shep@alum.mit.edu> writes:

> Hmm... if the renaming is going to go in mainline, I feel pretty
> strongly it should go in *before* a patch to switch over to use the
> intermediate queues.  The whole point of the renaming was to make the
> code that uses the intermediate queues much more understandable
> (avoiding the unfortuante collision of "txq" meaning two different
> things throughout the code).
>
> Once it is all done and everyone's done reading and trying to
> understand this code, there's much less reason to do the renaming.
>
> Toke, how do you feel about this at this point?

I'm fine with not renaming things for now. Been looking at the current
code enough that it doesn't bother me.

Oh, and you can hide most of the ieee80211_txq stuff behind macros, so
it doesn't have to be all over the code. Makes the patch set smaller
too...

> I'm asking because I hope to have a new version of my patch soon
> (fixing a bug in how it handles tid->hwq->pending_frames and
> hq_max_pending[*] ),

Cool. I started looking into what it will take to do a full conversion
(getting rid of the old TX path). Not quite there yet (to say the
least), so if you have a less buggy base I can work from that would be
cool ;)

-Toke
