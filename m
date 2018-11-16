Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC55EC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 21:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F5B42082A
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 21:30:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OcZE+E+p"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F5B42082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbeKQHod (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 17 Nov 2018 02:44:33 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46035 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbeKQHoc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Nov 2018 02:44:32 -0500
Received: by mail-ed1-f68.google.com with SMTP id d39so17505762edb.12
        for <linux-wireless@vger.kernel.org>; Fri, 16 Nov 2018 13:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=pPYyVDyfaBcKjHm0lN9MsXzO+10dBJNrRmHiQm31cYs=;
        b=OcZE+E+pUYpw9zm2cDX447Q7vu/110MopYvUN8TuQsv8C+8UHsUPkOp10WudVa5bHl
         XN1XmxFgA8sZUskHlemLwvASlafK10bVd5CbimuiW0HfK3AGctmm6X2yoWMIQaAjmTLr
         4+eYcPrGPmy5DYDd9z+55hMV9rM/zuqucAylU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=pPYyVDyfaBcKjHm0lN9MsXzO+10dBJNrRmHiQm31cYs=;
        b=GqONVLAYk9NDUwH732KGESYtF+Vg0vVfcY92PaCW2YplbrPnY7ZoGkJRqBWA06bEku
         RGgvIJQd96l5T0Rb29+WGNRaT1NAjZW097E5b7UxTK0xxhTvPXge79zCQoLTxAP3b3JB
         s6G8vEzROjhgd8hHJXvcEofoTTnkTJfZomCBvftkrqLGMoM2jc1h4kLRSYoJWXF1EB6M
         qMZQjrAaCqvfykCQdNVGhD01EP9v+dJEoSbkrQDQ/rgwGOjWMk12ENyF7ge0U/HtvzXy
         sGZMZHdRqlgOOPxygRzO7rfcJw8ERqpXsHlSBYl/deEedbzLmHie/sUHqghe0rzS88CT
         vASA==
X-Gm-Message-State: AGRZ1gIyM4WMLRjlTsdCJG5H5ZLe0vtd3x+M2kDCLw8EuJqslCzxUQdL
        QrmCgTISZ5VIsi1wC1yVDWeQAQ==
X-Google-Smtp-Source: AJdET5cZNOG35nB92UFQ4JNllaKEYWx82tHxp6C3B41NYL/N+pLw1SDBhV1qgcUpmItdilXTHyA9xQ==
X-Received: by 2002:a50:a4c8:: with SMTP id x8-v6mr11281956edb.210.1542403825610;
        Fri, 16 Nov 2018 13:30:25 -0800 (PST)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id f31sm2869526eda.16.2018.11.16.13.30.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Nov 2018 13:30:24 -0800 (PST)
Subject: Re: [PATCH] firmware: efi: add NULL pointer checks in efivars api
 functions
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <1542142278-14352-1-git-send-email-arend.vanspriel@broadcom.com>
 <CAKv+Gu8FK7=gcRVg--GX3LMA9fmGtvMkxDuXF8UEWuGpKq4HTA@mail.gmail.com>
 <524197b4-4f2b-00d6-2509-22ed4b3b3f5d@broadcom.com>
 <CAKv+Gu8oQeMLZo=DtvS+D=7GcadSrqhSX2pndHOr-KTQQ2fxPw@mail.gmail.com>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Hans de Goede <hdegoede@redhat.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c32a6efa-802b-880a-a1aa-46bfdcc5d814@broadcom.com>
Date:   Fri, 16 Nov 2018 22:30:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu8oQeMLZo=DtvS+D=7GcadSrqhSX2pndHOr-KTQQ2fxPw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/15/2018 2:54 PM, Ard Biesheuvel wrote:
> On Tue, 13 Nov 2018 at 15:04, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>>
>> On 11/13/2018 11:50 PM, Ard Biesheuvel wrote:
>>> Hi Arend,
>>>
>>> On Tue, 13 Nov 2018 at 12:51, Arend van Spriel
>>> <arend.vanspriel@broadcom.com> wrote:
>>>>
>>>> Since commit ce2e6db554fa ("brcmfmac: Add support for getting nvram
>>>> contents from EFI variables") we have a device driver accessing the
>>>> efivars api (since next-20181107). Several functions in efivars api
>>>> assume __efivars is set, ie. will be accessed after efivars_register()
>>>> has been called. However, following NULL pointer access was reported
>>>> calling efivar_entry_size() from the brcmfmac device driver.
>>>>
>>>> [   14.177769] Unable to handle kernel NULL pointer dereference at
>>>>                 virtual address 00000008
>>>> [   14.197303] pgd = 60bfa5f1
>>>> [   14.211842] [00000008] *pgd=00000000
>>>> [   14.227373] Internal error: Oops: 5 [#1] SMP ARM
>>>> [   14.244244] Modules linked in: brcmfmac sha256_generic sha256_arm snd cfg80211 brcmutil soundcore snd_soc_tegra30_ahub tegra_wdt
>>>> [   14.269109] CPU: 1 PID: 114 Comm: kworker/1:2 Not tainted 4.20.0-rc1-next-20181107-gd881de3 #1
>>>> [   14.269114] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
>>>> [   14.269154] Workqueue: events request_firmware_work_func
>>>> [   14.269177] PC is at efivar_entry_size+0x28/0x90
>>>> [   14.269362] LR is at brcmf_fw_complete_request+0x3f8/0x8d4 [brcmfmac]
>>>> [   14.269369] pc : [<c0c40718>]    lr : [<bf2a3ef4>]    psr: a00d0113
>>>> [   14.269374] sp : ede7fe28  ip : ee983410  fp : c1787f30
>>>> [   14.269378] r10: 00000000  r9 : 00000000  r8 : bf2b2258
>>>> [   14.269384] r7 : ee983000  r6 : c1604c48  r5 : ede7fe88  r4 : edf337c0
>>>> [   14.269389] r3 : 00000000  r2 : 00000000  r1 : ede7fe88  r0 : c17712c8
>>>> [   14.269398] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
>>>> [   14.269404] Control: 10c5387d  Table: ad16804a  DAC: 00000051
>>>>
>>>> Disassembly showed that the local static variable __efivars is NULL. Likely
>>>> because efivars_register() is not called on this Tegra platform. So adding
>>>> a NULL pointer check in efivar_entry_size() and similar functions while at
>>>> it. In efivars_register() a couple of sanity checks have been added.
>>>>
>>>> Cc: Hans de Goede <hdegoede@redhat.com>
>>>> Reported-by: Jon Hunter <jonathanh@nvidia.com>
>>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>>> ---
>>>>  drivers/firmware/efi/vars.c | 108 +++++++++++++++++++++++++++++++++++---------
>>>>  1 file changed, 87 insertions(+), 21 deletions(-)
>>>>
>>>> diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
>>>> index 9336ffd..5fbd8e7 100644
>>>> --- a/drivers/firmware/efi/vars.c
>>>> +++ b/drivers/firmware/efi/vars.c
>>>> @@ -318,7 +318,12 @@ struct variable_validate {
>>>>  static efi_status_t
>>>>  check_var_size(u32 attributes, unsigned long size)
>>>>  {
>>>> -       const struct efivar_operations *fops = __efivars->ops;
>>>> +       const struct efivar_operations *fops;
>>>> +
>>>> +       if (!__efivars)
>>>> +               return EFI_UNSUPPORTED;
>>>> +
>>>> +       fops = __efivars->ops;
>>>>
>>>>         if (!fops->query_variable_store)
>>>>                 return EFI_UNSUPPORTED;
>>>> @@ -329,7 +334,12 @@ struct variable_validate {
>>>>  static efi_status_t
>>>>  check_var_size_nonblocking(u32 attributes, unsigned long size)
>>>>  {
>>>> -       const struct efivar_operations *fops = __efivars->ops;
>>>> +       const struct efivar_operations *fops;
>>>> +
>>>> +       if (!__efivars)
>>>> +               return EFI_UNSUPPORTED;
>>>> +
>>>> +       fops = __efivars->ops;
>>>>
>>>>         if (!fops->query_variable_store)
>>>>                 return EFI_UNSUPPORTED;
>>>> @@ -429,13 +439,18 @@ static void dup_variable_bug(efi_char16_t *str16, efi_guid_t *vendor_guid,
>>>>  int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
>>>>                 void *data, bool duplicates, struct list_head *head)
>>>>  {
>>>> -       const struct efivar_operations *ops = __efivars->ops;
>>>> +       const struct efivar_operations *ops;
>>>>         unsigned long variable_name_size = 1024;
>>>>         efi_char16_t *variable_name;
>>>>         efi_status_t status;
>>>>         efi_guid_t vendor_guid;
>>>>         int err = 0;
>>>>
>>>> +       if (!__efivars)
>>>> +               return -EFAULT;
>>>> +
>>>> +       ops = __efivars->ops;
>>>> +
>>>>         variable_name = kzalloc(variable_name_size, GFP_KERNEL);
>>>>         if (!variable_name) {
>>>>                 printk(KERN_ERR "efivars: Memory allocation failed.\n");
>>>> @@ -583,12 +598,14 @@ static void efivar_entry_list_del_unlock(struct efivar_entry *entry)
>>>>   */
>>>>  int __efivar_entry_delete(struct efivar_entry *entry)
>>>>  {
>>>> -       const struct efivar_operations *ops = __efivars->ops;
>>>>         efi_status_t status;
>>>>
>>>> -       status = ops->set_variable(entry->var.VariableName,
>>>> -                                  &entry->var.VendorGuid,
>>>> -                                  0, 0, NULL);
>>>> +       if (!__efivars)
>>>> +               return -EINVAL;
>>>> +
>>>> +       status = __efivars->ops->set_variable(entry->var.VariableName,
>>>> +                                             &entry->var.VendorGuid,
>>>> +                                             0, 0, NULL);
>>>>
>>>>         return efi_status_to_err(status);
>>>>  }
>>>> @@ -607,12 +624,17 @@ int __efivar_entry_delete(struct efivar_entry *entry)
>>>>   */
>>>>  int efivar_entry_delete(struct efivar_entry *entry)
>>>>  {
>>>> -       const struct efivar_operations *ops = __efivars->ops;
>>>> +       const struct efivar_operations *ops;
>>>>         efi_status_t status;
>>>>
>>>>         if (down_interruptible(&efivars_lock))
>>>>                 return -EINTR;
>>>>
>>>
>>> Any reason in particular you put the check after the lock is taken? Is
>>> this to ensure that __efivars does not change under your feet?
>>
>> That was my reasoning although I am not sure if that is likely. Is
>> efivars_register() always called before any drivers are started?
>>
>
> First of all, efivars_register() is only called on EFI systems, and
> this Tegra is not an EFI system. So in general, it would be better if
> your code checks efi_enabled(EFI_RUNTIME_SERVICES) before attempting
> to access any EFI APIs, especially since CONFIG_EFI support can be
> compiled out (in which case efi_enabled() resolves to a build time
> constant 'false') Something like

That was my first stab at it, but felt that the API could be more robust 
as well. I will create a patch for my driver as well.
>
> Of course, that doesn't mean we should crash if you access the API
> anyway, so I will queue this patch in efi/next as well. (I'll drop the
> last hunk, though, if you don't mind - it returns with the lock held)

Works for me.

Thanks,
Arend

