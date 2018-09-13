Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:45491 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726792AbeIMOeD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 10:34:03 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Kan Yan <kyan@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH RFC v3 0/4] Move TXQ scheduling into mac80211
In-Reply-To: <CA+iem5uyGOP1R-U_VxOjxUvy5CJV9HvxgrjciGG43Oi=SB-Hig@mail.gmail.com>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1> <1536565926.3224.15.camel@sipsolutions.net> <878t49lhy8.fsf@toke.dk> <1536578789.3224.69.camel@sipsolutions.net> <CA+iem5uyGOP1R-U_VxOjxUvy5CJV9HvxgrjciGG43Oi=SB-Hig@mail.gmail.com>
Date: Thu, 13 Sep 2018 11:25:23 +0200
Message-ID: <87y3c5hhq4.fsf@toke.dk> (sfid-20180913_112528_472909_D5E1D322)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kan Yan <kyan@google.com> writes:

>> I think this is a great approach, that we should definitely adopt in
>> mac80211. However, I'm not sure the outstanding airtime limiting should
>> be integrated into the fairness scheduling, since there are drivers such
>> as ath9k that don't need it.
>>
>> Rather, I'd propose that we figure out the API for fairness scheduling
>> first, and add the BQL-like limiter as a separate layer. They can be
>> integrated in the sense that the limiter's estimate of airtime can be
>> used for fairness scheduling as well in the case where the
>> driver/firmware doesn't have a better source of airtime usage.
>>
>> Does that make sense?
> Sure that make sense. Yes, the airtime based BQL like queue limiter is
> not needed for drivers such as ath9k. We could leave the outstanding
> airtime accounting and queue depth limit to another subject and get
> airtime fairness scheduling API done first.

Cool! I was thinking I would stub out an untested PoC in a separate
patch on my next submission, to show how I think this could be
incorporated. Have some other stuff to finish up this week, but
hopefully I'll have time to do the next version over the weekend :)

-Toke
