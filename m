Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE3FC2BC61
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 11:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5621920827
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 11:04:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hsIw1IlX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5621920827
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbeJ3T5m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 15:57:42 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:33153 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727239AbeJ3T5m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 15:57:42 -0400
Received: by mail-yw1-f67.google.com with SMTP id z72-v6so425135ywa.0
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2018 04:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=OZ8V90BJm/Hbipa/VO/BI1rDvoANxjsyoxlWbL55ar0=;
        b=hsIw1IlXVbp2irt9t3XhA5RxJRrNBszD0MYc9nuQ2KfcFJxek20fNwTwlwPwyYAxV6
         g1IN04D2oiMZA73EtR5mbhYq9AuxpCO5gQVS9gCa5FUdCqkgS1Zhwu40lmqELw+HsEHa
         rxIkxi5Ws+yaKYHOG/u1DDcW4ohBa6EgeMkfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=OZ8V90BJm/Hbipa/VO/BI1rDvoANxjsyoxlWbL55ar0=;
        b=CDknYr8wdQ0ByHhdGiBThJr86nU69B+VIK0PQjk5Az+ECX9pHEPbuuyVy1WwLo8bEW
         ktyBu39KFmtLnb84HDQJtyx73Axa8Y4QamMSBcUoJD5xtm//4GCkW1OwpYNtYK4Ho5LE
         Xe7toe+5U2q0uO1V/qQEjYCVxlEHJhD8EOP+dvwkmX5diHxLm+1cQSKSaw/vzijOHS/F
         giEOcrJe1vdrK8AQfWsohjhyEaMEFnEnVhuIIXmpBNIAi03HTdqBAYbpBPtkORIiK10b
         VWlvoNeQL5FUu5r9GGNvpj35ZhvQZKvGGhU0yfJ7iMlao1bOkNK0sDxCiHC3TAZYFdio
         cPnA==
X-Gm-Message-State: AGRZ1gKaZ4LbEXw4hPQK9q+LUQLBVNIFxiq7/XlE5/+C5s+ZXZLmFJq4
        dFW2cDKgK4glS9sDjYTJAoisAA==
X-Google-Smtp-Source: AJdET5eDVTv5wPlZgD8L2ghqCRq3t/fy5fOoxjDHaLwyB+yJEACECvD76gIoKzdM76yVKdybkUFKaQ==
X-Received: by 2002:a81:3802:: with SMTP id f2-v6mr1835270ywa.81.1540897480896;
        Tue, 30 Oct 2018 04:04:40 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id o131-v6sm5717370ywb.107.2018.10.30.04.04.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Oct 2018 04:04:40 -0700 (PDT)
Subject: Re: [PATCH 2/3] brcmfmac: add credit numbers updating support
To:     Wright Feng <Wright.Feng@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1540808552-28738-1-git-send-email-wright.feng@cypress.com>
 <1540808552-28738-3-git-send-email-wright.feng@cypress.com>
Cc:     "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <aa65d65d-f610-3136-2e7d-45d150ec183d@broadcom.com>
Date:   Tue, 30 Oct 2018 12:04:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1540808552-28738-3-git-send-email-wright.feng@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/29/2018 11:27 AM, Wright Feng wrote:
> The credit numbers are static and tunable per chip in firmware side.
> However the credit number may be changed that is based on packet pool
> length and will send BRCMF_E_FIFO_CREDIT_MAP event to notify host driver
> updates the credit numbers during interface up.
> The purpose of this patch is making host driver has ability of updating
> the credit numbers when receiving the BRCMF_E_FIFO_CREDIT_MAP event.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
>  .../broadcom/brcm80211/brcmfmac/fwsignal.c         | 23 ++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
> index f3cbf78..e0910c5 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c

[...]

> @@ -1595,19 +1599,21 @@ static int brcmf_fws_notify_credit_map(struct brcmf_if *ifp,
>  		brcmf_err("event payload too small (%d)\n", e->datalen);
>  		return -EINVAL;
>  	}
> -	if (fws->creditmap_received)
> -		return 0;
>
>  	fws->creditmap_received = true;

I think the creditmap_received struct member is no longer needed.

>  	brcmf_dbg(TRACE, "enter: credits %pM\n", credits);
>  	brcmf_fws_lock(fws);
>  	for (i = 0; i < ARRAY_SIZE(fws->fifo_credit); i++) {
> -		if (*credits)
> +		fws->fifo_credit[i] += credits[i] - fws->init_fifo_credit[i];
> +		fws->init_fifo_credit[i] = credits[i];
> +		if (fws->fifo_credit[i] > 0)
>  			fws->fifo_credit_map |= 1 << i;
>  		else
>  			fws->fifo_credit_map &= ~(1 << i);
> -		fws->fifo_credit[i] = *credits++;
> +		if (fws->fifo_credit[i] < 0)
> +			brcmf_err("fifo_credit[%d] value is negative(%d)\n",
> +				  i, fws->fifo_credit[i]);

This looks like it should not happen so maybe warrants a WARN or WARN_ONCE?

>  	}
>  	brcmf_fws_schedule_deq(fws);
>  	brcmf_fws_unlock(fws);

