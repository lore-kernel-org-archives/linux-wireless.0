Return-Path: <SRS0=dsQx=NY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D82BC43441
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 10:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B5422245E
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 10:45:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="beEYJTJ1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B5422245E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732262AbeKMUm5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Nov 2018 15:42:57 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:46770 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732148AbeKMUm5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Nov 2018 15:42:57 -0500
Received: by mail-yw1-f67.google.com with SMTP id t13so1392900ywe.13
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2018 02:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding;
        bh=uhLDWAdKFheYTWB5c+KMsVV/tAr5gulZR8GUqApDmpM=;
        b=beEYJTJ1E7tN7lai6iqvsSrI0BDxnUSqnzDHaXFdKS5UCZpju+kJ6N0NNinBWI8HZT
         +Axaj8hoyWY3WYCrjoJhSQ7zmrRKD183+Zhpz/n3ykN9tggANUQn9+LT/HuDtC6wV9bf
         +XWiFMYnb1aUynbzHhKS066HXJJtokDROvydM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=uhLDWAdKFheYTWB5c+KMsVV/tAr5gulZR8GUqApDmpM=;
        b=iD1K+yuE8QMspjQsG1OcopZa7o2b1mMekQ9X7hUcYoorVwLzMOAcUOaTlvEX0oTDNx
         T2t0/pstnfII7mzfrT38DX8dTC+dm5A3wOEAtUHm1dcvusCGnYdXEvbdNl+CrhNzN3PX
         gbMp2SPueZJH/t7R5ffD91CH1JX/KMEZH93G1lfR2TJ7KBO/HO4XThjRdv4oTX0cIKEL
         d6LjN7yF/xd3JqB2gLFq/w3ByVIZPgMxyqks5gNkt3J3jEL1k95l+toWjfzIWGTEPUST
         8wwex5F/eELGo1TpLr6BvFnpQ/CBYeAKq7rSeW9EuyoGj/JVP3lyX4FiQzeutOhyhQ7+
         tsUQ==
X-Gm-Message-State: AGRZ1gJptAWa8iqGpbM94hpivnJCmzA7s3iMfLsysc9zGbEYGbvwoeUW
        +qFl4HT2ddBVU6scnFSMeHlYtA==
X-Google-Smtp-Source: AJdET5fRVtHweq+d3eHJyr39rA/My2SX3bqhV8qq+qNJS1iltyo9tTr469hrJjPLVSnC2SbrH8sBRQ==
X-Received: by 2002:a0d:e984:: with SMTP id s126-v6mr4159338ywe.47.1542105924330;
        Tue, 13 Nov 2018 02:45:24 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id 207-v6sm4951053yww.21.2018.11.13.02.45.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Nov 2018 02:45:23 -0800 (PST)
Subject: Re: [REGRESSION] brcmfmac: NULL pointer deference starting
 next-20181107
To:     Hans de Goede <hdegoede@redhat.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <dbc5e8f9-6f14-77d2-be2a-f0738e13b773@nvidia.com>
 <9f72ac4f-a83a-7af7-3c26-b1ced6d98653@broadcom.com>
 <9e0a7997-4c14-a3a1-c935-d674270533aa@redhat.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5a34ee3c-53e5-18d3-9945-68e958566e74@broadcom.com>
Date:   Tue, 13 Nov 2018 11:45:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <9e0a7997-4c14-a3a1-c935-d674270533aa@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/13/2018 11:40 AM, Hans de Goede wrote:
> Hi,
>
> On 13-11-18 11:24, Arend van Spriel wrote:
>> + Ard as this involves EFI.
>>
>> On 11/12/2018 2:24 PM, Jon Hunter wrote:
>>> Hi Hans, Kalle,
>>>
>>> Starting with next-20181107 I am seeing the following NULL pointer
>>> deference on Tegra (note the firmware is missing on this board) ...
>>>
>>> [   14.072883] brcmfmac: brcmf_fw_alloc_request: using
>>> brcm/brcmfmac4329-sdio for chip BCM4329/3
>>>
>>> [   14.130287] brcmfmac mmc1:0001:1: Direct firmware load for
>>> brcm/brcmfmac4329-sdio.nvidia,cardhu-a04.txt failed with error -2
>>>
>>> [   14.156283] brcmfmac mmc1:0001:1: Direct firmware load for
>>> brcm/brcmfmac4329-sdio.txt failed with error -2
>>>
>>> [   14.177769] Unable to handle kernel NULL pointer dereference at
>>> virtual address 00000008
>>>
>>> [   14.197303] pgd = 60bfa5f1
>>>
>>> [   14.211842] [00000008] *pgd=00000000
>>>
>>> [   14.227373] Internal error: Oops: 5 [#1] SMP ARM
>>>
>>> [   14.244244] Modules linked in: brcmfmac sha256_generic sha256_arm
>>> snd cfg80211 brcmutil soundcore snd_soc_tegra30_ahub tegra_wdt
>>>
>>> [   14.269109] CPU: 1 PID: 114 Comm: kworker/1:2 Not tainted
>>> 4.20.0-rc1-next-20181107-gd881de3 #1
>>>
>>> [   14.269114] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
>>>
>>> [   14.269154] Workqueue: events request_firmware_work_func
>>>
>>> [   14.269177] PC is at efivar_entry_size+0x28/0x90
>>>
>>> [   14.269362] LR is at brcmf_fw_complete_request+0x3f8/0x8d4 [brcmfmac]
>>>
>>> [   14.269369] pc : [<c0c40718>]    lr : [<bf2a3ef4>]    psr: a00d0113
>>>
>>> [   14.269374] sp : ede7fe28  ip : ee983410  fp : c1787f30
>>>
>>> [   14.269378] r10: 00000000  r9 : 00000000  r8 : bf2b2258
>>>
>>> [   14.269384] r7 : ee983000  r6 : c1604c48  r5 : ede7fe88  r4 :
>>> edf337c0
>>>
>>> [   14.269389] r3 : 00000000  r2 : 00000000  r1 : ede7fe88  r0 :
>>> c17712c8
>>>
>>
>> Hi Jon,
>>
>> I tried building drivers/firmware/efi/vars.c using tegra_defconfig.
>> Had to enable CONFIG_EFI. So the null pointer access is a 0x00000008
>> so I looked at the disassembly below:
>>
>> int efivar_entry_size(struct efivar_entry *entry, unsigned long *size)
>> {
>>       310:       e1a05001        mov     r5, r1
>>          const struct efivar_operations *ops = __efivars->ops;
>> ==>  314:       e5936008        ldr     r6, [r3, #8]
>>
>> So I think __efivars is NULL on your platform. It is private to the
>> source file. Not sure how the driver should deal with this. Maybe use
>> efi_enabled() but not sure what feature to use. My best bet would be
>> EFI_RUNTIME_SERVICES.
>
> Ah right, thank you for catching this I had looking into this
> on my TODO list, but you beat me to it.
>
> IMHO the best fix here would be to modify efivar_entry_size(),
> adding:
>
>     if (!ops)
>         return -ENOENT;
>
> Which makes it return the same error as when we do have efivar
> support but the requested variable is not found.

That was my first thought, but I just wanted Jon to try modifying 
brcmfmac and confirm. I can create a patch like above and maybe a patch 
adding sanity checks in efivars_register().

Regards,
Arend
