Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE1CDC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84E26223C8
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:32:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="c0EN0W9I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84E26223C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbeKLUYj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 15:24:39 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36977 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbeKLUYi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 15:24:38 -0500
Received: by mail-wr1-f66.google.com with SMTP id o15-v6so8692697wrv.4
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2018 02:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=72YQoTccSaLxyEUZvq+QadAVR8OO6GdhDQH3u2OhPTM=;
        b=c0EN0W9Irq19n4rUh+kTbeGFaBaSezCJsACK02l2nG7K1BiBPRAGgYaru55X+fgP08
         MkbCTDI3PK6kXf+6hv59mrhmhIBuaB+imAYfKmdezHowu1wWD3g3a8y0hk5P5w1MKjiR
         xcj78t/3e5Tkrq0GuRa044HVW5sDTHwaxhrsc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=72YQoTccSaLxyEUZvq+QadAVR8OO6GdhDQH3u2OhPTM=;
        b=uO3V3FpcGPaHs5jZFjD+GA2y/eCdeXCloXvMxmL4osZUrradhWbD0cpiEeOrzlxlqC
         9oKsIFiYpIf1iRCMuE1SFhfLKYdIBnTx2KS44UE0TUeJSJdKF/pH4RI4V55/eWafi25+
         3zZgy/Wi+AYdYPYdELfeFiFilKWzkxZLMfwO1zVI8jM9zlt04Rsr6zvT1F0QRzxYDWEv
         qkNEmuWwfqTmzT1r2zubUaVQ0HHLBnokBG+7w356dIWP6ZeNOe7jVHiNIdYPDzku/HVn
         dFN/WjR1BrcBYDwkvhaKyIMak60O/SwU5R4sQa5sdeSSLlRl9fVMUCzWQGgiM3HKx9W/
         M+XA==
X-Gm-Message-State: AGRZ1gK6IOmVbRbAV7x5jDTv+IVlFy4oQSOv4Y4OfQ6YI7A77EM/D2uj
        siXwenvQQo3thqnTfn1wk/PD7w==
X-Google-Smtp-Source: AJdET5e7YYTHvaklLJ2L/kqnABaRjmbidwRr0u2iPhIj7YfndZCbK/UPzhF915FUVnLDE99CFs4WEg==
X-Received: by 2002:adf:f501:: with SMTP id q1-v6mr423713wro.63.1542018720076;
        Mon, 12 Nov 2018 02:32:00 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id j203-v6sm14181516wmd.46.2018.11.12.02.31.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Nov 2018 02:31:59 -0800 (PST)
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
Message-ID: <f5fb82b7-30e3-83ed-db78-301868516bd2@broadcom.com>
Date:   Mon, 12 Nov 2018 11:31:58 +0100
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
>
> Command decode for below chips are disabled in this commit:
>  - 4339
>  - 4345
>  - 4354
>  - 4373

Already have my review tag so this is fine as is.

> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> Signed-off-by: Double Lo <double.lo@cypress.com>
> Signed-off-by: Madhan Mohan R <madhanmohan.r@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

