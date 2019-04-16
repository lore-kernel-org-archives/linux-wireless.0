Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D852C10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 09:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ABA820675
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 09:17:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OOIsaiQA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbfDPJR5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 05:17:57 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:46374 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbfDPJR4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 05:17:56 -0400
Received: by mail-yb1-f193.google.com with SMTP id m5so5656316ybk.13
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2019 02:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=okaLzz9oJ0nunTrdTjr1Rvs94B6PYqrKuoq4gZZcNt0=;
        b=OOIsaiQARGOhKvgbBX8ZA4BTP5Z8CoPzy5fO3R+g3frrR7eO32Lbvmdq+AufYC/b8z
         d2ID6oWtLrP5U3yEL9Y8L/5txSG64ID1YbnvsWvDL+OkCivDxr9DnRsgprJCVDRW4bB8
         sadO+dT20i2urrSPBnCxoaszndFQs6urzEJ1g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=okaLzz9oJ0nunTrdTjr1Rvs94B6PYqrKuoq4gZZcNt0=;
        b=jb4Yjg2BxxhVjezq1YJweNGYXMWOo/n1lhOwhkjdL/MThB0qWTGmEBcahPO8gIycIr
         vhMc8RLnnzBmqGNAi4i4ZJ9VVnuPwcoEp04uq4ax71crNeBE8GNHcr7L418FbUDjxy+F
         4lm8NScgPxTO2Z+TekfYmHFZVLRCOoY73y+9DOCTGVka4bTiUxI9JRDecIV3BTAKGdvO
         Z5KM5E9ubn+NNJCTfy5lW+du7UIZKemo/Qvhe6rMVNmTKQSxRp1UAdDuQSm0GyJemlgb
         D7hcZb72KyqMIs11Lv1DoAbwQWFa+K0NNbPOzPjJvU648ixm1XVm35kpTyPyyH7+wxhH
         VaSg==
X-Gm-Message-State: APjAAAUMAXW4zxczFgpF33uMGCUqzJPB0GGrRptzKKb/H9vyieBRGppb
        lJRecab1X5nZPsmpztSTaxjEi2nzKuDCd0GogZCHZk9BR/G46JXS69rTMH9Uui160QLs86A3ZAJ
        Vawb0HUEpE+5ASIrP/gE2u2YPMdxNdh0rPwc+4j7nPIaHnYyhgIsd6Wyqe5ytOJg0n7z8E3fGUD
        dtfFleJLKHp5mnYA==
X-Google-Smtp-Source: APXvYqyFjyAeYN592M/ztHvgcqHfPZi459m9XM3Q/Dz6YNHt4c53DBXox5qZmHM2Hs/8b2cJWWfevg==
X-Received: by 2002:a25:2558:: with SMTP id l85mr64652031ybl.310.1555406275833;
        Tue, 16 Apr 2019 02:17:55 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id 135sm17549818ywq.14.2019.04.16.02.17.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Apr 2019 02:17:55 -0700 (PDT)
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate tx
 queues
To:     Johannes Berg <johannes@sipsolutions.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
References: <20190316170634.13125-1-nbd@nbd.name>
 <20190316170634.13125-5-nbd@nbd.name> <87sgvmvg9g.fsf@toke.dk>
 <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com>
 <20190416074444.pdubbh6fbibdnhi7@gondor.apana.org.au>
 <73b18131-2777-da5c-a6ee-9d9b3e13cd06@broadcom.com>
 <20190416083636.5ttvezqyhzr2worg@gondor.apana.org.au>
 <eab39dd804405854997e50102f3d0ff925feb8d2.camel@sipsolutions.net>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <cd0715bb-b75c-63b0-0ae4-858d14afd500@broadcom.com>
Date:   Tue, 16 Apr 2019 11:17:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <eab39dd804405854997e50102f3d0ff925feb8d2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 4/16/2019 10:37 AM, Johannes Berg wrote:
> On Tue, 2019-04-16 at 16:36 +0800, Herbert Xu wrote:
>> On Tue, Apr 16, 2019 at 10:04:24AM +0200, Arend Van Spriel wrote:
>>>
>>> I was just writing up an email clarifying my question. But let me summarize
>>> this email thread. The patch from Felix adds this flag in mac80211 for
>>> drivers that indicate to support pulling packets from the internal TXQ in
>>> mac80211. I found it is deprecated, but as Felix mentioned it is used in
>>> various parts of the network subsystem, ie. batman-adv, bridge, vlan, tunnel
>>> implementations. So its use seems to be restricted rather than deprecated.
>>> Given your response above I guess my question would be to get details about
>>> what you call "proper design" as I think you are saying with that it is not
>>> needed, right?
>>
>> Essentially the only time it would be OK to use LLTX in its current
>> form is if you have no TX queue/congestion feedback which is clearly
>> not the case with wireless drivers.
> 
> It is true because we have an entire buffering layer in mac80211 (in
> this case at least) and never push back to the stack.

Ok, so the crux is the "never push back to the stack" part? Well, the 
internal TXQ and how that is used is obviously enabling that ;-)

Regards,
Arend
