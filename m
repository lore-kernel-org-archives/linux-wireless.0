Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34078 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751089AbdFANdk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 09:33:40 -0400
Received: by mail-wm0-f68.google.com with SMTP id d127so11362481wmf.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Jun 2017 06:33:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87r2z3lu3j.fsf@kamboji.qca.qualcomm.com>
References: <20170510211925.17468-1-adrian@freebsd.org> <87y3tdmdbo.fsf@kamboji.qca.qualcomm.com>
 <2a6a2af2-29c7-6b74-ead1-c5ae8688a87c@broadcom.com> <87r2z3lu3j.fsf@kamboji.qca.qualcomm.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Thu, 1 Jun 2017 06:33:38 -0700
Message-ID: <CAJ-VmokfLW6RZyKZ4cKR7+cbTxwwa4aUZPm88Djv17Bo-oZ-0A@mail.gmail.com> (sfid-20170601_153349_342408_CFC79047)
Subject: Re: [PATCH] ath10k: add configurable debugging.
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 June 2017 at 06:24, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>
>> On 31-05-17 14:16, Kalle Valo wrote:
>>> Adrian Chadd <adrian@freebsd.org> writes:
>>>
>>>> This adds a few configurable debugging options:
>>>>
>>>> * driver debugging and tracing is now configurable per device
>>>> * driver debugging and tracing is now configurable at runtime
>>>> * the debugging / tracing is not run at all (besides a mask check)
>>>>   unless the specific debugging bitmap field is configured.
>>>>
>>>> Signed-off-by: Adrian Chadd <adrian@FreeBSD.org>
>>>
>>> [...]
>>>
>>>> --- a/drivers/net/wireless/ath/ath10k/core.c
>>>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>>>> @@ -2444,6 +2444,8 @@ struct ath10k *ath10k_core_create(size_t
>>>> priv_size, struct device *dev,
>>>>     ar->hw_rev = hw_rev;
>>>>     ar->hif.ops = hif_ops;
>>>>     ar->hif.bus = bus;
>>>> +   ar->debug_mask = ath10k_debug_mask;
>>>> +   ar->trace_debug_mask = ath10k_debug_mask;
>>>
>>> Until now tracing has been always enabled, irrespective what debug_mask
>>> has contained. Now you are changing that and by default log messages are
>>> not delivered through tracing until user enables them. So I think to
>>> keep the old behaviour trace_debug_mask should be ATH10K_DBG_ANY
>>> (0xffffffff) by default and the user can modify the mask per device via
>>> the debugfs file.
>>>
>>> But is it really needed to be able to filter trace messages? debug_mask
>>> I understand, but not sure about trace_debug_mask.
>>
>> FWIW, in brcmfmac I decided not to filter trace messages. The overhead
>> is relatively small and if needed you can pass filter expressions with
>> trace-cmd record.
>
> I also think that this is how it should work. For example, if you have
> tracing enabled in wpasupplicant/hostapd with the command below you can
> get a lot of information in one file with relatively little overhead:
>
> trace-cmd record -e mac80211 -e cfg80211 -e ath10k
>
> But if user is forced to use debugfs to enable ath10k tracing that is
> quite a step backwards.
>

I agree that is how it should work, but i can't see how you do it on
ath10k without the debug overhead always being there.

If there's a way to know /a/ trace watch is going on from the kernel
then it could be flipped on for that, but i didn't see any obvious
"trace enable" / "trace disable" hooks.



-a
