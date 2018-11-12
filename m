Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E67A4C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAA0D216FD
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:11:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BYRj3AUp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAA0D216FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbeKLUD6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 15:03:58 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:39234 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbeKLUD5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 15:03:57 -0500
Received: by mail-yw1-f67.google.com with SMTP id v8-v6so4146267ywh.6
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2018 02:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=PB/cW4vkoz9SDingwjk7uAvXA79EOPQax1XKhHWoidg=;
        b=BYRj3AUpxeI7k/2TjM6rjecU/YsoKJQHIKbi3hnzwUm8rUUchIH9OIhinmI6qWLDYo
         /1StTXBkUFU5uDSCyqkhjuOsCF8MpvSUCEPgVXSYGLIJ46I/6SC95RhHJk9vxdAwPV6H
         1XxhIE88SMZilbyc3T0dgjY9vLtQ+yqp/leyI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=PB/cW4vkoz9SDingwjk7uAvXA79EOPQax1XKhHWoidg=;
        b=uMHcXIt4NiQerUb2YTaYqdAgulz3a0yQdKoDSY3fj4OEDVgYT3txlmw/mpsQYeUwpa
         OQRZmXWNMy8LbN8BCqiVKO4pjxqkVBdUgdOddPjkg66EqJjCpHd1fL1ohX2P6JEL6wUT
         BRzhUjRwSAbGObFeJwKM0ADVeiXFN0KhqZdW36odR+g95oTYHWRz9wnMcj8oK1OK4RRP
         rw8Hxw81EYe/mJ9LNAWOK/LQpdKOBx9Bo51YLMPMPCtY0vGh2CrkCO+z5HlwKGAT0q9m
         QgJuQ8q1xupmrqKfFQG7DXcnvBaj21Tf7M6O4QulzLH4uoHLE7/0uU1OLwFTPHDxwE6e
         j9BQ==
X-Gm-Message-State: AGRZ1gK/oVnQd4mLNOMtz9k/GQ5yLYpZADDPUVDBkXbWzAMBU/eLjlFd
        +rgCIpwbOHLT2F7LDdLv54lc6w==
X-Google-Smtp-Source: AJdET5ckHy1qiu6iYqZ/gdjvWvWQaBouOarw/iucVEiGaJy++pJoj27/bbbcC6RAepDigihdaVT6Kw==
X-Received: by 2002:a81:1fd4:: with SMTP id f203-v6mr218308ywf.332.1542017485700;
        Mon, 12 Nov 2018 02:11:25 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id u130-v6sm4376657ywa.71.2018.11.12.02.11.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Nov 2018 02:11:25 -0800 (PST)
Subject: Re: [PATCH V2 1/8] brcmfmac: add 4354 raw pcie device id
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
 <1542007730-47284-2-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Winnie Chang <Winnie.Chang@cypress.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c58d0d6d-afe4-3e58-6503-2f5aa2ffdcf4@broadcom.com>
Date:   Mon, 12 Nov 2018 11:11:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1542007730-47284-2-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/12/2018 8:29 AM, Chi-Hsien Lin wrote:
> From: Winnie Chang <winnie.chang@cypress.com>
>
> Add the raw 4354 PCIe device ID for unprogrammed Cypress boards.

Already have my review tag so this is fine as is.

> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Signed-off-by: Winnie Chang <winnie.chang@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c       | 1 +
>  drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 1 +
>  2 files changed, 2 insertions(+)

