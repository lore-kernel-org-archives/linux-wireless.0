Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:50907 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaB1Jyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 04:54:33 -0500
Received: by mail-ea0-f169.google.com with SMTP id d10so2518306eaj.14
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 01:54:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87txbjbn7s.fsf@kamboji.qca.qualcomm.com>
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
	<1393485587-16879-1-git-send-email-michal.kazior@tieto.com>
	<1393485587-16879-5-git-send-email-michal.kazior@tieto.com>
	<8738j3d2t2.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQn8GTu3A4LdRGtpJeVr0SnaApTwnNZAoZ8=3Vj5qF+W=g@mail.gmail.com>
	<87txbjbn7s.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 28 Feb 2014 10:54:31 +0100
Message-ID: <CA+BoTQkgxNL9tkxR=b2Qif5+6Z_cFQOc2uL5QD5scd=Nx1y50g@mail.gmail.com> (sfid-20140228_105443_370325_4380078F)
Subject: Re: [PATCH v3 4/8] ath10k: bypass htc for htt tx path
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 February 2014 10:28, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> On 28 February 2014 10:06, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>> Michal Kazior <michal.kazior@tieto.com> writes:
>>>
>>>> --- a/drivers/net/wireless/ath/ath10k/htc.c
>>>> +++ b/drivers/net/wireless/ath/ath10k/htc.c
>>>> @@ -202,10 +202,8 @@ static int ath10k_htc_tx_completion_handler(struct ath10k *ar,
>>>>       struct ath10k_htc *htc = &ar->htc;
>>>>       struct ath10k_htc_ep *ep = &htc->endpoint[eid];
>>>>
>>>> -     if (!skb) {
>>>> -             ath10k_warn("invalid sk_buff completion - NULL pointer. firmware crashed?\n");
>>>> +     if (WARN_ON(!skb))
>>>>               return 0;
>>>> -     }
>>>
>>> WARN_ON() is a bit dangerous here as it might cause excessive spamming.
>>> Why did you want to change this? I think either ath10k_warn() or
>>> WARN_ON_ONCE() would be safer, but not sure which one to use.
>>

[...]

>> Perhaps WARN_ON() is a bit over the top here, but since this is now
>> more of a logic issue rather than runtime issue I decided to change it
>> from ath10k_warn to WARN_ON(). It's probably still a good idea to make
>> it _ONCE generally, although if you actually get skbuff it's already
>> too late or it should be screaming loudly because someone must've
>> changed the code in an incorrect/incomplete way.
>
> So I change it to WARN_ON_ONCE(), ok?

Sure. Thanks!


Michał
