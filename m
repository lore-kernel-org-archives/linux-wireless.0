Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF2BC6786C
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 13:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E16521104
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 13:06:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sEl4VKmU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E16521104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbeLNNGx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 08:06:53 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45547 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729875AbeLNNGx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 08:06:53 -0500
Received: by mail-wr1-f67.google.com with SMTP id t6so5196971wrr.12;
        Fri, 14 Dec 2018 05:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bCZ6oVGixp+wejaDWjT5aV6gV0lSz4z6cpumuzPBuvk=;
        b=sEl4VKmUyhY9G0vW+5V6m5o4v1aiXUS5mH0BwHxRUatw6se1nKZQMxqdLt8LJxMfNe
         TxyL5lhVKCICm1jQCh4eAVulvmCl5B6F0iIJDBh60OfF+o9YUqxyhjVGFWPCjtE9h/ao
         ipc0VSHjiasHn/jzq1Q+D48maoxwrbAMoImqVbuoCX4bmq8QXtEGU+PP0g2m2twNLGIl
         994/lEZQWbuysUwK79HpoEUKiSgqSeisnGQqfiQfaaNifIQUO4c5ggxo2CRO7lLKSCsN
         1/EI8aoxGwK3nVO/2lcekyRQcvblffuQsg5gMwr53af2aJKjIx32b+TIwgRZAQHcKV3b
         ukxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bCZ6oVGixp+wejaDWjT5aV6gV0lSz4z6cpumuzPBuvk=;
        b=s08PNs/tS3UTCbldnIoUUByrSDB7Un75EqzpVIrg6UNs7+UpMIcJrglT98oV1uEGoM
         kerlzeFhO/T3BF7C5KKkuSWbn80RD5wuVY4BYT3xHGklqr1we6iUcKv0jNhr+az+BeRB
         rV0snn9OmPhDyyJxVmtcHYPLv/VOIzTVsqSqrUfuzLRNxFs9pniBhre0UcuPiQmb8tv1
         7+/+L703ZxMk1Il+312bY/ozDvcIv6DBbs0WeMdplP7wX6ZXCWTI830g4bGXsimGXjih
         2f2YYnHa3dcfKN2a8uaDh7XaV1Ivy5n1LW1+HLhIkWKMVhgfZhW0MotXFW/F+93ymZUg
         C6YA==
X-Gm-Message-State: AA+aEWbQ9HGnxxJOdcJdj5P27D6k6qfa8WI98WwNGISs9TGgCoNnjJK+
        3Ur4mnexfLbDWpxq2/uVEdY=
X-Google-Smtp-Source: AFSGD/WYxxlQsNMl8ic2JE/Q1grvXJmWz3rkUbpZcvKpW2e/Y4FmnMEtiUrJFvRV+MnTEeXnsnBgSA==
X-Received: by 2002:a05:6000:100f:: with SMTP id a15mr2667498wrx.298.1544792811015;
        Fri, 14 Dec 2018 05:06:51 -0800 (PST)
Received: from [192.168.8.147] (225.83.136.77.rev.sfr.net. [77.136.83.225])
        by smtp.gmail.com with ESMTPSA id k128sm6162824wmd.37.2018.12.14.05.06.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Dec 2018 05:06:50 -0800 (PST)
Subject: Re: question: ip forwarding and fq/mq qdisc
To:     Sergey Matyukevich <geomatsi@gmail.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        sergey.matyukevich.os@quantenna.com
References: <20181214120210.kmeuwvajuiwlp2n7@bars>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c3ac480b-2c6c-689a-a39e-75df601e5261@gmail.com>
Date:   Fri, 14 Dec 2018 05:06:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181214120210.kmeuwvajuiwlp2n7@bars>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 12/14/2018 04:02 AM, Sergey Matyukevich wrote:
> Hi all,
> 
> I have been running 4.18-rc8 kernel with enabled IP forwarding between
> wired and wireless interfaces, where both interfaces
> were configured as fq qdisc.
> 
> However after moving to 4.20-rc1 kernel the same configuration does not
> work anymore: pass-through packets are not forwarded in both directions.
> Forwarding starts working again only if I change qdisc of _both_ interfaces
> to anything but fq/mq. For instance any combination of pfifo/fq_codel/noqueue
> works fine.
> 
> Does it look like a regression or it is a known change in behavior ?
> 
> Regards,
> Sergey
> 

Hi Sergey

I guess EDT model broke this use case.

I was under the impression skb->tstamp was cleared when forwarding packets, maybe I was wrong.

Can you try the following ?

diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
index 06ee4696703c0ce72ea914403b739839e60f1584..00ec819f949b5e76ea96be901a697f4e12d5cf4d 100644
--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -79,6 +79,7 @@ static int ip_forward_finish(struct net *net, struct sock *sk, struct sk_buff *s
        if (unlikely(opt->optlen))
                ip_forward_options(skb);
 
+       skb->tstamp = 0;
        return dst_output(net, sk, skb);
 }
 

