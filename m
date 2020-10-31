Return-Path: <SRS0=pUCm=EG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 120FFC388F9
	for <linux-wireless@archiver.kernel.org>; Sat, 31 Oct 2020 12:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B85BE206E3
	for <linux-wireless@archiver.kernel.org>; Sat, 31 Oct 2020 12:53:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HRdyPuCA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgJaMxj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 31 Oct 2020 08:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgJaMxi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 31 Oct 2020 08:53:38 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAF9C0613D5
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2020 05:53:38 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id w14so9313859wrs.9
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2020 05:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IGOQADbFVeGZWVfP002B+KSVOMq2VfPDk2aZ0hM7j3M=;
        b=HRdyPuCAUvNmKA4o5Q98hD/xnFVA7djYQFLWOIotx97nsduS/HcN5mOUgKjeQTSJGh
         5KQJ8uMayd5ViBu5SS4E0dmEksyI9mhF653S4xLw/74BS8tmzcp+UrGU5pe9b4AQSILj
         Y9HOat2nyaeq4SjNssrnRHjZ+eoz7ZdsjCwSsegU+sDrYWmjBF9D9MZj6bE+++IoOzQx
         r3z9kju19ooJBKLDCLNPrdcqCV/ZZByGOY7vUE59t5fpLxoQEKgxEOiHp/LaRam+M9Ai
         4v/Gv5j2qXeLpbB+HXMjlngAvV/jqbkDSsojc7zoJIM6JSiP2f9esr3RvIl6Gorkk1e4
         wVbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IGOQADbFVeGZWVfP002B+KSVOMq2VfPDk2aZ0hM7j3M=;
        b=cEVmyWfZURB6OhsNP70r975+Wf4Pw3uz8zZIJ+W2MSZP8vIS+fhUP6hfebf2YZfbFw
         oC+9Y7oJkyFODQ2B5SXPus9tb6Cck4EAZBojB7SP+N5aVaT0EXuozl0nlUX9O0ePOEjN
         jv6QtZhoxIp3LJZH8IViSp4sTX/I37hskmpnPoIx864eEbp8N8SKMeHed2FrvTdZ2xML
         ZFlrZl38fxRt4bdYfKJMSVxxNKtdSYbWSaKI9hq+Lt1Wj+40hnBCLYn/Vlp+E26IEsr8
         J/KsAUIgToU7HVPF7Auev1zngPuUUjVrjL1rUUKT8NStEjxHXaNvnk9JUZZYjsISkIqv
         clXw==
X-Gm-Message-State: AOAM5323EbhRlhWGLIrWmleEQIXoZbYG6Ibe6p3dy/yXltorzs6D/UJC
        ugOhC8P3ljUHlg5sZska/67aLg==
X-Google-Smtp-Source: ABdhPJwzwfXAXJpYWsyb8DuXasYbLebFIwAmHnnSJiZNFNMYcgcxjfw+DldHwojxJk0qqPSH7cSa6Q==
X-Received: by 2002:adf:fc07:: with SMTP id i7mr4294011wrr.223.1604148817004;
        Sat, 31 Oct 2020 05:53:37 -0700 (PDT)
Received: from [192.168.0.162] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id f23sm7971793wmb.43.2020.10.31.05.53.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 05:53:36 -0700 (PDT)
Subject: Re: [PATCH 3/3] wcn36xx: Enable firmware offloaded keepalive
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>
References: <20201031022311.1677337-1-bryan.odonoghue@linaro.org>
 <20201031022311.1677337-4-bryan.odonoghue@linaro.org>
 <CAMZdPi86jzZ_A6OuBH=0NvdA=YXMjgXb+UaX5gajHffh20MgmQ@mail.gmail.com>
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Message-ID: <7df58938-e84c-aecd-bfd7-1e14775a34bf@linaro.org>
Date:   Sat, 31 Oct 2020 12:54:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAMZdPi86jzZ_A6OuBH=0NvdA=YXMjgXb+UaX5gajHffh20MgmQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 31/10/2020 09:39, Loic Poulain wrote:
> On Sat, 31 Oct 2020 at 03:22, Bryan O'Donoghue
> <bryan.odonoghue@linaro.org> wrote:
>> +                       wcn36xx_smd_keep_alive_req(wcn, vif,
>> +                                       WCN36XX_HAL_KEEP_ALIVE_NULL_PKT);
> 
> There is the wcn36xx_enable_keep_alive_null_packet function (from
> pmc.c) that you can use.

Sure
