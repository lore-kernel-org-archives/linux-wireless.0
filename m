Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:36221 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752745AbeGCOgT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 10:36:19 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] mac80211: don't put null-data frames on the normal TXQ
In-Reply-To: <1530628340.4735.29.camel@sipsolutions.net>
References: <20180703124725.30917-1-johannes@sipsolutions.net> <87601wfl1u.fsf@toke.dk> <1530628340.4735.29.camel@sipsolutions.net>
Date: Tue, 03 Jul 2018 16:36:12 +0200
Message-ID: <8736x0fktf.fsf@toke.dk> (sfid-20180703_163623_475588_DDC65CDD)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2018-07-03 at 16:31 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>=20
>> > From: Johannes Berg <johannes.berg@intel.com>
>> >=20
>> > Since (QoS) NDP frames shouldn't be put into aggregation nor are
>> > assigned real sequence numbers, etc. it's better to treat them as
>> > non-data packets and not put them on the normal TXQs, for example
>> > when building A-MPDUs they need to be treated specially, and they
>> > are more used for management (e.g. to see if the station is alive)
>> > anyway.
>>=20
>> No objections to this per se;
>
> :-)
>
>> but didn't we want to move towards
>> everything going through the TXQs? Any progress on that front? :)
>
> Not really. Yes, I wanted to, but it's some massive surgery. Right now
> I'm working on converting iwlwifi, perhaps I'll learn about it more
> and can then do the mac80211 surgery better later.

Right, sounds good! Looking forward to the iwlwifi conversion :)

-Toke
