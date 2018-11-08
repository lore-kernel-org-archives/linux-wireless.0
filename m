Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB18C32789
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C888920892
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:53:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UJ34eMRp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C888920892
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbeKHV3D (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 16:29:03 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:37695 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbeKHV3C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 16:29:02 -0500
Received: by mail-yw1-f66.google.com with SMTP id v77-v6so7885586ywc.4
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2018 03:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=GLk+oS3Sow2vI6yfJVbDh5UQuaW/kK30XomlPLsDxBY=;
        b=UJ34eMRppC3xc2IPxW+mwyftI4DAT19rsL4pF265jYN6SScUm4kNO+B+dOr3bdl6rP
         8u/a03NJz0EKX21bq5r67kDzx8GiFFEy8NxegB9beXUj5dw66QlKImGRWxwz1QLJnBXE
         0d4MHN8cQzDnIPRHRzyIdUfxCoMPFW8y+aYbA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=GLk+oS3Sow2vI6yfJVbDh5UQuaW/kK30XomlPLsDxBY=;
        b=azKYF/siMxQPsSxpsCrBMcUbVHtwTYR4+qFNyQIy2oCSjUqvUqdtst1pReDydTO2PR
         zbGZcLSBVzNguUSez/XygkAk+HL5ON22gd1EYL2kBIDLjkKGV3u6fCL8epK2RzfBo71q
         T2C1VjoTW0CyhTwwGEE3jqrUD5/ZeN9jWyhrAUnZ9U6y1zt2VkWTfEp0f/2G79nmye8I
         RBNK8vzKuRFVk4dTh8N86NdXb7We/gjd2MXG6X1/hOBTX/40o8m7dmmrMs45EMcDIhi2
         u14xrk3kekDyz7F67jMASf/2GaNNQtnTvCeCp4n55P5Flo1kO4pV1jazF7OrH5VvqrSl
         Zo3w==
X-Gm-Message-State: AGRZ1gLRzDQqB2psv7bVIu+1m3I3//KwAxBEJ84fBouZnOEd1wTDQ4yR
        Lv69UH20bDU8R91EQJSAjVbO6wF2Fv9KWQ==
X-Google-Smtp-Source: AJdET5eNBAaD8QOpGqkxv7ydO/Hk7oD0e9P7O2bcVZ3ucBZMynHVa+K2nfj+pplJril5zSMtlraj6Q==
X-Received: by 2002:a81:708f:: with SMTP id l137-v6mr3773276ywc.146.1541678033542;
        Thu, 08 Nov 2018 03:53:53 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id j65-v6sm81506ywg.52.2018.11.08.03.53.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 03:53:53 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 06/11] brcmfmac: saverestore support changes for 43012
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541476188-75475-7-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Praveen Babu Chandran <Praveen.Chandran@cypress.com>
Message-ID: <137600e1-b188-1905-99e4-841c656ab322@broadcom.com>
Date:   Thu, 8 Nov 2018 12:53:51 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1541476188-75475-7-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/6/2018 4:50 AM, Chi-Hsien Lin wrote:
> From: Praveen Babu C <praveen.chandran@cypress.com>
>
> Add saverestore register settings for 43012.

I would collapse this commit with PATCH 04/11.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Praveen Babu C <praveen.chandran@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |  5 +++++
>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 22 +++++++++++++++++-----
>  2 files changed, 22 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 299f59f58d8c..a32eb5f868b5 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -3354,16 +3354,29 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
>  {
>  	int err = 0;
>  	u8 val;
> +	u8 wakeupctrl;
> +	u8 cardcap;
> +	u8 chipclkcsr;
>
>  	brcmf_dbg(TRACE, "Enter\n");
>
> +	if (bus->ci->chip == CY_CC_43012_CHIP_ID) {

Use brcmf_chip_is_ulp() here as well (see PATCH 04/11).

hmmm..wait. This is actually disabling the command decode for 43012, 
which is claimed to be done in PATCH 09/11. So maybe another helper 
would be more appropriate here, eg. brcmf_sdio_aos_no_decode(bus).

> +		wakeupctrl = SBSDIO_FUNC1_WCTRL_ALPWAIT_SHIFT;
> +		cardcap = SDIO_CCCR_BRCM_CARDCAP_CMD_NODEC;
> +		chipclkcsr = SBSDIO_HT_AVAIL_REQ;
> +	} else {
> +		wakeupctrl = SBSDIO_FUNC1_WCTRL_HTWAIT_SHIFT;
> +		cardcap = (SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT |
> +				   SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT);
> +		chipclkcsr = SBSDIO_FORCE_HT;
> +	}
> +
