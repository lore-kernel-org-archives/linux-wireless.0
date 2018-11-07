Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D5BC0044C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 21:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0697E20827
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 21:00:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Rn3zqmYk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0697E20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbeKHGdB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 01:33:01 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:38708 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbeKHGdB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 01:33:01 -0500
Received: by mail-yb1-f196.google.com with SMTP id u103-v6so5885242ybi.5
        for <linux-wireless@vger.kernel.org>; Wed, 07 Nov 2018 13:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=Q4vlTuqAKc30XIttFdsz/eqRbSPV/rYu6n8x4WO+zVc=;
        b=Rn3zqmYkA9xITd78680TmCk2f/ShQjYgOCXhL+VD17+unXTHlB2Umg4aiQx/lLq46a
         VxZcwhqYbZTX69NaZT8x1+gdI4nNPkoSe4yTBG7rs0+sXwp/cuMb/mimKLk5tOc5eJEq
         u8ZDm5x5wM9xudxstwwnjTBfv4NdpMWfUUUNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=Q4vlTuqAKc30XIttFdsz/eqRbSPV/rYu6n8x4WO+zVc=;
        b=M7Yqi2ZSRR2ZmkCnHA22QvP4wXCcJL2V1uTNlLvOHpHdamtKkQs4Y6OCdK8PBDGZ9N
         JDYO0Zzd4EZuTdGS5M3GuCQRivT/rVLRV5e8XUnpHLYP2oT6lk6308IN2SQZRVwcWhjb
         NGyOctzKchUT4wzPNM2y0HLUh4QhOuVC5DJkNc3ox94F0mC3yd8taS2I7fRtspv9watq
         +FFL6Hstmsn2C3vnickqWPIKWWW5zdm6DLXfAsersxo/gZmHtIunnAOTJrTrZ3/OgWEa
         /PiQG3VmleOCFfhpeHMk7RptgWRpSQYjWHBG9TZMbLL++u8o/yv72m3nLAyxKM/e4TG6
         pcrg==
X-Gm-Message-State: AGRZ1gJu5vkPWMbItWiQb5ELaybr4PNelTGyOaLZDYRrzqv4/acEOexc
        WEjEFMKEOp7OLhMqcpvzifM17FqLxmX4vg==
X-Google-Smtp-Source: AJdET5c/yDnkhjf/qZTg7/hKmPFUlymX+a2CxOmlOvd88AZFjIW1dRp9VCkEOBWAcD1zWdEyh1/Jqg==
X-Received: by 2002:a25:cfcc:: with SMTP id f195-v6mr2004590ybg.20.1541624452715;
        Wed, 07 Nov 2018 13:00:52 -0800 (PST)
Received: from [10.177.251.110] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id h62-v6sm396790ywa.53.2018.11.07.13.00.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Nov 2018 13:00:52 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: support STA info struct v7
To:     Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <1539289141-13689-1-git-send-email-dan.haab@luxul.com>
 <CACna6rxJUxGLw1P7d4nCRocHxSs3nyxBvHzr4YaDH9ES+kg39g@mail.gmail.com>
 <87r2fxciif.fsf@codeaurora.org>
Cc:     Rip Route <riproute@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com, Dan HAAB <dan.haab@luxul.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <9ba1e229-6d9a-b40a-cd4a-ae3a2e768d6c@broadcom.com>
Date:   Wed, 7 Nov 2018 22:00:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <87r2fxciif.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/7/2018 11:02 AM, Kalle Valo wrote:
> Rafał Miłecki <zajec5@gmail.com> writes:
>
>> On Thu, 11 Oct 2018 at 22:21, Dan Haab <riproute@gmail.com> wrote:
>>> The newest firmwares provide STA info using v7 of the struct. As v7
>>> isn't backward compatible, a union is needed.
>>>
>>> Even though brcmfmac does not use any of the new info it's important to
>>> provide the proper struct buffer. Without this change new firmwares will
>>> fallback to the very limited v3 instead of something in between such as
>>> v4.
>>>
>>> Signed-off-by: Dan Haab <dan.haab@luxul.com>
>>
>> It's too bad Broadcom's existing struct has been changed instead of
>> just being extended.
>>
>> The patch looks good to me though. I just wanted to share my opinion /
>> ping due to patch being marked as "Deferred".
>>
>> Reviewed-by: Rafał Miłecki <rafal@milecki.pl>
>
> Good that you brought this up, I wasn't sure what to do with it so I
> marked as Deferred. Arend, please let me know what I should do.

Currently there is no issue as there is currently no image in 
linux-firmware relying on v7 structure. However, it is not unlikely that 
people are using firmware from other sources. As said earlier I am fine 
with this change although v7 structure already was extended. I have a 
small remark on the patch, which I will send out later.

Regards,
Arend

