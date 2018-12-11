Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D04AC07E85
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 12:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F9AD2084A
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 12:44:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="L08auQXz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F9AD2084A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbeLKMoV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 07:44:21 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:36066 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbeLKMoV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 07:44:21 -0500
Received: by mail-yb1-f195.google.com with SMTP id 64so3951216ybe.3
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2018 04:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0p4kYTBHabW7yWbCFM0Kewpgyz6plV+wMKMGP9mgKfY=;
        b=L08auQXzFCIwl+s3fXJX5HwiNhspGMhMPs7Unb+oKz4ntE6y/Gk4DDM0O9P4LSd8Qv
         OJxkMKRI3lxweNukpSSw7qHaoBBYIjG3M+OBHHS+IgL2uSpaPQcQEQDwE1TwuaWuGHrn
         uQhcMDs37LvpTUm7e3qLu2a3ZNUbLi15NVEkY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0p4kYTBHabW7yWbCFM0Kewpgyz6plV+wMKMGP9mgKfY=;
        b=PrX6LuKApS0wn+QJhK4dL1thVrYG+TYezli/areaftoiuoGffVDux0AEZBMyaq1FLe
         r2hrNanoZKjPCRMHsj3jMNp550DJVtmLXTR3BI92nEk3UYUPoJ/9V+LaMCV8KRhCLj0X
         YAJ59VIUpsVhxS8tNwfq6V7uR+UEwUpWfBX0uvrY1TCLgFy8IH6TlJMoT0QA2RiCAJjp
         ikMfUM1gF2XO5gpulkvP8yy4+KEpmY9tqjFzGYHfjn7B00eEMNsUsQk2bPjrWj68O+NB
         Vjijqzv5igH0cs8KJXfN9+Xt1oQHxVKM64hlB9AuL3w0W9Y3dDkYyLS0Xe0F4z9pw7X+
         v/Fg==
X-Gm-Message-State: AA+aEWZ27F7UVMEsivjNMObmycfq02Ah2MZlVyVyKJIJjMNCzLLta0pO
        AfZYnjEegxfCi43zmFJexpfoOg==
X-Google-Smtp-Source: AFSGD/VQ5AQmqTjJD1aHD/j0xxYmBdo82fc4x8BFOzug4xOfnQy+45AW6KfukU/t/Ief93BhRw6mjg==
X-Received: by 2002:a5b:852:: with SMTP id v18mr12311313ybq.146.1544532260404;
        Tue, 11 Dec 2018 04:44:20 -0800 (PST)
Received: from [10.176.51.60] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id l140sm4689846ywe.77.2018.12.11.04.44.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Dec 2018 04:44:19 -0800 (PST)
Subject: Re: [PATCH v3 2/3] brcmfmac: enable frameburst mode in default
 firmware setting
To:     Wright Feng <Wright.Feng@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc:     "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
References: <20181105055137.13333-1-wright.feng@cypress.com>
 <20181105055137.13333-3-wright.feng@cypress.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6dc0c088-b958-21d8-3037-b0d9bdc0fffe@broadcom.com>
Date:   Tue, 11 Dec 2018 13:44:17 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181105055137.13333-3-wright.feng@cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 11/5/2018 6:51 AM, Wright Feng wrote:
> The frameburst feature can enable per-packet framebursting in firmware
> side and get higher TX throughput in High Throughput(HT) mode. To enhance
> TX throughput, we enable frameburst mode in default firmware setting.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
> v3: Enable frameburst in default instead of being a module parameter
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 6 ++++++
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h     | 1 +
>   2 files changed, 7 insertions(+)
