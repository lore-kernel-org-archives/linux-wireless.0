Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A06C64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 08:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 864A8213A2
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 08:52:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="awVWBm0e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 864A8213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbeJDPoj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 11:44:39 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42500 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbeJDPoj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 11:44:39 -0400
Received: by mail-pg1-f193.google.com with SMTP id i4-v6so2832133pgq.9;
        Thu, 04 Oct 2018 01:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=zTXLXK8P+FBlVdxIdbSO7KNUqx7jveW1kZHc8/lXAIA=;
        b=awVWBm0e9iOKQvI2J2Iry0B+pme1R+lur6gbFMjxqqTW59ipWxmzHmlLefcyVulGRc
         3GyUy0O4TLLzh5ONs+LvqSUTX34FphLNLYrYUoSEeY8HKw9jDcKB2ril2jdQRa6/jieo
         MA6uNlhRar3SWfQQb6FEZBMNbxBZQ0bXNTWcFHdvghk3Yub2ZDzJilCwyUQo15KpesJB
         QxAWcZwdWnmRlqU/a1sPsS3FrdVS5JzOiHqg0pSWvgIi7jaG8XrLu87eL435N7lOCbHb
         lmbpum7D/JOhEvNecemGs9OOVSBdDJ6lxcsAIKhQlGgXb92rAMf8CUScUskLcPgpA4NL
         5KDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=zTXLXK8P+FBlVdxIdbSO7KNUqx7jveW1kZHc8/lXAIA=;
        b=VU0+Kq/n80CVpunu1X7XKjcEDcKw1/ZQ6IYzwyZ7utgb6U60XozCDCQGB3arAOWvAD
         WdBHE4OgZ8DGgARz+Am0dFD7titv+ouzO2rg6EJyBrOHUvo1pmKedshfaWDpvenCKiw5
         N81u1xbU/8qOg2XYePBqqQOKSkBRihncaaRXdvLOt2Be7DM+5zmwNClK48enAy9A/iGU
         Yp5c+GvjovFLwcVIwH2gbgDCAqE4jVJvNmtgaOKVhFh1ZTb2BId1XztUyGf+d2L+4WW7
         qf2c0jJoCGWXOV6QjIPkJ7viGZNWwjhPjlXZumles8lpkcPXcOsrwZbWIK9gIugie10l
         azJw==
X-Gm-Message-State: ABuFfoglLHA32dZXCazYmk3zArNO+lN6HLfAuFspmsgEGuG+6gtZMdD+
        8UHO83X6qxTv02DVWy1o4o3iqAm4
X-Google-Smtp-Source: ACcGV60EG92/K2ePN5H9oEgsXGtIUFL/8ODx3FoOxNp+0lBVIKxSiCN23h1/lv4RqyrBn/eWmFbOyg==
X-Received: by 2002:a62:f20f:: with SMTP id m15-v6mr5625959pfh.244.1538643145145;
        Thu, 04 Oct 2018 01:52:25 -0700 (PDT)
Received: from ?IPv6:2402:f000:1:1501:200:5efe:166.111.71.3? ([2402:f000:1:1501:200:5efe:a66f:4703])
        by smtp.gmail.com with ESMTPSA id g88-v6sm7875036pfd.181.2018.10.04.01.52.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Oct 2018 01:52:24 -0700 (PDT)
Subject: Re: [PATCH] net: wireless: iwlegacy: Fix possible data races in
 il4965_send_rxon_assoc()
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20181003140745.7650-1-baijiaju1990@gmail.com>
 <20181004075914.GB20523@redhat.com>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <988494cb-c121-697e-b502-ea4e7c601f47@gmail.com>
Date:   Thu, 4 Oct 2018 16:52:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20181004075914.GB20523@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Thanks for your reply :)


On 2018/10/4 15:59, Stanislaw Gruszka wrote:
> On Wed, Oct 03, 2018 at 10:07:45PM +0800, Jia-Ju Bai wrote:
>> These possible races are detected by a runtime testing.
>> To fix these races, the mutex lock is used in il4965_send_rxon_assoc()
>> to protect the data.
> Really ? I'm surprised by that, see below.

My runtime testing shows that il4965_send_rxon_assoc() and 
il4965_configure_filter() are concurrently executed.
But after seeing your reply, I need to carefully check whether my 
runtime testing is right, because I think you are right.
In fact, I only monitored the iwl4965 driver, but did not monitor the 
iwlegacy driver, so I will do the testing again with monitoring the 
lwlegacy driver.

>
>> @@ -1297,6 +1297,7 @@ il4965_send_rxon_assoc(struct il_priv *il)
>>   	const struct il_rxon_cmd *rxon1 = &il->staging;
>>   	const struct il_rxon_cmd *rxon2 = &il->active;
>>   
>> +	mutex_lock(&il->mutex);
>>   	if (rxon1->flags == rxon2->flags &&
> For 4965 driver il4965_send_rxon_assoc() is only called by
> il_mac_bss_info_changed() and il4965_commit_rxon().
>
> il_mac_bss_info_changed() acquire il->mutex and
> callers of  il4965_commit_rxon() acquire il->mutex
> (but I did not check all of them).
>
> So I wonder how this patch did not cause the deadlock ?

Oh, sorry, anyway, my patch will cause double locks...

>    
> Anyway what can be done is adding:
>
> lockdep_assert_held(&il->mutex);
>
> il4965_commit_rxon() to check if we hold the mutex.

I agree.


Best wishes,
Jia-Ju Bai
