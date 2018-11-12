Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F40DBC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBC65223C8
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:30:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="QlPOgKgV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBC65223C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbeKLUW7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 15:22:59 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38580 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbeKLUW6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 15:22:58 -0500
Received: by mail-wm1-f66.google.com with SMTP id f2-v6so7563752wme.3
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2018 02:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=plWeLGN5GXmyQQB5KabuMawFKvoUNTuCDVNA7qvcd7k=;
        b=QlPOgKgV6v4IAkqjdndi8yTbEWqnH5U9tkSnZB/stnyWv68Ny2fxBz6R/O8e57aMdW
         cqzC9N/hpWZthOSY1umqZ3FEXr0UdnSh9OtVtqtBnrMVseu3FYrKhNtKcI/d7Ti/Fd11
         PiTd3i9aQ/MArf+2A/1QNxLxKjPYXx/2yHwdY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=plWeLGN5GXmyQQB5KabuMawFKvoUNTuCDVNA7qvcd7k=;
        b=kTJK2WmamqRZ13NVe99T1aqjRvY6ZEYJqqgda65tLAk702rfvgKWL25nnergIlsnO1
         okQL8G/Nbm5BPDnAwQvgTIoR/DB78I54dHRt5N680W1RtDcELEcH+0U9i9vbZyfgfDps
         XCPRou8/Adx5pr34BqtYe3EZ+cwlorI7VDpyQYTh7vLSWTOGFL/tDi4Zovg12AI/DWkM
         gVGqmYZs2GTpmctywHczaqIakRhlB1w2IlaIpwyjUv9iIQ0LuTHhL+8hT2GBSTM6Un4p
         aPdsidazC1eQAktzKoZJZGfDB7B/uuu7lKXEGgJ9BrtUxl3VdYLik1uNwc4cs9WW8SOZ
         VfIQ==
X-Gm-Message-State: AGRZ1gKRs+fVaDdQJRsXVxB4UBXhmTfp8i8Tsg/1vAhEExxlDHH/8gMM
        73dPUuy1TSPMpfEP2ZipeK85fw==
X-Google-Smtp-Source: AJdET5fK0YaC3B3DG3aMSfCIDWZYEYxSJYlKmpc2DVusUAkLe64Kqu0/zDBrtqkAG9nqNkpIbBTI4Q==
X-Received: by 2002:a1c:adc7:: with SMTP id w190-v6mr6706960wme.96.1542018620880;
        Mon, 12 Nov 2018 02:30:20 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id t198-v6sm15172878wmd.9.2018.11.12.02.30.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Nov 2018 02:30:20 -0800 (PST)
Subject: Re: [PATCH V2 7/8] brcmfmac: 4373 save-restore support
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
 <1542007730-47284-8-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <0d024ae5-dc3e-a812-3afb-8b9fbd910444@broadcom.com>
Date:   Mon, 12 Nov 2018 11:30:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1542007730-47284-8-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/12/2018 8:29 AM, Chi-Hsien Lin wrote:
> Use sr_eng_en bit to check 4373 sr support.
>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> index a8d3b96b727f..08d5173d000c 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> @@ -1365,6 +1365,11 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
>  		addr = CORE_CC_REG(base, sr_control1);
>  		reg = chip->ops->read32(chip->ctx, addr);
>  		return reg != 0;
> +	case CY_CC_4373_CHIP_ID:
> +		/* explicitly check SR engine enable bit */
> +		addr = CORE_CC_REG(base, sr_control0);
> +		reg = chip->ops->read32(chip->ctx, addr);
> +		return (reg & BIT(0)) != 0;

Sorry for not saying it earlier, but maybe it is good to add define of 
SR engine enable bit in brcm80211/include/chipcommon.h.

Regards,
Arend
