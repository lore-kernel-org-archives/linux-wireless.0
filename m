Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CD8C46465
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F41620892
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:55:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="F6UTCU7w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F41620892
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbeKHVbH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 16:31:07 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:35228 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbeKHVbG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 16:31:06 -0500
Received: by mail-yw1-f66.google.com with SMTP id w135-v6so7889446ywd.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2018 03:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=ONsp0+f9HV5i54FIZa+JnalSEecUMFoWeG8Kd2W1yWY=;
        b=F6UTCU7wc8mDI2mZWGvNqzRFHVqKMhgB9GpCS6qo1hj4kJ00BUnagwa0QpwJ5fU1uJ
         2I3wCEw83mWF0GB1G9i6g7UgJaeVPWIa/GstMaK5rTteiS34kFVaWVkkJIxOFYDYn//2
         7aY9p847Owi/P+tOmXeeO/CF2zHbN6zeMvUuU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=ONsp0+f9HV5i54FIZa+JnalSEecUMFoWeG8Kd2W1yWY=;
        b=bpFnO4KZYktzGpHUx8GC9xuXIpigiQo6roePc7ttMq+QahOxwl5Y5lyVD4TLd9QHM1
         u3E1DUMrxPrW3yTg0nS7EE3Vmnhg/0+PQy0KV/uJg1c9sHzq3VMNYM0+k1SMa9lzaLIG
         MHHZNEGwtXcqSMtCnBatSmWQLUxK5LZD6X/YRLNAbLvv0AHuBbnrpBzQDQnN16bz7JW6
         KyrAbH6J3W9IcEVHEeq3jYJbwV11qxY9H7goE3r+DRQ2aT1zbaQfEQUByIE4BypD50z2
         t4r9Z5FgA0/xbGPNW2jdAVfukY+PakMhfB0/SYtCEVb/z9MTcmRaEduhCFpEmcWUx6Mv
         wubA==
X-Gm-Message-State: AGRZ1gK3xQfOh86OUQ/P+67TDUsxk3AhYg0G7dnhjp3u8vKOVetifyjE
        fk+mOjmGqTJKUWW6SblxVf0/OQ==
X-Google-Smtp-Source: AJdET5eRr1YMnovVVaBGFrypFEQjvgQgXWNoxrQ2dUkGzRa8W0h5M/JXQAizL8ieFENwrk/cqSLhsA==
X-Received: by 2002:a81:cd4:: with SMTP id 203-v6mr3898256ywm.364.1541678157563;
        Thu, 08 Nov 2018 03:55:57 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id v5-v6sm917025ywb.62.2018.11.08.03.55.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 03:55:57 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 11/11] brcmfmac: disable command decode in sdio_aos for
 4373
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541476188-75475-12-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Madhan Mohan R <MadhanMohan.R@cypress.com>
Message-ID: <76e43ad1-6c56-8371-0e63-c7e457dd54c7@broadcom.com>
Date:   Thu, 8 Nov 2018 12:55:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1541476188-75475-12-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/6/2018 4:50 AM, Chi-Hsien Lin wrote:
> From: Madhan Mohan R <madhanmohan.r@cypress.com>
>
> By disabling command decode, sdiod_aos module supports
> the detection of sdio command line toggle only and
> generates a wakeup request to PMU and to sdiod core.
> It does not decode any sdio command and generates no
> response to any command.

See comment in PATCH 09/11

> Signed-off-by: Madhan Mohan R <madhanmohan.r@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 +
>  1 file changed, 1 insertion(+)

