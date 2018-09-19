Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48292 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731592AbeISWdq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 18:33:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 19 Sep 2018 09:54:59 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v4 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <8736u5k0cu.fsf@toke.dk>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1>
 <153711973109.9231.7094211814263758096.stgit@alrua-x1.karlstad.toke.dk>
 <13400b5f9bdb5e36c6afabd071cc7b0d@codeaurora.org> <87o9cvksiv.fsf@toke.dk>
 <efa33810860b2e5db789a76747bb826b@codeaurora.org> <87efdq8rn0.fsf@toke.dk>
 <5e2612cbd4ea9f560a63149c599f8587@codeaurora.org> <87y3bxkg5p.fsf@toke.dk>
 <878t3xsg3h.fsf@purkki.adurom.net> <8736u5k0cu.fsf@toke.dk>
Message-ID: <4b0b297a0ecf2f1e7278c23ab1ebe984@codeaurora.org> (sfid-20180919_185503_812873_6C0BC1F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-19 07:50, Toke Høiland-Jørgensen wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
> 
>> Toke Høiland-Jørgensen <toke@toke.dk> writes:
>> 
>>>> Unfortunately ath10k is not reporting last_tx_rate in tx_status(). 
>>>> So
>>>> I also applied this "ath10k: report tx rate using 
>>>> ieee80211_tx_status"
>>>> change.
>>> 
>>> Yeah, that and the patch that computes the last used rate will 
>>> probably
>>> be necessary; but they can be pretty much applied as-is, right?
>> 
>> Unfortunately not. I think the plan is now to follow Johannes' 
>> proposal:
>> 
>>    "I'd recommend against doing this and disentangling the necessary
>>     code in mac80211, e.g. with ieee80211_tx_status_ext() or adding
>>     similar APIs."
>> 
>>    https://patchwork.kernel.org/patch/10353959/
> 
> Ahh, right... *that* patch :)
> 
> Was thinking on this one with the "as-is" comment:
> 
> https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/588189
> 
It is useful only when the driver calls tx_status_noskb(). It was 
recommended not to
call tx_status() and tx_status_noskb() APIs from same driver. Hence Anil 
was trying
to piggyback tx rate report by tx_status itself.

https://chromium.googlesource.com/chromiumos/third_party/kernel/+/1e034d84bd444fd29b7f902c5e033a8c737a58b2%5E%21/
https://chromium.googlesource.com/chromiumos/third_party/kernel/+/2a8da427fc9dfb527516e7ac395b1e6af73bff84%5E%21/

-Rajkumar
