Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:55809 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbcFDOcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 10:32:25 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Tim Shepard <shep@alum.mit.edu>
Cc: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org
Subject: Re: [RFC/RFT 2/5] ath9k: use mac80211 intermediate software queues
References: <E1b8sbm-00083e-00@www.xplot.org>
Date: Sat, 04 Jun 2016 16:32:20 +0200
In-Reply-To: <E1b8sbm-00083e-00@www.xplot.org> (Tim Shepard's message of "Fri,
	03 Jun 2016 13:10:06 -0400")
Message-ID: <87fustrpmz.fsf@toke.dk> (sfid-20160604_163229_504930_135E477D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tim Shepard <shep@alum.mit.edu> writes:

>> Reworked to not require the global variable renaming in ath9k.
>> 
>> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
>
> Huh.  I wonder why you did that?  Is it really better to call the
> ieee80211_txq a swq and call the ath9k hardware queue a txq?  I
> thought doing the renaming made for more readable and much more
> maintainable code (where searching for text strings produced much
> cleaner results when trying to track down all references).

Well, the immediate reason was that at the time I just spent two weeks
figuring out how ath9k worked and what the different concepts were, and
suddenly they start to mean something different. The txq->hwq renaming
would probably make sense in itself, but suddenly the same variable
(txq) meant something different, which was quite confusing. So I found
it was easier to change your patch to not require the renaming.

A secondary reason was to keep the patch delta as small as possible. I'm
definitely not the right person to make that call, but I found the
global renaming somewhat intrusive.

As for the first point, I think it would be easier if you did not call
the mac80211 queues 'txq' but something else ('swq' like I did, perhaps;
I also considered 'imq' for intermediate queue). This will at least make
it clear at a glance that it is something different than 'txq' was
previously.

> I am grateful to learn that someone has read my patched version of
> ath9k at least enough to do this rework. Any comments on the actual
> work?

Well, it seems to work well enough (haven't noticed the pending_frames
issue, but on the other hand I haven't been looking very hard). However,
it does fell like somewhat of a temporary solution. Having another
intermediate queue in the driver (tid->i_q) and having a side-effect in
ath_tid_has_buffered() seems a bit iffy to me. Wouldn't the 'right' way
to do it be to have ath_tid_has_buffered() ask the mac layer if it has
any frames queued, and then have ath_tx_get_tid_subframe() basically
translate straight to a call to ieee80211_tx_dequeue() (taking into
account the retry queue)? Not sure if that covers all code paths, but
the current approach seems like it has one too many layers of queues?

Haven't given the above a lot of thought, but since you asked... :)

-Toke
