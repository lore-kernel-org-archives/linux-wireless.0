Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82AEBC43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 12:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D6BA205C9
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 12:00:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Seva5ojj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfAGMA2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 07:00:28 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:36512 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfAGMA2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 07:00:28 -0500
Received: by mail-yb1-f196.google.com with SMTP id a190so43770ybg.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2019 04:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PlJZudmsUZF5DkWiSL14bbRH+e5UqYkTkvb6q63bS+I=;
        b=Seva5ojjYWvg3x+kFMUQ+R1k9V9DfCrh5/j7fPA5DMB2W6LzDrUhme2M9SaXXQvl28
         NoJmynEqyPBeJ9t8nAI8n/1JCbknJMHFYatXViE9gj8VR7yOdpTRvTzx+7IH2dmn8JdG
         KGrGsoZI3gTZdpG0/pQCAQt79ctCItnWPmCTE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PlJZudmsUZF5DkWiSL14bbRH+e5UqYkTkvb6q63bS+I=;
        b=VQ+3ZOEecWk6VGvRDGf1Xoz5BeBD5zfW7E46I08Ae6rOjuXyS9YZdcXhwM1NujHCSY
         3WqKPi+3GxiHiC44FGncooqLfBSxvCPvdfdJ3rqWvGuddEiwr9ozdhb6ZgEOuuDexkHP
         agKGFFeaHGOZ62OX98xE65R4GLEQ7PxTvy4g0dOUoWSDcfhEiL4Ngx3M1lTMl1LzUZ98
         0ZXxGuPfXx0Ia/kbHcIlaA7LpQ3i75L8IUzZT96v9rydV2qukamXnY+/y8VPUoghF01i
         cD2dLiv7m+MZ/7Dgl6DuAiji5h8Hhiqzz3Ye70yCSfPhsiuLXzZ+zUCnvgW1gudH5v7V
         qoGA==
X-Gm-Message-State: AJcUukd/CyzLgxBGFcHIzeIFAsmU4LVVx2WK56fRhLUvEZY/Weqnq6Fo
        KxqryjO7ctb9x+Is2CQp+kEMiQ==
X-Google-Smtp-Source: ALg8bN6Utjvuv00680AvQmNKNTz3EsdT/CZB02jL9QDHtzqejTKmNJGqDzy/NcHUyrg4qTbToZJcXQ==
X-Received: by 2002:a25:b091:: with SMTP id f17mr50694392ybj.25.1546862426359;
        Mon, 07 Jan 2019 04:00:26 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id d3sm46937548ywc.103.2019.01.07.04.00.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Jan 2019 04:00:25 -0800 (PST)
Subject: Re: [PATCH 3/6] brcmfmac: send port authorized event for FT-802.1X
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanley Hsu <Stanley.Hsu@cypress.com>
References: <1546582221-143220-1-git-send-email-chi-hsien.lin@cypress.com>
 <1546582221-143220-3-git-send-email-chi-hsien.lin@cypress.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1f1544ca-7db1-eb6e-656c-c672fbdae521@broadcom.com>
Date:   Mon, 7 Jan 2019 13:00:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1546582221-143220-3-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/4/2019 7:11 AM, Chi-Hsien Lin wrote:
> From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> 
> With FT-802.1X, driver should send a port authorized event right after
> sending a roamed event. It is used to indicate that a new AP is already
> authorized so 802.1X is not required.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 8 ++++++++
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h | 1 +
>   2 files changed, 9 insertions(+)
