Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4EF3C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D824216FA
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:40:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pRSIektI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D824216FA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbeI0V7g (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 17:59:36 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41553 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbeI0V7g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 17:59:36 -0400
Received: by mail-ot1-f68.google.com with SMTP id e18-v6so2980740oti.8
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 08:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZgGttQ8robyb5pJ7qsH1Yngi+R6YvHVh4joWCYHv5D8=;
        b=pRSIektIWlGPN5Q9n+ZJe/WanNFT2b9HJ10kGzNp5l95bri1zaG7i/6FFTf7FNF7bH
         QHEQAEOIU70X2nx9sEMwm1vr857bGfHCsURXCWZ+YwnJLDpGt/8hO2d4sQYAUEs0lWEq
         fBKOnZ55gl8pTcLbHt6ctZ15lG6MZrbK2QS4BBAP9eE+QcpXodvFqkkvgTtO3SwM6t38
         GL9tChO0EcZ+FMfxJ2a2VX8Sje/dmujjCiW5Xp9sYtVp1sA26qkgS4yehVvnT5a6mmTp
         sFJ1DdRtoUmM/AM5JwamErl0vW/hmYEvTS6BZPgoUJnpWMUQ0kacfp1TuKE2ziXecUhc
         r6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZgGttQ8robyb5pJ7qsH1Yngi+R6YvHVh4joWCYHv5D8=;
        b=e4ud8bpv6TrM9CR8MTY1hYBiKPLtXMV27Xg7BVNQ8y9R0xjbzO0lI4tNYAadZ8iAiP
         L9dKcEeXfvg8gcMR7xEi+ZJnPN5tPXPl7qFiW8VO3GJY1BWvyK6hF6EH45OQbv3rOtE5
         qQccthnw2qmEDH7KLWvnS+IvlCrQQdpTWk+npvKHiIonqlTrzks9/YqJv3dJdCSxVsDp
         lH4s6HkuRMaZTMtZip048KKTS8wj1AgKMyX2P5MOh+6qzaf9mhDVwHhV6b89G+poLlK/
         fKAUtq6mgwTRP9d24Dd4JSth56dk0B/2ohS56WQ9cqNKUKaRKVRHDfNnBxAPtAnb/QXQ
         XUJw==
X-Gm-Message-State: ABuFfoi/L5gxA1LQKCqWGTJYtJGfXbLsmawQwkbDhw4qgEXveRH1k/Hl
        P2ex8lK2VMEQhRAzyg9h9Rc+mV9t
X-Google-Smtp-Source: ACcGV62w4HJXYnul3IaZmXKPL7gpdPm1hj/NQA9Evl3bO97sn8yOId9GPFnYNNO4PMgNgIFXnxI7AA==
X-Received: by 2002:a9d:30b:: with SMTP id 11-v6mr2397688otv.95.1538062845616;
        Thu, 27 Sep 2018 08:40:45 -0700 (PDT)
Received: from [192.168.1.107] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id m11-v6sm926000oif.27.2018.09.27.08.40.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 08:40:45 -0700 (PDT)
Subject: Re: [PATCH 01/12] rtwlan: main files
To:     Stanislaw Gruszka <sgruszka@redhat.com>, yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        pkshih@realtek.com, tehuang@realtek.com
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
 <1537509847-21087-2-git-send-email-yhchuang@realtek.com>
 <20180927135040.GA4712@redhat.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <a6b6803e-fd18-81f4-6465-d573aa5c9e2a@lwfinger.net>
Date:   Thu, 27 Sep 2018 10:40:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20180927135040.GA4712@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 9/27/18 8:50 AM, Stanislaw Gruszka wrote:
--snip

> 
>> +#define BIT_LEN_MASK_32(__bitlen) (0xFFFFFFFF >> (32 - (__bitlen)))
>> +#define BIT_OFFSET_LEN_MASK_32(__bitoffset, __bitlen)                          \
>> +	(BIT_LEN_MASK_32(__bitlen) << (__bitoffset))
>> +#define LE_P4BYTE_TO_HOST_4BYTE(__start) (le32_to_cpu(*((__le32 *)(__start))))
>> +#define LE_BITS_CLEARED_TO_4BYTE(__start, __bitoffset, __bitlen)               \
>> +	(LE_P4BYTE_TO_HOST_4BYTE(__start) &                                    \
>> +	 (~BIT_OFFSET_LEN_MASK_32(__bitoffset, __bitlen)))
>> +#define LE_BITS_TO_4BYTE(__start, __bitoffset, __bitlen)                       \
>> +	((LE_P4BYTE_TO_HOST_4BYTE(__start) >> (__bitoffset)) &                 \
>> +	 BIT_LEN_MASK_32(__bitlen))
>> +#define SET_BITS_TO_LE_4BYTE(__start, __bitoffset, __bitlen, __value)          \
>> +	do {                                                                   \
>> +		*((__le32 *)(__start)) = \
>> +		cpu_to_le32( \
>> +		LE_BITS_CLEARED_TO_4BYTE(__start, __bitoffset, __bitlen) |     \
>> +		((((u32)__value) & BIT_LEN_MASK_32(__bitlen)) << (__bitoffset))\
>> +		);                                                             \
>> +	} while (0)

Stanislaw,

I have never loved these macros, and it took a lot of time to get them to be 
endian correct. Could you point me to a method that would overwrite a portion of 
a 32-bit little-endian word that would be correct for both little- and 
big-endian machines? Keep in mind that Kalle hates the use of compile tests on 
__LITTLE_ENDIAN.

Thanks,

Larry


