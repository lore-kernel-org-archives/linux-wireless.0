Return-Path: <SRS0=iJrv=PA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43A8C43387
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Dec 2018 11:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D5EF2186A
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Dec 2018 11:28:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dpV48Kww"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbeLWL2f (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 23 Dec 2018 06:28:35 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34361 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728056AbeLWL2e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 23 Dec 2018 06:28:34 -0500
Received: by mail-pf1-f195.google.com with SMTP id h3so4707534pfg.1;
        Sun, 23 Dec 2018 03:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=VYvPueiAdcxuAusaaW1W8F6f7fk46Omdj3hQIsddVlc=;
        b=dpV48KwwR92pNrlAieFULJeI9hzEczvP+NLwJv42s7xjhNDiBHi7X0mNdoyoatlSBj
         UpffQiBC176OJ3q0pEAXePGwYCg/bhPJAqRc+0FUfZ4mBIhaXR+xXbXhmVkSBYKJsEzG
         O8N58KbTGcw1F7OJFR4GcxD4CXrHfaJLHlldFlPZ7XUSMYH6PrqKakIG1HcNEEgWTydV
         BtSI3y8r6usGzBfJmGN5C+XJo8/ccDLmhgCnbJDHHcN1m7XU9La3DAJX1L4znAbhgLP6
         IvMf6p5Fu4MhAfDurIbJYlhGakXuAMUAvuXBvzzcjBKlulVXLmGMLv1giOyrbi54LZ0j
         1b5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VYvPueiAdcxuAusaaW1W8F6f7fk46Omdj3hQIsddVlc=;
        b=AE4a5OjAs9GnxcaKi5yDkTwnPfB9j10YE/7vdyf4BKyqhVwUxbh+XgvUNl1zjSGv5K
         hi2qvRABDBRy6p0efpBUvmicvrLPHU8JBjqNKXwC7Vs2O5DV02fm76Gx1yajbyJhe9PO
         MLfwK4lJUO4YTMIn6etdNsB+RXkDhhUbL3DIo/ptJyq7ARNiPwpwtYVj9nWwuDDs5u8g
         F4p1mOh2d1pxuTCVgTWhscktIv7I9NWjj2ljjaoE8dhN/QVf22PnOjAE1I4JzNzKSl0n
         OvJSADUP+6nUr32usbi+8uspKH0H9U3S9E9mGc+YMCuvgv2ZdCXeWGq3XB5dgqlkpqzY
         j34g==
X-Gm-Message-State: AJcUukf0GM0qlZLRS127kzezCfu8+CDrO2oRG+F6kDZg4X7XqmzpckjY
        Mk6HFgeO1MgD99Ctv7WHzTn+0USx
X-Google-Smtp-Source: ALg8bN4CJ6Uftl8ewH3A0ZfSU1nLg3A2oSyb6QpnjDslDpri8rE9JZjNg5HYmEsW1rh40ey117m5nQ==
X-Received: by 2002:a63:2f07:: with SMTP id v7mr8363370pgv.368.1545564513633;
        Sun, 23 Dec 2018 03:28:33 -0800 (PST)
Received: from ?IPv6:2402:f000:1:1501:200:5efe:166.111.71.49? ([2402:f000:1:1501:200:5efe:a66f:4731])
        by smtp.gmail.com with ESMTPSA id v184sm40150738pfb.182.2018.12.23.03.28.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Dec 2018 03:28:32 -0800 (PST)
Subject: Re: [PATCH net-next] cw1200: fix missing unlock on error in
 cw1200_hw_scan()
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        Solomon Peachy <pizza@shaftnet.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1545474894-124328-1-git-send-email-weiyongjun1@huawei.com>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <1a97f5e6-aacd-f937-f222-793764c93564@gmail.com>
Date:   Sun, 23 Dec 2018 19:28:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1545474894-124328-1-git-send-email-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Oh, I forgot to handle the error case in my previous commit 4f68ef64cd7f...
Thanks for this patch :)

On 2018/12/22 18:34, Wei Yongjun wrote:
> Add the missing unlock before return from function cw1200_hw_scan()
> in the error handling case.
>
> Fixes: 4f68ef64cd7f ("cw1200: Fix concurrency use-after-free bugs in cw1200_hw_scan()")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>   drivers/net/wireless/st/cw1200/scan.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/st/cw1200/scan.c b/drivers/net/wireless/st/cw1200/scan.c
> index 0a9eac9..71e9b91 100644
> --- a/drivers/net/wireless/st/cw1200/scan.c
> +++ b/drivers/net/wireless/st/cw1200/scan.c
> @@ -84,8 +84,11 @@ int cw1200_hw_scan(struct ieee80211_hw *hw,
>   
>   	frame.skb = ieee80211_probereq_get(hw, priv->vif->addr, NULL, 0,
>   		req->ie_len);
> -	if (!frame.skb)
> +	if (!frame.skb) {
> +		mutex_unlock(&priv->conf_mutex);
> +		up(&priv->scan.lock);
>   		return -ENOMEM;
> +	}
>   
>   	if (req->ie_len)
>   		skb_put_data(frame.skb, req->ie, req->ie_len);
>
>
>

Acked-by: Jia-Ju Bai <baijiaju1990@gmail.com>
