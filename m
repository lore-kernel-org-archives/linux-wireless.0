Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9981C10F03
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 11:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 806382084B
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 11:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="C4GuRxjh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfDYLW3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:22:29 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46824 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbfDYLW3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 07:22:29 -0400
Received: by mail-ed1-f68.google.com with SMTP id d1so18780141edd.13
        for <linux-wireless@vger.kernel.org>; Thu, 25 Apr 2019 04:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9g7GpgMRW/7NmFiw3exLo7k8Yrf6f9c2WsvXfc4KMVI=;
        b=C4GuRxjhuqlvyufpTuBQGs0TgTMZNC4xqSRyQv4bSmw3nLavwNMYQBKbu+9grZs7H1
         vkcnVdFZBvYkwnxVm2tbOo/RXUMAcUUOZ7qemNmLjQPdpnwAdwfiW9/kfsMM+4WCyL4F
         bHBaRMPyGjQkkFhu57dF6VOypCruLkISb/LHA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9g7GpgMRW/7NmFiw3exLo7k8Yrf6f9c2WsvXfc4KMVI=;
        b=W9d1oeQl10IddPL5TDhknsKKJO3t/zUIEnuE+fBYRnvb5muhkYuECm7vGB0KiJzL2S
         T/cO3YI1VIugPZFP5KeT1yybLmYmJRF+gg8nbqgeN6nR9imEhdztcBdoDjrQxqLSPx5i
         4QjfX46gzrxNNZLxB6tP3d1ryA0Llh7HkTOgBJnEGhJJINAddhQS5F1t2xX8lir9ammE
         4O84CSsfdSQhOMp6u3miItlLkTlpWaELaiUdVKIjjQiMKlsIYHTdtyySfOiUlSy50zh5
         /mOoZiV7aSSW433wUaiT5VTsxhr/IR/L87KBPQZKHb8dxjA8qNC+EpAT731fWnSxUZEN
         qEAw==
X-Gm-Message-State: APjAAAWaCTjdoEW1CeFqAYKsLeIIXb274vvDlkJsPcBA+IJmM/WiPAJ2
        bEkQrw7MBrEU5fxJZJ7WpW7eIXdVSPgP8A==
X-Google-Smtp-Source: APXvYqw25qGMXawkSuQKVKw5dHH6EICbjI8kcBQPsY6J3vQen2h7zUnlEvAGTiieXQPwwxDmD784GA==
X-Received: by 2002:a17:906:2356:: with SMTP id m22mr8428959eja.255.1556191347846;
        Thu, 25 Apr 2019 04:22:27 -0700 (PDT)
Received: from [10.230.40.234] ([192.19.215.250])
        by smtp.gmail.com with ESMTPSA id y19sm6044622edq.53.2019.04.25.04.22.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Apr 2019 04:22:27 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: allocate msgbuf pktid from 1 to pktids array
 size
To:     Wright Feng <Wright.Feng@cypress.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
References: <1556179487-147593-1-git-send-email-wright.feng@cypress.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <66165629-aa4d-afbe-5b09-3a592ff44a82@broadcom.com>
Date:   Thu, 25 Apr 2019 13:22:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556179487-147593-1-git-send-email-wright.feng@cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/25/2019 10:04 AM, Wright Feng wrote:
> Some PCIE firmwares drop txstatus if pktid is 0 and make packet held in
> host side and not be released. If that packet type is 802.1x, the
> pend_8021x_cnt value will be always greater than 0 and show "Timed out
> waiting for no pending 802.1x packets" error message when sending key to
> dongle.
> 
> To be compatible with all firmwares, host should allocate msgbuf pktid
> from 1 instead of from 0.

looking at it we are wasting entry 0 with this patch. Could we avoid that?

Regards,
Arend

> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> index d3780ea..b2fab3c 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> @@ -348,7 +348,7 @@ brcmf_msgbuf_alloc_pktid(struct device *dev,
>   	do {
>   		(*idx)++;
>   		if (*idx == pktids->array_size)
> -			*idx = 0;
> +			*idx = 1;
>   		if (array[*idx].allocated.counter == 0)
>   			if (atomic_cmpxchg(&array[*idx].allocated, 0, 1) == 0)
>   				break;
> 
