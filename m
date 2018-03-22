Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:46150 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751792AbeCVK3z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 06:29:55 -0400
Received: by mail-io0-f194.google.com with SMTP id g14so10321414iob.13
        for <linux-wireless@vger.kernel.org>; Thu, 22 Mar 2018 03:29:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87po3zxe9n.fsf@kamboji.qca.qualcomm.com>
References: <20180319014032.9394-1-alexey.roslyakov@gmail.com>
 <20180319014032.9394-3-alexey.roslyakov@gmail.com> <5AAF838D.2030105@broadcom.com>
 <CALFoz4YMKJr40fefczrbjXBROtZxnGikv0Jze-BnefofCB3dyg@mail.gmail.com>
 <817418fd-6446-57ea-b03d-383b4df9a979@gmail.com> <5AB044C0.9060701@broadcom.com>
 <87po3zxe9n.fsf@kamboji.qca.qualcomm.com>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Thu, 22 Mar 2018 11:29:53 +0100
Message-ID: <CAPDyKFr2GVB0+UUpT3GgGBT17TMcrky6X4L_pw+ztTL6ejbCwQ@mail.gmail.com> (sfid-20180322_113104_353629_27CF71AE)
Subject: Re: [PATCH net-next v2 2/2] dt: bindings: add new dt entries for brcmfmac
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexey Roslyakov <alexey.roslyakov@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 March 2018 at 10:55, Kalle Valo <kvalo@codeaurora.org> wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>
>>>> If I get it right, you mean something like this:
>>>>
>>>> mmc3: mmc@1c12000 {
>>>> ...
>>>>          broken-sg-support;
>>>>          sd-head-align = 4;
>>>>          sd-sgentry-align = 512;
>>>>
>>>>          brcmf: wifi@1 {
>>>>                  ...
>>>>          };
>>>> };
>>>>
>>>> Where dt: bindings documentation for these entries should reside?
>>>> In generic MMC bindings? Well, this is the very special case and
>>>> mmc-linux maintainer will unlikely to accept these changes.
>>>> Also, extra kernel code modification might be required. It could make
>>>> quite trivial change much more complex.
>>>
>>> If the MMC maintainers are not copied on this patch series, it will
>>> likely be hard for them to identify this patch series and chime in...
>>
>> The main question is whether this is indeed a "very special case" as
>> Alexey claims it to be or that it is likely to be applicable to other
>> device and host combinations as you are suggesting.
>>
>> If these properties are imposed by the host or host controller it
>> would make sense to have these in the mmc bindings.
>
> BTW, last year we were discussing something similar (I mean related to
> alignment requirements) with ath10k SDIO patches and at the time the
> patch submitter was proposing to have a bounce buffer in ath10k to
> workaround that. I don't remember the details anymore, they are on the
> ath10k mailing list archive if anyone is curious to know, but I would
> not be surprised if they are similar as here. So there might be a need
> to solve this in a generic way (but not sure of course as I haven't
> checked the details).

I re-call something about these as well, here are the patches. Perhaps
I should pick some of them up...

https://patchwork.kernel.org/patch/10123137/
https://patchwork.kernel.org/patch/10123139/
https://patchwork.kernel.org/patch/10123141/
https://patchwork.kernel.org/patch/10123143/

Kind regards
Uffe
