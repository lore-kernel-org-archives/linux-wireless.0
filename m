Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:57079 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbeIERUw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 13:20:52 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] mac80211: TDLS: fix skb queue/priority assignment
In-Reply-To: <1536150812.3528.15.camel@sipsolutions.net>
References: <20180905113402.7665-1-johannes@sipsolutions.net> <1536147453.3528.11.camel@sipsolutions.net> <87k1o05g04.fsf@toke.dk> <1536147683.3528.12.camel@sipsolutions.net> <1536147865.3528.14.camel@sipsolutions.net> <87efe8yvju.fsf@toke.dk> <1536150812.3528.15.camel@sipsolutions.net>
Date: Wed, 05 Sep 2018 14:50:41 +0200
Message-ID: <87bm9cyuou.fsf@toke.dk> (sfid-20180905_145046_447987_557F85BD)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2018-09-05 at 14:32 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>=20
>> > On Wed, 2018-09-05 at 13:41 +0200, Johannes Berg wrote:
>> > > On Wed, 2018-09-05 at 13:40 +0200, Toke H=C3=B8iland-J=C3=B8rgensen =
wrote:
>> > > >=20
>> > > > Guess we'll have to deal with everything else if we ever move mana=
gement
>> > > > frames onto the TXQ path as well...
>> > >=20
>> > > Depends on whether we care for management frame priorities or not ..=
. so
>> > > far we haven't really.
>> >=20
>> > Actually, for the most part we have implemented that properly. Except
>> > for the TXQ I added for bufferable management ... oh well, I think we'=
re
>> > the only user thereof now.
>> >=20
>> > I'm not sure we want to have a TXQ per TID for management, that seems
>> > overkill. But I'm also not sure how to solve this otherwise ...
>>=20
>> Graft it to an existing TXQ, similar to how the fragments queue is used
>> now? Saves a TXQ at the expense of having to special-case it...
>
> The problem isn't so much how we handle it in mac80211 for the queueing,
> but how we deal with things like A-MSDU and how we present it to the
> driver ... for iwlwifi at least we'd really like to have only data
> frames so we can map it directly to the hardware queue ...

Ah, I see. No, then just putting them at the head of a different TXQ
probably won't work...

Are you mapping TXQs to hardware queues dynamically as they empty and
re-fill? Presumably you'll have cases where you don't have enough HWQs?

-Toke
