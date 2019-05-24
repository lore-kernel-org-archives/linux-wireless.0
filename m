Return-Path: <SRS0=H164=TY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A7BBC072B5
	for <linux-wireless@archiver.kernel.org>; Fri, 24 May 2019 09:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F088217F9
	for <linux-wireless@archiver.kernel.org>; Fri, 24 May 2019 09:28:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="Yo2QJu3O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389978AbfEXJ2o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 24 May 2019 05:28:44 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17848 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389724AbfEXJ2o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 May 2019 05:28:44 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ce7b94b0000>; Fri, 24 May 2019 02:28:43 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 24 May 2019 02:28:43 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 24 May 2019 02:28:43 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 24 May
 2019 09:28:41 +0000
Subject: Re: [PATCH v2] wlcore: sdio: Fix a memory leaking bug in
 wl1271_probe()
To:     Gen Zhang <blackgod016574@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190523144425.GA26766@zhanggen-UX430UQ>
 <87d0k9b4hm.fsf@kamboji.qca.qualcomm.com>
 <20190524024307.GA5639@zhanggen-UX430UQ>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <4f5d4070-a48a-bbc5-d3f5-ab6fc461105c@nvidia.com>
Date:   Fri, 24 May 2019 10:28:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524024307.GA5639@zhanggen-UX430UQ>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1558690124; bh=TY/LLkj+ZvzkU4/ChLoW2GQnwHdwxjE7R6eaX3uCVME=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Yo2QJu3OXzmlnBC8bER4vIASoypNoBAb6dcYVyBPXUrrYhoKfjP9svqGa0YZzxaFl
         cCBMlXivQS/+mjNcTruRg54OH61mhwQWxO8syBFqM+Wm3fiOOddHVvIQQ4MSeqb3kF
         nZB0IbEYG/Ivyd/66ht0Sm5/Zm+clTf+dU3X0fv8cALjEP4NBunRXNdPAndjwG5p4d
         4jHZtMBQf+lKj/tRBh8NUWkDHoRtypY4f9SqoEgW3GnxSb6x0THuw9VRV9CW5t61S+
         GrS2/uuMOr+0If4FPZDEc35tq3uvPcZkdw905Uv2wRm5UQhJo3Q4pbD99z90zXhXvM
         IeZ+vKfUwykpw==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 24/05/2019 03:43, Gen Zhang wrote:
> In wl1271_probe(), 'glue->core' is allocated by platform_device_alloc(),
> when this allocation fails, ENOMEM is returned. However, 'pdev_data'
> and 'glue' are allocated by devm_kzalloc() before 'glue->core'. When
> platform_device_alloc() returns NULL, we should also free 'pdev_data'
> and 'glue' before wl1271_probe() ends to prevent leaking memory.

No, devm_kzalloc() automatically frees memory on failure.

> Similarly, we should free 'pdev_data' when 'glue' is NULL. And we
> should free 'pdev_data' and 'glue' when 'ret' is error.
> 
> Further, we shoulf free 'glue->dev', 'pdev_data' and 'glue' when this
> function normally ends to prevent memory leaking.

Why?

> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> ---
> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
> index 4d4b0770..9110891 100644
> --- a/drivers/net/wireless/ti/wlcore/sdio.c
> +++ b/drivers/net/wireless/ti/wlcore/sdio.c
> @@ -298,8 +298,10 @@ static int wl1271_probe(struct sdio_func *func,
>  	pdev_data->if_ops = &sdio_ops;
>  
>  	glue = devm_kzalloc(&func->dev, sizeof(*glue), GFP_KERNEL);
> -	if (!glue)
> -		return -ENOMEM;
> +	if (!glue) {
> +		ret = -ENOMEM;
> +		goto out_free1;
> +	}
>  
>  	glue->dev = &func->dev;
>  
> @@ -311,7 +313,7 @@ static int wl1271_probe(struct sdio_func *func,
>  
>  	ret = wlcore_probe_of(&func->dev, &irq, &wakeirq, pdev_data);
>  	if (ret)
> -		goto out;
> +		goto out_free2;
>  
>  	/* if sdio can keep power while host is suspended, enable wow */
>  	mmcflags = sdio_get_host_pm_caps(func);
> @@ -340,7 +342,7 @@ static int wl1271_probe(struct sdio_func *func,
>  	if (!glue->core) {
>  		dev_err(glue->dev, "can't allocate platform_device");
>  		ret = -ENOMEM;
> -		goto out;
> +		goto out_free2;
>  	}
>  
>  	glue->core->dev.parent = &func->dev;
> @@ -380,12 +382,17 @@ static int wl1271_probe(struct sdio_func *func,
>  		dev_err(glue->dev, "can't add platform device\n");
>  		goto out_dev_put;
>  	}
> -	return 0;
> +	ret = 0;

This is completely wrong.

>  out_dev_put:
>  	platform_device_put(glue->core);
>  
> -out:
> +out_free2:
> +	devm_kfree(&func->dev, glue);
> +
> +out_free1:
> +	devm_kfree(&func->dev, pdev_data);
> +
>  	return ret;
>  }
>  
> ---

Jon

-- 
nvpublic
