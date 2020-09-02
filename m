Return-Path: <SRS0=XV+2=CL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5A6C433E7
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Sep 2020 09:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8E652078B
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Sep 2020 09:38:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="noXOX00h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgIBJi3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Sep 2020 05:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgIBJi3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Sep 2020 05:38:29 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D4CC061244
        for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2020 02:38:28 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id b79so3787308wmb.4
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2020 02:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ij+gbx4yllRnmme7mhYtpcU7g4pCchfdrbavMHvQwo4=;
        b=noXOX00hBiRhs73wjx7qI2bJ3i55+5WL1YuctxZVrxVcb1O1pW1h3ZleiMcVGL2+Qz
         BHAooP7z8iBl09QMPnzrJL5dBr4xQxPV8IXmxDPxR7w5O+RBt+toy6wBY72b6hQpjEIR
         8wQH3VY+oaVaxItiIL7h1tUqzZ+o8Le6TEmlANvg8pFSDkYHsAGv8q8zPMagfvOqfvdd
         wwEEbufdV/u9hXCkUaihPKmL6pLc3KAmecVBFPTzWvvmasprtJ+K8AOPCzP8POtQzn+r
         YNgO9FxA6abr9GNGqh3fZzM50wGVPZtiGfB1fCROhy4LrDP9D92/ltudzvXDANGO+T5o
         jrNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ij+gbx4yllRnmme7mhYtpcU7g4pCchfdrbavMHvQwo4=;
        b=bT82dQwbEA/k2upE0FrRWFvuVUT4ze90wfKQXtGMBMaD6Vdigd82WXZp1OvtLd7Psl
         zkOys1rkrRjNXuozq4qAsAjLQdVWyRTFbVIO2P8B0RSq+F/Us+c4HKiTUj8vgVPPBuiR
         UHkBeByH5PfSTy5Ux3ooQ79Nui/qrkJ6LQTva7VWPOXE+cZ2pZe0IhWc7gf1U3syZrWM
         bdwJ3rjMiC5PVF9mqegUz7BQ2yPd7zE9yseZ4GSGCLjSnIBzBkcNv+UgIxGLK3yZL5m7
         TcdgOiQ3RRzgW9Ej9mOoC48RneMfTsRs1nx8TLTwdtMuhXMavzq1Bdb2yQ5j9SnNjf8p
         ZmSQ==
X-Gm-Message-State: AOAM532qI7RCVvu+G4W2DHQziCpw4yy9JBV4wjkxolBOj3Z07zQGE72A
        kGek7bqL5/s9+8yb1QC+Sn+xFA==
X-Google-Smtp-Source: ABdhPJz4zM7n95vPPplFVdob6oA2aoihPCZWFzlbu+LJ9li3cnpJcrt0tqcvWW+m4WSVCqscRaMV0g==
X-Received: by 2002:a05:600c:20f:: with SMTP id 15mr5522270wmi.99.1599039506915;
        Wed, 02 Sep 2020 02:38:26 -0700 (PDT)
Received: from [192.168.0.38] ([176.61.57.127])
        by smtp.gmail.com with ESMTPSA id z14sm6591801wre.34.2020.09.02.02.38.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 02:38:26 -0700 (PDT)
Subject: Re: [PATCH v2 01/12] wcn36xx: Add VHT fields to parameter data
 structures
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        shawn.guo@linaro.org, loic.poulain@linaro.org
References: <20200829033908.2167689-2-bryan.odonoghue@linaro.org>
 <20200902085942.05A42C433C6@smtp.codeaurora.org>
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Message-ID: <2b2d04fb-14bc-fc6f-9c63-f3cefc4c9a43@linaro.org>
Date:   Wed, 2 Sep 2020 10:39:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200902085942.05A42C433C6@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 02/09/2020 09:59, Kalle Valo wrote:
> Bryan O'Donoghue <bryan.odonoghue@linaro.org> wrote:
> 
>> In order to pass VHT parameters to wcn3680 we need to use a super-set of
>> the V1 data-structures with additional VHT parameters tacked on.
>>
>> This patch adds the additional fields to the STA and BSS parameter
>> structures with some utility macros to make calculation of the structure
>> size easier.
>>
>> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
> 
> New warnings:
> 
> drivers/net/wireless/ath/wcn36xx/smd.c:1257:1: warning: 'wcn36xx_smd_set_sta_params_v1' defined but not used [-Wunused-function]
>   1257 | wcn36xx_smd_set_sta_params_v1(struct wcn36xx *wcn,
>        | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ath/wcn36xx/smd.c:150:1: warning: 'wcn36xx_smd_set_bss_vht_params' defined but not used [-Wunused-function]
>    150 | wcn36xx_smd_set_bss_vht_params(struct ieee80211_vif *vif,
>        | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

I'm declaring a series of functions in patches for later use, in patches 
03-10.

Do you want those squashed into the patch/patches where they are first 
used ?
