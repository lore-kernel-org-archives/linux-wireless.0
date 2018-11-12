Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E3BAC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12DCB22360
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:12:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="EYo6jCtd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 12DCB22360
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbeKLUFG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 15:05:06 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:42226 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbeKLUFG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 15:05:06 -0500
Received: by mail-yw1-f66.google.com with SMTP id l2-v6so4124504ywb.9
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2018 02:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=97PXiZ5ag1wYgIrspXHV32uj0dDT/7jWkNiazthSg/g=;
        b=EYo6jCtdfwIYRT/9nmhRJRFnqaKs3cm4OfNyp8T/9qLUctdGN8RNaaMhfgu12nCrZg
         zTOKIwZOnCdNtJomajnN7eTBv8jeX9Vk0UgUHs3XyoY7JBBdEJCgdZRbNMQb+t92trWB
         xuFx6trBhZDPDSH//j4evKm1VLac2XpSmz5ts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=97PXiZ5ag1wYgIrspXHV32uj0dDT/7jWkNiazthSg/g=;
        b=MQJT7ZtuuFRq4hdWj1bDSyZwym6hs6QZYp1AXq3SWbZbAWb06VfNay3xOgqWBFuXJ0
         YcIYfRiW7ifbqGnw8F75FrBTfsLCeJwyWyfz4mztc8xXXKuAtck4zuHUN6ki5oYdxKa3
         bn7s1rVdUoXpyJRkzBasFmb/1yyjyNn+faD/M8R4Je93qoNROCFJ2/CK7qb97w7GmWJL
         wtLSUOVOAiGbSONsE80N4D2mxrreN6h49AI4dEUn3jGhXp6t14jwWtanobSZIN1BC+Yk
         8JDnj5WDk8TjSFfN/qDfG/0O4hC3Ikm5O3nmDKuOTeldSwVhoSCi1KmGKsqc985j1LU4
         xVeg==
X-Gm-Message-State: AGRZ1gJRTnm7+aW7OwCZOkhT9vYiiHOa+lvCkNYRy9eewPXM+8j8hfbw
        nwVQ3V07dP5EzSAifsF+3WfUv1DJqo51PA==
X-Google-Smtp-Source: AJdET5fmxfdnNuYZsgtIcU96NQGRrMkpzwTAEDH2Wui35ZY8Kq75Rv7o89uPCAt4UJlnH3mX+aku4g==
X-Received: by 2002:a0d:ea8b:: with SMTP id t133-v6mr199184ywe.341.1542017553775;
        Mon, 12 Nov 2018 02:12:33 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id p195-v6sm4568356ywe.83.2018.11.12.02.12.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Nov 2018 02:12:33 -0800 (PST)
Subject: Re: [PATCH V2 2/8] brcmfmac: set F2 watermark to 256 for 4373
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
 <1542007730-47284-3-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <21c7854c-556b-faa1-50a2-aa7353f063a2@broadcom.com>
Date:   Mon, 12 Nov 2018 11:12:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1542007730-47284-3-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/12/2018 8:29 AM, Chi-Hsien Lin wrote:
> From: Wright Feng <wright.feng@cypress.com>
>
> We got SDIO_CRC_ERROR with 4373 on SDR104 when doing bi-directional
> throughput test. Enable watermark to 256 to guarantee the operation
> stability.

Please see my comment on patch 6/8 regarding introducing queuing latency 
with this change.

Regards,
Arend

> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 26 ++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)

