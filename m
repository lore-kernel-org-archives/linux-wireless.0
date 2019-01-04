Return-Path: <SRS0=K5U7=PM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEDD3C43387
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 10:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5EDF20874
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 10:51:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GIHe3Y/a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfADKvY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Jan 2019 05:51:24 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:44630 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfADKvY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Jan 2019 05:51:24 -0500
Received: by mail-yw1-f66.google.com with SMTP id b63so13066016ywc.11
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jan 2019 02:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Iczrm3gtgIK0YwPfN9gz/VeazULhZZIKONXmQuD1D6s=;
        b=GIHe3Y/al8/8U0B5ug68g1/BFeP39xFRc+w6cmtk6DBqXYLV8SKgW4ojsWwJ2/2Ywb
         Rrz6h4y92A1YWJ7QLxqIIx6sLjULH30ZTVmw9ZTyYJpRvRaTtL8yRI9tvFvjd3d1pGGS
         CoplNiD4eP3WNFgcv4E9+KV/kU7KXHciZgq4o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Iczrm3gtgIK0YwPfN9gz/VeazULhZZIKONXmQuD1D6s=;
        b=CbgW888h+cUzEzfBfQIBMXIqO5goLBYh+hDSJAyaUGGxWW8blLptntk45xi9ZqLyug
         GtfBOQTv+AVA+xKplqzX2xW9/GTdf85HPCVYlBDZ4koBecU9Iw/JrT9QKKAkIYDI425P
         2BhK1nleTP+QHghSGb6L+rZMJYpslmSbrWABrT+3HFKifZjwL+pSsP5ci52UtGBCMVx5
         rP2VAGS+0bw7CbeCMW2H3Xd+00+9zPnoH4PuaB6QV9dOkp8jY6aK/oXoa4GwaPRhzvmC
         zt7E7QA5jxQHDgAfofpBGCXx3EMyxZW7H9K+LAAqEFCCEyDl400DLGqoqKcP3rHf6yft
         bv9Q==
X-Gm-Message-State: AA+aEWZWT65TY5JlgkJdQp+gjSGLPgS0DaauFMxRy1ba92mgApS2aesO
        aP4u+IDrNgw+urQ3pJxkaARs8w==
X-Google-Smtp-Source: AFSGD/V6EWZFcNd+eA7cnXEboi7p0a9ZB0kGzrN4j9c+S6xrUxtoirgINoUKCeI46f4kXIMzV1JLXQ==
X-Received: by 2002:a81:9244:: with SMTP id j65mr51556292ywg.36.1546599082925;
        Fri, 04 Jan 2019 02:51:22 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id h145sm22570578ywc.72.2019.01.04.02.51.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Jan 2019 02:51:22 -0800 (PST)
Subject: Re: [PATCH 1/6] nl80211: add NL80211_ATTR_IFINDEX to port authorized
 event
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
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c8927d9e-09fc-e707-35b3-33a71966b29d@broadcom.com>
Date:   Fri, 4 Jan 2019 11:51:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <1546582221-143220-1-git-send-email-chi-hsien.lin@cypress.com>
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
> Add NL80211_ATTR_IFINDEX attribute to port authorized event to indicate
> the operating interface of the device.
> 
> Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>   net/wireless/nl80211.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 5e49492d5911..594aeba2982a 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -14727,7 +14727,8 @@ void nl80211_send_port_authorized(struct cfg80211_registered_device *rdev,
>   		return;
>   	}
>   
> -	if (nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, bssid))
> +	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
> +	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, bssid))
>   		goto nla_put_failure;

Maybe also put NL80211_ATTR_WIPHY in the notification to be consistent 
with the other MLME notifications.

Regards,
Arend
