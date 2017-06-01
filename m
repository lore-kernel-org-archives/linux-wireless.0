Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49331 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbdFANYS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 09:24:18 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
CC: Adrian Chadd <adrian@freebsd.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add configurable debugging.
Date: Thu, 1 Jun 2017 13:24:15 +0000
Message-ID: <87r2z3lu3j.fsf@kamboji.qca.qualcomm.com> (sfid-20170601_152421_850209_4CA1759D)
References: <20170510211925.17468-1-adrian@freebsd.org>
        <87y3tdmdbo.fsf@kamboji.qca.qualcomm.com>
        <2a6a2af2-29c7-6b74-ead1-c5ae8688a87c@broadcom.com>
In-Reply-To: <2a6a2af2-29c7-6b74-ead1-c5ae8688a87c@broadcom.com> (Arend van
        Spriel's message of "Wed, 31 May 2017 22:20:45 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 31-05-17 14:16, Kalle Valo wrote:
>> Adrian Chadd <adrian@freebsd.org> writes:
>>=20
>>> This adds a few configurable debugging options:
>>>
>>> * driver debugging and tracing is now configurable per device
>>> * driver debugging and tracing is now configurable at runtime
>>> * the debugging / tracing is not run at all (besides a mask check)
>>>   unless the specific debugging bitmap field is configured.
>>>
>>> Signed-off-by: Adrian Chadd <adrian@FreeBSD.org>
>>=20
>> [...]
>>=20
>>> --- a/drivers/net/wireless/ath/ath10k/core.c
>>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>>> @@ -2444,6 +2444,8 @@ struct ath10k *ath10k_core_create(size_t
>>> priv_size, struct device *dev,
>>>  	ar->hw_rev =3D hw_rev;
>>>  	ar->hif.ops =3D hif_ops;
>>>  	ar->hif.bus =3D bus;
>>> +	ar->debug_mask =3D ath10k_debug_mask;
>>> +	ar->trace_debug_mask =3D ath10k_debug_mask;
>>=20
>> Until now tracing has been always enabled, irrespective what debug_mask
>> has contained. Now you are changing that and by default log messages are
>> not delivered through tracing until user enables them. So I think to
>> keep the old behaviour trace_debug_mask should be ATH10K_DBG_ANY
>> (0xffffffff) by default and the user can modify the mask per device via
>> the debugfs file.
>>=20
>> But is it really needed to be able to filter trace messages? debug_mask
>> I understand, but not sure about trace_debug_mask.
>
> FWIW, in brcmfmac I decided not to filter trace messages. The overhead
> is relatively small and if needed you can pass filter expressions with
> trace-cmd record.

I also think that this is how it should work. For example, if you have
tracing enabled in wpasupplicant/hostapd with the command below you can
get a lot of information in one file with relatively little overhead:

trace-cmd record -e mac80211 -e cfg80211 -e ath10k

But if user is forced to use debugfs to enable ath10k tracing that is
quite a step backwards.

--=20
Kalle Valo=
