Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7BB1C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62D802081C
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:48:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Tw8eZKbu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62D802081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbeKIW3O (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 17:29:14 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44463 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727667AbeKIW3O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 17:29:14 -0500
Received: by mail-wr1-f68.google.com with SMTP id j17-v6so1747710wrq.11
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 04:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=HjA2W7gAb7MJRA5VqfprkYfLAvDId+LbS4wEVTjMKyA=;
        b=Tw8eZKbuQGTOUE5BnsmAKi8AN+U8Mi7u/TD+K01HvBQEWyQgbEwkOvA0MHh8U5H+29
         dEgs0GQab9GAGG2YDP2kTKgQgTZuHkEt0m/hUes8HW2ZYlZEmbCOlU52cIpcYj4UvVkO
         4oH7W0OzXUOvoX7qNtz0toKrEoDfUG714F+Ag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=HjA2W7gAb7MJRA5VqfprkYfLAvDId+LbS4wEVTjMKyA=;
        b=P6oCmRhT8ezQXOL/BaaVMTgYkM7cZrSO3eas6uFviDOVEygc1HUcxcd+w5ybGsocmK
         JGWIB4eK3AOnezHK4WyKJLDewXrwEqTe0YBl7jYXMa+1dgoT8I32x2y0r7EgSyu4toDU
         PqctzDBVdhEBk7Qx5OUqBRn07XdcEX4d44hBBRhvLd7AmENtbzr3EAt0Vr3PJhl0Ql2b
         ZzR03HuB/OfHQnKkOGYNDjnEvybNvJAZa+yOLxpF30xTsMofCQ78s8ciUbNF7YAgtKv+
         6wj/mgZY7cj6gG4l2ioVDxfpPaJZjBNDhahk0TrgOnqPBdZvOspUlQDECR5nFHCJyHsH
         1GqQ==
X-Gm-Message-State: AGRZ1gIIaS43ok7uxf3ru/WDnAA4iw6YAvMA/XJf8VTs6OnjmA7ly8aU
        WYhhLwww4GHWCzk8XVNjk9/1kA==
X-Google-Smtp-Source: AJdET5cCKeK2xkuFrNFdQcCO5ry5iB7VTHIyjaT/kiM9kmKGHFc1Q6GvPyjX0w9QYjR8YTanKiNRWA==
X-Received: by 2002:a5d:4907:: with SMTP id x7-v6mr7879581wrq.272.1541767723850;
        Fri, 09 Nov 2018 04:48:43 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id 81-v6sm1093313wmh.30.2018.11.09.04.48.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Nov 2018 04:48:43 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 1/5] brcmfmac: set apsta to 1 when AP start on primary
 interface.
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1541648845-194984-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541648845-194984-2-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Message-ID: <fa3b98cf-666c-2919-2484-9d496e926a5b@broadcom.com>
Date:   Fri, 9 Nov 2018 13:48:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1541648845-194984-2-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/8/2018 4:48 AM, Chi-Hsien Lin wrote:
> From: Wright Feng <wright.feng@cypress.com>
>
> APSTA can work on two band concurrently with using VSDB(Virtual
> Simultaneous Dual-Band) or RSDB(Real Simultaneous Dual-Band) features.
> In this case, we have to keep apsta is 1 in firmware side. However, if
> we start wpa_supplicant on wlan0 and then start hostapd on wlan 1, the
> apsta will be set to 0, and we will see data stall on wlan0(station)
> So that, we only set apsta to 1 when AP start on primary interface.

The description makes my head spin. From reading the commit message I 
think the code should add a !VSDB check instead of dropping the !RSDB 
check. Would you agree?

Regards,
Arend

> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

