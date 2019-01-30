Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D812FC282D6
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 06:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A922820989
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 06:11:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="kb3qU0xJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfA3GLD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 01:11:03 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42356 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbfA3GLD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 01:11:03 -0500
Received: by mail-pg1-f194.google.com with SMTP id d72so9892238pga.9
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2019 22:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=s3pPF054WEm8OyrXxyPjZFhtv/s9dWvBEg00z0qjpF4=;
        b=kb3qU0xJ3xOSzyns5X5241P6RvtUWe5fYq2dcvHBCTuUo5QP4+jScF4cJxrwRVQCC1
         lwJiVU977td9AAhJ4qJepv6W7Btxrki3ok2SsPteqi7JE0Dj6SYiC8bXLnaZuphqZmJ1
         Ty5IvCNp0L5ffFvP9KtRYnKBWyZC5CoOpEIXM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=s3pPF054WEm8OyrXxyPjZFhtv/s9dWvBEg00z0qjpF4=;
        b=Fhsn6MlwRT1XbIdGzqEstW6I3iejC5Uz682yBf5+AtoNsDrTOxD70bQKyJb7HOx3oq
         8gujtmDkD8AE+OTlR6MoCcKyw6EZsS4BOnRTKTzGCXB5N/JN3TKL9jUWHFC60jgiGgvP
         uGF8L1SO4Pv6LpORZj3uSrMsXfFB43BE77KIhyvJEkRgVfcF5TUC7to9YyKtB9HuBPZ6
         EgdJBk/XReQ2X77jUnxZER/OvVIGsjgsfEQbFabuTl8DEsU/WLLBLXJaFyztvYffWqmp
         kuVW1//O4aZDfS3v+QgcdxahZ3CaIFEVCEk2bf2Og1Wl40+9cr9MgB5x5PKHoaj0bBBW
         ib8A==
X-Gm-Message-State: AJcUukc6JdaH6s9X63ZJClI5cntauZ12Yua7WYUqwDOlVa9Ruyb9SSTU
        nIhC8xg1IgkKRkM6KM1+VmkPhg==
X-Google-Smtp-Source: ALg8bN6RPg4y7Z4+W8+BchPwK3kz+yolMBfg7BW738pfnZp4EzIEkA6M5jbQrPOooq4YIttrU0H/Bg==
X-Received: by 2002:a62:4156:: with SMTP id o83mr29164466pfa.72.1548828662467;
        Tue, 29 Jan 2019 22:11:02 -0800 (PST)
Received: from tuxbook-pro (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id b13sm1556889pfj.66.2019.01.29.22.11.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jan 2019 22:11:01 -0800 (PST)
Date:   Tue, 29 Jan 2019 22:10:59 -0800
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        Wen Gong <wgong@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-5.0] ath10k: correct bus type for WCN3990
Message-ID: <20190130061059.GA2387@tuxbook-pro>
References: <20190129231201.42230-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190129231201.42230-1-briannorris@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue 29 Jan 15:12 PST 2019, Brian Norris wrote:

> WCN3990 is SNOC, not PCI. This prevents probing WCN3990.
> 
> Fixes: 367c899f622c ("ath10k: add bus type check in ath10k_init_hw_params")
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

> ---
> This was a regression in 4.20.
> 
>  drivers/net/wireless/ath/ath10k/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 399b501f3c3c..e8891f5fc83a 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -548,7 +548,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>  	{
>  		.id = WCN3990_HW_1_0_DEV_VERSION,
>  		.dev_id = 0,
> -		.bus = ATH10K_BUS_PCI,
> +		.bus = ATH10K_BUS_SNOC,
>  		.name = "wcn3990 hw1.0",
>  		.continuous_frag_desc = true,
>  		.tx_chain_mask = 0x7,
> -- 
> 2.20.1.495.gaa96b0ce6b-goog
> 
