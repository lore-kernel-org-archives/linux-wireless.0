Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A46C6C0044C
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D08420840
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:49:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ZNAEhtl/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D08420840
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbeKIW3r (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 17:29:47 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43229 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727667AbeKIW3r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 17:29:47 -0500
Received: by mail-wr1-f68.google.com with SMTP id y3-v6so1759607wrh.10
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 04:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=fEI/qhiXh1N4hrwSyCwB9KEOiwAc56NuglC7/P0ldQg=;
        b=ZNAEhtl/mUFzm6Ts213tr+2nyO0SS9GQXO8/AVh4OnTKJcD6ZWUl+t5r2bawVzWmXA
         U9sZvUFFwbTLgz+CdSjL9V+vQh7B9Q6bXXCPtWlvvglXLiUklbha7pTh2FvnKwbIVdiB
         BnvjyHTTCLn/bV73UAXFJpS1/qc1zZdasmeT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=fEI/qhiXh1N4hrwSyCwB9KEOiwAc56NuglC7/P0ldQg=;
        b=lUoOAPEdkox4ilYfB4XrNBEq4WF5dUN2ymiJiqpZSjJUm3RmtVt3KuRE/G0Ds32XlL
         TI06NDCSrx2ddnMEdFHiQJJmipk5KQkKNT2ik6HwtmO9gEtbp545bWCwEBZ0vahlcjsF
         rdXntLvhtFzERL7Q5qa4kXHz5lDLipxeraIf7ujpFRfFQSRigUMuIcG/IUHiTWhiRn30
         YmUoAbVXITviZiDzL5qpkeU3LDsdWTKe1qFwn36cY5pQYgvZ6p/vU7GxNnwiXOylj4vG
         cOfJohfZBfnepBhZ/5q0NS9CA6+qdNiekE583V3VLZy6VCgi0lhYiPjd7QG+FRmB0PN1
         Mnxw==
X-Gm-Message-State: AGRZ1gIiVGwJdyVhYzLJ2duO3OmDcnkdgM4Ax/D/bw7xXjTuy7gMKFrg
        K5VnI10CqK5VK486loN6tulyZA==
X-Google-Smtp-Source: AJdET5fNH/sXMuTl1LAESPy6rP/di8iTMpaQsH9zSr1qb3vQkcVjJnM6RUvXRw/gjCCMFogd/qqtng==
X-Received: by 2002:a5d:5111:: with SMTP id s17-v6mr7972493wrt.162.1541767757890;
        Fri, 09 Nov 2018 04:49:17 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id z8sm7109069wrw.78.2018.11.09.04.49.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Nov 2018 04:49:17 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 4/5] brcmfmac: only generate random p2p address when
 needed
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1541648845-194984-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541648845-194984-5-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Hans de Goede <hdegoede@redhat.com>
Message-ID: <b3baaaec-d7ae-fead-f83c-2ed529f41830@broadcom.com>
Date:   Fri, 9 Nov 2018 13:49:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1541648845-194984-5-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ Hans

On 11/8/2018 4:48 AM, Chi-Hsien Lin wrote:
> P2p spec mentioned that the p2p device address should be the globally
> administered address with locally administered bit set. Therefore,
> follow this guideline by default.
>
> When the primary interface is set to a locally administered address, the
> locally administered bit cannot be set again. Generate a random locally
> administered address for this case.

We discussed this on the linux-wireless list a while ago. I have no 
problem with the approach in this patch.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)

