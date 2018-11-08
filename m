Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 478C9C32789
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D69520817
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:53:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="N7LQjgJp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D69520817
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbeKHV2G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 16:28:06 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:36129 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbeKHV2G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 16:28:06 -0500
Received: by mail-yw1-f65.google.com with SMTP id h21-v6so7883065ywa.3
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2018 03:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=zNxkDWrNOyzhoyFSJScMrboSpwuPofq5ZVxPKZnxe8M=;
        b=N7LQjgJp6uqrc0prmMzIJ/CXqxFKfJy9CLs6qTsbdPOnqiwjmOj/Zq+I+14otKaWPc
         E/iT5FoEWamhHt8mvg3KXYADtyyKNm7FetXBEeVQ9owg9zgb8z1Wzp+ob/pRvLVkRm8Z
         NSQ5Uqapsp2llGQsRXWVF4PgEupqoZQd05Gms=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=zNxkDWrNOyzhoyFSJScMrboSpwuPofq5ZVxPKZnxe8M=;
        b=oETdfn1cXolbzL42kr1UeRmf+VlNS7E3DUqpvDOtHAMDo9Q/TUZvZGy1cGmTVkzQHE
         C8zuN8bIkLC713BsAGhgEhksuWvxpJPkX9gYF0fcRCe/NTV2Rv0NSbha/KWtiJ+fa5cG
         XWnZiDvpcvY0bzNejmJUTS4jHbPpwitX7OLoiL+tq3PKznTggbsJb2HSdMpP8OQoCgh2
         uAihjjbg3RXa4PFy0cjkuUhurLPbDVtjXiMAS+8yl1JgrdVBv/7AxhwM3V2MjybKi7F+
         agh1riLQSQnIj7tLQtc9mXKG6qlLzuLdhfWPpiogmT/sL2ytPVWgGhWlu6wFARsURWzy
         n91g==
X-Gm-Message-State: AGRZ1gJu3ahui8pNjcdbvQEoMaPfgrE13IF8jidUeVCz0kDQj0j30dTl
        yaYod3yHXFZGb9ccjwYaBgeWDA==
X-Google-Smtp-Source: AJdET5e5agoRyipWg5IpGtxy0yUyA3E5Gk1faL10yTEW0v7nlNVxWj9+mDYTtcfMU8l+Q8GMClSoLA==
X-Received: by 2002:a0d:c802:: with SMTP id k2-v6mr3867675ywd.135.1541677977761;
        Thu, 08 Nov 2018 03:52:57 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id s187-v6sm1016258ywe.10.2018.11.08.03.52.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 03:52:57 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 01/11] brcmfmac: add 4354 raw pcie device id
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541476188-75475-2-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Winnie Chang <Winnie.Chang@cypress.com>
Message-ID: <70c45413-af4d-db3b-2e40-294729f347fa@broadcom.com>
Date:   Thu, 8 Nov 2018 12:52:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1541476188-75475-2-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/6/2018 4:50 AM, Chi-Hsien Lin wrote:
> From: Winnie Chang <winnie.chang@cypress.com>
>
> Add the raw 4354 PCIe device ID.

What is the motivation for adding this. I can do an educated guess, but 
I would like to see it in the commit message. Why only for 4354?

Regards,
Arend

> Signed-off-by: Winnie Chang <winnie.chang@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c       | 1 +
>  drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 1 +
>  2 files changed, 2 insertions(+)

