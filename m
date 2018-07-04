Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:50667 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932290AbeGDIZW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 04:25:22 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        Peter Oh <peter.oh@bowerswilkins.com>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] mac80211: don't put null-data frames on the normal TXQ
In-Reply-To: <1530690856.3324.2.camel@sipsolutions.net>
References: <20180703124725.30917-1-johannes@sipsolutions.net> <e9813f60-5cf5-a4bf-5906-623282319991@bowerswilkins.com> <1530661681.4735.51.camel@sipsolutions.net> <87zhz7ea1s.fsf@toke.dk> <1530690856.3324.2.camel@sipsolutions.net>
Date: Wed, 04 Jul 2018 10:25:18 +0200
Message-ID: <87o9fne7bl.fsf@toke.dk> (sfid-20180704_102539_526927_BDE21214)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2018-07-04 at 09:26 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>=20
>> > I see no evidence of ath9k doing this correctly, so this might fix a
>> > bug there, but I may have missed it.
>>=20
>> ath9k does check for this, in ath_tx_sched_aggr() and in
>> ath_tx_form_aggr(); it'll check for the IEEE80211_TX_CTL_AMPDU flag, and
>> stop building the current aggregate if the flag is not set.
>
> Ok, thanks. Nevertheless, I guess it's more efficient to not stop the
> aggregate on encountering a (QoS-)NDP :-)

Oh, absolutely! :)

-Toke
