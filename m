Return-Path: <SRS0=0lX+=SQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BA3C282CE
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Apr 2019 09:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E829218D3
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Apr 2019 09:44:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="IdFVNxsX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbfDNJoW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Apr 2019 05:44:22 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43578 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfDNJoV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Apr 2019 05:44:21 -0400
Received: by mail-ed1-f68.google.com with SMTP id j20so1791410edq.10
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2019 02:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IiSsptnnyZ9bqezfXcL3CGfC0PcZy8wJum/lZcgYTXw=;
        b=IdFVNxsX/tQ4KaEemI35DCjxv2Q1qOExoNVW7hNo9WU9ATPqJ0hAEAHVFB22xhD4NW
         0QOHRArpsyKZP5RB0NzZTs/VRVpQ1KKS93UuQj7NvBFZyxP0+mG5klgh0ZT+ebgTmY0Z
         fXO2NuXqusJzrnWY9K0nMmZgPC3tVK0DKUDWg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IiSsptnnyZ9bqezfXcL3CGfC0PcZy8wJum/lZcgYTXw=;
        b=Ps4lAIo6Q21//g1KMj6L7haD/aMn5Ro6ecH+ZPrWi2U5ohWYPKGn8OXYyKgZOjSf37
         NYc5HJmKru0OhDN2+lerl8TVo/U2koazqVtZ6s/2gICYKgut/SOC82ktXTENb29gJJd5
         DOhVg23r3k6i3qXx1F2BPyhe82NvuCEjGdO/cgiGPXbXcJKaZz3cVjGf6UckM7woMSiB
         gdjP/Mm60QP+E5okOFqw5AA9cE4uVyLiMOebn4Z+4wZcLLo2YYU8QJ/86Hq9D3aB1Ks2
         m7E8rf3SnZwUpWSbr2V8tJ+dBIUg8v1oghyNhvKa6pTVBYf8lYonaL3VNxbSwLQjSxng
         F4GA==
X-Gm-Message-State: APjAAAVSjHfGQY1HkOaMTsOUTfaQEWjDeZqxU4KYlGCv/yWf7oS5DJKt
        SvmwgnAFyoNHtRqw+bnl2AbjFQ==
X-Google-Smtp-Source: APXvYqy52Guyko5P39KimqDRqQ3I/nOrJ//PqPEb4+vK/eMuxWOwCiCERuCS6aRgL4gwBYxck5e/bQ==
X-Received: by 2002:a50:ac76:: with SMTP id w51mr3442677edc.13.1555235059597;
        Sun, 14 Apr 2019 02:44:19 -0700 (PDT)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id a25sm5381685edr.94.2019.04.14.02.44.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Apr 2019 02:44:18 -0700 (PDT)
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate tx
 queues
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, Herbert Xu <herbert@gondor.apana.org.au>
References: <20190316170634.13125-1-nbd@nbd.name>
 <20190316170634.13125-5-nbd@nbd.name> <87sgvmvg9g.fsf@toke.dk>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com>
Date:   Sun, 14 Apr 2019 11:44:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <87sgvmvg9g.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ Herbert

On 3/16/2019 7:14 PM, Toke Høiland-Jørgensen wrote:
> Felix Fietkau <nbd@nbd.name> writes:
> 
>> When using iTXQ, tx sequence number allocation and statistics are run at
>> dequeue time. Because of that, it is safe to enable NETIF_F_LLTX, which
>> allows tx handlers to run on multiple CPUs in parallel.
> 
> Cool, didn't know about that flag.

It is water under the bridge as this patch got applied already, but I 
stumbled upon it just recently and didn't know about that flag either. 
So I looked for more information about it and found the definition [1], 
but the comment seemed important enough to send this reply.

	NETIF_F_LLTX_BIT,	/* LockLess TX - deprecated. Please */
				/* do not use LLTX in new drivers */

Here is the commit that marked it deprecated:

commit e24eb521fbf2a350ce879dfc1d8e56d4ffa2aa22
Author: Christian Borntraeger <borntraeger@de.ibm.com>
Date:   Tue Sep 25 19:42:02 2007 -0700

     [NET]: note that NETIF_F_LLTX is deprecated

So I am not sure we should really do this in mac80211. Maybe Herbert can 
comment although it has been over a decade ago.

Regards,
Arend

[1] 
https://elixir.bootlin.com/linux/latest/source/include/linux/netdev_features.h#L32
