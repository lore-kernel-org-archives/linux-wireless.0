Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8138FC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 08:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 415D62084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 08:14:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cogentembedded-com.20150623.gappssmtp.com header.i=@cogentembedded-com.20150623.gappssmtp.com header.b="bY4lmZcg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 415D62084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cogentembedded.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbeJAOvW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 10:51:22 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41143 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728784AbeJAOvV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 10:51:21 -0400
Received: by mail-lj1-f193.google.com with SMTP id u21-v6so4193606lja.8
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 01:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qS0r9HVgqdKGty1MY0LULmO0HK3jFHwvnrkynDjoFgw=;
        b=bY4lmZcgdw9sdwVhEYhqVe2bFwCf4jeuiZ3jSxc1JUkHfBayiYWxjQP5FuX0CwFWzM
         yr6J4sS+n1ZGE7wnkfrAuiwN9aCIh+UVZEtNymGSqdJRwWvg6n+VPoQlrArue13u+P5J
         bhwWdwWZ3gkZmF0G5UwboiLEi3N6MQDEq/7b8pihsWBoop3SreKrdD5OenP6fmDpfBNp
         yW7Pslrhls2wbuHDE7wSLCG6GpRTXB+yCkj+x/L60+n/miZNN6brrem95ZaBuqv5zOoY
         xu4qdqlhM8cpi0ZYmG78t9D29xZqr0yyRqvZ9DR3PhDNFS5/s4RFL8/FHj+c4r5EqTq6
         RZ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qS0r9HVgqdKGty1MY0LULmO0HK3jFHwvnrkynDjoFgw=;
        b=T3s2AB9unsVvvSEHDrI1q102Pi9DC9bCV0k/5kgntlctJoaXvbDmLqnR7vs+e8frwh
         uxXpmkjJyMndxnPAq6R1sg/qsTeVXZz4/AUm8Rc07nkuuTN9RVA+/FIOgmg+NqqdsgaP
         xW5grDzOUTDEMUJqdfHVeO751KwpDP14bKyM1zY2d7SrJgN/D48hnM5iWssZfrbiyL+9
         QcvXwteoqdzv5A3rPSxokpm26bGg4q30fuWho6vnDrVJ99pFL0gl4DD/yTF0VXoGi3Q7
         7Lbr7uEu+VBVvJs+5vxywY9cqdZjPOMav6GTikYqWWKJ8Q3KXxy8uthxRcu29wuuDor5
         puww==
X-Gm-Message-State: ABuFfogyvTtb490b8x9Fai39NwpOIaPwL/ey+yvqmbIZvvIqlSy3M/J7
        MrJaCfo0ym9+qHRpVmxo9OZXSw==
X-Google-Smtp-Source: ACcGV63ojtXA8iJ3soyZYguo8x8Ja+iCX1XSEUrXAUwoX9xg8Il+1kI0MyhJax+CDg0wLN/N3nlOsw==
X-Received: by 2002:a2e:638d:: with SMTP id s13-v6mr5367467lje.117.1538381687613;
        Mon, 01 Oct 2018 01:14:47 -0700 (PDT)
Received: from [192.168.0.126] ([31.173.84.210])
        by smtp.gmail.com with ESMTPSA id s68-v6sm2028431lfg.17.2018.10.01.01.14.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Oct 2018 01:14:46 -0700 (PDT)
Subject: Re: [PATCH] ipw2x00: clean up clang warning on extraneous parentheses
To:     Colin King <colin.king@canonical.com>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180930223809.18136-1-colin.king@canonical.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <b7ab11aa-0ec5-0c29-9170-4e62f5ab4ac3@cogentembedded.com>
Date:   Mon, 1 Oct 2018 11:14:40 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20180930223809.18136-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello!

On 10/1/2018 1:38 AM, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There are extraneous parantheses that are causing clang to produce a

    Parentheses.

> warning so remove these.
> 
> Clean up clang warning:
> equality comparison with extraneous parentheses [-Wparentheses-equality]
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
[...]

MBR, Sergei

