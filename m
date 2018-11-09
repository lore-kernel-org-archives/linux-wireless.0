Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBF8C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35FFB2081C
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:49:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="MdrPBNNE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35FFB2081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbeKIW31 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 17:29:27 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40652 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727667AbeKIW30 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 17:29:26 -0500
Received: by mail-wm1-f66.google.com with SMTP id b203-v6so1833327wme.5
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 04:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=4IPAj0b/uVKRR72+VEKX5EIIF8uahRpAZzFEIfXFWgo=;
        b=MdrPBNNEZkanNyYxpPPIiW2llrmJnecgqpZq8laJQleHMbPbtWw18E2VZU0bfPo/QR
         Z2whSa/sTlOS52h3+WGUFetmOTNViKqnN018tu2R1LWJSvwLGBfrGo3tuB8aNi3z47kA
         QqC2Y11b/eNsSIctJYz0dG6TkC5HYXB0tGfJc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=4IPAj0b/uVKRR72+VEKX5EIIF8uahRpAZzFEIfXFWgo=;
        b=t92tu9xnNCKg95Y5I7bc4LgVsLGYroFpFdqQFdNfCHXSpGwmI3e6MGrD/iFCFHq2m+
         rbGezxH7l4HxfLVm2ZPNskK78YxTr2I/RQBp+fAIIpyNHyDh+NznEjh7P4eLI76X6EBt
         Xg1hjdXjqQhzBgGVqyHURRKxIf7gaJso2nopR1VWD7slX/hwcuHf0ayBhcY3Vc9jwbRV
         t1SmkjTouHzx+421OQCd6tCTqNCcpv1LEQjqmhJb/a0uUtgHZIj8/dc1ic90VXegfnOO
         dlrdn+NGTq3XPpS698hsGR3MZuAc4qFitvwuH/mbVm4ydRbGxf8CJcNiBxCdg4rpIGrw
         5KjQ==
X-Gm-Message-State: AGRZ1gI6ETqcMhjvK0O5bIXLzbKaT9DIBrbGxrGr0Cb1hcg0Wl7hrD/L
        BwL8myr5WETTd3Nx/6ltJ3R6TC9T5Z3Pxg==
X-Google-Smtp-Source: AJdET5cyWeNayVweVrk8mxqjJhxn6H4mUenRElemkmSSz+fxGK3uBN7c6OcG2yzvd6ANt3OLSbH1tw==
X-Received: by 2002:a7b:c393:: with SMTP id s19-v6mr4769430wmj.142.1541767736275;
        Fri, 09 Nov 2018 04:48:56 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id p16-v6sm11680505wro.29.2018.11.09.04.48.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Nov 2018 04:48:55 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 3/5] brcmfmac: p2p cert 6.1.9-support GOUT handling p2p
 presence request
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1541648845-194984-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541648845-194984-4-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Madhan Mohan R <MadhanMohan.R@cypress.com>,
        Jouni Malinen <j@w1.fi>
Message-ID: <5561b212-d0d6-559d-9aa0-fc93135f474f@broadcom.com>
Date:   Fri, 9 Nov 2018 13:48:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1541648845-194984-4-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ Jouni

On 11/8/2018 4:48 AM, Chi-Hsien Lin wrote:
> From: Madhan Mohan R <MadhanMohan.R@cypress.com>
>
> Send p2p presence response from the p2p interface address instead
> of the p2p device address. This is needed for p2p cert 6.1.9 to pass.

I am not really into the P2P spec, but if this is indeed a requirement 
(@Jouni: can you confirm?) I would expect wpa_supplicant to send the 
action frame over the correct netdevice (although there is no netdev for 
P2P_DEVICE interface so expect primary interface will be used).

So instead of looking at the action frame subtype it seems to be more 
appropriate to determine and pass the appropriate vif in 
brcmf_p2p_send_action_frame().

Regards,
Arend

> Signed-off-by: Madhan Mohan R <MadhanMohan.R@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

