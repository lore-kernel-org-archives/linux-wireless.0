Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33014 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbeCTJzY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 05:55:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Alexey Roslyakov <alexey.roslyakov@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, robh+dt@kernel.org,
        mark.rutland@arm.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH net-next v2 2/2] dt: bindings: add new dt entries for brcmfmac
References: <20180319014032.9394-1-alexey.roslyakov@gmail.com>
        <20180319014032.9394-3-alexey.roslyakov@gmail.com>
        <5AAF838D.2030105@broadcom.com>
        <CALFoz4YMKJr40fefczrbjXBROtZxnGikv0Jze-BnefofCB3dyg@mail.gmail.com>
        <817418fd-6446-57ea-b03d-383b4df9a979@gmail.com>
        <5AB044C0.9060701@broadcom.com>
Date: Tue, 20 Mar 2018 11:55:16 +0200
In-Reply-To: <5AB044C0.9060701@broadcom.com> (Arend van Spriel's message of
        "Tue, 20 Mar 2018 00:16:16 +0100")
Message-ID: <87po3zxe9n.fsf@kamboji.qca.qualcomm.com> (sfid-20180320_105542_897625_45EFE29F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

>>> If I get it right, you mean something like this:
>>>
>>> mmc3: mmc@1c12000 {
>>> ...
>>>          broken-sg-support;
>>>          sd-head-align = 4;
>>>          sd-sgentry-align = 512;
>>>
>>>          brcmf: wifi@1 {
>>>                  ...
>>>          };
>>> };
>>>
>>> Where dt: bindings documentation for these entries should reside?
>>> In generic MMC bindings? Well, this is the very special case and
>>> mmc-linux maintainer will unlikely to accept these changes.
>>> Also, extra kernel code modification might be required. It could make
>>> quite trivial change much more complex.
>>
>> If the MMC maintainers are not copied on this patch series, it will
>> likely be hard for them to identify this patch series and chime in...
>
> The main question is whether this is indeed a "very special case" as
> Alexey claims it to be or that it is likely to be applicable to other
> device and host combinations as you are suggesting.
>
> If these properties are imposed by the host or host controller it
> would make sense to have these in the mmc bindings.

BTW, last year we were discussing something similar (I mean related to
alignment requirements) with ath10k SDIO patches and at the time the
patch submitter was proposing to have a bounce buffer in ath10k to
workaround that. I don't remember the details anymore, they are on the
ath10k mailing list archive if anyone is curious to know, but I would
not be surprised if they are similar as here. So there might be a need
to solve this in a generic way (but not sure of course as I haven't
checked the details).

-- 
Kalle Valo
