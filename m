Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41668 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752527AbdGGImK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 04:42:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
        <37617809-d840-fe43-ae0d-71c545f9fab1@broadcom.com>
Date: Fri, 07 Jul 2017 11:41:46 +0300
In-Reply-To: <37617809-d840-fe43-ae0d-71c545f9fab1@broadcom.com> (Arend van
        Spriel's message of "Fri, 7 Jul 2017 10:28:29 +0200")
Message-ID: <87wp7kd4fp.fsf@kamboji.qca.qualcomm.com> (sfid-20170707_104239_425782_6E7914C8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 7/7/2017 12:32 AM, Linus Torvalds wrote:
>> On Thu, Jul 6, 2017 at 10:11 AM, Arend van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>>
>>> Looks fine to me so ...
>>
>> I really think that if we can't trust 'len', then we have to check
>> against the lower bound of DOT11_MGMT_HDR_LEN too, because otherwise
>> we'll just have a big 16-bit number instead.
>
> Fair enough. The firmware on the device should have a check in place,
> but guess what... :-( Anyway, the lower bound depends on the type of
> management frames. So for action frames it is DOT11_MGMT_HDR_LEN + 1
> /* Action Category */ + 1 /* Action */.
>
> Might be better to place the lower bound check in
> net/wireless/nl80211.c and do that appropriate for the type of
> management frame. That way it is assured for all wireless drivers.

So I drop this patch and wait for v2?

-- 
Kalle Valo
