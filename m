Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80205C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 19:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5134920859
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 19:34:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Og5XyYXJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728832AbfAQTd5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 14:33:57 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44221 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfAQTd5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 14:33:57 -0500
Received: by mail-ot1-f67.google.com with SMTP id f18so12174949otl.11;
        Thu, 17 Jan 2019 11:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tiMK4byqwhsiWqiYm01TCI6vfQdsfTjZo9dRLYEIraU=;
        b=Og5XyYXJzVza1lKycEzMSszRaioM1/d+THTHunNJGR4q51a9L4p12gH7vTbWDnBtG7
         xGVCN0/2ynn75VPOHOHpYhg8TFcRYL0Zgo2jU60tPZfXB6uOeHyKCf0KTrn+MEUuFuFA
         Y6MxRKQ3HI8xI5J76z3F/xzNq431VaFm1pRf0X8KZblzceYCq5nNdz79h/mFVR30ZfAe
         lwkjOJqW3ZQOJO9+1ycBfqS5wyaC/iu6o2ZgFV+grociut8xGM2OXvX9geKUz66bCmyG
         n+aYCe8GU3AkUm6R+azJXgJk+CwlxuPH3sH9cIBm2pKOkiXXx5cI92AJyyysj1JfRUIY
         HrGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tiMK4byqwhsiWqiYm01TCI6vfQdsfTjZo9dRLYEIraU=;
        b=Nb1dq70+ItVFMhBxU7qKQ4j2RPLwmSg7/VWMTPlFjQBEWAr+dH7MpkVhqqnUCiA2Cy
         OZgsrXPI8fFLatBZS8QOKBoAOtfZdeb5AFs1Pt4bIme4QwJ5+J3Kg7EHlchSp6HXPxVR
         Sv9OAImVWCcHnE17+25x3wES5xktBkN5glMu8wTzwGh+R1FMR+68ol9LxYlkWwxX0ZbZ
         Sctwupx3BTyWcq5gy6QhmYNwuYV4j4SpXiYPCF6P+nSR2iWfPHgBuOorhysmZkHDdWFc
         pyWu4AZ7Ckutcwl6I6LnhbW3IRbKXpm9WWqgqxnwUY13rUdcPXdTatweEBM0nUCuj/Cf
         xaRA==
X-Gm-Message-State: AJcUukelKN1LhG9ctIjjJsoUQmcLY5Deq121CFzJAt7oB6qkMQDqXFdL
        JwrX6y7VNXZkPl71expO7wI=
X-Google-Smtp-Source: ALg8bN72s1EcYKvP6X1vzO5QTGIZC2HksL5fyB2RujTI7DpNpi6h6ynsE7MaSbdXUUcwS187xO3k0A==
X-Received: by 2002:a9d:6a50:: with SMTP id h16mr9082498otn.95.1547753635943;
        Thu, 17 Jan 2019 11:33:55 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id h25sm1064235otj.27.2019.01.17.11.33.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 11:33:55 -0800 (PST)
Subject: Re: [PATCH] rtlwifi: rtl818x: fix indentation issue
To:     Joe Perches <joe@perches.com>,
        Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>
References: <20190117152859.6873-1-colin.king@canonical.com>
 <e68c7ae7b0a863742df0f4457368a3a529ed47e5.camel@perches.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <284e7ef0-5820-021b-7b0c-2fc754440fe8@lwfinger.net>
Date:   Thu, 17 Jan 2019 13:33:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <e68c7ae7b0a863742df0f4457368a3a529ed47e5.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/17/19 1:29 PM, Joe Perches wrote:
> On Thu, 2019-01-17 at 15:28 +0000, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> There is a statement that is indented too deeply. Fix this.
> 
> Thanks.
> 
>> diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
> []
>> @@ -803,7 +803,7 @@ static void rtl8180_config_cardbus(struct ieee80211_hw *dev)
>>   		rtl818x_iowrite16(priv, FEMR_SE, 0xffff);
>>   	} else {
>>   		reg16 = rtl818x_ioread16(priv, &priv->map->FEMR);
>> -			reg16 |= (1 << 15) | (1 << 14) | (1 << 4);
>> +		reg16 |= (1 << 15) | (1 << 14) | (1 << 4);
>>   		rtl818x_iowrite16(priv, &priv->map->FEMR, reg16);
>>   	}
> 
> trivia:
> 
> It sure looks as if there could be some rather useful
> conversions of magic bits to constants one day.

How much work is warranted for this driver for a device that is not likely in 
use anywhere in the wild? In addition, I'm not sure anyone knows what those bits 
actually do, I certainly do not have a product sheet for that one.

Larry

