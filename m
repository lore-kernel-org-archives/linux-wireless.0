Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58545C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 06:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B7A620657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 06:44:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oL6xw/8C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfCKGoM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 02:44:12 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42417 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfCKGoL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 02:44:11 -0400
Received: by mail-lf1-f67.google.com with SMTP id p1so2506185lfk.9;
        Sun, 10 Mar 2019 23:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zMblhS00+sT80Cq7Jhau/emE5bUOV9+iyYBuzntWk6Y=;
        b=oL6xw/8CFRCz098lGbTjArOCC4a23FLC8kT+RwgXo6GsQY2PGFtrvqd/T6Tu0tQL/e
         OxbISMd1xvzqofJx9EbqKm1DAN2qowbHunflfZIXGYUP+0gx6FaxLBivsWwWnhjnOvct
         np8vSJ66MCrXsfw/GRWFc9derCiaaGwkvLIWtDpCmMpo9ZxSPvkDW5r1QHBEyP09oPXF
         4VGE4E/XL/hOd7BLDxI6sMHj6e/bK+pNyIjs9w+nIETENJ8ML6/O3lVOrJSC7bIsqtOm
         YjXs6WJkYLdXtXhkxenI62bge5N0ZRcsA45CASVHtPUFyR+0rEfDR29KbfdqB1qC7ZHl
         oLvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zMblhS00+sT80Cq7Jhau/emE5bUOV9+iyYBuzntWk6Y=;
        b=tn/EWOn7LzG1QZyHMO8YNVVJJnnT7CMpETzCGEyK/bVU9n/Kwe8gJKy8psb2RPYbqS
         DQbAXk7zv2uJFQ9JPRujOBCj9W52R0mPpu7/Gk8PujMcS9/zbWBl853I3tqQVyiBkVwo
         uLcUy3Q7E7OrlAiRQGU76kBYNzCAk8ayNYqzqSKv1tVSD5MIFcM7gsoYQvKIPjSop9xA
         k24L25XDFCAcuKY2Bt+yq9bm6K7522SOAaX4UMeNaEEWb7UWrRQbu8L4jdev6P+nSQYU
         cH6ibljJUzAqBwhhA64oNlq1VRkB6AtveMDI4SV9mOy8s9HX+jxSISyCv58KCbuBAHTn
         yXUA==
X-Gm-Message-State: APjAAAWlYRL3ecM9kjQyaYzKYHHPgdjwI1kQMczjusdvcv+NFG4BzK0a
        9euckCgH+Xa0uS6pPKug0J1dwQXbCPE=
X-Google-Smtp-Source: APXvYqwuTiW2gbLz4ct+bHPP3Cy3Y05QdpW0stCLQdobogHmneQNkOlhrgoCAgG+lmEMUR/iw1tZFQ==
X-Received: by 2002:a19:f008:: with SMTP id p8mr16311238lfc.134.1552286649210;
        Sun, 10 Mar 2019 23:44:09 -0700 (PDT)
Received: from [192.168.43.26] (c-5eea31d7-74736162.cust.telenor.se. [94.234.49.215])
        by smtp.gmail.com with ESMTPSA id a8sm812717ljf.52.2019.03.10.23.44.07
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Mar 2019 23:44:08 -0700 (PDT)
Subject: Re: FW: [PATCH] ath10k: fix return value check in wake_tx_q op
To:     Yibo Zhao <yiboz@codeaurora.org>, Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless-owner@vger.kernel.org
References: <20180506132500.16888-1-erik.stromdahl@gmail.com>
 <6dc00772b826410e930306891fd13ed9@euamsexm01f.eu.qualcomm.com>
 <c77a1c0961f34ee68b7266444d2207f5@aptaiexm02e.ap.qualcomm.com>
 <66a74025a23795f305de37989c1b8aa3@codeaurora.org>
 <87sgwz8ylw.fsf@kamboji.qca.qualcomm.com>
 <a1c113622b9aec9b32393c0a3e159e32@codeaurora.org>
 <4dadbeebe8dc1e911cc4871d767b4ed1@codeaurora.org>
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <8c882c7d-41e3-cdc9-34ae-6446970dbc52@gmail.com>
Date:   Mon, 11 Mar 2019 07:44:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <4dadbeebe8dc1e911cc4871d767b4ed1@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Yibo,

Sorry for a late reply, but I have been busy with other projects lately.
I have added my comments below

On 3/4/19 2:56 AM, Yibo Zhao wrote:
> 在 2019-02-25 12:40，Yibo Zhao 写道：
>> 在 2019-02-07 22:25，Kalle Valo 写道：
>>> Yibo Zhao <yiboz@codeaurora.org> writes:
>>>
>>>> We have met performance issue on our two-core system after applying
>>>> your patch. In WDS mode, we found that the peak throughput in TCP-DL
>>>> and UDP-DL dropped more than 10% compared with previous one. And in
>>>> some cases, though throughput stays the same, one CPU usage rises
>>>> about 20% which leads to 10% in total CPU usage. With your change, I
>>>> think driver will try its best to push as many packets as it can.
>>>> During this time, the driver's queue lock will be held for too much
>>>> time in one CPU and as a result, the other CPU will be blocked if it
>>>> wants to acquired the same lock. Working in this way seems not
>>>> efficiency.
>>>>
>>>> So I think it is better to revert the change till we come up with a
>>>> new solution.
>>>
>>> I don't think reverting is a clear option at this stage because that
>>> again creates problems for SDIO. IIRC without this patch SDIO was
>>> sending one packet a time (or something like that, can't remember all
>>> the details right now).

I have a few patches related to bundling of TX packets on my private repo.
I have not yet had the time to prepare them for submission.
This patch is related to that work, but I decided to submit it separately
since I considered it a bugfix.

<snip>

>>
>> IMHO, with Erik's change, Erik's change has changed the way fq's
>> schedule behavior and it looks like there is no other packets in the
>> fq after a packet has been dequeued. And as a result, this flow's
>> deficit will be refill and then removed from fq list at once in the
>> same CPU. And during this time, the other CPU could be blocked. When
>> new packet comes, same thing happens. So we get equal new flows and
>> tx-packets.
>>
>> Things would be different without Erik's change. After a packet has
>> been dequeued, this flow's deficit will not be refill immediately in
>> CPU0. It is possible that the deficit to be refilled in CPU1 while at
>> the same time CPU0 can fetch data from ethernet. So we can see more
>> tx-packets delivered to FW from aqm.
>>
>>
>>> Why does this happen only WDS mode? Did you test other modes, like AP or
>>> client mode?
>> AP mode has same issue. UDP throughput drops more than 10%. As for
>> TCP, CPU usage rising a lot although throughput stays similiar.
>> So, I'd say Erik's change does not work for us.
> 
> Hi Kalle,
> 
> May I have your comments?
> 

As I wrote in the commit message, the original code will always break out of
the loop after just one iteration.

It is OK with me to bring back the old logic, but I think we should skip the
loop entirely then.

Something like this:

if (ath10k_mac_tx_can_push(hw, txq)) {
	ath10k_mac_tx_push_txq(hw, txq);
}


Btw, I noticed that the "fair scheduling" mechanism (derived from ath9k) from
Toke have been integrated.

I haven't rebased my tree for a while, so I will most likely have to rewrite
my patches anyway in order to make them work with the new TX scheduling.
