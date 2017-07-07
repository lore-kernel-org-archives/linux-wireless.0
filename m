Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:36011 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbdGGLV7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 07:21:59 -0400
Received: by mail-wr0-f173.google.com with SMTP id c11so42496008wrc.3
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jul 2017 04:21:58 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: buffer overflow in brcmf_cfg80211_mgmt_tx()
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?UTF-8?B?ZnJlZW5lcmd1byjpg63lpKflhbQp?= <freenerguo@tencent.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
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
 <20170707084640.cv3igibbhhmgsmta@mwanda>
 <a2496a2e-9258-7cc9-3c04-87886f0029cd@broadcom.com>
Message-ID: <f0f38282-9767-188d-a68b-76d1316ac17d@broadcom.com> (sfid-20170707_132203_060135_338D2479)
Date: Fri, 7 Jul 2017 13:21:55 +0200
MIME-Version: 1.0
In-Reply-To: <a2496a2e-9258-7cc9-3c04-87886f0029cd@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07-07-17 11:24, Arend van Spriel wrote:
> 
> 
> On 7/7/2017 10:46 AM, Dan Carpenter wrote:
>> On Thu, Jul 06, 2017 at 03:32:42PM -0700, Linus Torvalds wrote:
>>> On Thu, Jul 6, 2017 at 10:11 AM, Arend van Spriel
>>> <arend.vanspriel@broadcom.com> wrote:
>>>>
>>>> Looks fine to me so ...
>>>
>>> I really think that if we can't trust 'len', then we have to check
>>> against the lower bound of DOT11_MGMT_HDR_LEN too, because otherwise
>>> we'll just have a big 16-bit number instead.
>>
>> There is already a check in cfg80211_mlme_mgmt_tx().
>>
>>     if (params->len < 24 + 1)
>>         return -EINVAL;
>>
>> It probably should be using DOT11_MGMT_HDR_LEN instead of a magic 24.
> 
> Missed that check when I looked yesterday evening. Must have been the
> time ;-)

Hi Dan,

This being said, are you going to send a V2 adding a brcmf_err() call as
Linus proposed? I think we can improve the length check above later if
deemed necessary.

Regards,
Arend
