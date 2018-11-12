Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C901C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 09:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4DEB223B0
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 09:26:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Gnh0X+I2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4DEB223B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbeKLTSW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 14:18:22 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38302 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728396AbeKLTSW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 14:18:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id e3-v6so8469541wrs.5
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2018 01:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=78SjM7/+b9J/8gsEBV3YYwUIzJ8W0f2MGinFzs11thU=;
        b=Gnh0X+I21/I2pHwgnOLnMFB4M+/RR4CZ0TiuuhAkzE9QpKTZ763/S1jeavHKqXOOms
         FU0JEl6fRZngM2Kz+ZDHkG6y+hPmoHP+IfBoX1s4WDXKYwjCRTOc7Y9E0A1rfwr5CEX1
         zkFeUqMqzLZ2hlwQ3clH104Vbwpx8g6DXi4WQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=78SjM7/+b9J/8gsEBV3YYwUIzJ8W0f2MGinFzs11thU=;
        b=Ck/XH6tCtlQNYBGUMBkIXpG/N8VL1x5sU4/BIUbfCKE155Agx8ZInBmgVD43+y5pfs
         xSnbCi1VfMcPe4srUJquuP0ivz8qAxtyuJo6AL8J1GFG6uSyMFX+kj8dyYF/N4eV60Ds
         fqwp84y1LGzdON/URE5ylszEq40XZ0j7eVfHTTCq03eb8M40f9DuLLM2FEwNe2GFgCSU
         banYjeaylBcwDXw1m9jydwSmCowcY5ifRd/7MZUNVru24ChlbbaZUPlb/3VTv9eOQhe2
         QrRH0SupQ79tbDk6Hmtf5A1DnGQE1u2aSPrSyH3yOcUbVK7GgG37P/USSkUvI80DgxPJ
         nHjg==
X-Gm-Message-State: AGRZ1gILnjBtTZoEEedXKgx7DBUnXuntY1iSWvHRYeOfoNuM/avqljoV
        lqPMl8ytK0QAkQvN6ptFS5emAg==
X-Google-Smtp-Source: AJdET5ddMzxgF7Y7rkqLORytnfg6W1MlFfpG/oDfKuSkjC/IZm+t11LxZmGi/+2tZiIAYTw8KuA4bQ==
X-Received: by 2002:a05:6000:1091:: with SMTP id y17mr209859wrw.226.1542014760250;
        Mon, 12 Nov 2018 01:26:00 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id i7-v6sm12975281wrs.55.2018.11.12.01.25.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Nov 2018 01:25:59 -0800 (PST)
Subject: Re: [PATCH V2 6/8] brcmfmac: update 43012 F2 watermark setting to fix
 DMA Error during UDP RX Traffic
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
 <1542007730-47284-7-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Naveen Gupta <Naveen.Gupta@cypress.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5ed63f80-c599-3b34-05bc-b721b4af2a1d@broadcom.com>
Date:   Mon, 12 Nov 2018 10:25:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1542007730-47284-7-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/12/2018 8:29 AM, Chi-Hsien Lin wrote:
> From: Naveen Gupta <naveen.gupta@cypress.com>
>
> The number of words that the read FIFO has to contain except
> the end of frame before sends data back to the host.
> Max watermark = (512B - 2* (BurstLength))/4 =
> (512 - 128)/4 = 384/4 = 0x60
> so if burst length (i.e. BurstLength = 64) is increased,
> watermark has to be reduced. This is the optimal setting for this chip.
>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Naveen Gupta <naveen.gupta@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 7707b0169c21..e1708e297d07 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -52,6 +52,7 @@
>  /* watermark expressed in number of words */
>  #define DEFAULT_F2_WATERMARK    0x8
>  #define CY_4373_F2_WATERMARK    0x40
> +#define CY_43012_F2_WATERMARK    0x60

So basically you increase queuing in firmware rx path. How does this 
affect TCP latency. The DMA error obviously needs fixing, but why go 
from a watermark of 32 bytes to the maximum of 384 bytes. Same question 
for 4373.

Regards,
Arend
