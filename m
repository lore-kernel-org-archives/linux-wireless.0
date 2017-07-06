Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36174 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbdGFWcn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 18:32:43 -0400
Received: by mail-oi0-f46.google.com with SMTP id x187so14329385oig.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 15:32:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d2c78377-5608-b6c3-07d8-17dfc56a5c7e@broadcom.com>
References: <88f27bfd328f4ccdb0d6b7ff7e710819@MWHPR06MB3230.namprd06.prod.outlook.com>
 <d2c78377-5608-b6c3-07d8-17dfc56a5c7e@broadcom.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Jul 2017 15:32:42 -0700
Message-ID: <CA+55aFxGacqVMDN0pETkd9Ho554wR8ACvTZhxK6p6M6CtUc_DA@mail.gmail.com> (sfid-20170707_003247_287584_A5E9B811)
Subject: Re: [PATCH] brcmfmac: buffer overflow in brcmf_cfg80211_mgmt_tx()
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?B?ZnJlZW5lcmd1byjpg63lpKflhbQp?= <freenerguo@tencent.com>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 6, 2017 at 10:11 AM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> Looks fine to me so ...

I really think that if we can't trust 'len', then we have to check
against the lower bound of DOT11_MGMT_HDR_LEN too, because otherwise
we'll just have a big 16-bit number instead.

And we should do that brcmf_err() that I had in my version, which also
let's people know they are being attacked.

                    Linus
