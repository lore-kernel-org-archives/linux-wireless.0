Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A68C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 02:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D40D20863
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 02:32:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VkSW9mqI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbfCACcH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 21:32:07 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39607 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbfCACcG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 21:32:06 -0500
Received: by mail-qt1-f196.google.com with SMTP id o6so26115628qtk.6;
        Thu, 28 Feb 2019 18:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=QzaYYWLTLgwZqUkJIcAQxjTqSbN5ZFiQxz0iJmOQdrE=;
        b=VkSW9mqI4twONOA8CdLJMsS/ZIFjsgpjDiOrRshoH3epZbgZMn5A+RfO3BgjZ8WroT
         zEJibQTmBmoa1WE4CEBA+eLzRCKAF3WRjgR666Z7gLq9U6wnQI1fNkBn5TMPrlnEjhUW
         D1kUzcsqyUcjuKiNkAiQBmUR+I4cbbzGjb24vNyUAR6nEUjQf2KMIwtYpFfUuzYE8b+c
         7VMNQnN5GlBehhQjDTx1RB3aaiAsgmsWJPmP+JxSCcOi8jg8JFd2wgh6HaFcC1/Q1GBh
         SsAog0eNaJs7wGPOlc4BBKqiCQ1KpCOi1KkmVxiJxB/9PzWuVoWLCXN8UA3kV2o6JkQ6
         R/nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=QzaYYWLTLgwZqUkJIcAQxjTqSbN5ZFiQxz0iJmOQdrE=;
        b=hHfaC13lNnWXsS2X7Rg8LVO/t963ndZqJxdWlQ+iJVm40mMSWTwWppRQ/k6YAM3K1g
         rN9Vb5IrNUnA4jvSj8Q/+fSANTmvZVaY6lZqke1C0MbMH5yAwgMLplXNvNNRS1fFVrhb
         68nv4qUpewraTyRmsrKCRTCM12PVZLTqCkdk6XbgVgavtc0mpZWXYgUT4LC5M0tNuAye
         rIoNj5d1SjE7495WesfaQa6FxewvEvORWSBS4+D6ruNdWy4/ltBJFsO4q9ntKDthU26I
         9y25Eh1nQDn9htX7tndglCCIUP6oNyrwhyDFHevRolFIx1cSv5QxWQJsyaARgtAa1z23
         rnRg==
X-Gm-Message-State: APjAAAUBQ8+NJwKiOfFbZEsOQj9LzUlsOeqXWTRcBChx8tVdLDEoy0pX
        Ipwii4I3fWF+j29df1PK/1glLsxT
X-Google-Smtp-Source: APXvYqzOBMGGMJEMCthkKYw6CbsnamjTssjVC/35RVLml0M/wyc3RIqnVLjbadB2IAcj+4nh2XYy1Q==
X-Received: by 2002:a0c:b98f:: with SMTP id v15mr1971132qvf.60.1551407525015;
        Thu, 28 Feb 2019 18:32:05 -0800 (PST)
Received: from [192.168.1.199] (pool-108-28-156-19.washdc.fios.verizon.net. [108.28.156.19])
        by smtp.gmail.com with ESMTPSA id m128sm11767097qkf.53.2019.02.28.18.32.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Feb 2019 18:32:04 -0800 (PST)
Subject: Re: Realtek r8822be kernel module does not negotiate 802.11ac
 connection
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Pkshih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <51d62a31-7cde-e815-bdee-4ef5433007aa@gmail.com>
 <F7CD281DE3E379468C6D07993EA72F84D17AF74C@RTITMBSVM04.realtek.com.tw>
From:   "David R. Bergstein" <david.r.bergstein@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david.r.bergstein@gmail.com; keydata=
 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
 cZPytJop3jxjNbB2ZRfwBXX3FsGBkJ4S2SKQyQ==
Message-ID: <b0518665-d5ca-7c94-9808-7cc0cf565814@gmail.com>
Date:   Thu, 28 Feb 2019 21:32:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17AF74C@RTITMBSVM04.realtek.com.tw>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony,

Thanks for your response.  Can you advise as to the availability of the
new rtw88 driver?  As it appears to be under development, I could not
locate a copy of the code for local compilation.

Sincerely,

David R. Bergstein

On 2/27/19 5:23 AM, Tony Chuang wrote:
>> This message is in regard to a bug I have open on bugs.launchpad.net, 1813372,
>> linked below.  This issue, originally identified in an Ubuntu kernel, has been
>> duplicated in the most current mainline kernel, 5.0-rc8, and is in regard to
>> problems attaining a wireless connection at 802.11ac speeds.
>>
>> https://bugs.launchpad.net/bugs/1813372
>>
>> At your earliest convenience, please see the bug report above, and advise if a fix
>> will be available for the r8822be kernel module.
>>
>> Sincerely,
>>
>> David R. Bergstein
>>
> Hi,
>
> If it's possible I will suggest that you can use the new driver "rtw88" being
> reviewed now. rtw88 is better supported by Realtek and has significant
> improvement in contrast to r8822be. And also it is aim to better support
> 802.11ac series ICs, so it may help resolve your problem about 802.11ac
> connection speeds.
> Thanks!
>
> Yan-Hsuan
>
