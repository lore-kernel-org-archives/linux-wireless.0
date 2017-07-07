Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:33933 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750768AbdGGJT1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 05:19:27 -0400
Received: by mail-wr0-f180.google.com with SMTP id 77so38162524wrb.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jul 2017 02:19:26 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: buffer overflow in brcmf_cfg80211_mgmt_tx()
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?B?ZnJlZW5lcmd1byjpg63lpKflhbQp?= <freenerguo@tencent.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        "security@kernel.org" <security@kernel.org>
References: <88f27bfd328f4ccdb0d6b7ff7e710819@MWHPR06MB3230.namprd06.prod.outlook.com>
 <d2c78377-5608-b6c3-07d8-17dfc56a5c7e@broadcom.com>
 <CA+55aFxGacqVMDN0pETkd9Ho554wR8ACvTZhxK6p6M6CtUc_DA@mail.gmail.com>
 <871spsej2d.fsf@kamboji.qca.qualcomm.com>
 <20170707084919.aaybvtw2t6dyjgv7@mwanda>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <a5817691-a2f2-314a-bc72-c72663a54d10@broadcom.com> (sfid-20170707_111930_914055_5CB05149)
Date: Fri, 7 Jul 2017 11:19:23 +0200
MIME-Version: 1.0
In-Reply-To: <20170707084919.aaybvtw2t6dyjgv7@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 7/7/2017 10:49 AM, Dan Carpenter wrote:
> On Fri, Jul 07, 2017 at 11:40:26AM +0300, Kalle Valo wrote:
>> Linus Torvalds <torvalds@linux-foundation.org> writes:
>>
>>> On Thu, Jul 6, 2017 at 10:11 AM, Arend van Spriel
>>> <arend.vanspriel@broadcom.com> wrote:
>>>>
>>>> Looks fine to me so ...
>>>
>>> I really think that if we can't trust 'len', then we have to check
>>> against the lower bound of DOT11_MGMT_HDR_LEN too, because otherwise
>>> we'll just have a big 16-bit number instead.
>>>
>>> And we should do that brcmf_err() that I had in my version, which also
>>> let's people know they are being attacked.
>>
>> I hope brcmf_err() is ratelimited so that the attacker cannot spam the
>> logs too much.
> 
> The attacker already has CAP_NET_ADMIN here so you're probably already
> toasted.

Indeed and brcmf_err() is ratelimited when build without CONFIG_BRCMDBG, 
which is what distros typically do.

Regards,
Arend
