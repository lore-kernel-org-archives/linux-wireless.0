Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:42147 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752667AbaCXNOO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 09:14:14 -0400
Message-ID: <1395666846.4515.52.camel@dubbel> (sfid-20140324_141418_646823_6A32EF05)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 24 Mar 2014 15:14:06 +0200
In-Reply-To: <CA+BoTQmuUK5DDv5p7OTnvQQaL7hPV459w=UhaBu1HgMeavmZBA@mail.gmail.com>
References: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
	 <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
	 <1395408675-26013-2-git-send-email-michal.kazior@tieto.com>
	 <1395663944.4515.45.camel@dubbel>
	 <CA+BoTQmuUK5DDv5p7OTnvQQaL7hPV459w=UhaBu1HgMeavmZBA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2 1/4] mac80211: fix CSA tx queue locking
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-24 at 13:58 +0100, Michal Kazior wrote:
> On 24 March 2014 13:25, Luca Coelho <luca@coelho.fi> wrote:
> > On Fri, 2014-03-21 at 14:31 +0100, Michal Kazior wrote:
> > Actually, in the beacon-didn't-change case, we should probably not even
> > stop the queues?
> 
> I think we should stop the queues. Take this for example:
> 
> 2 ap vifs. ap1 starts csa cs_count=100 block_tx=0, ap2 starts csa
> cs_count=0 block_tx=1.
> 
> In this case ap2 won't switch immediately but will stay around until
> ap1 interface is done.

Yes, this would be okay for count=0.  But for count=1 making ap2 wait
until ap1 is done could be problematic.  The STAs will be on the other
channel waiting after 1 beacon but it will take up to 99 more beacons
for ap2 to switch.  They'll probably drop the connection (or try to
roam) due to beacon loss.

I think it would be better to force ap2 to use the same count as ap1 (or
whatever is left in ap1's count).


> > You can call ieee80211_stop_queues_by_reason() even if it is already
> > stopped for this reason, but maybe you could call
> > ieee80211_csa_needs_block_tx() here to avoid eventually calling it
> > multiple times.  I think this is also a bit more consistent.
> >
> >         if(ieee80211_csa_needs_block_tx(...))
> >                 ieee80211_stop_queues_by_reason(...)
> 
> I fail to see how this would avoid calling it multiple times, or
> rather, where is it being called multiple number of times now that it
> can be prevented?
> 
> If you call ieee80211_csa_needs_block_tx() you check the block_tx
> anyway. Since csa_active is guaranteed to be true here already you
> just need to check block_tx.

Yeah, forget it.

--
Luca.

