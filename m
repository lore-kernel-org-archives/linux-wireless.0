Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACB4C46465
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FA5C20892
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:54:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ViFAgDeq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FA5C20892
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbeKHV3S (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 16:29:18 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:37776 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbeKHV3S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 16:29:18 -0500
Received: by mail-yb1-f193.google.com with SMTP id d18-v6so8206882yba.4
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2018 03:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=1enJ4nmaUqQACQYwEuCz7qK9moj0JOWZcLrjZg5twZc=;
        b=ViFAgDeqMzsLyE58OmM+yolFMjjYagxxQSrJMkviDu2vV8RUfU2VPCA5E+qQVQHpGv
         SeNmLxNHMDMQAUzJKdCn4Rl1LCIB3bXD4XohR4GaAVwCl/RGh87W+UdX/UsnqKUuCmnT
         FN8NBCMYIWvkLFmU3UkfHdrTwF2CJ2j7JwGrU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=1enJ4nmaUqQACQYwEuCz7qK9moj0JOWZcLrjZg5twZc=;
        b=WNZUaiEafYNmEOkoSdK4dSRf9LAjiMLvbPY3JEAtuTjUH1EZTGvrq7P0VE9/91q98u
         hgpKu/9MT8gr+sfi3TnyfWa+zy8nyfw38fIRl7FqppzfJJboFgie1u5xXjY+4eW5CSxX
         LLDQXqtOC1cYIBbpq3P2HCVhax+tdJFS8Cw8S5SN8/r+cnyaHamSEB/3OhDyrzDae0+3
         ENa9HMWp/akoqhGrmpo+DGi17bimkQk49EzHy5bKIDI8G+iDvMjGkl/T5kZlpfuJgpB3
         8I4znvl3Dq6HFQxuLkF0jmCTPssfJFxfYrBb9fzhd+UwfwUdFnhXNjc+92WAokW5ihqF
         zWqw==
X-Gm-Message-State: AGRZ1gIKHoIYVBGzGUaiqvEOHdcyRm2bQsaQ+Qfz0n1NrgErBHmk9lyn
        +oKvds+grq3EVIIS2dQ8jGNs1Q==
X-Google-Smtp-Source: AJdET5cXW9Q4kN1JZAwH7ZCEoJf0K1VMIPDWjrUS3R15jV9uoL3X42dCP54542UJLPx163qS2xq0iw==
X-Received: by 2002:a25:b20a:: with SMTP id i10-v6mr3862844ybj.154.1541678048606;
        Thu, 08 Nov 2018 03:54:08 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id c126-v6sm1158189ywd.104.2018.11.08.03.54.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 03:54:08 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 08/11] brcmfmac: 4373 save-restore support
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541476188-75475-9-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Message-ID: <023710dd-0b93-e1d4-f145-d877136627ba@broadcom.com>
Date:   Thu, 8 Nov 2018 12:54:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1541476188-75475-9-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/6/2018 4:50 AM, Chi-Hsien Lin wrote:
> Use sr_eng_en bit to check 4373 sr support.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> index a8d3b96b727f..dfc2af943bff 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> @@ -1332,7 +1332,7 @@ bool brcmf_chip_set_active(struct brcmf_chip *pub, u32 rstvec)
>
>  bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
>  {
> -	u32 base, addr, reg, pmu_cc3_mask = ~0;
> +	u32 base, addr, reg, sr_eng_en, pmu_cc3_mask = ~0;
>  	struct brcmf_chip_priv *chip;
>  	struct brcmf_core *pmu = brcmf_chip_get_pmu(pub);
>
> @@ -1365,6 +1365,12 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
>  		addr = CORE_CC_REG(base, sr_control1);
>  		reg = chip->ops->read32(chip->ctx, addr);
>  		return reg != 0;
> +	case CY_CC_4373_CHIP_ID:
> +		/* explicitly check SR engine enable bit */
> +		sr_eng_en = BIT(0);
> +		addr = CORE_CC_REG(base, sr_control0);
> +		reg = chip->ops->read32(chip->ctx, addr);
> +		return (reg & sr_eng_en) != 0;

Drop the variable and just do (reg & BIT(0)).
