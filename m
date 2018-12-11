Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A89C07E85
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 12:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 112FC2084A
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 12:44:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Rhy6Q6Kn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 112FC2084A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbeLKMn7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 07:43:59 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:38700 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbeLKMn7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 07:43:59 -0500
Received: by mail-yb1-f195.google.com with SMTP id d187so6633793ybb.5
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2018 04:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JIOfynfTNRuhF8D6a6ylS09lgdqDkhP0BgwR40od+EM=;
        b=Rhy6Q6Kn++BWJFtrnmR9ilUZrUn4g4aAnYvYpS1+lhqvcw31fkiG/UjBcMZRUe+qOy
         3NcNTK89V3qJ5r393j1C66AQ5Z6Io9NUkr9METAFVGaZ7/Qmdfq5jkCqB39Ncg5vHnGT
         0hZCZhs9oq9kGlLGtazTzFaVgr550cem8SLSo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JIOfynfTNRuhF8D6a6ylS09lgdqDkhP0BgwR40od+EM=;
        b=OLkm0FRb0gJ1LXKq89QviN4aceYiUjMUsZCklZUGYXJ2+ChYnZehfA0qEXPYS0GQpN
         OEBxVqQHGxfY38RgGg4JbxN9M4YDPY2uMAmQkDOzq6N6HVr/hDUmwFUppQfsPPsQdVsX
         5YyC8BWKjNDxY0tYXovx63b9lks5paRw/Zvf9n/PFjEslSFZ2zpXv+qg9C9BagPGXCwb
         MzjLfkWeBE9ASw4hZRFDhrSGp4awzyNCNjQJBzRUnbRch54l+lRl9k0JMJr/tg+TqAGn
         Ccy86eOOBOVUvNFVC0wt83BnTyLblxXJ2DE2IUGO+JVqPvCGKLVJBAWyGWaGwSmub3w6
         J/8A==
X-Gm-Message-State: AA+aEWZF6UiG+HTQ/Of0ES1VDdIeLN9inQgQD5PkbSqwdzz8MVWiPSOG
        1dnvZiqpxumxZZY+VuC9aYmBqw==
X-Google-Smtp-Source: AFSGD/WM9M3ssgRMXpv6/Igw9NQGFBgYWSRWq7+jp8zpXCuONh2xgEvf6dGrrkmnQcEiApEO2vvksw==
X-Received: by 2002:a25:c887:: with SMTP id y129-v6mr15478040ybf.264.1544532238027;
        Tue, 11 Dec 2018 04:43:58 -0800 (PST)
Received: from [10.176.51.60] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id i7sm4445955ywd.7.2018.12.11.04.43.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Dec 2018 04:43:57 -0800 (PST)
Subject: Re: [PATCH v3 1/3] brcmfmac: add credit numbers updating support
To:     Wright Feng <Wright.Feng@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc:     "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
References: <20181105055137.13333-1-wright.feng@cypress.com>
 <20181105055137.13333-2-wright.feng@cypress.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <8a87285f-9b0c-a5a2-e2ce-9b8b1fb31761@broadcom.com>
Date:   Tue, 11 Dec 2018 13:43:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181105055137.13333-2-wright.feng@cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/5/2018 6:51 AM, Wright Feng wrote:
> The credit numbers are static and tunable per chip in firmware side.
> However the credit number may be changed that is based on packet pool
> length and will send BRCMF_E_FIFO_CREDIT_MAP event to notify host driver
> updates the credit numbers during interface up.
> The purpose of this patch is making host driver has ability of updating
> the credit numbers when receiving the BRCMF_E_FIFO_CREDIT_MAP event.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
> v2: Replace brcmf_err with WARN_ONCE
> ---
>   .../broadcom/brcm80211/brcmfmac/fwsignal.c    | 23 ++++++++++++-------
>   1 file changed, 15 insertions(+), 8 deletions(-)
