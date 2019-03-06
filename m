Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D43B6C43381
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 08:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BE6D20675
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 08:49:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hpvEdFMe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbfCFItz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 03:49:55 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37768 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbfCFItz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 03:49:55 -0500
Received: by mail-ed1-f68.google.com with SMTP id m12so9630452edv.4
        for <linux-wireless@vger.kernel.org>; Wed, 06 Mar 2019 00:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TPYTlTwBSDowYvaoUIEWchMSWnZ6OWY3AIFcYhBKPWg=;
        b=hpvEdFMemZbDaZXvFjXWsdJIiWCOyXJB+vsoXCU72htrtQi1WBLKdJaTb+h+dAgL/h
         +MPCozHGGXXgNW76gC0GxGTYML6hKUeH9+O5oZZq68i5cpUhkBgNAB8dM2ZVsVoTy68E
         lSYFHWn6DG2hcYQnC4qdRp2oXSrLbVxX5umG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TPYTlTwBSDowYvaoUIEWchMSWnZ6OWY3AIFcYhBKPWg=;
        b=pmDOx/T6hf1xAQSQz1oOBeOrXktLF1HHxb9jT1fsY0EcKoYKWajEZa7ao0+BCPMtlS
         RSojv00CRhb+l1ckG9C9ztEEzPYwjNBcL86oZ1l4R9nHazWr5B2ocB29ziaeJ8HtVoGk
         mP9mH2jJMXjuBdBoqRSYAqFcNMHB6PWnOhDQArSa/5KOblAA8f/xsURqSrOkYjvDILPU
         ahyzdA4Vib0FjfSPir9MV0a79bahO/85DHOyRnSp6DIYZX4ANkuf7pzM7Gu2/rZ2Q1mt
         aLSN0sYCFhexcPznfx5oTEkxjbRO+AJJ4OW/PCOsJqkhNpLQ+P5wG2/rj51pKriJ5kE4
         mfbA==
X-Gm-Message-State: APjAAAWqSK6e4XX/5X/rI9QhyKycCHMFuwpBTCRJaLeqZRBFA1JX0960
        lFarjIYRWSGWE7BeRhgECTT6pw==
X-Google-Smtp-Source: APXvYqxf/h3nqS3F9kxOJ2y9/x4Gl6lG3+bzThZ/9zP2UA7v/QgFjodv3tV1KFv+K+gwcLskch3yyQ==
X-Received: by 2002:a17:906:f87:: with SMTP id q7mr3154763ejj.237.1551862194027;
        Wed, 06 Mar 2019 00:49:54 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id gl18sm214825ejb.49.2019.03.06.00.49.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 00:49:53 -0800 (PST)
Subject: Re: [PATCH 1/4] brcmfmac: support repeated brcmf_fw_alloc_request()
 calls
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20190226131119.7907-1-zajec5@gmail.com>
 <20190226131119.7907-2-zajec5@gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <93330b1f-2cce-e4d2-bac6-d82807a7254f@broadcom.com>
Date:   Wed, 6 Mar 2019 09:49:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190226131119.7907-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/26/2019 2:11 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> During a normal brcmfmac lifetime brcmf_fw_alloc_request() is called
> once only during the probe. It's safe to assume provided array is clear.
> 
> Further brcmfmac improvements may require calling it multiple times
> though. This patch allows it by fixing invalid firmware paths like:
> brcm/brcmfmac4366c-pcie.binbrcm/brcmfmac4366c-pcie.bin

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 1 +
>   1 file changed, 1 insertion(+)
