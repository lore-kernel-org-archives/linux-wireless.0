Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:50607 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727649AbeIJPpv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 11:45:51 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Kan Yan <kyan@google.com>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH RFC v3 0/4] Move TXQ scheduling into mac80211
In-Reply-To: <CA+iem5te2vFq+aXiVDZ7OhuWkR+cScOKiV8bSb85ycD6WDK1WQ@mail.gmail.com>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1> <CA+iem5te2vFq+aXiVDZ7OhuWkR+cScOKiV8bSb85ycD6WDK1WQ@mail.gmail.com>
Date: Mon, 10 Sep 2018 12:52:21 +0200
Message-ID: <87pnxllj4q.fsf@toke.dk> (sfid-20180910_125238_507033_4B9B7BFD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kan Yan <kyan@google.com> writes:

> Hi Toke,
>
> It is great to see finally there will be a general airtime fairness
> support in mac80211. I feel this patch set could still use some
> improvements to make it works better with 11ac drivers like ath10k. I
> did a version of airtime fairness in the ath10k driver that used in
> Google Wifi and I'd like to share a few things I learned from this
> experience.

Hi Kan

Thanks for weighing in!

> The idea is to use airtime accounting to give firmware just enough
> frames to keep it busy and form good aggregations, and keeps the rest
> of frames in mac80211 layer queues so Fq_Codel can work on it to
> control latency.

I think this is a great approach, that we should definitely adopt in
mac80211. However, I'm not sure the outstanding airtime limiting should
be integrated into the fairness scheduling, since there are drivers such
as ath9k that don't need it.

Rather, I'd propose that we figure out the API for fairness scheduling
first, and add the BQL-like limiter as a separate layer. They can be
integrated in the sense that the limiter's estimate of airtime can be
used for fairness scheduling as well in the case where the
driver/firmware doesn't have a better source of airtime usage.

Does that make sense?

-Toke
