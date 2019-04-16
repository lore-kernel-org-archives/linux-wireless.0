Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1F6C10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 08:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01F042073F
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 08:04:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UgTcesyp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbfDPIE3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 04:04:29 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36083 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfDPIE3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 04:04:29 -0400
Received: by mail-pl1-f194.google.com with SMTP id ck15so9947974plb.3
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2019 01:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nk+OWOYsdf25kucEnTk3N1w03EcPlopbE5Ld8gMjU+M=;
        b=UgTcesyp1FzmLYKe+VBd6IwA2QHcgboMXig9Ktu5hSViN5vbOk1xJCh0MKcu5EJTEr
         E5fVX16JGCUkUwF8f/jKp0386rOhJP0eYpzuGs/jCSkP6fLtuLRYY0/x4SG0xGRsas18
         2CMFrEeShxlEl1y/chExOUW3kZD5HrYvZlVxM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nk+OWOYsdf25kucEnTk3N1w03EcPlopbE5Ld8gMjU+M=;
        b=YcRxsIK3dVqz+wqCNJfBn29XchwO2F2xQECjJPTu5l71ovI6+zuM35Ym4xsQk1ypsR
         168kkRZnEBp7FGt+crAC7QCDXIdSRG5tveY79HzyNb3GjFgLLkPfluertgRrdfwr20QT
         y96qkKJdqzAlhrWDSWJI78Ptct7+PRsZ966Zh4gltyV6AhONQMsMGtaJQDXD0LnPPkRD
         /rcrqvJzA3I2rhvrrxWOYCDDjv6rf79csp2ZrFFDSEec+tbLmJD9WlC3+RXmFaOOPyAV
         8mIyaj8HP5RwlM7F7RYxNhTOQwdsL+1iP2XOYsd0jH5tU6cl0gcedr17KWSonpXV+l59
         4lSA==
X-Gm-Message-State: APjAAAUrKG2/38a5oDQWl4wLmgN4O0BzT4BuFMiAPTgEalsirc27KOY2
        KK3D82dkfKPFJcJWWUOkXdlrduCzoxRgnw==
X-Google-Smtp-Source: APXvYqxBjQIJ+SmIKGvwgtlf8RwsUQHv9GeUZ0vrbepWi3jed8m+O0H9C3PDhIwLnpntqUoaSRyJhw==
X-Received: by 2002:a17:902:4381:: with SMTP id j1mr16430631pld.173.1555401868426;
        Tue, 16 Apr 2019 01:04:28 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id x28sm57549046pgl.38.2019.04.16.01.04.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Apr 2019 01:04:27 -0700 (PDT)
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate tx
 queues
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net
References: <20190316170634.13125-1-nbd@nbd.name>
 <20190316170634.13125-5-nbd@nbd.name> <87sgvmvg9g.fsf@toke.dk>
 <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com>
 <20190416074444.pdubbh6fbibdnhi7@gondor.apana.org.au>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <73b18131-2777-da5c-a6ee-9d9b3e13cd06@broadcom.com>
Date:   Tue, 16 Apr 2019 10:04:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190416074444.pdubbh6fbibdnhi7@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/16/2019 9:44 AM, Herbert Xu wrote:
> On Sun, Apr 14, 2019 at 11:44:17AM +0200, Arend Van Spriel wrote:
>> + Herbert
>>
>> On 3/16/2019 7:14 PM, Toke Høiland-Jørgensen wrote:
>>> Felix Fietkau <nbd@nbd.name> writes:
>>>
>>>> When using iTXQ, tx sequence number allocation and statistics are run at
>>>> dequeue time. Because of that, it is safe to enable NETIF_F_LLTX, which
>>>> allows tx handlers to run on multiple CPUs in parallel.
>>>
>>> Cool, didn't know about that flag.
>>
>> It is water under the bridge as this patch got applied already, but I
>> stumbled upon it just recently and didn't know about that flag either. So I
>> looked for more information about it and found the definition [1], but the
>> comment seemed important enough to send this reply.
>>
>> 	NETIF_F_LLTX_BIT,	/* LockLess TX - deprecated. Please */
>> 				/* do not use LLTX in new drivers */
> 
> The most obvious problem with LLTX is that it can cause AF_PACKET
> to see packets twice.  But the more subtle issue is that with a
> proper design this lock should have no contention anyway.
> 
> So please explain why you want to use this in your driver and where
> the contention is coming from?

Hi Herbert,

I was just writing up an email clarifying my question. But let me 
summarize this email thread. The patch from Felix adds this flag in 
mac80211 for drivers that indicate to support pulling packets from the 
internal TXQ in mac80211. I found it is deprecated, but as Felix 
mentioned it is used in various parts of the network subsystem, ie. 
batman-adv, bridge, vlan, tunnel implementations. So its use seems to be 
restricted rather than deprecated. Given your response above I guess my 
question would be to get details about what you call "proper design" as 
I think you are saying with that it is not needed, right?

Regards,
Arend
