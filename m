Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:54709 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726999AbeIEOZ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 10:25:57 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] mac80211: use non-zero TID only for QoS frames
In-Reply-To: <1536141045.3528.4.camel@sipsolutions.net>
References: <20180905080036.9177-1-johannes@sipsolutions.net> <87in3k6zti.fsf@toke.dk> <1536141045.3528.4.camel@sipsolutions.net>
Date: Wed, 05 Sep 2018 11:56:28 +0200
Message-ID: <87d0ts6zeb.fsf@toke.dk> (sfid-20180905_115633_252755_BD4FDC58)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2018-09-05 at 11:47 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>=20
>> > From: Johannes Berg <johannes.berg@intel.com>
>> >=20
>> > Some frames may have a non-zero skb->priority assigned by
>> > mac80211 internally, e.g. TDLS setup frames, regardless of
>> > support for QoS.
>> >=20
>> > Currently, we set skb->priority to 0 for all data frames.
>> > Note that there's a comment that this is "required for
>> > correct WPA/11i MIC", but that doesn't seem true as we use
>> >=20
>> >         if (ieee80211_is_data_qos(hdr->frame_control))
>> >                 qos_tid =3D ieee80211_get_tid(hdr);
>> >         else
>> >                 qos_tid =3D 0;
>> >=20
>> > in the code there. We could therefore reconsider this, but
>> > it seems like unnecessary complexity for the unlikely (and
>> > not very useful) case of not having QoS on the connection.
>> >=20
>> > This situation then causes something strange - most data
>> > frames will go on TXQ for TID 0 for non-QoS connections,
>> > but very few exceptions that are internally generated will
>> > go on another TXQ, possibly causing confusion.
>>=20
>> What kind of confusion are you seeing? Reordering issues, or something
>> else?
>
> I haven't actually been able to test this...
>
> But with the iwlwifi work we're doing, at the very least we'd waste a
> hardware queue for the case that basically never happens, since you'd
> end up putting these frames (that are very few) on a separate TXQ and
> thus hardware queue.

Ah, right, you're doing 1-to-1 TXQ-to-HWQ mapping. Gotcha.

> You could argue we should explicitly _not_ do this, but then we should
> also set skb->priority to be non-zero for non-QoS stations. Then we
> could benefit from some form of QoS (between the TXQs) for non-QoS
> connections, but that seems pretty complex and doesn't seem worth it
> since all connections that want anything from HT/11n and newer need QoS
> anyway.
>
> So basically this gets rid of a corner case that we shouldn't have.
> Either we should decide that using different TXQs is *always* correct
> for non-QoS, or - what I thought - that this isn't worth it, and then we
> should *never* do it.

Yeah, I agree that this is not worth it. The queue is already
FQ-CoDel'ed, which gives us most of the benefit of QoS anyway :)

-Toke
