Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36802 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbdEaV2m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 17:28:42 -0400
Received: by mail-wm0-f47.google.com with SMTP id 7so134251888wmo.1
        for <linux-wireless@vger.kernel.org>; Wed, 31 May 2017 14:28:41 -0700 (PDT)
Subject: Re: [PATCH] ath10k: add configurable debugging.
To: Adrian Chadd <adrian@freebsd.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20170510211925.17468-1-adrian@freebsd.org>
 <87y3tdmdbo.fsf@kamboji.qca.qualcomm.com>
 <2a6a2af2-29c7-6b74-ead1-c5ae8688a87c@broadcom.com>
 <CAJ-Vmom0SpsrTWK8-rdZk3AKW_JGcFLGeQzfVbvX81UBKw=REg@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <fa553ad3-773b-966f-c54f-c09617e85b89@broadcom.com> (sfid-20170531_232846_024670_05B58B5A)
Date: Wed, 31 May 2017 23:28:39 +0200
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmom0SpsrTWK8-rdZk3AKW_JGcFLGeQzfVbvX81UBKw=REg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31-05-17 22:23, Adrian Chadd wrote:
> On 31 May 2017 at 13:20, Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
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
>>>> @@ -2444,6 +2444,8 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
>>>>      ar->hw_rev = hw_rev;
>>>>      ar->hif.ops = hif_ops;
>>>>      ar->hif.bus = bus;
>>>> +    ar->debug_mask = ath10k_debug_mask;
>>>> +    ar->trace_debug_mask = ath10k_debug_mask;
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
> The reason for configuring it via a mask is that:
> 
> * the previous behaviour is "always call debug(), conditionally print,
> always pass to trace"
> 
> This meant that function arguments were evaluated even if things
> weren't being printed.
> 
> So to avoid that in the default case, there are now two masks. If I
> have one mask then I can only trace what is being printed, which is
> not desired. I'd like to be able to have no overhead when doing no
> debugging, a little overhead when doing tracing (and only the items
> being traced), and then printing when I want to print.

Well, it is up to you. Have to clariy though that if you are not
actually recording a trace there is (almost) no overhead. We have
Kconfig to compile tracing code in and I see no performance impact with
tracing code. Only when doing tracing you will get little overhead.

Regards,
Arend

> -adrian
> 
