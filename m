Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B87C43381
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 03:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A876B20823
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 03:16:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ks+kYPap"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbfCBDQY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 22:16:24 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41644 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfCBDQY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 22:16:24 -0500
Received: by mail-qt1-f194.google.com with SMTP id v10so30244079qtp.8;
        Fri, 01 Mar 2019 19:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=iCrMRx3hb630A2wxwPkLxj7aOIlGrD8Tg5ChwcKkYO4=;
        b=Ks+kYPapu+B0XeR7EMSb2dKHDrBxcUipO5V2rQ24QI/Zhpe2lynQABAiU/hst/2GQJ
         H2hIJ9zFqm1HYRRmMzn2KnNqGvsPzsei9A/cGMdGNx3v76xz/MBDF7U/EZ1GbGwvGd6Z
         r7eEEpgxoASC6WGXAZXajZYPveKyh9M2DGZJbeItUIKobWmjx6Ii6w6Iw/skkdAABeln
         uJ/7WRVGCmaZJYtD6Uk88R7oijaavjXrBBtoCc0Q7hQWQhSSja3rR+rbpoXr2t/JTy7f
         5aoQns/6ImI9OLkQV1pTWTiEqXkH6tHAoHOmY+WU7ESUrDIpAIjsFhD9DcqJF8iOGhvQ
         GtEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=iCrMRx3hb630A2wxwPkLxj7aOIlGrD8Tg5ChwcKkYO4=;
        b=MaV0WgRtj/pn4U57SajsEjoiqvgVCjAP1qomeKabSco44wSqn/lm0EHOlrEDa+KirM
         10GS+wsRD2Zzf/ngXCH3RkoNcQmrJrfvu7+t7OXppQtPergBuhxPmRNGLiJyyOFrdAAr
         YtnrVeZ/upOPUvHXdPhmuJvzJn6fOb0aE1kULSACcOVYoYpcChnlWHXIE05lapQrPtsF
         ypQu9s43uWC8TcVCkqFU8ss6uqc11HJmIazTDAub9ZiMOBJB7Mi510RNpN9iO0Ppvu7s
         J5DeXbHsBLiffSAPjpxb95mnZdLk2ItVnYj2vNY8C5jaCawEid7VxMYubMkwIGNaW1zA
         i5Xw==
X-Gm-Message-State: APjAAAWyYIOWUo/XbqrwTpXKNYqzqQQROYJPLu5efvEiRWURJc1NekaQ
        HN9ziJwhlxgQ81GTo+EQZLVtGpvg
X-Google-Smtp-Source: APXvYqyhRNoxntc+A+exTR7Bd5jU+LRT98O8GnoGqyD11cBzBY/V/d5qIzcx/jn5+yyznwWEH+5jbw==
X-Received: by 2002:a0c:f2d3:: with SMTP id c19mr6285836qvm.230.1551496582332;
        Fri, 01 Mar 2019 19:16:22 -0800 (PST)
Received: from [192.168.1.199] (pool-108-28-156-19.washdc.fios.verizon.net. [108.28.156.19])
        by smtp.gmail.com with ESMTPSA id a68sm15056212qkj.82.2019.03.01.19.16.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 19:16:21 -0800 (PST)
Subject: Re: Realtek r8822be kernel module does not negotiate 802.11ac
 connection
From:   "David R. Bergstein" <david.r.bergstein@gmail.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Tony Chuang <yhchuang@realtek.com>
Cc:     Pkshih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <51d62a31-7cde-e815-bdee-4ef5433007aa@gmail.com>
 <F7CD281DE3E379468C6D07993EA72F84D17AF74C@RTITMBSVM04.realtek.com.tw>
 <b0518665-d5ca-7c94-9808-7cc0cf565814@gmail.com>
 <e68c6aae-8d71-266a-81fe-d078ac1ef38c@lwfinger.net>
 <6eb7af74-b1a8-d112-e027-6c14252af994@gmail.com>
 <487c350c-c455-b490-8de5-1d68760aa3dc@lwfinger.net>
 <2e39892d-d206-e87f-c802-d427c54277cf@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david.r.bergstein@gmail.com; keydata=
 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
 cZPytJop3jxjNbB2ZRfwBXX3FsGBkJ4S2SKQyQ==
Message-ID: <8706d34c-1fac-84ba-759d-18d96750636b@gmail.com>
Date:   Fri, 1 Mar 2019 22:16:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <2e39892d-d206-e87f-c802-d427c54277cf@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry,

Please disregard my last message.  The firmware is now installed and the
rtw88 module is working with my wireless router.  The next hurdle
appears to be setting the speed to 802.11ac as it is currently
connecting as an 802.11n client.

Sincerely,

David R. Bergstein

On 3/1/19 9:55 PM, David R. Bergstein wrote:
> Larry,
>
> Following up to your last reply, I blacklisted the r8822be module,
> rebooted and was unable to bring up the wireless interface via rtw88. 
> Below are some errors recorded in my system log:
>
>  
> [  267.509818] rtw_pci 0000:3d:00.0: Direct firmware load for
> rtw88/rtw8822b_fw.bin failed with error -2
> [  267.509821] rtw_pci 0000:3d:00.0: failed to request firmware
> [  267.511068] rtw_pci 0000:3d:00.0: mac power on failed
> [  267.511072] rtw_pci 0000:3d:00.0: failed to power on mac
> [  267.511073] rtw_pci 0000:3d:00.0: failed to setup chip efuse info
> [  267.511075] rtw_pci 0000:3d:00.0: failed to setup chip information
> [  267.512817] rtw_pci: probe of 0000:3d:00.0 failed with error -114
>
> As directed, I used the rtwpci module to perform load/unload the rtw88
> module before I saw the errors above.  Do I still need to install firmware?
>
> Sincerely,
>
> David R. Bergstein
>
> On 3/1/19 8:46 PM, Larry Finger wrote:
>> On 3/1/19 4:26 PM, David R. Bergstein wrote:
>>> Larry,
>>>
>>> Thanks for the response and detailed instructions, which allowed me to
>>> build and install the rtw88 kernel module.  I cannot however seem to get
>>> my system to actually use the module.  Just to recap this is an HP Omen
>>> laptop with secure boot disabled.  Upon boot-up both the new rtw88 and
>>> old r8822be modules are loaded.  If I unload the r8822be module the wifi
>>> network connection gets terminated, even if I unload/reload the rtw88
>>> module.
>>>
>>> Is there something else I should be doing prior to invoking rtw88, e.g.,
>>> blacklisting the old module?
>> Yes, r8822be must be blacklisted. Use the lsmod command to see what
>> modules are actually loaded. You load/unload rtw88 using the rtwpci
>> module.
>>
>> Larry
>>
