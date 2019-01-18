Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3DA9C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 09:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BA2A2086D
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 09:46:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="J0zvbVmc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbfARJp6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 04:45:58 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:33173 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727377AbfARJp5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 04:45:57 -0500
Received: by mail-yw1-f68.google.com with SMTP id p65so5020358ywe.0
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jan 2019 01:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9x1m8LrQ/uaJc1e20IjN4qpu27XdRlDaxrcIM5MXSNw=;
        b=J0zvbVmcFH6OVjrxh2ax/T7/hmzWWrzDB+7VAmObP/81Oz3Z4SPbYsPbCzdsYon8xT
         QOBhhVg4sxNG0Molx/08oMB6C6s3iSwXOwDZaMnYFLHPHr4VhWl5nh0xkqATxNDdS3kY
         WcjWUiS9NhvWrwFQ+IP98UmOA6HQL71E4gEtU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9x1m8LrQ/uaJc1e20IjN4qpu27XdRlDaxrcIM5MXSNw=;
        b=Ccce8QijSeKd7CtfL4VWUQwV664GdO9m/iKQlickRnE/vP0NOB9C4sdIXpAuE05edj
         SOCr2SaomcvOSOa5LGe5G+7Y/jYXFd//N+41Tsi4lT8AJh0kcf/FbaRyfCGMkt5CpfL4
         1MMNbYjbWWxUgL7ht1W1qZxcwOoKL59PJ6XVaQiZ+LRjvHUe2cOYEy5uJElyL65vZ803
         m6Bj5DgNF9nkVqAlJq0VLGCEUNoy4m4Fy7LIzPMd/nn6VDjjFRjGC5zggVwDNBdPha9p
         luaDrPsiV+4FUfsZ0kSZqw+bynmcwmI6kTgQeqUp29CaI1FQ6YrcRv4eT7Z5q798Jvx6
         3Dxw==
X-Gm-Message-State: AJcUukcswb+ZGnKJ7dThx9c313AvtdB2A/KfnZwLcii4H32JqzvnxX5Z
        fm8FCZFKB5Kv7RGgzJjwZZBxpg==
X-Google-Smtp-Source: ALg8bN5Mivn6t/6+Qqlj7OAgfK7GKS+YO4T/VuUyIdYqIvgc0tiKFWZZdV+O5hClqXudLJ6OTXSCIw==
X-Received: by 2002:a0d:db97:: with SMTP id d145mr16776018ywe.487.1547804757105;
        Fri, 18 Jan 2019 01:45:57 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id j134sm1964113ywb.91.2019.01.18.01.45.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jan 2019 01:45:56 -0800 (PST)
Subject: Re: [PATCH] wireless: remove unneeded semicolon
To:     YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net,
        kvalo@codeaurora.org, franky.lin@broadcom.com,
        chi-hsien.lin@cypress.com, pkshih@realtek.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
References: <20190118033215.5904-1-yuehaibing@huawei.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e90c544b-3830-70d9-b793-ffa296c94320@broadcom.com>
Date:   Fri, 18 Jan 2019 10:45:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190118033215.5904-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/18/2019 4:32 AM, YueHaibing wrote:
> remove unneeded semicolon

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 2 +-
