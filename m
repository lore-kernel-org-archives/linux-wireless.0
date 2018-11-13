Return-Path: <SRS0=dsQx=NY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8FDC43441
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 13:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7B88224E0
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 13:33:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7B88224E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387587AbeKMXbH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Nov 2018 18:31:07 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45048 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387583AbeKMXbH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Nov 2018 18:31:07 -0500
Received: by mail-ed1-f65.google.com with SMTP id n19-v6so10446126edq.11
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2018 05:32:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iyTcgoYrzaNArNoPuNhm5QlvSGmoxrw4LOJltufNJj0=;
        b=gIJ+C/bTWz3CXc5uckbYDLfSPDk+4V4ImtjBgjr/McWzpkz0uGvCGLl86kL0y1xtWt
         Ztbfkz+cVcTqIYFo9HHDANA7ryMT6PJ/yuOh4SvOIYAgzmXu1WpH66UXrxfxhKZqiDL4
         FqKojgNP9CxQtu7+aanPR+ujQvpnp93c5zNluCX3W6P3oTXfFbddLWVZ7RwiUkfBRu/p
         8Pz8F9gT1jIg/StH9ywsCYvnWe6gTI2JHCd427OPUgL+1jMrcAz7iQUUJCPVnCW5towg
         PFyLjJObYePVeC3EXhIMhXfxCJK1kbwCddcvIi8UMBxJaO2hORWjQMo47g+A0E04mD1Z
         e8jQ==
X-Gm-Message-State: AGRZ1gLtcAv1ZaUHTcm+zyeBcMBaxRJ4y2lni/FwsnohbUir/WAz1AQu
        MYmOACw71TrnnLf+nX6033NriQ==
X-Google-Smtp-Source: AJdET5f5XYMlHrcxwz82g54smJVHbplMBXhjQgKT/EtXFVSnrsrqvdssfoddqVIXfEBTM+HYRZRIEA==
X-Received: by 2002:a50:d6de:: with SMTP id l30-v6mr16447877edj.145.1542115976621;
        Tue, 13 Nov 2018 05:32:56 -0800 (PST)
Received: from shalem.localdomain (546A5441.cm-12-3b.dynamic.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id t20-v6sm2903435ejt.17.2018.11.13.05.32.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Nov 2018 05:32:55 -0800 (PST)
Subject: Re: [REGRESSION] brcmfmac: NULL pointer deference starting
 next-20181107
To:     Jon Hunter <jonathanh@nvidia.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <dbc5e8f9-6f14-77d2-be2a-f0738e13b773@nvidia.com>
 <9f72ac4f-a83a-7af7-3c26-b1ced6d98653@broadcom.com>
 <9e0a7997-4c14-a3a1-c935-d674270533aa@redhat.com>
 <000bfd39-10cf-661c-9512-0410782168dc@nvidia.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <b33e91b9-e375-5169-dda6-dc664700eefc@redhat.com>
Date:   Tue, 13 Nov 2018 14:32:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <000bfd39-10cf-661c-9512-0410782168dc@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

HI,

On 13-11-18 14:21, Jon Hunter wrote:
> 
> On 13/11/2018 10:40, Hans de Goede wrote:
>> Hi,
>>
>> On 13-11-18 11:24, Arend van Spriel wrote:
>>> + Ard as this involves EFI.
>>>
>>> On 11/12/2018 2:24 PM, Jon Hunter wrote:
>>>> Hi Hans, Kalle,
>>>>
>>>> Starting with next-20181107 I am seeing the following NULL pointer
>>>> deference on Tegra (note the firmware is missing on this board) ...
>>>>
>>>> [   14.072883] brcmfmac: brcmf_fw_alloc_request: using
>>>> brcm/brcmfmac4329-sdio for chip BCM4329/3
>>>>
>>>> [   14.130287] brcmfmac mmc1:0001:1: Direct firmware load for
>>>> brcm/brcmfmac4329-sdio.nvidia,cardhu-a04.txt failed with error -2
>>>>
>>>> [   14.156283] brcmfmac mmc1:0001:1: Direct firmware load for
>>>> brcm/brcmfmac4329-sdio.txt failed with error -2
>>>>
>>>> [   14.177769] Unable to handle kernel NULL pointer dereference at
>>>> virtual address 00000008
>>>>
>>>> [   14.197303] pgd = 60bfa5f1
>>>>
>>>> [   14.211842] [00000008] *pgd=00000000
>>>>
>>>> [   14.227373] Internal error: Oops: 5 [#1] SMP ARM
>>>>
>>>> [   14.244244] Modules linked in: brcmfmac sha256_generic sha256_arm
>>>> snd cfg80211 brcmutil soundcore snd_soc_tegra30_ahub tegra_wdt
>>>>
>>>> [   14.269109] CPU: 1 PID: 114 Comm: kworker/1:2 Not tainted
>>>> 4.20.0-rc1-next-20181107-gd881de3 #1
>>>>
>>>> [   14.269114] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
>>>>
>>>> [   14.269154] Workqueue: events request_firmware_work_func
>>>>
>>>> [   14.269177] PC is at efivar_entry_size+0x28/0x90
>>>>
>>>> [   14.269362] LR is at brcmf_fw_complete_request+0x3f8/0x8d4 [brcmfmac]
>>>>
>>>> [   14.269369] pc : [<c0c40718>]    lr : [<bf2a3ef4>]    psr: a00d0113
>>>>
>>>> [   14.269374] sp : ede7fe28  ip : ee983410  fp : c1787f30
>>>>
>>>> [   14.269378] r10: 00000000  r9 : 00000000  r8 : bf2b2258
>>>>
>>>> [   14.269384] r7 : ee983000  r6 : c1604c48  r5 : ede7fe88  r4 :
>>>> edf337c0
>>>>
>>>> [   14.269389] r3 : 00000000  r2 : 00000000  r1 : ede7fe88  r0 :
>>>> c17712c8
>>>>
>>>
>>> Hi Jon,
>>>
>>> I tried building drivers/firmware/efi/vars.c using tegra_defconfig.
>>> Had to enable CONFIG_EFI. So the null pointer access is a 0x00000008
>>> so I looked at the disassembly below:
>>>
>>> int efivar_entry_size(struct efivar_entry *entry, unsigned long *size)
>>> {
>>>        310:       e1a05001        mov     r5, r1
>>>           const struct efivar_operations *ops = __efivars->ops;
>>> ==>  314:       e5936008        ldr     r6, [r3, #8]
>>>
>>> So I think __efivars is NULL on your platform. It is private to the
>>> source file. Not sure how the driver should deal with this. Maybe use
>>> efi_enabled() but not sure what feature to use. My best bet would be
>>> EFI_RUNTIME_SERVICES.
>>
>> Ah right, thank you for catching this I had looking into this
>> on my TODO list, but you beat me to it.
>>
>> IMHO the best fix here would be to modify efivar_entry_size(),
>> adding:
>>
>>      if (!ops)
>>          return -ENOENT;
>>
>> Which makes it return the same error as when we do have efivar
>> support but the requested variable is not found.
> 
> So the above did not work. I see a patch from Arend and I will give this
> a try.

Ah right, looking at Arend's patch my little snippet got the test wrong.

Hopefully Arend's patch will fix things.

Regards,

Hans

