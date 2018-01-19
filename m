Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:46539 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754070AbeASJCy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 04:02:54 -0500
Received: by mail-wm0-f51.google.com with SMTP id 143so1890812wma.5
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jan 2018 01:02:54 -0800 (PST)
Subject: Re: AP6335 with mainline kernel
To: Vanessa Maegima <vanessa.maegima@nxp.com>,
        "festevam@gmail.com" <festevam@gmail.com>
References: <CABACg+yVE+fuzT-qwjNnACqq24KQbNJOae22=v+J+0Q=8kuKRQ@mail.gmail.com>
 <85717463-11e2-e2e3-b08e-b758986687b5@broadcom.com>
 <1510916848.26896.2.camel@nxp.com> <5A0EDC25.7030505@broadcom.com>
 <1510932224.22506.0.camel@nxp.com>
 <d9a80a75-b3d4-d78e-a5bf-ab31732f040d@broadcom.com>
 <e14bdc26-5092-18c9-4caa-c45fd1d12984@broadcom.com>
 <1511347672.18886.2.camel@nxp.com> <5A15584A.9090601@broadcom.com>
 <1511450638.9102.1.camel@nxp.com> <5A1FFA17.6000703@broadcom.com>
 <1512413992.18900.3.camel@nxp.com>
 <CAF7Mx6q6mTOXc=4OFVCHAHd26pyfv5e6pK=TMNmb1S6=FBWUWQ@mail.gmail.com>
 <1512485878.9392.1.camel@nxp.com>
 <CAOMZO5DXoCFgTtuRRAq_jFjzkzFp6chMCwczXF5Z0bFaNfQnog@mail.gmail.com>
 <5A5E5EBE.7040301@broadcom.com> <1516276016.8817.1.camel@nxp.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "van.ayumi@gmail.com" <van.ayumi@gmail.com>,
        "embed3d@gmail.com" <embed3d@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A61B43C.4000305@broadcom.com> (sfid-20180119_100429_258753_69680D7C)
Date: Fri, 19 Jan 2018 10:02:52 +0100
MIME-Version: 1.0
In-Reply-To: <1516276016.8817.1.camel@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/18/2018 12:47 PM, Vanessa Maegima wrote:
> Hi Arend,
>
> On Ter, 2018-01-16 at 21:21 +0100, Arend van Spriel wrote:
>> On 1/15/2018 9:08 PM, Fabio Estevam wrote:
>>>
>>> Hi Arend,
>>>
>>> On Tue, Dec 5, 2017 at 12:58 PM, Vanessa Maegima
>>> <vanessa.maegima@nxp.com> wrote:
>>>
>>>>
>>>> Hi Arend,
>>>>
>>>> Sorry for this!
>>>>
>>>> I updated the folder on https://emea01.safelinks.protection.outlo
>>>> ok.com/?url=https%3A%2F%2Fdrive.google.com%2Fdrive%2Ffolders%2F1f
>>>> osahjL&data=02%7C01%7Cvanessa.maegima%40nxp.com%7Cf07cd1a6ffb34c0
>>>> 961f608d55d1eb901%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C63
>>>> 6517308901643244&sdata=6JAqSN%2BVPJ%2FCF7cbnBjm8geMKWydWkG9JcUhGB
>>>> Pj644%3D&reserved=0
>>>> N1KI5NKS59_aPZdHLpENPFHtK
>>>>
>>>> Thanks!
>>> Any ideas, please?
>> Well, the dumps confirm a crash early in the firmware boot. However,
>> I
>> could not obtain more information from it. To capture the failure I
>> need
>> to rework some firmware functionality which is not trivial and I can
>> not
>> claim time for it right now.
>>
>> Regards,
>> Arend
>>
>
> Thanks for all your investigation here!
>
> I just want to report one more thing that I noticed from my tests.
>
> I have tried to use an html file that I downloaded using wget as the
> nvram file (https://github.com/OpenELEC/wlan-firmware/blob/master/firmw
> are/brcm/nvram_ap6335.txt) and the wifi seems to work. I have not
> noticed the wrong format file until testing it.

Interesting. In brcmfmac the file is parsed before sending it to the 
firmware so I am wondering what is effectively send to the device.

Can you dump the nvram that is sent to the device. Just add hexdump call 
of nvram in brcmf_fw_request_nvram_done() in firmware.c just before 
fwctx->done() is called.

Regards,
Arend
