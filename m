Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9438C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 15:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B200820868
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 15:10:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T2DFgB/u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B200820868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbeK3CPm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 21:15:42 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:32813 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729040AbeK3CPl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 21:15:41 -0500
Received: by mail-ot1-f68.google.com with SMTP id i20so2059224otl.0;
        Thu, 29 Nov 2018 07:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=njDPO7eRcKSKwnJmQxEb1ParYuJ6CzGy5clgzweirns=;
        b=T2DFgB/u8vSQS25IznOOS02AiKOYCrs6xwGpEE7yfDY/etx21pK+hYPGZ/q3kwS/pt
         kJfCbXrnCu53i9l1BStKi02HmcnPhQDVJNc9Dh0SY4XwiJUmR8QpqIxEkB4tKX2CqwU4
         b6oDUx/WOVNv6YbYPQa1RB1fKDKGuJWWbP5oc5kiHYJD9wyG4s1UUwexqWX3Hzfg0F+d
         sm1Q4fYfcCpONuQ8o/U+A7754mQYWLWF8QL3/ZDHBkaPN4KBPUvBkUqS/gNHMiqh0UBE
         zP9CvjtDZ2lR3zF1GXOpBcQClo81LyQJhzE0YBgCYzXqCjWxsrJG+hrWKVnF9ia8tCBP
         yFlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=njDPO7eRcKSKwnJmQxEb1ParYuJ6CzGy5clgzweirns=;
        b=bZISmXKBf0xAKUHy+2JOPGAp3el/zsTo2BPTVhO7AogJ5U8cOH3QZjIWHFUGQMV5vG
         rAAjFIGJ4GaboKU4+njFkfROUnacnIsdDSC/97pH2PfWc8o2xolxtpZg0Dfphya1dABZ
         zA09rZTGJna0lo5J/IpzPbtoOMScAUdLEdAWix8d+/xSlcerUUh6Pjmr16xSvz8UnACT
         7LqXaajebIrWmyASWbFDypXDUjiDUovSgkbckFLPOZx8QpCcgKqjma+C2dhrPKs97d/O
         lQBtfalWAG7mmkyBm2lmeBNrNNIV/JchzjKU/YHRjgJa5N8EW1wLhB0Plplt3EUO/dYB
         cZ3w==
X-Gm-Message-State: AA+aEWZW0w3RUXwy7e9mijj/crUt78KhtdoElMzkYPHs3a9fhCGFYkBJ
        k2kY9YqYAv3WJMmsyzc+G1yZOdI/
X-Google-Smtp-Source: AFSGD/UQLOq24jnh+EEdScueK43TCZ0cOZRRsYcjXVJCZ8iSx4is57A1qceznZ7AGWOEBg1S1mDQMg==
X-Received: by 2002:a9d:401:: with SMTP id 1mr1096008otc.78.1543504201181;
        Thu, 29 Nov 2018 07:10:01 -0800 (PST)
Received: from [192.168.1.103] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id k130sm606858oia.47.2018.11.29.07.09.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Nov 2018 07:10:00 -0800 (PST)
Subject: Re: [PATCH] rtl818x: fix potential use after free
To:     Pan Bian <bianpan2016@163.com>,
        Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1543488490-101743-1-git-send-email-bianpan2016@163.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <984166c8-bf7a-33f0-f5c5-269ee14f420a@lwfinger.net>
Date:   Thu, 29 Nov 2018 09:09:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <1543488490-101743-1-git-send-email-bianpan2016@163.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/29/18 4:48 AM, Pan Bian wrote:
> entry is released via usb_put_urb just after calling usb_submit_urb.
> However, entry is used if the submission fails, resulting in a use after
> free bug. The patch fixes this.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>   drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
> index cec3778..1a2ea8b 100644
> --- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
> +++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
> @@ -444,12 +444,13 @@ static int rtl8187_init_urbs(struct ieee80211_hw *dev)
>   		skb_queue_tail(&priv->rx_queue, skb);
>   		usb_anchor_urb(entry, &priv->anchored);
>   		ret = usb_submit_urb(entry, GFP_KERNEL);
> -		usb_put_urb(entry);
>   		if (ret) {
>   			skb_unlink(skb, &priv->rx_queue);
>   			usb_unanchor_urb(entry);
> +			usb_put_urb(entry);
>   			goto err;
>   		}
> +		usb_put_urb(entry);
>   	}
>   	return ret;

Good catch.

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,
Larry

