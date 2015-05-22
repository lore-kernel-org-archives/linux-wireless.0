Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37623 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbbEVL4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 07:56:19 -0400
Received: by wibt6 with SMTP id t6so44690602wib.0
        for <linux-wireless@vger.kernel.org>; Fri, 22 May 2015 04:56:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87zj4w4zdz.fsf@kamboji.qca.qualcomm.com>
References: <CA+BoTQ=V1psOoaL1WG7vSUjSLhPnQqBUODjeB3NyWt-pMtmNFA@mail.gmail.com>
	<1432282693-4553-1-git-send-email-michal.kazior@tieto.com>
	<87zj4w4zdz.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 22 May 2015 13:56:18 +0200
Message-ID: <CA+BoTQkNO3oD36GFWVvG3TuAu1nKqTrW_54Z-V9de0Lt7jE8hA@mail.gmail.com> (sfid-20150522_135625_580807_6439DAC5)
Subject: Re: [PATCH v3 1/2] ath10k: handle cycle counter wraparound
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 May 2015 at 13:36, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> When QCA988X cycle counter HW register wraps
>> around it resets to 0x7fffffff instead of 0. All
>> other cycle counter related registers are divided
>> by 2 so they never wraparound themselves. QCA61X4
>> has a uniform CC and it wraparounds in a regular
>> fashion though.
>>
>> Worst case wraparound time is approx 24 seconds
>> (2**31 / 88MHz). Since scan channel visit times
>> are max 5 seconds (offchannel case) it is
>> guaranteed there's been at most 1 wraparound and
>> it is possible to compute survey data.
>>
>> This fixes some occasional incorrect survey data
>> on QCA988X as some channels (depending on how/when
>> scan/offchannel requests were requested) would
>> have approx 24 sec active time which wasn't
>> actually the case.
>>
>> This should help make hostapd ACS more reliable.
>>
>> Reported-by: Srinivasa Duvvuri <sduvvuri@chromium.org>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> +void ath10k_core_get_cc_delta(struct ath10k *ar,
>> +                           u32 *cc_delta, u32 *rcc_delta,
>> +                           u32 cc, u32 rcc,
>> +                           u32 cc_prev, u32 rcc_prev)
>> +{
>> +     if (ar->hw_params.has_shifted_cc_wraparound && cc < cc_prev) {
>> +             cc_prev -= 0x7fffffff;
>> +             rcc *= 2;
>> +     }
>> +
>> +     *cc_delta = cc - cc_prev;
>> +     *rcc_delta = rcc - rcc_prev;
>> +}
>
> Why do you have this function in core.c? Why not in wmi.c?

I don't consider this a part of WMI protocol per se. It's a logic
which happens to be used with values delivered via WMI but is chip
specific otherwise. For what it's worth we could be reading CC
registers, e.g. directly via MMIO.


Michał
