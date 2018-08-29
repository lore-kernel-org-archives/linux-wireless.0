Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:37648 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbeH2NUp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 09:20:45 -0400
Message-ID: <1535534678.5215.23.camel@sipsolutions.net> (sfid-20180829_112449_391118_A74203F2)
Subject: Re: [RFC v2 1/4] mac80211: Add TXQ scheduling API
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Cc: make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>
Date: Wed, 29 Aug 2018 11:24:38 +0200
In-Reply-To: <87a7p54jed.fsf@toke.dk>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1>
         <153115422491.7447.12479559048433925372.stgit@alrua-x1>
         <1535528167.5215.15.camel@sipsolutions.net> <87a7p54jed.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-08-29 at 11:22 +0200, Toke Høiland-Jørgensen wrote:

> > We're also working on adding a TXQ for (bufferable) management packets
> > - I wonder how that should interact here? Always be scheduled first?
> 
> Ah, cool! It may be that it should be given priority, yeah. Presently,
> the multicast queue just rotates in the RR with the others, but is never
> throttled as it doesn't have an airtime measure (though perhaps it
> should)? But that might not be desirable for management frames, as
> presumable those need to go out as fast as possible?

Good question. I guess the multicast should have an airtime measure, but
I don't think we want to do accounting on the management. That really
should be few frames, and we want them out ASAP in most cases.

> Hmm, I seem to recall thinking about just putting the call to
> schedule_txq() into drv_wake_tx_queue; don't remember why I ended up
> dropping that; but will take another look at whether it makes sense to
> combine things.

I was thinking the other way around - but that doesn't work since you'd
loop from the driver to itself. This way might work, I guess, hadn't
considered that.

Might be better anyway though to make a new inline that does both, since
the drv_() calls usually really don't do much on their own (other than
checks, and in one case backward compatibility code, but still)

johannes
