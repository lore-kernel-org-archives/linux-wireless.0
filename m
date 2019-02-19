Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84540C10F00
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 09:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C86921848
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 09:23:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="L0ptuK/w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfBSJXu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 04:23:50 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39729 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727652AbfBSJXt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 04:23:49 -0500
Received: by mail-ed1-f65.google.com with SMTP id p27so8546949edc.6
        for <linux-wireless@vger.kernel.org>; Tue, 19 Feb 2019 01:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yrztGYAc5wghEm9F/LRIaZRDbVFOD0gOzcRyECOh5SY=;
        b=L0ptuK/wMi5aiyhOQpPZY9z+ftgbgZ1iL3jjtaJ1xL/CFXwIhVjCsN+pJ9ALJsHRPJ
         jel/mrl5UTdKQJJXKO54Vsb0wsgYUPryYgdaGWN9MCv0HymZncB/e9QRfc4g0H+N4GWc
         LtQ/M3DbypVuLCku58xHf+AZsbTARZOdlTn9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yrztGYAc5wghEm9F/LRIaZRDbVFOD0gOzcRyECOh5SY=;
        b=qoA1Ft8OeAMcvNMb0pxFMiEEHZjrnpXvFrnLfdqWwOBiOzmSdb/j5gwJsgv2ksZhuc
         zvHz0tajuRqJYk0/Qk8aEtD0rzTN10eMHXLUj3DuqAdqeDBBwrsYRdNyTegekIG7VyhG
         G/iJ8JdhOJfikX0fGDP+/AMpTnxK3kW1RlMwkxPO+1zIVNmXOt5eBQWnQ6F23VGRt5Gt
         I62aPbmHBQaUL7rQj9ZG00NAaqB0R8vi2AYvkaTqFmEOVHJDW/QRAZfCX8f8x1GlKei1
         JblQ0NDiVyl4g8Xh/6mnyNblOYnQl9e1CuPJBuRrd1MewSXxE5DJClGTKw3YTyWF1Wv+
         YTAw==
X-Gm-Message-State: AHQUAuZXaP14Y865t8GUBAmdK9dLDpjriVxBmUkQ/vEwaxarPT9faRnD
        1nIZMKxSgdMxeSfbnQPdD/uiqw==
X-Google-Smtp-Source: AHgI3IZYewq4ZhWY8QwQLNvKqKO3fWblcsAAa5QU3FEYf37ACet5wRdsHTAk1o3S2Jw0FCHP2FmC2g==
X-Received: by 2002:a17:906:4ec6:: with SMTP id i6mr2375134ejv.56.1550568227901;
        Tue, 19 Feb 2019 01:23:47 -0800 (PST)
Received: from [10.230.33.15] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id c25sm2839541ejx.59.2019.02.19.01.23.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Feb 2019 01:23:47 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: remove set but not used variable 'old_state'
To:     YueHaibing <yuehaibing@huawei.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, kernel-janitors@vger.kernel.org
References: <20190218080846.187942-1-yuehaibing@huawei.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <eda4bb84-0f38-5d70-0f40-0f80bd748ad2@broadcom.com>
Date:   Tue, 19 Feb 2019 10:23:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190218080846.187942-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/18/2019 9:08 AM, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c: In function 'brcmf_usb_state_change':
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c:578:6: warning:
>   variable 'old_state' set but not used [-Wunused-but-set-variable]
> 
> It's never used and can be removed.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 2 --
>   1 file changed, 2 deletions(-)
