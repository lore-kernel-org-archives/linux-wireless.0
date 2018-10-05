Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0C5C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 13:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 851C22084D
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 13:43:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UFOyi8SE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 851C22084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbeJEUlt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 16:41:49 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37865 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727701AbeJEUls (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 16:41:48 -0400
Received: by mail-pf1-f195.google.com with SMTP id j23-v6so5116600pfi.4;
        Fri, 05 Oct 2018 06:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=SYku1qYFAEJav22Y8Tj5nBN2krftALYGPwKWKdtPLt0=;
        b=UFOyi8SEBbG5cmn5b3ksNNF49qgX84G1IHC3CofReKq2h61IOji5e2lWVHX6gymZKD
         4RteRrjtYs0kMWaS0HrUx6omItvonPvw9+jSPiRCPB3wXHgEfZI/i7qxnpHeU7rz0fa+
         yfeBBMKZAzTvnhFtPwI7RpbDrsXXkeAH8jOoAGGKfQljmAeG5YXMChU82bPJGmuiZdZi
         cYFc+WQRr45JjqePQeXSTzWuQN3/0Ed7kgZ/uf7n4vAY10HL0NUpOozP1BiRBLvPtd0N
         CeHNs8D4kcYSqx7YJORTRuLWxDgY0D4zSlr3eG1YJgQQmVhSs4QyrgbbLpGsiXH93vDO
         d0Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=SYku1qYFAEJav22Y8Tj5nBN2krftALYGPwKWKdtPLt0=;
        b=dU/s4dCYzOWghVunFRuynBQkvBPoyNqJgGsxlYnI3OxLs7MxIVm3tiOkwRTTNS7eFz
         IJwPZM7BMg10pMad+r1pIOOvxaWNw+QQpTqeKoUDnz40roRfA1fozrOFZaYGswFaeniz
         Cb7RwoUBOMksVXGnqujuVZOcCFcZzmDibz/qPZC7/1h4GBsBSvds11QRqfNYEKcWu+aQ
         hz6Uzn3mb5djj65o9aNyAgGQzscE7yst43sOWKdTjWkvEdu79a/75Y2h1gzagAGX+2rT
         eppX1eJ5/R2A02+7B4ECKnVXLYAveRqIrN/Ae02wnJXHEqIGQqgm5VZuC22eWvl8Rzue
         7s5Q==
X-Gm-Message-State: ABuFfojPSsUyqKJnOsMQEh2rPiz/QBNLCIBr3zfIFRDDcPDrDu0qcC1r
        U9eTrykPZjzJG8gW2Szj/Xa5VrHx
X-Google-Smtp-Source: ACcGV62tKXE4FQQ3sogn+qcL9YQBK36OZRbU6FGmZqdqHSnSD25VcG6qTaVnmREPjC6n/zE8xICuNQ==
X-Received: by 2002:a63:982:: with SMTP id 124-v6mr10365569pgj.80.1538746980543;
        Fri, 05 Oct 2018 06:43:00 -0700 (PDT)
Received: from ?IPv6:2402:f000:1:1501:200:5efe:166.111.71.3? ([2402:f000:1:1501:200:5efe:a66f:4703])
        by smtp.gmail.com with ESMTPSA id 189-v6sm13801546pfe.121.2018.10.05.06.42.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Oct 2018 06:42:59 -0700 (PDT)
Subject: Re: [PATCH] net: wireless: iwlegacy: Fix possible data races in
 il4965_send_rxon_assoc()
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20181003140745.7650-1-baijiaju1990@gmail.com>
 <20181004075914.GB20523@redhat.com>
 <988494cb-c121-697e-b502-ea4e7c601f47@gmail.com>
 <20181005075403.GC1931@redhat.com>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <60d6ad7c-3aaa-73e1-451c-c6fc7cb66e99@gmail.com>
Date:   Fri, 5 Oct 2018 21:42:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20181005075403.GC1931@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 2018/10/5 15:54, Stanislaw Gruszka wrote:
> On Thu, Oct 04, 2018 at 04:52:19PM +0800, Jia-Ju Bai wrote:
>> On 2018/10/4 15:59, Stanislaw Gruszka wrote:
>>> On Wed, Oct 03, 2018 at 10:07:45PM +0800, Jia-Ju Bai wrote:
>>>> These possible races are detected by a runtime testing.
>>>> To fix these races, the mutex lock is used in il4965_send_rxon_assoc()
>>>> to protect the data.
>>> Really ? I'm surprised by that, see below.
>> My runtime testing shows that il4965_send_rxon_assoc() and
>> il4965_configure_filter() are concurrently executed.
>> But after seeing your reply, I need to carefully check whether my
>> runtime testing is right, because I think you are right.
>> In fact, I only monitored the iwl4965 driver, but did not monitor
>> the iwlegacy driver, so I will do the testing again with monitoring
>> the lwlegacy driver.
> <snip>
>>> So I wonder how this patch did not cause the deadlock ?
>> Oh, sorry, anyway, my patch will cause double locks...
> So how those runtime test were performend such you didn't
> notice this ?

I write a tool to perform runtime testing.
This tool records the lock status during driver execution.
Some calls to mutex_lock() are in common.c that I did not handle, so the 
corresponding lock status was not recorded by my tool, causing this 
false positive.

Now I have handled common.c, and this false positive is not reported any 
more.
Actually, I get several new reports.
I will send you these reports to you later, and hope you can have a 
look, thanks in advance :)

>
>>> Anyway what can be done is adding:
>>>
>>> lockdep_assert_held(&il->mutex);
>>>
>>> il4965_commit_rxon() to check if we hold the mutex.
>> I agree.
> Care to post a patch ?

Sure :)


Best wishes,
Jia-Ju Bai
