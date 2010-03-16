Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f200.google.com ([209.85.222.200]:58980 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965811Ab0CPAJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 20:09:25 -0400
Received: by pzk38 with SMTP id 38so2601420pzk.33
        for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 17:09:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4B9ECB3E.3010802@openwrt.org>
References: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
	<20100315214338.GB4000@tux> <43e72e891003151625t795b8ecdr2ce2e6927e8632a4@mail.gmail.com>
	<20100315234909.GA2662@tux> <4B9EC85B.8070800@openwrt.org>
	<43e72e891003151655i7dc051d0lc1da26267e9c706@mail.gmail.com>
	<4B9ECB3E.3010802@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 15 Mar 2010 17:09:04 -0700
Message-ID: <43e72e891003151709r42745e27q6e42c131d202a4cb@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] ath9k_hw: complete support for AR9271
To: Felix Fietkau <nbd@openwrt.org>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 15, 2010 at 5:05 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2010-03-16 12:55 AM, Luis R. Rodriguez wrote:
>> On Mon, Mar 15, 2010 at 4:52 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>>> On 2010-03-16 12:49 AM, Luis R. Rodriguez wrote:
>>>> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
>>>> index 00570fb..867cfaf 100644
>>>> --- a/drivers/net/wireless/ath/ath9k/hw.c
>>>> +++ b/drivers/net/wireless/ath/ath9k/hw.c
>>>> @@ -807,6 +804,10 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
>>>>               acktimeout += 64 - sifstime - ah->slottime;
>>>>
>>>>       ath9k_hw_setslottime(ah, slottime);
>>>> +
>>>> +     if (AR_SREV_9271(ah))
>>>> +             return;
>>>> +
>>>>       ath9k_hw_set_ack_timeout(ah, acktimeout);
>>>>       ath9k_hw_set_cts_timeout(ah, acktimeout);
>>>>       if (ah->globaltxtimeout != (u32) -1)
>>>
>>> Why leave out the ACK/CTS timeout setting? How does the hw handle ACK
>>> and CTS timeouts?
>>
>> Right, so that's why I originally removed this hunk completely, I was
>> under the impression you latest fix would have addressed any issues
>> but it does not, we get association time outs. I think we'll have to
>> review this further in order to support coverage class.
> Are you sure the slot time was set properly by the callback?

Well ath9k_htc did not have it implemented, I just added the code for
it, you know what.. I did not test modifying the ACK/CTS timeout *and*
with the new slot time code I added to ath9k_htc, let me try that.

> Can you
> print out the values that it's setting?

Yeah, 20 upon initial association and then I see another setting for 9.

> The initvals for 9271 don't
> really look all that different.

Indeed, odd... this should work with the fudge factor you added.

  Luis
