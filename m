Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:46455 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727096AbeIJPvJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 11:51:09 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH RFC v3 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <1536565717.3224.12.camel@sipsolutions.net>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1> <153635897010.14170.2992498632345986102.stgit@alrua-x1> <1536565717.3224.12.camel@sipsolutions.net>
Date: Mon, 10 Sep 2018 12:57:37 +0200
Message-ID: <87musplivy.fsf@toke.dk> (sfid-20180910_125743_081463_C8CD22DF)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sat, 2018-09-08 at 00:22 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>=20
>> Usage of the new API is optional, so drivers can be ported one at a time.
>
> With the 1:1 hardware queue/txq mapping in iwlwifi (we're close to
> getting that patch in, though now the Jewish holidays mean a delay),
> I'm not sure we'd be able to do this at all in iwlwifi. So this may
> not be a case of porting one at a time until we can get rid of it ...

Could you elaborate a bit more on how the hwq/txq stuff works in iwl?
Does the driver just hand off a TXQ to the hardware on wake_txq(), which
is then scheduled by the hardware after that? Or how does the mapping to
hwqs work, and how is the hardware notified that there are still packets
queued / that new packets have arrived for an already mapped txq?

> It would be nice to be able to use it, for better queue behaviour, but
> it would mean much more accounting in iwlwifi? Not even sure off the
> top of my head how to do that.

I think we'll need to have some kind of fallback airtime estimation in
mac80211 that calculates airtime from packet size and rate information.
Not all drivers can get this from the hardware, it seems. See my reply
to Kan about the BQL-like behaviour as well.

Does iwl get airtime usage information for every packet on tx complete?

-Toke
