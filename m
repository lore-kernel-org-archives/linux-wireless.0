Return-Path: <SRS0=dsQx=NY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58635C43441
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 10:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 152FD22507
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 10:40:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 152FD22507
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732327AbeKMUhn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Nov 2018 15:37:43 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36797 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732220AbeKMUhn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Nov 2018 15:37:43 -0500
Received: by mail-ed1-f67.google.com with SMTP id f23so748122edb.3
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2018 02:40:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iCcxhaSHcYqU7vIdql5rPGJ3Zl5aUVJMH1jrSewWVJY=;
        b=hrXoE9zRdO0bAZ0GF0nUfcuDb8GoYgPvimvzGfuVTrzZEHUojB9Xuu+juW7DDgbvF/
         T4M9qKE73Kl5h3w9ObNwbURhpkAEYf3Co8WFTjXUOCnvdLMzbwF/yXjN0QlyAiUFjDJx
         GhFO8Om3ryAs3fWy6R4Z+V5gXe6zbhBXPKKQOjxEEjVPk9GlCu6KFKL5LaZX2n0jOB91
         +ij2FylLgja1pzB3E7I5EQhirSa/hPeHyecseCqZuXjiRm+OnsularLJMnKWzn+jRNBC
         vFzacJMyMkoq5Ch3vksVGM0WEZIcCsEiyJRhgGkInhbsGKHvy02chYZZNo4HcF/lN9Ko
         uwzA==
X-Gm-Message-State: AGRZ1gK/BHuUsEYVg4rLS4J0S9bSOnDxkf3DZqamnuDjff8R3+S9/P0A
        +N/HAyzcrAKuwqNCFHlwBbx1JA==
X-Google-Smtp-Source: AJdET5fTZm9V/6Ezr76jh5cc8ksnMpR0nxGCoWWZzY2Nu7GBJ89CDWi6I02Qw9EPl0Sszh2CKomAEA==
X-Received: by 2002:a50:8704:: with SMTP id i4-v6mr16088836edb.53.1542105610453;
        Tue, 13 Nov 2018 02:40:10 -0800 (PST)
Received: from shalem.localdomain (546A5441.cm-12-3b.dynamic.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id t1-v6sm5114793eds.44.2018.11.13.02.40.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Nov 2018 02:40:09 -0800 (PST)
Subject: Re: [REGRESSION] brcmfmac: NULL pointer deference starting
 next-20181107
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <dbc5e8f9-6f14-77d2-be2a-f0738e13b773@nvidia.com>
 <9f72ac4f-a83a-7af7-3c26-b1ced6d98653@broadcom.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <9e0a7997-4c14-a3a1-c935-d674270533aa@redhat.com>
Date:   Tue, 13 Nov 2018 11:40:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <9f72ac4f-a83a-7af7-3c26-b1ced6d98653@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On 13-11-18 11:24, Arend van Spriel wrote:
> + Ard as this involves EFI.
> 
> On 11/12/2018 2:24 PM, Jon Hunter wrote:
>> Hi Hans, Kalle,
>>
>> Starting with next-20181107 I am seeing the following NULL pointer
>> deference on Tegra (note the firmware is missing on this board) ...
>>
>> [   14.072883] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4329-sdio for chip BCM4329/3
>>
>> [   14.130287] brcmfmac mmc1:0001:1: Direct firmware load for brcm/brcmfmac4329-sdio.nvidia,cardhu-a04.txt failed with error -2
>>
>> [   14.156283] brcmfmac mmc1:0001:1: Direct firmware load for brcm/brcmfmac4329-sdio.txt failed with error -2
>>
>> [   14.177769] Unable to handle kernel NULL pointer dereference at virtual address 00000008
>>
>> [   14.197303] pgd = 60bfa5f1
>>
>> [   14.211842] [00000008] *pgd=00000000
>>
>> [   14.227373] Internal error: Oops: 5 [#1] SMP ARM
>>
>> [   14.244244] Modules linked in: brcmfmac sha256_generic sha256_arm snd cfg80211 brcmutil soundcore snd_soc_tegra30_ahub tegra_wdt
>>
>> [   14.269109] CPU: 1 PID: 114 Comm: kworker/1:2 Not tainted 4.20.0-rc1-next-20181107-gd881de3 #1
>>
>> [   14.269114] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
>>
>> [   14.269154] Workqueue: events request_firmware_work_func
>>
>> [   14.269177] PC is at efivar_entry_size+0x28/0x90
>>
>> [   14.269362] LR is at brcmf_fw_complete_request+0x3f8/0x8d4 [brcmfmac]
>>
>> [   14.269369] pc : [<c0c40718>]    lr : [<bf2a3ef4>]    psr: a00d0113
>>
>> [   14.269374] sp : ede7fe28  ip : ee983410  fp : c1787f30
>>
>> [   14.269378] r10: 00000000  r9 : 00000000  r8 : bf2b2258
>>
>> [   14.269384] r7 : ee983000  r6 : c1604c48  r5 : ede7fe88  r4 : edf337c0
>>
>> [   14.269389] r3 : 00000000  r2 : 00000000  r1 : ede7fe88  r0 : c17712c8
>>
> 
> Hi Jon,
> 
> I tried building drivers/firmware/efi/vars.c using tegra_defconfig. Had to enable CONFIG_EFI. So the null pointer access is a 0x00000008 so I looked at the disassembly below:
> 
> int efivar_entry_size(struct efivar_entry *entry, unsigned long *size)
> {
>       310:       e1a05001        mov     r5, r1
>          const struct efivar_operations *ops = __efivars->ops;
> ==>  314:       e5936008        ldr     r6, [r3, #8]
> 
> So I think __efivars is NULL on your platform. It is private to the source file. Not sure how the driver should deal with this. Maybe use efi_enabled() but not sure what feature to use. My best bet would be EFI_RUNTIME_SERVICES.

Ah right, thank you for catching this I had looking into this
on my TODO list, but you beat me to it.

IMHO the best fix here would be to modify efivar_entry_size(),
adding:

	if (!ops)
		return -ENOENT;

Which makes it return the same error as when we do have efivar
support but the requested variable is not found.

Regards,

Hans





> 
>          efi_status_t status;
> 
>          *size = 0;
>       318:       e3a03000        mov     r3, #0
>       31c:       e5813000        str     r3, [r1]
> 
>          if (down_interruptible(&efivars_lock))
>       320:       ebfffffe        bl      0 <down_interruptible>
>       324:       e2504000        subs    r4, r0, #0
>       328:       1a000012        bne     378 <efivar_entry_size+0x80>
>                  return -EINTR;
>          status = ops->get_variable(entry->var.VariableName,
> 
> Regards,
> Arend
> 
>> [   14.269398] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
>>
>> [   14.269404] Control: 10c5387d  Table: ad16804a  DAC: 00000051
>>
>> [   14.269417] Process kworker/1:2 (pid: 114, stack limit = 0x984bfbff)
>>
>> [   14.269423] Stack: (0xede7fe28 to 0xede80000)
>>
>> [   14.269434] fe20:                   00000000 c1604c48 edf336e0 edf337c0 ee983000 c1604c48
>>
>> [   14.269447] fe40: edf336e0 bf2a3ef4 edf339db c0466bcc edf339c0 edd1417c edd14008 00000000
>>
>> [   14.269460] fe60: 006000c0 edf33b40 edf339c0 edf33250 c0f9110c edf33b40 c17db2d0 edf339c0
>>
>> [   14.269471] fe80: 00000000 edd14008 00000000 0076006e 00610072 0000006d edf33940 00000003
>>
>> [   14.269482] fea0: edf33980 c0923f84 edf33840 edf33940 edf33980 ede7ff1c c0f9110c c0924410
>>
>> [   14.269492] fec0: 7fffffff d9025ae9 00000001 edf337c0 00000000 ef7b9e00 edf33804 ef7bd000
>>
>> [   14.269512] fee0: 00000000 00000000 c1787f30 bf2a4438 ee952280 00000000 edf33800 ee952280
>>
>> [   14.678917] ff00: ef7b9e00 edf33804 ef7bd000 c0924738 00000000 00000003 00000001 edf33940
>>
>> [   14.678931] ff20: edf33800 c035ee0c ef7b9e00 ef7b9e18 ede7e018 ee952280 ef7b9e00 ef7b9e18
>>
>> [   14.720757] ff40: ede7e018 c17878b8 ee952294 c1603d00 00000008 c035f130 eea99d9c ede7e000
>>
>> [   14.720769] ff60: ee970740 c1603d00 eea99d9c eea99d80 ee970740 00000000 eea99d9c ee952280
>>
>> [   14.720785] ff80: c035f0f0 ee911ebc 00000000 c0364418 ee970740 c03642f0 00000000 00000000
>>
>> [   14.783682] ffa0: 00000000 00000000 00000000 c03010e8 00000000 00000000 00000000 00000000
>>
>> [   14.783693] ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>>
>> [   14.783707] ffe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
>>
>> [   14.846132] [<c0c40718>] (efivar_entry_size) from [<bf2a3ef4>] (brcmf_fw_complete_request+0x3f8/0x8d4 [brcmfmac])
>>
>> [   14.846253] [<bf2a3ef4>] (brcmf_fw_complete_request [brcmfmac]) from [<bf2a4438>] (brcmf_fw_request_done+0x68/0x11c [brcmfmac])
>>
>> [   14.893363] [<bf2a4438>] (brcmf_fw_request_done [brcmfmac]) from [<c0924738>] (request_firmware_work_func+0x40/0x68)
>>
>> [   14.893396] [<c0924738>] (request_firmware_work_func) from [<c035ee0c>] (process_one_work+0x164/0x448)
>>
>> [   14.939206] [<c035ee0c>] (process_one_work) from [<c035f130>] (worker_thread+0x40/0x524)
>>
>> [   14.939228] [<c035f130>] (worker_thread) from [<c0364418>] (kthread+0x128/0x158)
>>
>> [   14.981096] [<c0364418>] (kthread) from [<c03010e8>] (ret_from_fork+0x14/0x2c)
>>
>> [   14.981102] Exception stack(0xede7ffb0 to 0xede7fff8)
>>
>> [   14.981112] ffa0:                                     00000000 00000000 00000000 00000000
>>
>> [   15.041390] ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>>
>> [   15.041399] ffe0: 00000000 00000000 00000000 00000000 00000013 00000000
>>
>> [   15.041415] Code: e1a07000 e30102c8 e34c0177 e1a05001 (e5926008)
>>
>> [   15.041491] ---[ end trace 06697c36d390de92 ]---
>>
> 
