Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:50933 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbeIJQL0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 12:11:26 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH RFC v3 0/4] Move TXQ scheduling into mac80211
In-Reply-To: <1536565926.3224.15.camel@sipsolutions.net>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1> <1536565926.3224.15.camel@sipsolutions.net>
Date: Mon, 10 Sep 2018 13:17:51 +0200
Message-ID: <878t49lhy8.fsf@toke.dk> (sfid-20180910_131755_536087_1AE67262)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sat, 2018-09-08 at 00:22 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>=20
>> A few things that were discussed in the last round that I did *not* chan=
ge:
>
> Thanks for this list btw.
>
>> - I did not add any locking around next_txq(); the driver is still suppo=
sed
>>   to maintain a lock that prevents two threads from trying to schedule t=
he
>>   same AC at the same time. This is what drivers already do, so I figure=
d it
>>   was easier to just keep it that way rather than do it in mac80211.
>
> I'll look at this in the code, but from a maintainer perspective I'm
> somewhat worried that this will lead to issues that are really the
> driver's fault, but surface in mac80211. I don't know how easy it
> would be to catch that.

Yeah, I get what you mean. The alternative would be to have a
ieee80211_start_schedule(ac) and ieee80211_end_schedule(ac), which
basically just takes a lock. Would mean we could get rid of the 'first'
parameter for next_txq(), so might not be such a bad idea; and if the
driver has its own locking the extra locking in mac80211 would just be
an always-uncontested spinlock, which shouldn't be much overhead, right?

-Toke
