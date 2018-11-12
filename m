Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8CA2C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 834A0223C8
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:34:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LZHUUAJG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 834A0223C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbeKLU0l (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 15:26:41 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44381 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbeKLU0k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 15:26:40 -0500
Received: by mail-wr1-f68.google.com with SMTP id j17-v6so8680268wrq.11
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2018 02:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=YkQjTsIvQ80WicbIJHHMm9M7sgsO2x/XoZzC+QQISXU=;
        b=LZHUUAJGW4a4aeNn4MG3H6j+e2DQQ+S4woeVymT6Ba/Um5Z1l8z7yEviBn1aGPY0Tb
         dqYqCaJ2tVJWW5NaEe5nWYj7rQwYLsJ07JeY67ZiWstjsOFTyqWyxTYEL2o6SzwEoqgA
         cGlUHly4ZytO8yDSq6QzG7xZ9dYJ+xicnhrvQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=YkQjTsIvQ80WicbIJHHMm9M7sgsO2x/XoZzC+QQISXU=;
        b=M6s5lTg7RVghefV2O6p76fAU3szMruLryCfJBalGneb7yePdA3m+ixmZ2FQxallr+9
         J18yBYTrlgOPxMGf73+IvXKOOfRvXcaCoBffqKPy6R1LcQ/d+h7HlO0YIKAFhwC/dJWO
         BEKcyNxDfmBDz7uvhYihFE2kxD79a0kMsh+UXQQ8GfC6QvrnlCq/fXp/acTgda2ptrPG
         5NKferOkrkL1TinxblFj8TIHNKBU7gjhQFd4WIdZ31HLfFYJevB4Uitez5NIzvFOXDa7
         z+SMxuNxibu0XQwXjNxZZSb/msbK5eOxMDbh2F59FLxHNcV1EYk73mWyGP7CeTdQ/xpB
         NEjQ==
X-Gm-Message-State: AGRZ1gLOHupUYo2HStnxIbOqt+cUKDjH23pfQCkDi4+JT+H4Dhh4DMRl
        J4kQXHsAkLkxiqIJB0noe/xThw==
X-Google-Smtp-Source: AJdET5cvJzFR+5StFRju+57bYnFp8VjM9FaYdCemGYTcl86plpMumsEggcEcRKhkhIvX5iXbBFwSUw==
X-Received: by 2002:a05:6000:1cb:: with SMTP id t11mr463180wrx.146.1542018836834;
        Mon, 12 Nov 2018 02:33:56 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id y7-v6sm8794997wmy.27.2018.11.12.02.33.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Nov 2018 02:33:56 -0800 (PST)
Subject: Re: [PATCH V2 8/8] brcmfmac: disable command decode in sdio_aos
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
 <1542007730-47284-9-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Double Lo <Double.Lo@cypress.com>,
        Madhan Mohan R <MadhanMohan.R@cypress.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <45d702d0-9761-add6-5ae1-97c1ebdef331@broadcom.com>
Date:   Mon, 12 Nov 2018 11:33:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1542007730-47284-9-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/12/2018 8:30 AM, Chi-Hsien Lin wrote:
> From: Wright Feng <wright.feng@cypress.com>
>
> AOS is a part of the SDIOD core that becomes active when the rest of
> SDIOD is sleeping to keep SDIO bus alive responding to reduced set of
> commands.
>
> Transaction between AOS and SDIOD is not protected, and if cmd 52 is
> received in AOS and in the middle of response state changed from AOS to
> SDIOD, response is corrupted and it causes to SDIO Host controller to
> hang.

Just one question. The above sound pretty generic so does it apply to 
any SDIO chip with AOS logic?

Regards,
Arend

