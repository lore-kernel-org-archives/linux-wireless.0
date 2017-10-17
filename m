Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:50089 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753597AbdJQKJv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 06:09:51 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <1508234443.10607.72.camel@sipsolutions.net>
References: <20171016160902.8970-1-toke@toke.dk> <20171016160902.8970-2-toke@toke.dk> <1508224046.10607.67.camel@sipsolutions.net> <871sm2p6rt.fsf@toke.dk> <1508234443.10607.72.camel@sipsolutions.net>
Date: Tue, 17 Oct 2017 12:09:48 +0200
Message-ID: <871sm29jbn.fsf@toke.dk> (sfid-20171017_120955_083076_6670E4CB)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2017-10-17 at 09:34 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> Yeah, I did that initially. The reason I ended up squashing them is
>> that
>> this patch moved the per-station 'airtime' debugfs-entry that was
>> previously created by ath9k into mac80211. I assumed it would create
>> problems if both the driver and mac80211 tried to create the same
>> file;
>> not sure how to handle that if it's split into two patches?
>
> That might indeed be problematic, so perhaps just use a different
> name?

Well I would like to keep compatibility with my tooling that reads the
values :)

> Then again, if adding the entry fails in ath9k, nothing will happen
> since it doesn't even check the return value - so I think it doesn't
> actually matter.

Right, I'll try that, and otherwise create a separate patch to ath9k
that removes the debugfs entry before applying the mac80211 patch.

>> > I'd prefer this were called "airtime" or such,
>>=20
>> Right. I picked rx_time for symmetry with the tx side; should I
>> rename that as well, then, or is asymmetry fine?
>
> Let's not change the tx side in this patch, but we can clean it up
> later I guess.

ACK.

-Toke
