Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:34066 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753575AbeD0Vkz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 17:40:55 -0400
Received: by mail-wm0-f46.google.com with SMTP id a137so3296885wme.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 Apr 2018 14:40:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <000e01d3da46$43f06430$cbd12c90$@codeaurora.org>
References: <CAFnQ7os8AQGwJfkunZG-x9f9jdnOw=tjGCHE9wNxNwLfqka_tQ@mail.gmail.com>
 <001901d3c759$8cd5b970$a6812c50$@codeaurora.org> <CAFnQ7oti-cKJxBXyuCCfJeLgHMcw1U0pE1hkdCH_ukN032f90A@mail.gmail.com>
 <000e01d3da46$43f06430$cbd12c90$@codeaurora.org>
From: David Dean Zhang <daviddean166@gmail.com>
Date: Fri, 27 Apr 2018 17:40:53 -0400
Message-ID: <CAFnQ7ovp-rOB2Aaiu5drFS_Jfn9bcyD4w8W_cx0XAQPjnVcoqA@mail.gmail.com> (sfid-20180427_234100_285583_427BEB48)
Subject: Re: wil6210: low level sector API
To: linux-wireless@vger.kernel.org,
        Dedy Lansky <dlansky@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks so much for your information. I tried to use this command and
set "triggers" and "long_term_enable" to 0. Actually, in the
definition of the triggers, there is no 0x00 but it could be set.
After calling this WMI command, it returned 0 which looks like
correct. But when I checked the station bf info, it still changed. I
am wondering whether I can do anything to verify that. Thank you.

Regards,
David

On Sun, Apr 22, 2018 at 10:29 AM, Dedy Lansky <dlansky@codeaurora.org> wrot=
e:
>
>> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@=
vger.kernel.org] On Behalf Of David Dean Zhang
>> Sent: Wednesday, April 18, 2018 9:01 PM
>
>> I updated the firmware and tried to call some low level functions, like =
WMI_PRIO_TX_SECTORS_NUMBER_CMDID and WMI_SET_RF_SECTOR_ON_CMDID .
>> The previous errors have gone but it still has errors:
>> wil6210 0000:03:00.0 wlp3s0: wmi_event_handle: Unhandled event 0x19a5
>> wil6210 0000:03:00.0 wlp3s0: wmi_call: wmi_call(0x09a6->0x19a6) timeout =
2000 msec
>> So I am wondering whether it is because the chipset does not support the=
se wmi commands. I just want to know how to use these commands and how to d=
isable TXSS. I appreciate if anyone could provide some suggestions. Thanks.
>
> This is a bug in FW that upon WMI_PRIO_TX_SECTORS_NUMBER_CMDID, wrong eve=
nt is returned. Most likely that the WMI_PRIO_TX_SECTORS_NUMBER_CMDID was h=
andled successfully. The bug is not critical - event 0x19a5 is returned ins=
tead of 0x19a6 (as can be seen in dmesg).
>
> Another option for disabling TXSS/BRP and hopefully to keep the sector lo=
cked is by using WMI_BF_CONTROL_CMDID. Setting "triggers" and "long_term_en=
able" to 0 should disable BF completely.
>
> Thanks,
>  Dedy.
>
>
>
>
