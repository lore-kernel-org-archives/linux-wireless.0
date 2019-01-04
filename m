Return-Path: <SRS0=K5U7=PM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DBCC43387
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 12:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B6F62173B
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 12:17:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cfMqiElc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfADMRc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Jan 2019 07:17:32 -0500
Received: from mail-yw1-f49.google.com ([209.85.161.49]:41204 "EHLO
        mail-yw1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfADMRc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Jan 2019 07:17:32 -0500
Received: by mail-yw1-f49.google.com with SMTP id f65so14418683ywc.8
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jan 2019 04:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jUy8z4zVdNA5+5am+sxH+MHHzjdjH69AoGWm/O5XJJk=;
        b=cfMqiElc4U33xDnjfTjSnmtIM09HRyx+m9OQBEogvByp0/QFKAG0Y70fphtXHgeGLM
         5j2wl5zWqSVp9RlqwbtVfotDcNJLPW1pGNZefHtkWw1CGsEcDb0XlX+3Q+2gdHoFtmQb
         VUWODLHOrwrRg0J5ZGst3tRqHXZfBFKySgH/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jUy8z4zVdNA5+5am+sxH+MHHzjdjH69AoGWm/O5XJJk=;
        b=nE3vF+DG8WEIH3zgiiGKZoveZlPbpJsc22C1d1fh0O4F55B6DHUoSnc30IKVQYXvu9
         bdsQijz4daAUAJw+o6Z7Vsqdm52DxcXsuqe4nXdj8dTzfeZhoHKA1aZ0jnzmBrYk8W1A
         e2c2WO+BIcw44eFFudB9CcrguOedq9SAr2sUWDCKen3bofSTWoYElOGsdh8bYA0xN6a9
         Pav7aEMTqskfIKduejPDx+Y9bZ34UfbgF0KENCBVZPsaIyJFnFZW0tr/ypvpIe9NM1V0
         b7PyIMIIc3vDBdQ2kOVeDG6PKPOShIWM2MVudzgA5MmfoERHLmKoPVf9Ke42yercBBwB
         FxlA==
X-Gm-Message-State: AA+aEWYsucfuxpi2X4N2wGHVTKMr2382R4DEGPQa6h2N8AKGnWPEvhm8
        RWSHPczi0TLN9Vv+8Np2VjwlKw==
X-Google-Smtp-Source: AFSGD/UV+7CeQ7aI8PXaYvAwQpaEzMQIj3vvE4RKAeTdhSSSDYWSqx253+aYK1awT/rvblDxUsM1UA==
X-Received: by 2002:a81:85c5:: with SMTP id v188mr52190835ywf.51.1546604251478;
        Fri, 04 Jan 2019 04:17:31 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id j134sm27897105ywb.91.2019.01.04.04.17.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Jan 2019 04:17:30 -0800 (PST)
Subject: Re: [PATCH 2/2] brcmfmac: support wake on ping packet
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Double Lo <Double.Lo@cypress.com>
References: <1546501565-40752-1-git-send-email-chi-hsien.lin@cypress.com>
 <1546501565-40752-3-git-send-email-chi-hsien.lin@cypress.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <cad34d20-efd1-63c5-6981-cd87794259a4@broadcom.com>
Date:   Fri, 4 Jan 2019 13:17:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <1546501565-40752-3-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/3/2019 8:46 AM, Chi-Hsien Lin wrote:
> From: Lo-Hsiang Lo <double.lo@cypress.com>
> 
> Set up wiphy->wowlan_config and a dummy wowlan filter so brcmfmac can
> remain connected during suspend. Enable an unicast packet filter during
> suspend so ping packets can wake up the system.

This basically enables a default wowlan configuration, but why do we 
want this in the driver. The struct wiphy::wowlan_config member is 
primarily managed by cfg80211 (see nl80211_set_wowlan()) upon user-space 
request.

If user-space reconfigures with no wowlan triggers the default 
configuration is freed, but as we have no .set_wakeup() callback the 
configuration in firmware remains unchanged so things are out of sync. 
So I would discourage this default approach and just let user-space deal 
with wowlan configuration.

Regards,
Arend
