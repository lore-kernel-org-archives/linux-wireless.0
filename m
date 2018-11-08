Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB9CCC32789
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0DE620892
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:55:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HlBq2tya"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0DE620892
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbeKHVaw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 16:30:52 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:39468 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbeKHVaw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 16:30:52 -0500
Received: by mail-yb1-f195.google.com with SMTP id w17-v6so717446ybl.6
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2018 03:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=M/cdOePnHmONzLtSclJZ0i0lO4llZMUksoCdnmrhwys=;
        b=HlBq2tyamf2Op5AaXDOeUjVK1ja7GtGlte35OOJ+biqETTHmeEpKWISKdpLygWUhBj
         526EWe3kMYm/OlLIMgB8WKIkx2S0TmG6+A9bztYlioQw7FDNWXf9I5r0FexQZsKKZZCs
         4iL/XhSXuVvZ45VqBVXhrcws1w4e6g28Mh1ag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=M/cdOePnHmONzLtSclJZ0i0lO4llZMUksoCdnmrhwys=;
        b=h4nWmN0Em9ygGp2AxJTMoOf9Dq80qvc6doL1F0SJGKBrzpO+zNkzxDdeHN8GInHNFH
         RNOeG8811Vb7eqrcD6AoidZKKF9ZD4iFEKr2FunrT0kgBS1FI5se+/96+O/2OSGLayd0
         ph13J/yPwAY3mrxHBrlQ8cYiQMcx61l0vFjT/valh5lt4YsH6qP/wd4NCflyPabbkSC/
         sHsHoxp8CCDBcwMGk2wB1JjY/w8Ir3/yUAeVk834UmRZX9cv4qmH0qAEYuWmhEgRZ7Lo
         M2AlCm0ax7bdGRDRUDGhfwy1AjtNrkRJLmij/sALAsqly34u1iDLAhCFYldt/8hw8Uu7
         h4ow==
X-Gm-Message-State: AGRZ1gJvCp3mlPWaj23Yz+qf7xHxGhr9od5plegD2GYDzK/RbC6Z9ER6
        DHXOG9pwX3wLieFKyis2qNyXfA==
X-Google-Smtp-Source: AJdET5df9vQy3ZCB72xxgAVTQix4cceEq2U01CT++NaJN0iqjUQdIvS/xI9sbDBHgVwhxA91nvvtxA==
X-Received: by 2002:a25:8311:: with SMTP id s17-v6mr4094656ybk.142.1541678142521;
        Thu, 08 Nov 2018 03:55:42 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id z136-v6sm989067ywz.2.2018.11.08.03.55.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 03:55:42 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 10/11] brcmfmac: disable command decode in sdio_aos for
 4354
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541476188-75475-11-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Double Lo <Double.Lo@cypress.com>
Message-ID: <4c061b39-641f-2232-2a36-5fc27a01eef4@broadcom.com>
Date:   Thu, 8 Nov 2018 12:55:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1541476188-75475-11-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/6/2018 4:50 AM, Chi-Hsien Lin wrote:
> From: Double Lo <double.lo@cypress.com>
>
> Transaction between AOS and SDIOD is not protected, and if cmd 52
> received in AOS and in the middle of response state changed from AOS to
> SDIOD, response is corrupted and it causes to SDIO Host controller to
> hang.

See comment in PATCH 09/11

> Signed-off-by: Double Lo <double.lo@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

