Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41334 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751782AbdGGIkw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 04:40:52 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?utf-8?B?ZnJlZW5lcmd1byjpg63lpKflhbQp?= <freenerguo@tencent.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        =?utf-8?Q?R?= =?utf-8?Q?afa=C5=82_Mi=C5=82ecki?=
        <rafal@milecki.pl>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl\@broadcom.com"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        "security\@kernel.org" <security@kernel.org>
Subject: Re: [PATCH] brcmfmac: buffer overflow in brcmf_cfg80211_mgmt_tx()
References: <88f27bfd328f4ccdb0d6b7ff7e710819@MWHPR06MB3230.namprd06.prod.outlook.com>
        <d2c78377-5608-b6c3-07d8-17dfc56a5c7e@broadcom.com>
        <CA+55aFxGacqVMDN0pETkd9Ho554wR8ACvTZhxK6p6M6CtUc_DA@mail.gmail.com>
Date: Fri, 07 Jul 2017 11:40:26 +0300
In-Reply-To: <CA+55aFxGacqVMDN0pETkd9Ho554wR8ACvTZhxK6p6M6CtUc_DA@mail.gmail.com>
        (Linus Torvalds's message of "Thu, 6 Jul 2017 15:32:42 -0700")
Message-ID: <871spsej2d.fsf@kamboji.qca.qualcomm.com> (sfid-20170707_104111_235447_170BAA36)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Jul 6, 2017 at 10:11 AM, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>>
>> Looks fine to me so ...
>
> I really think that if we can't trust 'len', then we have to check
> against the lower bound of DOT11_MGMT_HDR_LEN too, because otherwise
> we'll just have a big 16-bit number instead.
>
> And we should do that brcmf_err() that I had in my version, which also
> let's people know they are being attacked.

I hope brcmf_err() is ratelimited so that the attacker cannot spam the
logs too much. BTW I didn't see your version of the patch, I guess it
was not CCed to linux-wireless.

Just a side note, but this discussion is not stored in patchwork, I only
see the original patch. No idea why:

https://patchwork.kernel.org/patch/9827721/

-- 
Kalle Valo
