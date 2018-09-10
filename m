Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:40013 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727649AbeIJRdB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 13:33:01 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH RFC v3 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <1536577419.3224.50.camel@sipsolutions.net>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1> <153635897010.14170.2992498632345986102.stgit@alrua-x1> <1536565717.3224.12.camel@sipsolutions.net> <87musplivy.fsf@toke.dk> <1536577419.3224.50.camel@sipsolutions.net>
Date: Mon, 10 Sep 2018 14:39:05 +0200
Message-ID: <87zhwpjzme.fsf@toke.dk> (sfid-20180910_143911_947337_EF1C9C2E)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2018-09-10 at 12:57 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>=20
>> > On Sat, 2018-09-08 at 00:22 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wr=
ote:
>> > >=20
>> > > Usage of the new API is optional, so drivers can be ported one at a =
time.
>> >=20
>> > With the 1:1 hardware queue/txq mapping in iwlwifi (we're close to
>> > getting that patch in, though now the Jewish holidays mean a delay),
>> > I'm not sure we'd be able to do this at all in iwlwifi. So this may
>> > not be a case of porting one at a time until we can get rid of it ...
>>=20
>> Could you elaborate a bit more on how the hwq/txq stuff works in iwl?
>
> I can try.
>
>> Does the driver just hand off a TXQ to the hardware on wake_txq(), which
>> is then scheduled by the hardware after that? Or how does the mapping to
>> hwqs work, and how is the hardware notified that there are still packets
>> queued / that new packets have arrived for an already mapped txq?
>
> Basically, we use the TXQ driver data to do this. On initialization, we
> set all TXQs to have no hardware queue mapped. Then, when the first wake
> happens for this TXQ, we allocate a hardware queue for this RA/TID.
>
> From then on, right now we basically just try to refill the hardware
> queue from the TXQ whenever the hardware releases frames from that
> queue. If there are none, we fall back to putting them on the hardware
> queue from the wake signal.

OK. So if the TXQ is ineligible to dequeue packets, but still have them
queued, there would need to be a signal (such as wake_txq()) when it
becomes eligible again, right?

-Toke
