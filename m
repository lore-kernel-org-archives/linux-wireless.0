Return-Path: <SRS0=mdyG=NV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BDEC43441
	for <linux-wireless@archiver.kernel.org>; Sat, 10 Nov 2018 20:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AA3220840
	for <linux-wireless@archiver.kernel.org>; Sat, 10 Nov 2018 20:25:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BwTwELvX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3AA3220840
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbeKKGIU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Nov 2018 01:08:20 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:40320 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbeKKGIU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Nov 2018 01:08:20 -0500
Received: by mail-yw1-f67.google.com with SMTP id l66-v6so2976125ywl.7
        for <linux-wireless@vger.kernel.org>; Sat, 10 Nov 2018 12:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=NbVbXgkSTWpTcUL6gGf02vRQEOF4VisTwyBjijCeHuI=;
        b=BwTwELvX4GRPV8RudvocKsL0nLJwecgZBb9KdQVy1a10KTMx/Mgvab5XbQKzW+N5BJ
         8eEdjMLKar+USjQZCMuwFhUaT55lIfVSm/GgaBCpRmWo1K0p+l9wzGo5ACx3jfYgzRNj
         uMt8cunUtKVuP1Kb/PmH7kvxjEHQeslTaCTOQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=NbVbXgkSTWpTcUL6gGf02vRQEOF4VisTwyBjijCeHuI=;
        b=SctaZzSJ/sysFqLShtbzWDMKp+3i2hghYOGa4KWPo1A4WrADHhkNuOEVj4xnJpzfF4
         Efcx9UAKrDm4/0+gRjkmjis/z5peLjcum5JHDPF7zBGgEoTioCHlV8bmVmGdcR8rC8mt
         sYs8SEuwzP6uU78nFbJb8O9VdDm8u1bBj5UjHWz6DY5v6uu/VbRCeOnplokZ+3vEfce3
         jR1qPQ0OBd1lTUDO9sB6UtX2T+AKjlMkTCrCj+RvHXBAjV49i+0WfQJ1e+GeUqY5x+al
         9wyBK3XKPmnWnxVpmcNyO+CXzgR72wR2vWAgpw4Zw1HcoNjC3ffz7Rqv293lIgYbuXyO
         xZNA==
X-Gm-Message-State: AGRZ1gIzqeE2woKGWVpsEIwRTOo6KClOYRtUSGMaZkZ/A1u/uINpi1nQ
        tiTD+TZSSnL2OQxu8TQJLiAw3g==
X-Google-Smtp-Source: AJdET5dGiCgI7gis9bPibCBtTHmVJhboOR5XXDrFiBYlQFCY0etD6Q/ggttShORkMiteXR1YuJiYxw==
X-Received: by 2002:a81:8d43:: with SMTP id w3-v6mr13130552ywj.7.1541881327459;
        Sat, 10 Nov 2018 12:22:07 -0800 (PST)
Received: from [10.177.251.59] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id j65-v6sm2882223ywg.52.2018.11.10.12.22.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Nov 2018 12:22:06 -0800 (PST)
Subject: Re: [PATCH v2] brcmfmac: support STA info struct v7
To:     Dan Haab <riproute@gmail.com>, Kalle Valo <kvalo@codeaurora.org>
References: <1541781535-10523-1-git-send-email-dan.haab@luxul.com>
Cc:     Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Dan Haab <dan.haab@luxul.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <24a7c83c-0fdd-5b2c-f9ad-813b4d17ab55@broadcom.com>
Date:   Sat, 10 Nov 2018 21:22:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1541781535-10523-1-git-send-email-dan.haab@luxul.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/9/2018 5:38 PM, Dan Haab wrote:
> The newest firmwares provide STA info using v7 of the struct. As v7
> isn't backward compatible, a union is needed.
>
> Even though brcmfmac does not use any of the new info it's important to
> provide the proper struct buffer. Without this change new firmwares will
> fallback to the very limited v3 instead of something in between such as
> v4.

I would expect a changelog, but looking at the patch is addresses my 
comments nicely so....

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Dan Haab <dan.haab@luxul.com>
> Reviewed-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 40 ++++++++++++++++++----
>  1 file changed, 33 insertions(+), 7 deletions(-)

