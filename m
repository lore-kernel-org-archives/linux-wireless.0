Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDBD6C46465
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD2FA20892
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:54:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bszbsQ7X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD2FA20892
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbeKHV3p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 16:29:45 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:36225 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbeKHV3o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 16:29:44 -0500
Received: by mail-yw1-f66.google.com with SMTP id h21-v6so7884540ywa.3
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2018 03:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=19VRs/xwyWYwmNVGIPGghyJ8oDqX+iU+p1z4HW3r9K8=;
        b=bszbsQ7Xrfp/P76NIBSHTIfJyHGk6sLpBUJ80gHHzH9MADQuMnF8ot6nB3ZMFlK7k2
         hVf/DiKMPXqpFPRJ75dgFkva5myPp1c7IsGvMD/QuWDswSJ67DcFOp5cTBOu8wltDrRO
         eOAKjERU3g0la1IyUQlkVgYXgsiZRDzq7inI0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=19VRs/xwyWYwmNVGIPGghyJ8oDqX+iU+p1z4HW3r9K8=;
        b=FPdYNgAavcFXmFPitP+DJveqGqxJ7spieXkjq1gQhQECCS0sIiXQxay8pjhqS2xoEp
         sMyTehKTk8f9+edKR/DLJCaKAXt3+kAEZyNQppEtPny5coj31OrxMwHsMOz0C+0/EDYU
         W6MU5dk0M2D0+2hIddyZNd95sVwDMl/B/t370lIrxxjB0vvtc+f5KQLQB1xxXN9rrFrC
         84XwJ4DG4itC9z8NqatRO001KGtrkmsiDRdBinCj8gPjj+Uyiri+oRdmdNbbjb6JPKRr
         6s8V2vCRqQmWKRZDTK4bH5EOK4ywlHQi3vJzzsZ3rmqN0VN9t4j/ldG9koDGQ3Y+z3Qm
         A7qA==
X-Gm-Message-State: AGRZ1gIqbPaRHCjuyFWQ3SzFtMsud8FOspOnEu5iGPDzhr91/zmfY+jP
        +f8eAQ561O629BVsXddOAfVSeg==
X-Google-Smtp-Source: AJdET5cVV/HsLlbrpvK9FTzcTjAVKw5vCOgwJScoHdSYL+pVom640iJsFMgAYD4nndQXg/EeB9rNUg==
X-Received: by 2002:a81:ad57:: with SMTP id l23-v6mr3832043ywk.260.1541678075896;
        Thu, 08 Nov 2018 03:54:35 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id 200-v6sm864060ywq.97.2018.11.08.03.54.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 03:54:35 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 09/11] brcmfmac: disable command decode in sdio_aos for
 43012/4339/4345
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541476188-75475-10-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Message-ID: <ccee0c01-c63b-4ff2-b4ea-5a4e39d15029@broadcom.com>
Date:   Thu, 8 Nov 2018 12:54:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1541476188-75475-10-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/6/2018 4:50 AM, Chi-Hsien Lin wrote:
> From: Wright Feng <wright.feng@cypress.com>
>
> Transaction between AOS and SDIOD is not protected, and if cmd 52
> received in AOS and in the middle of response state changed from AOS to
> SDIOD, response is corrupted and it causes to SDIO Host controller to
> hang.

I think it would be good to elaborate on what AOS stands for. It is a 
part of the SDIOD core that becomes active when the rest of SDIOD is 
sleeping to keep SDIO bus alive responding to reduced set of commands.

I would actually suggest to collapse patch 10 and 11 in this one.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index e7ee144dc5dd..d507d8f15e48 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -3363,15 +3363,21 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
>
>  	if (bus->ci->chip == CY_CC_43012_CHIP_ID) {
>  		wakeupctrl = SBSDIO_FUNC1_WCTRL_ALPWAIT_SHIFT;
> -		cardcap = SDIO_CCCR_BRCM_CARDCAP_CMD_NODEC;
>  		chipclkcsr = SBSDIO_HT_AVAIL_REQ;
>  	} else {
>  		wakeupctrl = SBSDIO_FUNC1_WCTRL_HTWAIT_SHIFT;
> -		cardcap = (SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT |
> -				   SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT);
>  		chipclkcsr = SBSDIO_FORCE_HT;
>  	}
>
> +	if (bus->ci->chip == CY_CC_43012_CHIP_ID ||
> +	    bus->ci->chip == BRCM_CC_4339_CHIP_ID ||
> +	    bus->ci->chip == BRCM_CC_4345_CHIP_ID) {

use brcmf_sdio_aos_no_decode(bus) helper here.

> +		cardcap = SDIO_CCCR_BRCM_CARDCAP_CMD_NODEC;
> +	} else {
> +		cardcap = (SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT |
> +			   SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT);
> +	}
> +
>  	val = brcmf_sdiod_readb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, &err);
>  	if (err) {
>  		brcmf_err("error reading SBSDIO_FUNC1_WAKEUPCTRL\n");
>

