Return-Path: <SRS0=K5U7=PM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E52C43387
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 11:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B5C12173B
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 11:37:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JDDef7Rf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfADLhw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Jan 2019 06:37:52 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:41320 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfADLhw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Jan 2019 06:37:52 -0500
Received: by mail-ed1-f65.google.com with SMTP id a20so24753480edc.8
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jan 2019 03:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TzScQNtnIa2Kg8KFoJQHvOT/UE7taAyqB0BU4VxsL7Q=;
        b=JDDef7Rf5J5eK5RIC8C2bMHo/kBn1b8Ask5j8+yvrhf/Hmyw9Hz5BgOO0wEPJdrQxs
         LM1ILpjhFJsc8vgOWQ7ZHty8KKUoJeDd4A3JAGVqcScqCiYgvqwS+HYRHGySPwVQ2TEE
         ZD4Osj0ArG3zZ7+GqOr6G5eL9Cnjsx7s8OGNk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TzScQNtnIa2Kg8KFoJQHvOT/UE7taAyqB0BU4VxsL7Q=;
        b=eR/UqwsivPDiQUEQ67HLRGY9qiFitSzRF4GmFR5wARtq96t0xDnCHCyRIScpf8TyOX
         DuBzO1LjvjYqEwhudDaD5r3MbYAZX6/jN05oIN4EpqnxlDsMFTVmmFrYyp4ZQQK+7Jod
         AUDBjjznVw7gcAD9nvryFj84Pg60avfituMgjBLGUt2AGCykYgEiJmoY1gVnL1tn1g1b
         dC9h0cnUHhnPMCSc40pr3eK4S5cz0hbMSDMv3J/iCnxDwHdXf9KmNVv3EI4olHR60JuJ
         IuZXOwmCRLgZGVuWSgIT6NQS1cHPwRIQfQddUMCb//SlrypmJujMo7b06JYO9qIoUbA4
         m7TA==
X-Gm-Message-State: AA+aEWZHss6I6liBfMUifgI0jE8Ja1QyxDAXnSOO9Ap0v/aj+YXn/S8R
        ZFjOA3xvOSSJ95Rypttg08Mz4A==
X-Google-Smtp-Source: AFSGD/UEAWj1YclA9EkGw9/R+CC40WUCJqypuT7SK+eRCMtbcvL+NBj+T0280Jl5/zM7HkswnflRXQ==
X-Received: by 2002:a17:906:6308:: with SMTP id p8-v6mr38702396ejk.100.1546601870472;
        Fri, 04 Jan 2019 03:37:50 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id p30sm24533711eda.68.2019.01.04.03.37.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Jan 2019 03:37:49 -0800 (PST)
Subject: Re: [PATCH 1/2] brcmfmac: fix system warning message during wowl
 suspend
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
 <1546501565-40752-2-git-send-email-chi-hsien.lin@cypress.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <3334f808-6da3-5c84-e41b-892de4e5869d@broadcom.com>
Date:   Fri, 4 Jan 2019 12:37:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <1546501565-40752-2-git-send-email-chi-hsien.lin@cypress.com>
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
> There is a system warning message, warn_slowpath-fmt, during suspend
> while using supplicant join AP and enable wowl feature by IW command.
> It's cuased by brcmf_pno_remove_request path can't find the reqid.
> This fix will not go to remove pno request function if there is no
> pno scan.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Lo-Hsiang Lo <double.lo@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c | 5 +++++
>   1 file changed, 5 insertions(+)
