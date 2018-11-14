Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDEDAC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 11:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 928CC2243E
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 11:29:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PevdFL0E"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 928CC2243E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbeKNVcW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 16:32:22 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37075 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728141AbeKNVcW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 16:32:22 -0500
Received: by mail-pg1-f193.google.com with SMTP id 80so7250114pge.4
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2018 03:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=Y+mOCcBGQHK0ojrMn0beD9G5K2cewNlgIzf+7gAKeuU=;
        b=PevdFL0E4aYKcWoA9OTfhkuIfcBwdlWIimaz8TejUJnyg7qOe1jUBNC83dJdW2pB39
         BLHd0IHIBpuWnVpWptSCdc4qB+cnqeFdkRn5wYXAQwiwQkQ1EHR9vIIrwd2LL6xpnZqV
         Bo6PlmLkTL/BjMq6VWrL/Vz5uX11NvYo90Lt0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=Y+mOCcBGQHK0ojrMn0beD9G5K2cewNlgIzf+7gAKeuU=;
        b=enylQey6xximnT0hoP+CWZTrfMgwlH518jmRbITeNznZ1Ko5IBaGYsIgaJlBff/Kb7
         8jmAMNx69g3fEP8oDLsFl7pf6BkHctUeHtNBpQrGyq+24SoBje9yvTIae+b/zBBdfzYW
         Vz9nBup0xIi6QPNbrOId+cJmpz5ORePFj2g3/6UedJHHcXD8/Fj2E6K+j7yxayePsvfK
         pFwkIOaZECABTP8m6Sy0PUTafDeD7zP3cBWzlH/U7txSw7nR5IfJekdZwjGdeDtcbNHB
         wlTe77eU5O3BzcdLPPV4EeCcmq/hrZw0U4zonMGZBw2teQcthzXkUtgBLRMiBF6+TQZk
         w2tQ==
X-Gm-Message-State: AGRZ1gItNR0Z6y+brCyXbyGBa+UqpSvLFtPuy9nik9pOjgxE3vpWomPB
        cqiWZlUpGdRKWnuMA5OUyr4EGLQVwJbWhg==
X-Google-Smtp-Source: AJdET5fcAcxctEAPB6/P8wlXpjup2SHb+XY7ISwrhwcyakbZsas/T1xebFrXsBur5kXFCZm6o3M+oA==
X-Received: by 2002:a62:5343:: with SMTP id h64-v6mr1549618pfb.226.1542194970057;
        Wed, 14 Nov 2018 03:29:30 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id p84-v6sm3656107pfi.85.2018.11.14.03.29.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Nov 2018 03:29:29 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: Use standard SKB list accessors in
 brcmf_sdiod_sglist_rw.
To:     Andy Duan <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20181110.163402.130407398146253939.davem@davemloft.net>
 <VI1PR0402MB36009CD578B9CDBF4449130FFFC30@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <9667eb4f-36a1-0439-867b-1defc5946bc2@broadcom.com>
 <VI1PR0402MB3600F31F8665EB1BDAFBAE36FFC30@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <6679c7f3-9df2-1eb0-6f0d-725717460a82@broadcom.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c9020dd1-0ecb-5d2d-0e9e-2b31c38b2f64@broadcom.com>
Date:   Wed, 14 Nov 2018 12:29:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <6679c7f3-9df2-1eb0-6f0d-725717460a82@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/14/2018 11:57 AM, Arend van Spriel wrote:
> On 11/14/2018 11:54 AM, Andy Duan wrote:
>> From: Arend van Spriel [mailto:arend.vanspriel@broadcom.com] Sent:
>> 2018年11月14日 16:40
>>> To: Andy Duan <fugang.duan@nxp.com>; David Miller
>>> <davem@davemloft.net>; netdev@vger.kernel.org
>>> Cc: linux-wireless@vger.kernel.org
>>> Subject: Re: [PATCH] brcmfmac: Use standard SKB list accessors in
>>> brcmf_sdiod_sglist_rw.
>>>
>>> On 11/14/2018 4:28 AM, Andy Duan wrote:
>>>> From: David Miller <davem@davemloft.net> Sent: 2018年11月11日 8:34
>>>>> [ As I am trying to remove direct SKB list pointer accesses I am
>>>>>   committing this to net-next.  If this causes a lot of grief I
>>>>>   can and will revert, just let me know. ]
>>>
>>> [...]
>>>
>>>>
>>>> I just have bcm4339 in hands, test the patch on i.MX7D sdb board with
>>> bcm4339, it works fine with iperf testing.
>>>>
>>>> Tested-by: Fugang Duan <fugang.duan@nxp.com>
>>>
>>> Thanks, Andy
>>>
>>> Can you do one more check? Please insert brcmfmac with module parameter
>>> debug=2 and let me know if the following log message is seen:
>>>
>>> brcmfmac: brcmf_sdiod_sgtable_alloc: nents=X
>>>
>>> If not seen, the driver does not go through the patched code.
>> My kernel don't enable debug and DEBUG and CONFIG_BRCM_TRACING, I add
>> the debug info in the brcmf_sdiod_sgtable_alloc(), and the log show
>> the driver go through the sg path:
>> Log: brcmf_sdiod_sgtable_alloc: max_segs:128, sg_support:1, nents=35
>
> Thanks, Andy
>
> Works for me ;-)

I should better read the patch email. I tried to apply the patch to 
wireless-testing, but it failed simply because the patch is already in 
place through net-next as Dave mentioned. Anyway, it is good that it has 
been tested to some extent.

Regards,
Arend

