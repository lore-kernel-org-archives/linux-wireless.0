Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:33903 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751756AbcIJUJQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Sep 2016 16:09:16 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Jim Gettys <jg@freedesktop.org>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [Make-wifi-fast] [PATCH] mac80211: Dynamically set CoDel
        parameters per station.
References: <20160910193315.30738-1-toke@toke.dk>
        <CAGhGL2D8Hfed0VTsinnCbkK31dGTc=bYjzpPfrcLRnp+x6O3sA@mail.gmail.com>
Date: Sat, 10 Sep 2016 22:09:10 +0200
In-Reply-To: <CAGhGL2D8Hfed0VTsinnCbkK31dGTc=bYjzpPfrcLRnp+x6O3sA@mail.gmail.com>
        (Jim Gettys's message of "Sat, 10 Sep 2016 15:54:44 -0400")
Message-ID: <87bmzv7c0p.fsf@toke.dk> (sfid-20160910_222042_947622_646B86A4)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jim Gettys <jg@freedesktop.org> writes:

>> On Sat, Sep 10, 2016 at 3:33 PM, Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
toke.dk> wrote:
>>
>>  CoDel can be too aggressive if a station sends at a very low rate,
>>  leading to starvation. This gets worse the more stations are present, as
>>  each station gets more bursty the longer the round-robin scheduling
>>  between stations takes.
>>
>>  This adds dynamic adjustment of CoDel parameters per station. It uses
>>  the rate selection information to estimate throughput and sets more
>>  lenient CoDel parameters if the estimated throughput is below a
>>  threshold. To not change parameters too often, a hysteresis of two
>>  seconds is added.
>
> =E2=80=8BWhere is this 2 second constant coming from? I'd expect it shoul=
d be
> of order the maximum RTT (or a small constant factor of that, which
> for intercontinental connections should be 200-300ms.

Well, in most cases a station is either going to be squarely below or
squarely above the threshold. The hysteresis is there to deal with the
exception to this, where a station's rate oscillates around the
threshold. I picked two seconds as something that is far enough above
the CoDel interval to hopefully let it do its thing.

> More interestingly, maybe the adjustment should be related to the # of
> active stations.

There is no doubt the algorithm can be improved. This is just a stopgap
measure to avoid starving slow stations. The CoDel parameters for slow
stations could be set smarter as well, or they could be scaled with the
rate instead of being threshold based. But since we have FQ, being
lenient can work without affecting latency too much.

> Basically, I'm pushing back about an arbitrary number apparently
> picked out of thin air... ;-).

You're very welcome to contribute to coming up with a better solution ;)

-Toke
