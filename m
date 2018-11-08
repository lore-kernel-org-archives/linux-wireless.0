Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F8DC32789
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E61BB20892
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:53:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CQojMrLp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E61BB20892
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbeKHV2x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 16:28:53 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:36174 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbeKHV2w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 16:28:52 -0500
Received: by mail-yw1-f66.google.com with SMTP id h21-v6so7883724ywa.3
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2018 03:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=5rPUdQ2J4oMfSMPdbWNrjOIPG9gBvZkJx1XCdS+4jyQ=;
        b=CQojMrLpB16KfGnDzhhCoKOsPRVdUM1Vgk9484N1H35H7/PS4s1QrnrZWgNDqjCwwF
         LmZjsIafceEyP6yCIdMNGIDIHGmkKpyyxdEfAHiUhh9ZPjBAuUr7xYBEURhcBVC49+q/
         s5B88DenXvuJww9En+fmER0S+TDe7WyMuSBZ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=5rPUdQ2J4oMfSMPdbWNrjOIPG9gBvZkJx1XCdS+4jyQ=;
        b=RTHGf9OhLJ9GwNJ1cORids80rtVoKPLy1m8UJyUYxxq8tAzO4rLJiUFl+XHKpVLeWl
         sISbqHjyMp5o5YjkFB1gzOr4Otp3EK8dKMhxy+3GiCF00O+gvrctoC4euGBBzNTKUT3N
         8oBWcOfT5jjGrSNOoNg15vbqnWY+Q3vYS/Ekh5JYvjlGMBsIQqZv9GclSD2UzzWbx691
         NmBHLtd7iPOS+OD4MuSfvmnWLwOpMqWXIAzACIdwZ/BBHYeL0vuPJTYIg/28K/r4vlVr
         uGa6BkC5gnl7ugSnkNOrI3jFAaR2y7Q1YJFu35/Yf0ketTkCfrpr040jMOU95d64b0Eo
         cq7g==
X-Gm-Message-State: AGRZ1gJczugwj3xsnhj0T0wAGsfDz3fVUi3koDNafOmK5A0OLiGJmzfo
        UjD3Jz6XjtitXUUZXq/ZbTnAzg==
X-Google-Smtp-Source: AJdET5eIvZsnUOrMNEOyA3pOaY0VwIOSdBzdyVqiKfSFFJkSJAZFNL2iicvEqI4Q7FAuUtlZk/LLjQ==
X-Received: by 2002:a81:6305:: with SMTP id x5-v6mr3808210ywb.269.1541678023957;
        Thu, 08 Nov 2018 03:53:43 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id d7-v6sm939878ywd.54.2018.11.08.03.53.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 03:53:43 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 05/11] brcmfmac: allow GCI core enumuration
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541476188-75475-6-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Message-ID: <6215f080-0ff6-65aa-0a07-072c13677d61@broadcom.com>
Date:   Thu, 8 Nov 2018 12:53:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1541476188-75475-6-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/6/2018 4:50 AM, Chi-Hsien Lin wrote:
> GCI core is needed for ULP operation. Allow GCI core enumuration with
> below changes:
>  - Allow GCI to be added to core list even when it doesn't have a wrapper.
>  - Allow 8K address space size.
>  - Don't overwrite the address value when an additional size descriptor
>    is in place.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)

