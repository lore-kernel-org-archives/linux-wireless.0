Return-Path: <SRS0=3nVx=R2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA1FC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 07:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87380218B0
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 07:16:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YPNaJGfy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfCWHQ2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Mar 2019 03:16:28 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42734 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfCWHQ2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Mar 2019 03:16:28 -0400
Received: by mail-ed1-f67.google.com with SMTP id j89so3476726edb.9
        for <linux-wireless@vger.kernel.org>; Sat, 23 Mar 2019 00:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tjzLOSP7QzZmuUDuBIBWuvZMCJc5VqvbmgpgaJVF4/8=;
        b=YPNaJGfyhR22Auto3X8qHVgbG2c5o597A8jhAT+PkrqoD6UZodenZN+JzYUYJf3R1i
         lHJ54pRYS1S1sOxF23Um0+9cbcvBkHlNPnhB3/JWMyy2p6WNqnIJpveYBoqLnxhyxc+K
         CGBdIA143eRFaMuNlFgATR14gLkoWExDnlbEw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tjzLOSP7QzZmuUDuBIBWuvZMCJc5VqvbmgpgaJVF4/8=;
        b=RqIBvlFEbTIgxNCk8trbbSvLStLkvQZQwG57SKQC2dy73vs6xN4wTtDe5ctXVJvJRd
         OEFY5VpJxK9G/ywIL78UmU519oRC9kS5WsCryddxkyCMKTQe503vSjeFLuU+8orgQcsU
         WYWogdc5kLhNUEgU5uFWQXuGeI6vRifus29Lmx3LLwV/vXmbfH2IDfrqAOjghLpP5m1O
         ge677D30REkkpanqkHlfK+ZHBKnsyGTJhzpBYqWXRGATzJgpbaD29Zgolvd0DoUXPuoH
         OkIjPpc1R4Ub2jXh1eO52aUcb0ytROU26T9muibJvRkmr20FeXTKjnmu4yBmkg8TP7q7
         yJdQ==
X-Gm-Message-State: APjAAAVYbutZC+xRszoN4f6leyFGtTJIP25zzlm4zRCNOh71Tfbvhia4
        096N876f+GjGfBbamORWYIX+1w==
X-Google-Smtp-Source: APXvYqzkxNQ/6j/R5YItq4zmdUFUEbE1rNUNLEQDxl8XRyy8RjdEdIr3vpQH2RqYC0atrmwx7yPeZQ==
X-Received: by 2002:aa7:d9d2:: with SMTP id v18mr8972783eds.74.1553325386436;
        Sat, 23 Mar 2019 00:16:26 -0700 (PDT)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id p16sm211357ejb.13.2019.03.23.00.16.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Mar 2019 00:16:25 -0700 (PDT)
Subject: Re: [PATCH] ath10k: reset chip after supported check
To:     Christian Lamparter <chunkeey@gmail.com>,
        =?UTF-8?Q?Tomislav_Po=c5=beega?= <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org, openwrt-devel@lists.openwrt.org,
        kalle@codeaurora.org,
        =?UTF-8?Q?Micha=c5=82_Kazior?= <kazikcz@gmail.com>
References: <1553281120-22139-1-git-send-email-pozega.tomislav@gmail.com>
 <3337086.qEUs9xMCTV@debian64>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <fe853ec8-0dca-d931-8632-fbe4df5cfaf8@broadcom.com>
Date:   Sat, 23 Mar 2019 08:16:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <3337086.qEUs9xMCTV@debian64>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ Michał

On 3/22/2019 8:25 PM, Christian Lamparter wrote:
> On Friday, March 22, 2019 7:58:40 PM CET Tomislav Požega wrote:
>> When chip reset is done before the chip is checked if supported
>> there will be crash. Previous behaviour caused bootloops on
>> Archer C7 v1 units, this patch allows clean device boot without
>> excluding ath10k driver.
>>
> You need
> 
> Fixes: 1a7fecb766c8 ("ath10k: reset chip before reading chip_id in probe")
> 
> too

Looking at the commit subject makes me suspicious whether this is a 
proper fix.

>> Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/pci.c |   12 ++++++------
>>   1 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
>> index e24403c..ec681da 100644
>> --- a/drivers/net/wireless/ath/ath10k/pci.c
>> +++ b/drivers/net/wireless/ath/ath10k/pci.c
>> @@ -3619,12 +3619,6 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
>>   		goto err_deinit_irq;
>>   	}
>>   
>> -	ret = ath10k_pci_chip_reset(ar);
>> -	if (ret) {
>> -		ath10k_err(ar, "failed to reset chip: %d\n", ret);
>> -		goto err_free_irq;
>> -	}
>> -
>>   	bus_params.dev_type = ATH10K_DEV_TYPE_LL;
>>   	bus_params.link_can_suspend = true;
>>   	bus_params.chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);

It seems to me the chip reset was done explicitly *before* reading the 
chipid for a reason.

"""
ath10k: reset chip before reading chip_id in probe
There are some very rare cases with some hardware
configuration that the device doesn't init quickly
enough in which case reading chip_id yielded 0.
This caused driver to subsequently fail to setup
the device.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
"""

Might be the ath10k_pci_chip_reset() function needs to be modified to 
work properly for Archer C7 v1 units.

Regards,
Arend
