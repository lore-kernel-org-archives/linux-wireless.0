Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57860 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731311AbeISUVe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 16:21:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v4 1/4] mac80211: Add TXQ scheduling API
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1>
        <153711973109.9231.7094211814263758096.stgit@alrua-x1.karlstad.toke.dk>
        <13400b5f9bdb5e36c6afabd071cc7b0d@codeaurora.org>
        <87o9cvksiv.fsf@toke.dk>
        <efa33810860b2e5db789a76747bb826b@codeaurora.org>
        <87efdq8rn0.fsf@toke.dk>
        <5e2612cbd4ea9f560a63149c599f8587@codeaurora.org>
        <87y3bxkg5p.fsf@toke.dk>
Date: Wed, 19 Sep 2018 17:43:14 +0300
In-Reply-To: <87y3bxkg5p.fsf@toke.dk> ("Toke \=\?utf-8\?Q\?H\=C3\=B8iland-J\?\=
 \=\?utf-8\?Q\?\=C3\=B8rgensen\=22's\?\= message of
        "Wed, 19 Sep 2018 11:09:06 +0200")
Message-ID: <878t3xsg3h.fsf@purkki.adurom.net> (sfid-20180919_164331_505684_D245D606)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

>> Unfortunately ath10k is not reporting last_tx_rate in tx_status(). So
>> I also applied this "ath10k: report tx rate using ieee80211_tx_status"
>> change.
>
> Yeah, that and the patch that computes the last used rate will probably
> be necessary; but they can be pretty much applied as-is, right?

Unfortunately not. I think the plan is now to follow Johannes' proposal:

   "I'd recommend against doing this and disentangling the necessary
    code in mac80211, e.g. with ieee80211_tx_status_ext() or adding
    similar APIs."

   https://patchwork.kernel.org/patch/10353959/

--=20
Kalle Valo
