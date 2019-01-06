Return-Path: <SRS0=sX2r=PO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6062C43387
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Jan 2019 09:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82A8221848
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Jan 2019 09:53:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="jEFUzijJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfAFJxj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 6 Jan 2019 04:53:39 -0500
Received: from mout.web.de ([217.72.192.78]:58831 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbfAFJxj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 6 Jan 2019 04:53:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1546768390;
        bh=0QiaJarJKQCjTROmnBfkHs185zhP/Wg4fxwjHsZomY8=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=jEFUzijJoCaOPgoirfgTRrjR7cbNIED/R5CGcalSRiHbT+Lnn7BgxrQ57lN1EWaf5
         gCiPisb0d8atejDSasQuO+MgIsWFb2VI3TOsKLRG1xiEGfmVFeAteo1Hu0d2Qgu2KH
         uPAi1usrGPVUxBOQObybxxMAb12f5eLTjLqfQohY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.57.47]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MMW2M-1gfWtH3b6k-008MqC; Sun, 06
 Jan 2019 10:53:10 +0100
Subject: Re: [PATCH] arm64: dts: hikey: Give wifi some time after power-on
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        John Stultz <john.stultz@linaro.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Wei Xu <xuwei5@hisilicon.com>, Ryan Grachek <ryan@edited.us>,
        linux-wireless@vger.kernel.org, "Reizer, Eyal" <eyalr@ti.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Ricardo Salveti <rsalveti@rsalveti.net>
References: <6ccac7db-3ab7-e396-90be-8681a8ee336b@web.de>
 <CALAqxLXz_s6B=NzSp17Lj6xMTYybEsMh4jDR8COXnWQCnFTrsw@mail.gmail.com>
 <CAPDyKFrY58-x3SsUwhfrLvf=hayhdjQZJWqUpmegArmnEsWATg@mail.gmail.com>
From:   Jan Kiszka <jan.kiszka@web.de>
Message-ID: <e4977d44-567a-5266-4617-ba62d194a666@web.de>
Date:   Sun, 6 Jan 2019 10:53:05 +0100
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
In-Reply-To: <CAPDyKFrY58-x3SsUwhfrLvf=hayhdjQZJWqUpmegArmnEsWATg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:wzL9kqqe+CszemgqHMAaOhEjdljmGacZWHJ+cKUotbX3O002/Vm
 vSKQzEIeG6ntKN8R9/uY+poJ7VnhYVQcrUodhFJq159stSS+KV4jAOni4TW+2lO9ZI/kSYM
 bqZzZpUOAOUYZJ45szvgjF7OPQsSaJKPbjLUIavCrASNvGmZXMceEKqavpn8oJiiHimZOut
 6IKtGAxeNMUJKYOf04UhA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:KYIP42mlWvQ=:FHeQ8gnASOFi2yXPxDYfx7
 tJN9lbI20QkMZdLdkKso5nG8hsooqQRejGfDxNx1KtFjKtfqh9G2rtk07K4WtKUgm1B/1kcDX
 hVbfzf5Xzlyd89aPBR3bz2dsBVJdYOQtJtmpLajJcSmoMkJZcX+0vtnV5LJCQXgNqjZj6WyuU
 aYvEhFq3W213sTtHJOe9UzbYWEgslkN71E1Rx7zVxRhdnpddAU/7uWxTmDB78NC3yJge2AZLm
 IkvnfdAB8LWtZyUYAoAE4QkSuVwOYADU9b/9oINfY+MXA4NrFfJ81h3l7aficGA+HRN3W7XxF
 Hczr0rCpZK/+imijojdFHxlj5tFP5KZl9h5FUZBelDRqVr/eFQAdjU0IzJQrUqMTnLdwOsGLu
 /EP7juM2qOqy20HyIjmPJkUZSmHTyFypQYGoYvrcs3lPKChxRSy9W4EEpg18Ufi5oxNptzFwa
 9wWda+EMTgPrWjN+MXpx3D5TnSX1S62PISewDX6QN36gO7gmSJZ51gBqi3QhcCveeLdOSg3og
 36rN40tFegTFCvwv4liyWVzoVKpCvEIsfV7dYeLvmEoueR6qHEK1oWaTsLvN9ICKamrNvIaKm
 IQRh25lgUPlYPvmNgxWMo+uNdJuTpreUQE6Iw8XJNm1u+OcH+s9ED3Q9cB5W9ZtonSMauUbel
 hmq43NmHNSDQ0GK4IVyfWRagOOrX6pH3AkiK9p09yVd5L/I5m7BZjMWb3cUswJ294RlMzUVRf
 Oj3pz1ia/NstAaDp3eZyRZ7UPAP/BW1rZty/uag0wbOUzihfpXjMSizSPsjUUzkQEmBix8WTd
 uaK5L+jbwo3HBWO0ECA8uCYZ90BlCPjaGd+fNU3iaBt64xGeL+fh43RVrdO1TMICHKWZwH9gl
 A6kHN+oqiQ2imX+QT8uGGicOQlZ1qQ8sIvgE9prNQlt9Ml0ygDv6fnVzGZEw/d
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 03.01.19 22:32, Ulf Hansson wrote:
> On Wed, 2 Jan 2019 at 23:21, John Stultz <john.stultz@linaro.org> wrote:
>>
>> Adding a few folks to cc from the thread here:
>> https://patchwork.kernel.org/patch/10734021/
>>
>> As this sounds like a very similar issue.
>> thanks
>> -john
> 
> John, thanks for looping me in.
> 
>>
>> On Sun, Dec 30, 2018 at 3:38 AM Jan Kiszka <jan.kiszka@web.de> wrote:
>>>
>>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>>
>>> Somewhere along recent changes to power control of the wl1835, power-on
>>> became very unreliable on the hikey, failing like this:
>>>
>>> wl1271_sdio: probe of mmc2:0001:1 failed with error -16
>>> wl1271_sdio: probe of mmc2:0001:2 failed with error -16
>>>
>>> After playing with some dt parameters and comparing to other users of
>>> this chip, it turned out we need some power-on delay to make things
>>> stable again. In contrast to those other users which define 200 ms, the
>>> hikey is already very happy with 1 ms.
> 
> According to the discussions we had so far, this doesn't sound like
> the correct solution.
> 
> I am intending to post patch soon, however, I am not sure exactly what
> solution to pick yet. I will keep you on cc - and of course I
> appreciate if you could help to test.
> 

FWIW, the Ultra96 is also affected. Here I worked around it by using a 10 ms 
power-on delay. The original workaround from the other thread did not help. 
Looking forward to the proper fix now!

Jan

> Kind regards
> Uffe
> 
>>>
>>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>>> ---
>>>
>>> Tested with 4.19 and linus/master.
>>>
>>>    arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts | 1 +
>>>    1 file changed, 1 insertion(+)
>>>
>>> diff --git a/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
>>> b/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
>>> index f4964bee6a1a..1e771bf201b9 100644
>>> --- a/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
>>> +++ b/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
>>> @@ -118,6 +118,7 @@
>>>                  reset-gpios = <&gpio0 5 GPIO_ACTIVE_LOW>;
>>>                  clocks = <&pmic>;
>>>                  clock-names = "ext_clock";
>>> +               post-power-on-delay-ms = <1>;
>>>                  power-off-delay-us = <10>;
>>>          };
>>>
>>> --
>>> 2.16.4

