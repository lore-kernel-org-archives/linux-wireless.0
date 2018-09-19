Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:40165 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731421AbeISU2o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 16:28:44 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v4 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <878t3xsg3h.fsf@purkki.adurom.net>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1> <153711973109.9231.7094211814263758096.stgit@alrua-x1.karlstad.toke.dk> <13400b5f9bdb5e36c6afabd071cc7b0d@codeaurora.org> <87o9cvksiv.fsf@toke.dk> <efa33810860b2e5db789a76747bb826b@codeaurora.org> <87efdq8rn0.fsf@toke.dk> <5e2612cbd4ea9f560a63149c599f8587@codeaurora.org> <87y3bxkg5p.fsf@toke.dk> <878t3xsg3h.fsf@purkki.adurom.net>
Date: Wed, 19 Sep 2018 16:50:25 +0200
Message-ID: <8736u5k0cu.fsf@toke.dk> (sfid-20180919_165030_054314_C85045EA)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
>
>>> Unfortunately ath10k is not reporting last_tx_rate in tx_status(). So
>>> I also applied this "ath10k: report tx rate using ieee80211_tx_status"
>>> change.
>>
>> Yeah, that and the patch that computes the last used rate will probably
>> be necessary; but they can be pretty much applied as-is, right?
>
> Unfortunately not. I think the plan is now to follow Johannes' proposal:
>
>    "I'd recommend against doing this and disentangling the necessary
>     code in mac80211, e.g. with ieee80211_tx_status_ext() or adding
>     similar APIs."
>
>    https://patchwork.kernel.org/patch/10353959/

Ahh, right... *that* patch :)

Was thinking on this one with the "as-is" comment:

https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/=
588189

-Toke
