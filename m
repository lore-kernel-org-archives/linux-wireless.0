Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F77C282DC
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 09:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BE9220835
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 09:16:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hWTNRVHn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731509AbfDQJQa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 05:16:30 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41682 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbfDQJQ3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 05:16:29 -0400
Received: by mail-pg1-f193.google.com with SMTP id f6so11718232pgs.8
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2019 02:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Suh5G6Gnh2Cwhh3okO4p06HhQ3wISJbQ83UDA4akMdc=;
        b=hWTNRVHncX2D4uDIX0FEPHmfFuhggpDRkOdQ91OEqvMnZRH4S9uMWAxFod5TlkZ8EC
         lF5A4Ojiilp3vijge3/EzanKFAb9f9u1jJ8cs2oPfIaf6GSjN98b9WtoXMYj5Ai71uKV
         UnUXVUNvwzNg7Lvu6Cuywr8GlK7dD5ou3THd0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Suh5G6Gnh2Cwhh3okO4p06HhQ3wISJbQ83UDA4akMdc=;
        b=VPDqwg9LCXbwHvyGy4ITfZ0/BxJm5wH6vWi5WaNlk3ciuI+gY6JlXwDdUnWI0YIhGW
         bx1jDiOdwYZleZ/ITmjV5Taz+s1jGEURCBBzCxzJNG3TjL4tw51VBPxZlWy4JFsE6nkv
         4CGgReBAAirBZOsyfrSq8mT+Mbpc97bfKT6PEXybTAJ60Mst2AY3ijALgvNpVUePlVZP
         ZXRkqGE05HJSe1wr4ZTmi+OUNl1s+a4ZlLD8dhW8dXgdykIwLRw/zNoHiOmtw6DZeXvK
         zTaT4yfZ47wEt1aCG/dEUS75dHR+x8el7bzvsmxltALh7JYhxh5UlAv1uT4glZHlf4Vq
         2/vQ==
X-Gm-Message-State: APjAAAWYZ3qYDl1JdCzaW0oecojDDyRIrMzWcSKw1xsl2e1Kbkfe5WXp
        o9yAR78HEawNAzVR1ugiVcn/HQ==
X-Google-Smtp-Source: APXvYqwHJQFMDy/SMfoQcY/IBtrlKsl7lmKaFjEXAvTM2SyNRY1kcs6kW3CtjpzRKVtEpfznnvNT9A==
X-Received: by 2002:a63:3281:: with SMTP id y123mr17798692pgy.272.1555492588432;
        Wed, 17 Apr 2019 02:16:28 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id l184sm130725058pfc.98.2019.04.17.02.16.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Apr 2019 02:16:27 -0700 (PDT)
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate tx
 queues
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Bob McMahon <bob.mcmahon@broadcom.com>
References: <20190416074444.pdubbh6fbibdnhi7@gondor.apana.org.au>
 <73b18131-2777-da5c-a6ee-9d9b3e13cd06@broadcom.com>
 <20190416083636.5ttvezqyhzr2worg@gondor.apana.org.au>
 <eab39dd804405854997e50102f3d0ff925feb8d2.camel@sipsolutions.net>
 <87ef62uwfm.fsf@toke.dk>
 <95f86cf69dee05a176625925657cf0df0e97b5c9.camel@sipsolutions.net>
 <20190416093707.dtlwcmitzqopaeaw@gondor.apana.org.au>
 <e4c1a3ca0c0c160b7c271ab83deebcf096f38497.camel@sipsolutions.net>
 <20190416131346.u2uolljlrd5t2jro@gondor.apana.org.au>
 <87wojut7f7.fsf@toke.dk>
 <20190417033834.ep6t7r6ttvjek5g7@gondor.apana.org.au>
 <87wojtroar.fsf@toke.dk>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <2662e6d5-25c7-6e40-4381-800f5e289d31@broadcom.com>
Date:   Wed, 17 Apr 2019 11:16:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <87wojtroar.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ Bob

On 4/17/2019 11:09 AM, Toke Høiland-Jørgensen wrote:
> Herbert Xu <herbert@gondor.apana.org.au> writes:
> 
>> On Tue, Apr 16, 2019 at 02:18:36PM +0100, Toke Høiland-Jørgensen wrote:
>>>
>>>> The congestion control happens at two levels. You are right that the
>>>> socket buffer acts as one limit. However, other applications may also
>>>> rely on the TX queue being full as the throttle (by setting a
>>>> sufficiently large socket buffer size).
>>>
>>> Do you happen to have an example of an application that does this that
>>> could be used for testing? :)
>>
>> Have a look at
>>
>> commit 6ce9e7b5fe3195d1ae6e3a0753d4ddcac5cd699e
>> Author: Eric Dumazet <eric.dumazet@gmail.com>
>> Date:   Wed Sep 2 18:05:33 2009 -0700
>>
>>      ip: Report qdisc packet drops
>>
>> You should be able to do a UDP flood while setting IP_RECVERR to
>> detect the packet drop due to a full queue which AFAICS will never
>> happen with the current mac80211 setup.
> 
> Yup, got that part. Was just wondering if you know of any applications
> that already do this, that I could test without having to write my
> own... :)

Hi Bob,

Is this something that could be easily implemented in iperf?

Regards,
Arend
