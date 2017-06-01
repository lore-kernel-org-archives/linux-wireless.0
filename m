Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65064 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbdFANek (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 09:34:40 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: Arend van Spriel <arend.vanspriel@broadcom.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add configurable debugging.
Date: Thu, 1 Jun 2017 13:34:29 +0000
Message-ID: <87mv9rltmg.fsf@kamboji.qca.qualcomm.com> (sfid-20170601_153500_086122_A0D6024C)
References: <20170510211925.17468-1-adrian@freebsd.org>
        <87y3tdmdbo.fsf@kamboji.qca.qualcomm.com>
        <2a6a2af2-29c7-6b74-ead1-c5ae8688a87c@broadcom.com>
        <CAJ-Vmom0SpsrTWK8-rdZk3AKW_JGcFLGeQzfVbvX81UBKw=REg@mail.gmail.com>
In-Reply-To: <CAJ-Vmom0SpsrTWK8-rdZk3AKW_JGcFLGeQzfVbvX81UBKw=REg@mail.gmail.com>       (Adrian
 Chadd's message of "Wed, 31 May 2017 13:23:32 -0700")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd <adrian@freebsd.org> writes:

>>>> --- a/drivers/net/wireless/ath/ath10k/core.c
>>>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>>>> @@ -2444,6 +2444,8 @@ struct ath10k *ath10k_core_create(size_t
>>>> priv_size, struct device *dev,
>>>>      ar->hw_rev =3D hw_rev;
>>>>      ar->hif.ops =3D hif_ops;
>>>>      ar->hif.bus =3D bus;
>>>> +    ar->debug_mask =3D ath10k_debug_mask;
>>>> +    ar->trace_debug_mask =3D ath10k_debug_mask;
>>>
>>> Until now tracing has been always enabled, irrespective what debug_mask
>>> has contained. Now you are changing that and by default log messages ar=
e
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

Ok, so you want also filter tracing messages. Any particular reason for
that, limited storage space or something else? Just curious.

So what's the most expensive part here, the actual function call to
ath10k_dbg() or va_start()/ve_end() within the function? And do you have
before and after throughput numbers for this? And maybe also with
CONFIG_ATH10K_DEBUG is disabled, which should be the most fastest. It
would be good to know how much this has affect on performance.

We could of course always change ath10k_dbg()/ath10k_dbg_dump() to
inline functions (or maybe even cpp macros) but if va_start()/va_end()
are the expensive part that won't help.

--=20
Kalle Valo=
