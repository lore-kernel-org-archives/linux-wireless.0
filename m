Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44290 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751397AbdFGOxX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Jun 2017 10:53:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [V4,1/3] brcmfmac: add support multi-scheduled scan
References: <1495180659-12406-1-git-send-email-arend.vanspriel@broadcom.com>
        <20170522151649.B5F1060AC8@smtp.codeaurora.org>
        <621288e8-e950-5aea-7d27-c5cb802dd416@broadcom.com>
Date: Wed, 07 Jun 2017 17:53:13 +0300
In-Reply-To: <621288e8-e950-5aea-7d27-c5cb802dd416@broadcom.com> (Arend van
        Spriel's message of "Wed, 7 Jun 2017 10:15:15 +0200")
Message-ID: <87y3t34zom.fsf@codeaurora.org> (sfid-20170607_165331_372834_FABD7492)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 5/22/2017 5:16 PM, Kalle Valo wrote:
>> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>>> From: Arend Van Spriel <arend.vanspriel@broadcom.com>
>>>
>>> This change adds support for multi-scheduled scan in the driver. It
>>> currently relies on g-scan support in firmware and will set struct
>>> wiphy::max_sched_scan_reqs accordingly. This is limited to 16 concurrent
>>> requests.
>>>
>>> The firmware currently has a limit of 64 channels that can be configured
>>> for all requests in total regardless whether there are duplicates. So if
>>> a request uses 35 channels there are 29 channels left for another reque=
st.
>>> When user-space does not specify any channels cfg80211 will add all
>>> channels defined by the wiphy instance to the request, which makes
>>> reaching the limit rather easy for dual-band devices.
>>>
>>> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
>>> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
>>> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>
>> I see new warnings:
>>
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c: In function =E2=
=80=98brcmf_pno_config_sched_scans=E2=80=99:
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c:166:6: warning: =
=E2=80=98mac_mask=E2=80=99 may be used uninitialized in this function [-Wma=
ybe-uninitialized]
>>    u8 *mac_mask;
>>        ^
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c:183:2: warning: =
=E2=80=98mac_addr=E2=80=99 may be used uninitialized in this function [-Wma=
ybe-uninitialized]
>>    memcpy(pfn_mac.mac, mac_addr, ETH_ALEN);
>>    ^
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c:165:6: note: =E2=
=80=98mac_addr=E2=80=99 was declared here
>>    u8 *mac_addr;
>>        ^
>>
>> 3 patches set to Changes Requested.
>>
>> 9736151 [V4,1/3] brcmfmac: add support multi-scheduled scan
>> 9736147 [V4,2/3] brcmfmac: add mutex to protect pno requests
>> 9736149 [V4,3/3] brcmfmac: add scheduled scan support for specified BSSI=
Ds
>
> Not seeing it here using gcc version 4.8.4 (Ubuntu
> 4.8.4-2ubuntu1~14.04.3).

My version is:

gcc (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609

I don't think that's really exocit version of the compiler, or is it?

> Also tried using W=3D1 on the make command
> line. Getting a bunck of other warnings, but not the ones above.

This was without W=3D1, just a default compilation with all wireless
drivers enabled.

> Do you want me to fix it?

Yes, please. I try to keep the patches warning free, even if they are
false warnings.

--=20
Kalle Valo
