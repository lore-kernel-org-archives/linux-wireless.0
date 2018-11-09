Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16662C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C260A20825
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:20:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="b8Ka/bjt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C260A20825
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbeKIWBB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 17:01:01 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41954 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbeKIWBB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 17:01:01 -0500
Received: by mail-wr1-f65.google.com with SMTP id v18-v6so1683879wrt.8
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 04:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=w3JukLmWMJN2i4o7jw6ro+k597vodqSF/6SDAF4utro=;
        b=b8Ka/bjtXVuBLffdCbH9zwxCcnPwUlLY/wgFLJNpapspzyksD+oYrs1w6pw40bkv/l
         +X9e8tRtkX9GNNcSTDM2d2dlJJyDqw0TUlK0poHF0UkuD787PoX4r8MLVMN3nQWMhdaL
         zTd/iFl4rzpjCmvGse5l35XFFeaNBEJ4bxY4g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=w3JukLmWMJN2i4o7jw6ro+k597vodqSF/6SDAF4utro=;
        b=cOmSOMOO0696415VmWFpgCm59tRvUdkDIxzlGlXZop16bZuf+OpfLnf4gsfOS7moO7
         l/kjWTvEJ7uMBT0w6zJf7/P1l1sE7LLOlP18aT99Nn+6hzfIVCRQUwF5NBbcr6WNqif/
         rGSF/DxsnG3HgfV2HZxfuJgQjsE3q07arSCQuUhVwRpEhEupjnj9KbEBQeKWbBSppaYQ
         NqweQmkSxzzu/19a5R2tQ4I1c4v+2idNlQwabXeM40xxfppJfp5HMAjXlgNtvxjw+YBN
         nCTWU44PPZs40GQXyrLQvlW078JFTNasESZfDAPk+T9DsuMaQS8j0eMMs8IpxicIQkBI
         1tgw==
X-Gm-Message-State: AGRZ1gIQxQKJeIQ1O5a2vOxYvxWclcOgn9b/wFcUX/Hhlha3Zlgk6saz
        dqzwqRRiG6BMgPfx5QoZxgIN0w==
X-Google-Smtp-Source: AJdET5cNUaYgcrFcfM2hAkuor8xq6z1wJSuTH3TUVMVWXqPWkMlQAOfgRPJm+ARfTsCGJVi0xoYYMA==
X-Received: by 2002:a5d:488a:: with SMTP id g10-v6mr7976186wrq.0.1541766036475;
        Fri, 09 Nov 2018 04:20:36 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id v9-v6sm8113713wrm.6.2018.11.09.04.20.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Nov 2018 04:20:35 -0800 (PST)
Subject: Re: [PATCH 03/11] brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541476188-75475-4-git-send-email-chi-hsien.lin@cypress.com>
 <62e88e38-b4d9-957d-12c9-60469687a4be@broadcom.com>
 <ad6f6a88-86c6-58eb-ed54-782cdfd53641@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Madhan Mohan R <MadhanMohan.R@cypress.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <f16703ee-e6d1-e2ca-1105-692e5ac81633@broadcom.com>
Date:   Fri, 9 Nov 2018 13:20:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <ad6f6a88-86c6-58eb-ed54-782cdfd53641@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/9/2018 8:34 AM, Chi-Hsien Lin wrote:
>
>
> On 11/08/2018 7:53, Arend van Spriel wrote:
>> On 11/6/2018 4:50 AM, Chi-Hsien Lin wrote:
>>> From: Madhan Mohan R <MadhanMohan.R@cypress.com>
>>>
>>> Along with F2 watermark (existing) configuration, F1 MesBusyCtrl
>>> should be enabled & configured to avoid overflow errors.
>>
>> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>> Signed-off-by: Madhan Mohan R <madhanmohan.r@cypress.com>
>>> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
>>> ---
>>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 +++
>>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h | 3 +++
>>>  2 files changed, 6 insertions(+)
>>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>> index 541d54661c9e..34a838fcc319 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>> @@ -51,6 +51,7 @@
>>>
>>>  #define DEFAULT_F2_WATERMARK    0x8
>>>  #define CY_4373_F2_WATERMARK    0x40
>>> +#define CY_4373_F1_MESBUSYCTRL  (CY_4373_F2_WATERMARK |
>>> SBSDIO_MESBUSYCTRL_ENAB)
>>
>> I don't see much value for this define. It is use once below so just or
>> it there. That way you can "directly" see what is written to the register.
>>
>>>  #ifdef DEBUG
>>>
>>> @@ -4118,6 +4119,8 @@ static void brcmf_sdio_firmware_callback(struct
>>> device *dev, int err,
>>>              devctl |= SBSDIO_DEVCTL_F2WM_ENAB;
>>>              brcmf_sdiod_writeb(sdiod, SBSDIO_DEVICE_CTL, devctl,
>>>                         &err);
>>> +            brcmf_sdiod_writeb(sdiod, SBSDIO_FUNC1_MESBUSYCTRL,
>>> +                       CY_4373_F1_MESBUSYCTRL, &err);
>>
>> just use 'CY_4373_F2_WATERMARK | SBSDIO_MESBUSYCTRL_ENAB' here. No
>> braces needed.
>
> Thanks for the input. The biggest difference is to prevent a 4-line
> function call like below so it's more readable. I'll make this change in
> V2. Please let me know if below looks too messy then I'll move back to V1:
>
>                          brcmf_sdiod_writeb(sdiod, CY_4373_F2_WATERMARK |
>                                             SBSDIO_MESBUSYCTRL_ENAB,
>                                             CY_4373_F2_WATERMARK |
>                                             SBSDIO_MESBUSYCTRL_ENAB, &err);
>

The second argument should just be SBSDIO_FUNC1_MESBUSYCTRL so that will 
make it a bit less messy. Look okay to me.

Regards,
Arend

