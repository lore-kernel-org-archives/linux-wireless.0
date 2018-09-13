Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37328 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbeIMJSN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 05:18:13 -0400
Received: by mail-lj1-f194.google.com with SMTP id v9-v6so3452294ljk.4
        for <linux-wireless@vger.kernel.org>; Wed, 12 Sep 2018 21:10:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1536578789.3224.69.camel@sipsolutions.net>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
 <1536565926.3224.15.camel@sipsolutions.net> <878t49lhy8.fsf@toke.dk> <1536578789.3224.69.camel@sipsolutions.net>
From: Kan Yan <kyan@google.com>
Date: Wed, 12 Sep 2018 21:10:30 -0700
Message-ID: <CA+iem5uyGOP1R-U_VxOjxUvy5CJV9HvxgrjciGG43Oi=SB-Hig@mail.gmail.com> (sfid-20180913_061037_416558_974F8128)
Subject: Re: [PATCH RFC v3 0/4] Move TXQ scheduling into mac80211
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I think this is a great approach, that we should definitely adopt in
> mac80211. However, I'm not sure the outstanding airtime limiting should
> be integrated into the fairness scheduling, since there are drivers such
> as ath9k that don't need it.
>
> Rather, I'd propose that we figure out the API for fairness scheduling
> first, and add the BQL-like limiter as a separate layer. They can be
> integrated in the sense that the limiter's estimate of airtime can be
> used for fairness scheduling as well in the case where the
> driver/firmware doesn't have a better source of airtime usage.
>
> Does that make sense?
Sure that make sense. Yes, the airtime based BQL like queue limiter is
not needed for drivers such as ath9k. We could leave the outstanding
airtime accounting and queue depth limit to another subject and get
airtime fairness scheduling API done first.


On Mon, Sep 10, 2018 at 4:26 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2018-09-10 at 13:17 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote=
:
>
>> > > - I did not add any locking around next_txq(); the driver is still s=
upposed
>> > >   to maintain a lock that prevents two threads from trying to schedu=
le the
>> > >   same AC at the same time. This is what drivers already do, so I fi=
gured it
>> > >   was easier to just keep it that way rather than do it in mac80211.
>> >
>> > I'll look at this in the code, but from a maintainer perspective I'm
>> > somewhat worried that this will lead to issues that are really the
>> > driver's fault, but surface in mac80211. I don't know how easy it
>> > would be to catch that.
>>
>> Yeah, I get what you mean. The alternative would be to have a
>> ieee80211_start_schedule(ac) and ieee80211_end_schedule(ac), which
>> basically just takes a lock.
>
> And I guess start would increment the schedule number, which is now
> dependent on first
>
>> Would mean we could get rid of the 'first'
>> parameter for next_txq(), so might not be such a bad idea;
>
> Right, that's what I meant.
>
>> and if the
>> driver has its own locking the extra locking in mac80211 would just be
>> an always-uncontested spinlock, which shouldn't be much overhead, right?
>
> It may still bounce around CPUs if you call this from other places, but
> I suspect that wouldn't be the biggest issue. There are a lot of
> calculations going on too...
>
> johannes
