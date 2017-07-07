Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31169 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751707AbdGGIuV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 04:50:21 -0400
Date: Fri, 7 Jul 2017 11:49:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        =?utf-8?B?ZnJlZW5lcmd1byjpg63lpKflhbQp?= <freenerguo@tencent.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        "security@kernel.org" <security@kernel.org>
Subject: Re: [PATCH] brcmfmac: buffer overflow in brcmf_cfg80211_mgmt_tx()
Message-ID: <20170707084919.aaybvtw2t6dyjgv7@mwanda> (sfid-20170707_105025_305374_6FA2F059)
References: <88f27bfd328f4ccdb0d6b7ff7e710819@MWHPR06MB3230.namprd06.prod.outlook.com>
 <d2c78377-5608-b6c3-07d8-17dfc56a5c7e@broadcom.com>
 <CA+55aFxGacqVMDN0pETkd9Ho554wR8ACvTZhxK6p6M6CtUc_DA@mail.gmail.com>
 <871spsej2d.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <871spsej2d.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 07, 2017 at 11:40:26AM +0300, Kalle Valo wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > On Thu, Jul 6, 2017 at 10:11 AM, Arend van Spriel
> > <arend.vanspriel@broadcom.com> wrote:
> >>
> >> Looks fine to me so ...
> >
> > I really think that if we can't trust 'len', then we have to check
> > against the lower bound of DOT11_MGMT_HDR_LEN too, because otherwise
> > we'll just have a big 16-bit number instead.
> >
> > And we should do that brcmf_err() that I had in my version, which also
> > let's people know they are being attacked.
> 
> I hope brcmf_err() is ratelimited so that the attacker cannot spam the
> logs too much.

The attacker already has CAP_NET_ADMIN here so you're probably already
toasted.

regards,
dan carpenter
