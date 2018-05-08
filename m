Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:47085 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754408AbeEHKX4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 06:23:56 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] cfg80211: Expose TXQ stats and parameters to userspace
In-Reply-To: <1525774746.14830.4.camel@sipsolutions.net>
References: <20180219170224.14816-1-toke@toke.dk> <20180219170224.14816-2-toke@toke.dk> <1525720384.22388.2.camel@sipsolutions.net> <87in7y5u3h.fsf@toke.dk> <1525774746.14830.4.camel@sipsolutions.net>
Date: Tue, 08 May 2018 12:23:55 +0200
Message-ID: <87fu325ttw.fsf@toke.dk> (sfid-20180508_122400_630626_8057FAE4)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2018-05-08 at 12:18 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>=20
>> > net/mac80211/cfg.c:3762:12: warning: context imbalance in
>> > 'ieee80211_get_txq_stats' - different lock contexts for basic block
>>=20
>> Found and fixed all the other warnings, but I'm not seeing this one. And
>> I don't really see what is wrong with the locking in that function? What
>> am I missing?
>
> Oh and what's wrong is that you "return 1" from the function with a lock
> held in one place, IIRC.

Ohhh, right... I already fixed that in my local branch, which is why I
can't find it I guess :D

-Toke
