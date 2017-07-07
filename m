Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46587 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdGGIsT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 04:48:19 -0400
Date: Fri, 7 Jul 2017 11:46:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        =?utf-8?B?ZnJlZW5lcmd1byjpg63lpKflhbQp?= <freenerguo@tencent.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        "security@kernel.org" <security@kernel.org>
Subject: Re: [PATCH] brcmfmac: buffer overflow in brcmf_cfg80211_mgmt_tx()
Message-ID: <20170707084640.cv3igibbhhmgsmta@mwanda> (sfid-20170707_104822_756732_F0701A22)
References: <88f27bfd328f4ccdb0d6b7ff7e710819@MWHPR06MB3230.namprd06.prod.outlook.com>
 <d2c78377-5608-b6c3-07d8-17dfc56a5c7e@broadcom.com>
 <CA+55aFxGacqVMDN0pETkd9Ho554wR8ACvTZhxK6p6M6CtUc_DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+55aFxGacqVMDN0pETkd9Ho554wR8ACvTZhxK6p6M6CtUc_DA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 06, 2017 at 03:32:42PM -0700, Linus Torvalds wrote:
> On Thu, Jul 6, 2017 at 10:11 AM, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
> >
> > Looks fine to me so ...
> 
> I really think that if we can't trust 'len', then we have to check
> against the lower bound of DOT11_MGMT_HDR_LEN too, because otherwise
> we'll just have a big 16-bit number instead.

There is already a check in cfg80211_mlme_mgmt_tx().

	if (params->len < 24 + 1)
		return -EINVAL;

It probably should be using DOT11_MGMT_HDR_LEN instead of a magic 24.

regards,
dan carpenter
