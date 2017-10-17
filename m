Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60980 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934919AbdJQKAr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 06:00:47 -0400
Message-ID: <1508234443.10607.72.camel@sipsolutions.net> (sfid-20171017_120050_355859_D76F167C)
Subject: Re: [PATCH 2/2] mac80211: Add airtime accounting and scheduling to
 TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Tue, 17 Oct 2017 12:00:43 +0200
In-Reply-To: <871sm2p6rt.fsf@toke.dk>
References: <20171016160902.8970-1-toke@toke.dk>
         <20171016160902.8970-2-toke@toke.dk>
         <1508224046.10607.67.camel@sipsolutions.net> <871sm2p6rt.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-10-17 at 09:34 +0200, Toke Høiland-Jørgensen wrote:

> Yeah, I did that initially. The reason I ended up squashing them is
> that
> this patch moved the per-station 'airtime' debugfs-entry that was
> previously created by ath9k into mac80211. I assumed it would create
> problems if both the driver and mac80211 tried to create the same
> file;
> not sure how to handle that if it's split into two patches?

That might indeed be problematic, so perhaps just use a different name?
Then again, if adding the entry fails in ath9k, nothing will happen
since it doesn't even check the return value - so I think it doesn't
actually matter.

> > I'd prefer this were called "airtime" or such,
> 
> Right. I picked rx_time for symmetry with the tx side; should I
> rename that as well, then, or is asymmetry fine?

Let's not change the tx side in this patch, but we can clean it up
later I guess.

johannes
