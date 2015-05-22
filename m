Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:44820 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038AbbEVMNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 08:13:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] ath10k: handle cycle counter wraparound
References: <CA+BoTQ=V1psOoaL1WG7vSUjSLhPnQqBUODjeB3NyWt-pMtmNFA@mail.gmail.com>
	<1432282693-4553-1-git-send-email-michal.kazior@tieto.com>
	<87zj4w4zdz.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQkNO3oD36GFWVvG3TuAu1nKqTrW_54Z-V9de0Lt7jE8hA@mail.gmail.com>
	<CA+BoTQ=xNbcQv+FVZWUAki5f0zQ_F0hTW3V6FkTp-DzQOr-FFA@mail.gmail.com>
Date: Fri, 22 May 2015 15:12:59 +0300
In-Reply-To: <CA+BoTQ=xNbcQv+FVZWUAki5f0zQ_F0hTW3V6FkTp-DzQOr-FFA@mail.gmail.com>
	(Michal Kazior's message of "Fri, 22 May 2015 14:00:05 +0200")
Message-ID: <87vbfk4xpw.fsf@kamboji.qca.qualcomm.com> (sfid-20150522_141312_904587_00A1C486)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 22 May 2015 at 13:56, Michal Kazior <michal.kazior@tieto.com> wrote:
>> On 22 May 2015 at 13:36, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>> Michal Kazior <michal.kazior@tieto.com> writes:
> [...]
>>>> +void ath10k_core_get_cc_delta(struct ath10k *ar,
>>>> +                           u32 *cc_delta, u32 *rcc_delta,
>>>> +                           u32 cc, u32 rcc,
>>>> +                           u32 cc_prev, u32 rcc_prev)
>>>> +{
>>>> +     if (ar->hw_params.has_shifted_cc_wraparound && cc < cc_prev) {
>>>> +             cc_prev -= 0x7fffffff;
>>>> +             rcc *= 2;
>>>> +     }
>>>> +
>>>> +     *cc_delta = cc - cc_prev;
>>>> +     *rcc_delta = rcc - rcc_prev;
>>>> +}
>>>
>>> Why do you have this function in core.c? Why not in wmi.c?
>>
>> I don't consider this a part of WMI protocol per se. It's a logic
>> which happens to be used with values delivered via WMI but is chip
>> specific otherwise. For what it's worth we could be reading CC
>> registers, e.g. directly via MMIO.
>
> Now that I think about it this would fit into hw.c as well.

Yeah, hw.c would be much better. And we could start adding more similar
hw adaptation code there in the future.

-- 
Kalle Valo
