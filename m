Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53064 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbdJFJoo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 05:44:44 -0400
Message-ID: <1507283082.19300.6.camel@sipsolutions.net> (sfid-20171006_114452_004880_2E063EBF)
Subject: Re: converting mac80211 to TXQs entirely
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless <linux-wireless@vger.kernel.org>
Cc: nbd <nbd@nbd.name>, Kalle Valo <kvalo@codeaurora.org>
Date: Fri, 06 Oct 2017 11:44:42 +0200
In-Reply-To: <878tgps1o7.fsf@toke.dk>
References: <1507205618.2387.19.camel@sipsolutions.net>
         <1507217947.2387.60.camel@sipsolutions.net> <87efqhsgni.fsf@toke.dk>
         <1507221836.2387.66.camel@sipsolutions.net> <878tgps1o7.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-10-05 at 23:52 +0200, Toke Høiland-Jørgensen wrote:
> 
> > I think that's reasonable. I'm not really sure it's *necessary*
> > though? Couldn't mac80211 return NULL, and then simply call
> > wake_tx_queue again when the TXQ becomes eligible for scheduling
> > again? Otherwise the driver might end up doing a lot of polling for
> > it to become eligible again?
> 
> Theoretically, but then there would have to be some kind of callback
> or another mechanism to figure out when the queue is ready again. The
> neat thing about DRR scheduling is that we just use the fact that
> there was an attempt to schedule the queue as an opportunity to
> increase that queue's deficit by one quantum. This does give a bit of
> "polling overhead" as you say, but it has been hidden in the
> measurement noise in all my tests.

Ok.

> The obvious alternative is to do a token-based airtime scheduler,
> where the airtime used by one station is immediately divided out to
> all active stations. But that requires walking over all active
> stations on every TX completion, and there's a lot of housekeeping to
> make sure we don't accidentally starve everyone. So I'd prefer to
> stick with the DRR scheduler :)

Sure, works for me.

I have no objection to defining a special error code (we can always use
ERR_PTR(-EAGAIN) or something like that, after all) - we just need to
be careful with driver updates.

Given all these discussions, I'd actually like to put a temporary
restriction on merging new drivers with TXQ support - Felix, I think
you were planning to eventually use this for mt7601u? How far along is
that?

johannes
