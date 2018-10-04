Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F395BC64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 16:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB331206B2
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 16:20:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CtjtqsRa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB331206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbeJDXOB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 19:14:01 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:42593 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbeJDXOA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 19:14:00 -0400
Received: by mail-oi1-f193.google.com with SMTP id w81-v6so7943512oiw.9
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2018 09:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fcA+6lSdOhTn8hhxM0ZLKx6LRQFLAOsq0aSYxuzNOlI=;
        b=CtjtqsRar6H8Rd6KOSoz/wE6DKVzQUb4Tcmd0hb91c6dpHKXOzwcPiwJeo9jGHDfmW
         EG98WflxdjSMpPTH9JIYMkmD2fkzwYKTH4eerYq7kyvbKjVNO1daLU0mg3b9VWMzgHbX
         MkrRaVmmteXjLovdv2rykgiaOm1k+hJuwPsJWghI7la3NQtC8ptsnNnwitDDht3qZeiE
         Uj5bmJbdij8sXkHSUkIr7Q5UesmF4y6JpQQtN1qEKdMXJqqyM/VqZs0HQY2dTzCXieEJ
         vnsXOA4hDNDL/dzHIYU8jGt43+tR1vEF5bJy3KJKPMy9yevnZ4Q5bV8NmVfzDjxLELD4
         a/Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fcA+6lSdOhTn8hhxM0ZLKx6LRQFLAOsq0aSYxuzNOlI=;
        b=YlibZPquNe6KSrjHJFybiPLsvOXKSSLUS7XAY3ymeLOTKpZE3s4ELRp6jai8Rmx/j1
         Ey4U//G87oXzHm4d7uxZRUr732+HnEGLW/4C0t0X7rYzS8RqsjeRX+owSuWnPnGtzZvG
         KEIPzJFMEmPrZ7vQJvbq7z1POxzerIvUkUfrVBTAKMCSzjRuDSxONpYx9KexCUZ4VrJn
         B+H2g2XQM+kz1n1yZjLfT1e+Oihwsf5H98V0v1vcKxib2+0c1qU78XJ68U4rsGdnXpdT
         AosV8wxHwEB56rA8QlXqTZBQ5QdDmubRWvK4DZC/7hejCCKtFIPAkcGaGdh0nHpXhjUa
         XI1Q==
X-Gm-Message-State: ABuFfohxE9MxqChPvT8x5GDvwRcM4R/hZDXGdG38H1VoxAxDQaq87Nlr
        AzHePtJkbzInr/KMQiuu3gIh7L8J
X-Google-Smtp-Source: ACcGV62c/3NdfCcAXZ7o+pBK2MF4mDR4nLum2YiQ19FcjkenAhpb7v/7/mnxnboRuqtPH1k626NKWQ==
X-Received: by 2002:aca:34d6:: with SMTP id b205-v6mr3237743oia.77.1538670001599;
        Thu, 04 Oct 2018 09:20:01 -0700 (PDT)
Received: from [192.168.1.107] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id a9-v6sm1649007otl.56.2018.10.04.09.20.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Oct 2018 09:20:00 -0700 (PDT)
Subject: Re: [PATCH 01/12] rtwlan: main files
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
References: <1537509847-21087-2-git-send-email-yhchuang@realtek.com>
 <20180927135040.GA4712@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D08D9F56@RTITMBSVM01.realtek.com.tw>
 <20180928092918.GC8323@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D08DB7E3@RTITMBSVM01.realtek.com.tw>
 <20181002102957.GB25116@redhat.com>
 <a54dec4e-1164-f9c5-c791-3396a239eeba@lwfinger.net>
 <F7CD281DE3E379468C6D07993EA72F84D1728978@RTITMBSVM01.realtek.com.tw>
 <4b50e06f-2fd0-9378-d283-1ca6d02f9586@lwfinger.net>
 <87k1mx28dg.fsf@codeaurora.org> <20181004134252.GA20484@redhat.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <2fa15cec-bcef-35af-43af-5365d52d82c8@lwfinger.net>
Date:   Thu, 4 Oct 2018 11:19:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20181004134252.GA20484@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/4/18 8:42 AM, Stanislaw Gruszka wrote:
> On Thu, Oct 04, 2018 at 03:39:55PM +0300, Kalle Valo wrote:
>>>> Can we put the configuration file in the firmware directory?
>>>> Should we package them into binary files? Or just put the raw data.
>>>>
>>>> We can test the performance for it. After we got the result, we will make a decision
>>>> about it. And if we decide to put them in the firmware directory, will send a patch.
>>>> For now, I think we can just leave them in the .c.
>>>
>>> Yes, you could put the configuration files in the firmware directory.
>>> I would put them in binary form, not as text files. That way the size
>>> would be smaller, and it would not be possible to alter them,
>>> particularly if the binary file is checksummed.
>>>
>>> It would likely be OK if only the agc table was stored in this way.
>>> That would take away about half of the lines in the 8822b table file.
>>
>> So what's the worry here? The lines of source code, binary size or what?
>>
>>   .../net/wireless/realtek/rtw88/rtw8822b_table.c    | 20783 +++++++++++++++++++
>>
>> Looking at the diffstat rtw8822b_table.c seems to be 20 kLOC, IMHO it's
>> not that bad as it's just data. But of course I might be missing
>> something as I haven't checked patches yet.
> 
> My concern was it's plenty of redundant data, for example:
> 
>          0x81C, 0xFF000003,
>          0x81C, 0xFE000003,
>          0x81C, 0xFD020003,
>          0x81C, 0xFC040003,
>          0x81C, 0xFB060003,
>          0x81C, 0xFA080003,
>          0x81C, 0xF90A0003,
>          0x81C, 0xF80C0003,
>          0x81C, 0xF70E0003,
>          0x81C, 0xF6100003,
> 
> Approx 10000 lines like this, braked by lines like this
> 
>          0x90000012,     0x00000000,     0x40000000,     0x00000000,
> 
> in more or less regular way.
> 
> Not big deal, but perhaps this could be coded in much more compact way.

What should be the tradeoff between large tables of redundant data and 
complicated generation and interpretation? I think this table should be 
converted to binary in its present form and added to the "firmware", the way 
that is done for b43. That way the source is smaller, and the loading will be 
only a bit more time consuming.

Larry

