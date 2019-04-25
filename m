Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD74C10F03
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 07:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4ED6206BA
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 07:37:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hnZgrHNL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfDYHhj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 03:37:39 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36676 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfDYHhi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 03:37:38 -0400
Received: by mail-ed1-f66.google.com with SMTP id u57so18293130edm.3
        for <linux-wireless@vger.kernel.org>; Thu, 25 Apr 2019 00:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MNhaGlVvO2ZfBx6h+Q8WXm8BtTKheepa6vp+R25Wpw0=;
        b=hnZgrHNLVP+7pvV2rd1Xkfd0A3honXCDHGEP/rVwCRqRBqYMjCudiY8nVF0aJxBqNq
         DsiYYuUQvGnam8b/isFBgof9N5UU2kwdPrlmj1hjzGj820Y9VsX8oFsxh+sxYKumavU/
         Cze/SFyvhfWtuZ0LG6ojJf8uj7mtOOfkWiOx4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MNhaGlVvO2ZfBx6h+Q8WXm8BtTKheepa6vp+R25Wpw0=;
        b=Ciw7dolm5MQmGqabJICiENO+YZq2LFxsmhrs5Tyk9Jq2teF8rKW82np20e8VkYo5QF
         sBTZooXX6gnO7AwoIp6AYl96r2FlE7ZdoOZk7WJySAO8XkWclsQmAWwUwKcyDSLQzWvz
         zNY+OrPt/Oi6IrumrZOEvtujN0jrv7RcdIS76soOtRhmXignMnVXvD2UMmMqndxl7HA4
         Kid7r0cPk7ITNUrrh2PmpDkDUn2IgP4vbyT8NGm88cVrlEfxgqcRiI9l2dEQfbwLsrHj
         AE825seJVfYG21Jr0sZvn/eLDX9TWdQ7CPWZIkB6DR/QurSHlo0poFM8JiB2/xxhacBG
         sRTQ==
X-Gm-Message-State: APjAAAU2Sm3DKL1Q0qn02ShQm337IYCj0jYTUxiBEJQ6F6Ayy4Ia3jS5
        lyKU9/8pHaSyp6guyCKWvc04PA==
X-Google-Smtp-Source: APXvYqxvHHTGlOQS6eaiaNhwtgnqxTFbqdyaYvRcGillELjwhAIDtr05mXlxxrQNDF9MtUV75KW7lQ==
X-Received: by 2002:a17:906:b1a:: with SMTP id u26mr10753165ejg.69.1556177857072;
        Thu, 25 Apr 2019 00:37:37 -0700 (PDT)
Received: from [10.230.40.234] ([192.19.215.250])
        by smtp.gmail.com with ESMTPSA id q24sm110031eda.25.2019.04.25.00.37.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Apr 2019 00:37:36 -0700 (PDT)
Subject: Re: [PATCH v2] brcmfmac: send mailbox interrupt twice for specific
 hardware device
To:     Wright Feng <Wright.Feng@cypress.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
References: <1556175939-174559-1-git-send-email-wright.feng@cypress.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <90995d3d-9b48-ada4-d2cc-1487c34d6b4d@broadcom.com>
Date:   Thu, 25 Apr 2019 09:37:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556175939-174559-1-git-send-email-wright.feng@cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/25/2019 9:05 AM, Wright Feng wrote:
> For PCIE wireless device with core revision less than 14, device may miss
> PCIE to System Backplane Interrupt via PCIEtoSBMailbox. So add sending
> mail box interrupt twice as a hardware workaround.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
