Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86009C32789
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:53:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F9EB20892
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:53:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UBGmMiHH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F9EB20892
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbeKHV2j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 16:28:39 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:45838 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbeKHV2i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 16:28:38 -0500
Received: by mail-yw1-f68.google.com with SMTP id p18-v6so5662948ywg.12
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2018 03:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=ulRe8aNUh9F+iCkh0IJ28fFheoyZPfIeD4YqSQwrhRE=;
        b=UBGmMiHHTb/X05JoYvJOuRoMPwEQYY6P2DYEOld/HyGqxfJrwjqgW9dldGrUUBOtyM
         RUqEMFlBa1wdzxrICG2U8IIyfADZaqobT/6/UBuxdIrte2a+QwtI/Qqk2s/utaJPZbbR
         5JtZT/AJeeZ5eGprkNKiM99EVYJpMlCHVBkbg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=ulRe8aNUh9F+iCkh0IJ28fFheoyZPfIeD4YqSQwrhRE=;
        b=LSgw+VlZO3GM02hoOYO1knArflw/IeuB2c2mkAH7wfOKWnBHcxSElUY2i1oOL/brEW
         R2OJmP0tUddgvaYtgpgKD+Jy2sPRor//i6O1msU6DmwqJKSPypUeE/gTt1wmFiEgLhV/
         nX9aP1ipdam90uuEDqqeVy0Zp6aOQDbsuup2BJqqgHUuw3bEJHjKGrjiKeYq28CD2RjN
         5InFHg+zIHWop+7xXF1TqFqNxZzHaiZH7k9FuhELPtxnquJeD7nkd5PRZv+Fi3c4O0s1
         pumAzbk/7BdFVYAw4c+ZRFXPeMudUdKBnSChpXkEvAIqAHlqexMtTPxou0c60o4UFOcR
         66Kw==
X-Gm-Message-State: AGRZ1gKSa4zbh1Or4XJiQ48PALjbFKNbdEpriFos5nQ2ANCfJ469Kl79
        +UTG3qeGOw9m9WTJ9famueg65Q==
X-Google-Smtp-Source: AJdET5dCbxM2BZbyDefyOYzYrV5JH9IfGTVVO9bTLtLrB9VPM3EvIUOk9/xnxqHbrhoQM+11SK6ZdQ==
X-Received: by 2002:a81:7a90:: with SMTP id v138-v6mr3748012ywc.100.1541678009511;
        Thu, 08 Nov 2018 03:53:29 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id k185-v6sm854256ywc.98.2018.11.08.03.53.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 03:53:29 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 03/11] brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541476188-75475-4-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Madhan Mohan R <MadhanMohan.R@cypress.com>
Message-ID: <62e88e38-b4d9-957d-12c9-60469687a4be@broadcom.com>
Date:   Thu, 8 Nov 2018 12:53:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1541476188-75475-4-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/6/2018 4:50 AM, Chi-Hsien Lin wrote:
> From: Madhan Mohan R <MadhanMohan.R@cypress.com>
>
> Along with F2 watermark (existing) configuration, F1 MesBusyCtrl
> should be enabled & configured to avoid overflow errors.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Madhan Mohan R <madhanmohan.r@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 +++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h | 3 +++
>  2 files changed, 6 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 541d54661c9e..34a838fcc319 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -51,6 +51,7 @@
>
>  #define DEFAULT_F2_WATERMARK    0x8
>  #define CY_4373_F2_WATERMARK    0x40
> +#define CY_4373_F1_MESBUSYCTRL  (CY_4373_F2_WATERMARK | SBSDIO_MESBUSYCTRL_ENAB)

I don't see much value for this define. It is use once below so just or 
it there. That way you can "directly" see what is written to the register.

>  #ifdef DEBUG
>
> @@ -4118,6 +4119,8 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
>  			devctl |= SBSDIO_DEVCTL_F2WM_ENAB;
>  			brcmf_sdiod_writeb(sdiod, SBSDIO_DEVICE_CTL, devctl,
>  					   &err);
> +			brcmf_sdiod_writeb(sdiod, SBSDIO_FUNC1_MESBUSYCTRL,
> +					   CY_4373_F1_MESBUSYCTRL, &err);

just use 'CY_4373_F2_WATERMARK | SBSDIO_MESBUSYCTRL_ENAB' here. No 
braces needed.

