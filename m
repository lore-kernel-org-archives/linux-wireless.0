Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:39303 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbdLAIig (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 03:38:36 -0500
Received: by mail-qk0-f196.google.com with SMTP id u184so12237650qkd.6
        for <linux-wireless@vger.kernel.org>; Fri, 01 Dec 2017 00:38:35 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: Add sg parameters dts parsing
To: Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        linux-wireless@vger.kernel.org
References: <20171201075542.GA31376@aremote07.aus.cypress.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, brcm80211-dev-list@cypress.com,
        brcm80211-dev-list.pdl@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, Wright Feng <Wright.Feng@cypress.com>,
        Stanley Hsu <Stanley.Hsu@cypress.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A211508.6030603@broadcom.com> (sfid-20171201_093839_655630_E35E9763)
Date: Fri, 1 Dec 2017 09:38:32 +0100
MIME-Version: 1.0
In-Reply-To: <20171201075542.GA31376@aremote07.aus.cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/1/2017 8:55 AM, Chi-Hsien Lin wrote:
> broken_sg_support, sd_head_align, and sd_sgentry_align are used in
> brcmfmac code but not configurable in dts file. Add the parsing logic.
> Now they can be configured like below in dts:
> 	brcm,broken_sg_support;
> 	brcm,sd_head_align =/bits/  16 <4>;
> 	brcm,sd_sgentry_align =/bits/  16 <4>;

Hi Chi-Hsien,

For device tree support you should submit a separate commit on the dt 
binding specification. For broadcom fullmac chipsets binding spec can be 
found in 
Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt.

The alignment properties are to be specified in bytes, not bits.

Regards,
Arend
