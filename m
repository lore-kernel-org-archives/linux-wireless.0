Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C74C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 09:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58C7E21872
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 09:50:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="d5SswaQi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbfCOJut (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 05:50:49 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:43646 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728782AbfCOJut (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 05:50:49 -0400
Received: by mail-yw1-f65.google.com with SMTP id j66so6741786ywc.10
        for <linux-wireless@vger.kernel.org>; Fri, 15 Mar 2019 02:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N2TmsKXbvDGU0X42ituryieWnNgh/sDH4QOuRfO6NR0=;
        b=d5SswaQi/ccEEQTezLipe2b1d2URO5vZOCV8pJJJsqT3bZtdYN/FRum9RFXp87a5Eh
         SK8iZYsqQ6G7UFz9M5ztwVeQZyLYb28LIekch3hRvgZjkppLtVL9dDIcBGHRFFXtlKjh
         uE/m9tl6XqOmGnxJOddeNYhfsfKT8o/702AI8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N2TmsKXbvDGU0X42ituryieWnNgh/sDH4QOuRfO6NR0=;
        b=cXabjvop2MNt2TwAd/kL1PtcqKf68Nifqxh0DTv4xqZCugdvcil0cV8erWUkZJgE3c
         uqfv58d2S7/EWZshRZucKfflTMnHeN7pPyvwoZsLC8NY3j5IADI3ZEjPYCnCBSNcy+CR
         u7ZHW2WJq8vKcYJN84TMh4WUyKvtrOiaju6IN0sybKVnAvQme6SM8ehiGAZ6HaAa2R+L
         xjZ8nqyIGSExy9006D/7Rsr773LvFjSsVRVJ4Re+xtbgGv7ydCu+Iit1U1yHTDsDPrIk
         tkhrICycL8bBhGu86rbWQN/ncPGG/Pr6fTOEHyYUS/yk3+Fp8wOpVxyM1MagsKIUqvq/
         QqRQ==
X-Gm-Message-State: APjAAAWD1HPrQXLK37LVjx4ek5czIKEh1hd2Sl05BR80whYcA9XAoL+5
        DRV/8Fai1d6eyp8nDv9HGPh8qTop7dcaLA==
X-Google-Smtp-Source: APXvYqxXTTLXkkGYTzAMZPXWcHhMTd6xiM1CdWUp/U2NElcRvn7Im1Lm0v3nHkG0CaAw9x2dbZ1Kng==
X-Received: by 2002:a0d:c5c3:: with SMTP id h186mr1946124ywd.462.1552643448591;
        Fri, 15 Mar 2019 02:50:48 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id 81sm652526ywr.21.2019.03.15.02.50.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Mar 2019 02:50:48 -0700 (PDT)
Subject: Re: [PATCH v2] net: brcm80211: fix missing checks for kmemdup
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190312043929.727-1-kjlu@umn.edu>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d712dd26-8b51-143a-b3ff-ad44f2774944@broadcom.com>
Date:   Fri, 15 Mar 2019 10:50:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190312043929.727-1-kjlu@umn.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 3/12/2019 5:39 AM, Kangjie Lu wrote:
> In case kmemdup fails, the fix sets conn_info->req_ie_len to zero
> to avoid buffer overflows.

Hi Kangjie,

See comment below. Also for v3 change prefix 'net:brcm80211:' to 
'brcmfmac:' instead.

> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index e92f6351bd22..5d9a3c35fef5 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -5464,6 +5464,8 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
>   		conn_info->req_ie =
>   		    kmemdup(cfg->extra_buf, conn_info->req_ie_len,
>   			    GFP_KERNEL);
> +		if (!conn_info->req_ie)
> +			conn_info->req_ie_len = 0;

good.

>   	} else {
>   		conn_info->req_ie_len = 0;
>   		conn_info->req_ie = NULL;
> @@ -5480,6 +5482,8 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
>   		conn_info->resp_ie =
>   		    kmemdup(cfg->extra_buf, conn_info->resp_ie_len,
>   			    GFP_KERNEL);
> +		if (!conn_info->resp_ie)
> +			conn_info->req_ie_len = 0;

bad! I think you took my comment too literal. Here it should set 
conn_info->resp_ie_len to zero.

Regards,
Arend

>   	} else {
>   		conn_info->resp_ie_len = 0;
>   		conn_info->resp_ie = NULL;
> 
