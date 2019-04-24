Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE2BC10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 05:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 397B9218D2
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 05:24:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="adOy2B/r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbfDXFYU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 01:24:20 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43766 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728726AbfDXFYU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 01:24:20 -0400
Received: by mail-ed1-f65.google.com with SMTP id j20so14699940edq.10
        for <linux-wireless@vger.kernel.org>; Tue, 23 Apr 2019 22:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:date:message-id:in-reply-to:references:user-agent
         :subject:mime-version:content-transfer-encoding;
        bh=834H7PTpvae6jQORG9wci8C+iaPLk2Q03DDsRBQDqog=;
        b=adOy2B/rsRVD4LCnsq6ZAaomA/gnPgDJwLen3xU4U4vmOLFqRbAlggEnzzDR07SbKu
         I4cBvOM9ZByS6tkZkAcVTRnh9FMKi5CRWB+09+8GOS+a8jFAsmuDb4H/ytsbe1GJBzOq
         fJImMrjFW94AVvDMHTc8D6Icn7vimkWM6O9mg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:subject:mime-version
         :content-transfer-encoding;
        bh=834H7PTpvae6jQORG9wci8C+iaPLk2Q03DDsRBQDqog=;
        b=jyVV7PCZijsuXLBN9LbsNN6GAYZXbE10YZHAiXFF9Fzy8wqbjQXtLd40o/abz7NMvx
         Ao5Ew2W61Z3nu67jeVbt2TGu41nx/gmkSrX/pTlZolKzrfoeWka3HVqh7OF+SMH14ceW
         QoGg36zn0ejLQqxQiUyE+7M2nMgcPSu1q9fJVbEo+u4aw6D0ST61EA8czO2r5IUnjICv
         MNwNhHfUDkppvh9d5qgvaEmqSFUa5NP9IV01Ck15w2sH9MTqdVzWS6Uod2SzVKBPgGb0
         tPqfcChFOSI/O2PUICOdb6lAgK73c3NkEnsPKZHIupafagxEs6+0atxex38R1hTZ8JKz
         l75Q==
X-Gm-Message-State: APjAAAVl9F4LzhuFw9X9pDxrkXIZxkOJSaTqETY0RdgFY12AtHy3gvlq
        l/5PbqMFsKFceVhRA1AUvTNNWA==
X-Google-Smtp-Source: APXvYqxVQiSNHeBb9B5KM0hMzWHGN1+a7/zlUutpcvbFKfMopNDfxPxFDmYrkggEyFh9fKAGuCpkbA==
X-Received: by 2002:aa7:c38c:: with SMTP id k12mr19314487edq.33.1556083458373;
        Tue, 23 Apr 2019 22:24:18 -0700 (PDT)
Received: from [192.168.178.17] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id i12sm1544595ejc.27.2019.04.23.22.24.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 23 Apr 2019 22:24:17 -0700 (PDT)
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     Wright Feng <Wright.Feng@cypress.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <kvalo@codeaurora.org>,
        "Chi-Hsien Lin" <Chi-Hsien.Lin@cypress.com>
CC:     <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>
Date:   Wed, 24 Apr 2019 07:24:15 +0200
Message-ID: <16a4dcd3418.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <1555901236-145920-1-git-send-email-wright.feng@cypress.com>
References: <1555901236-145920-1-git-send-email-wright.feng@cypress.com>
User-Agent: AquaMail/1.20.0-1447 (build: 102000000)
Subject: Re: [PATCH] brcmfmac: remove the duplicate line of sending mail box interrupt
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On April 22, 2019 4:47:31 AM Wright Feng <Wright.Feng@cypress.com> wrote:

> The line is duplicate so remove it from pcie.c. We don't need to send
> host to dongle mail box interrupt twice after writing data.

Hi Wright,

Thanks for the patch. I am a bit early as it is not uncommon that hardware 
requires an extra kick. Might be the case here for some chips. Will 
follow-up on it.

Regards,
Arend

> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 1 -
>  1 file changed, 1 deletion(-)


