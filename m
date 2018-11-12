Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E992DC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 09:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF75C223AE
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 09:13:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hZD9Ti4k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF75C223AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbeKLTF2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 14:05:28 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53512 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728810AbeKLTF2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 14:05:28 -0500
Received: by mail-wm1-f68.google.com with SMTP id f10-v6so7643462wme.3
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2018 01:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=v3ZXsj97Ul1YwMLd9OrQ3wnCuOCDePhmRLXcCK7h/Kg=;
        b=hZD9Ti4kcKN035yWlaJLWTGAYv0e5NwnbmNvvRbrn1JL6XXfICoHp0MFhSIil38Omg
         46JhIkephTzLt3Kkqf3qjDycttqNvh8c7yRbItIWk13qmv2v3JZhEMHJezXZa/mOqx97
         dsotEMb0pGk3OhEaFTD8/ik95Vg95CCKOpTpw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=v3ZXsj97Ul1YwMLd9OrQ3wnCuOCDePhmRLXcCK7h/Kg=;
        b=E91SQR4PMo14hiJ7M/JMiLflWx4PzZHbwOan51je+9w+GSE0SO8w83T0c3Ktzs/Ofr
         5vaKEHQf60roAQYAj90GzIe43nkyTHf4zPnaQvq5tBGseYyoE6ALNjjlcBbNwdlryV0i
         JAJi5GlbQTN5vDD4ggC8SB9wIH99AtIvf/ZLZl+Tw6RTK77LVMBdOCCrSskjPy/Llm7G
         QsNFvib+m6HFW4MJqVkyFhs9HahlGTmL4dK4cwGFxnHOiNfJv6OWmNnapmooQfRbrSsV
         7Fl5f0ekkRX7bKtsJwloSHFsjtGfmtodpMjZy3mkzpS+lwEIm83ocv/+o9DHGpQNYhwS
         bedg==
X-Gm-Message-State: AGRZ1gKlwIz/dxqA6q9r5U7dAPY1zI+Bpc8JV49IBdko2QEzHvAAeK3C
        8fvkmsZr6hCqqiHV4DPp7IZeyw==
X-Google-Smtp-Source: AJdET5eE8iZugpE7ERXuj15FbwvzzH0fFPJwKTmAeOl6fApAIZ3SWcZ4tR1OxfeN9/CSJe9eGuA7RA==
X-Received: by 2002:a1c:9c85:: with SMTP id f127-v6mr6758174wme.73.1542013989379;
        Mon, 12 Nov 2018 01:13:09 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id k3-v6sm19637933wro.9.2018.11.12.01.13.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Nov 2018 01:13:08 -0800 (PST)
Subject: Re: [PATCH V2 3/8] brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
 <1542007730-47284-4-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Madhan Mohan R <MadhanMohan.R@cypress.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <0925038a-a767-351d-5b03-f8fa10b8aad1@broadcom.com>
Date:   Mon, 12 Nov 2018 10:13:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1542007730-47284-4-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/12/2018 8:29 AM, Chi-Hsien Lin wrote:
> From: Madhan Mohan R <MadhanMohan.R@cypress.com>
>
> Along with F2 watermark (existing) configuration, F1 MesBusyCtrl
> should be enabled & configured to avoid overflow errors.

I am a bit confused. Why is it necessary to program the watermark in 
both SBSDIO_WATERMARK (0x10008) and SDSDIO_FUNC1_MESBUSYCTRL (0x1001D).
Looks suspicious to me.

Regards,
Arend
