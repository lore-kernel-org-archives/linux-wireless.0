Return-Path: <SRS0=dsQx=NY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 288B4C43441
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 13:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E12612245E
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 13:21:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="mfhAh0yS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E12612245E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733258AbeKMXTc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Nov 2018 18:19:32 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1595 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733158AbeKMXTc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Nov 2018 18:19:32 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5beacfce0000>; Tue, 13 Nov 2018 05:21:18 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 13 Nov 2018 05:21:24 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 13 Nov 2018 05:21:24 -0800
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 13 Nov
 2018 13:21:23 +0000
Subject: Re: [REGRESSION] brcmfmac: NULL pointer deference starting
 next-20181107
To:     Hans de Goede <hdegoede@redhat.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <dbc5e8f9-6f14-77d2-be2a-f0738e13b773@nvidia.com>
 <9f72ac4f-a83a-7af7-3c26-b1ced6d98653@broadcom.com>
 <9e0a7997-4c14-a3a1-c935-d674270533aa@redhat.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <000bfd39-10cf-661c-9512-0410782168dc@nvidia.com>
Date:   Tue, 13 Nov 2018 13:21:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <9e0a7997-4c14-a3a1-c935-d674270533aa@redhat.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL108.nvidia.com (172.18.146.13) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1542115278; bh=Q8qkYAH28YwCp3+8NmQGwWOeUjxXezrMIZ2+Ov7rNhU=;
        h=X-PGP-Universal:Subject:To:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=mfhAh0ySEfqXI+fC+WmvgChA2ECr3jakpuu7bcTBOwGFcnMg0gZdaxHLBgTFwJMnL
         V2JWmf2laF+/p1h9Ii3JzE2mjZjl4V9hUnhPyVOQau6SfuB5sFXpJwv4fGs8H8/Qb/
         JeJgt5hrXX82k4V1jLoHJFlqUz8p70eo2im20AXsYI5I44HBzqHVWYpXXm5HpUHOe2
         9ch7CuOa2ehNKibN4I0FO03i4nNLsOUj9JK2N2uENDB0K8NU8aPLOLKpfjID5tdgIk
         PKE3KUZKQ5ry6AUWQwYtWRfhXdYV5fy0G41n7LVJAR1QEzJdmLL+dXAqEw/PCsQctE
         BbvOZ/cwiV5vQ==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 13/11/2018 10:40, Hans de Goede wrote:
> Hi,
>=20
> On 13-11-18 11:24, Arend van Spriel wrote:
>> + Ard as this involves EFI.
>>
>> On 11/12/2018 2:24 PM, Jon Hunter wrote:
>>> Hi Hans, Kalle,
>>>
>>> Starting with next-20181107 I am seeing the following NULL pointer
>>> deference on Tegra (note the firmware is missing on this board) ...
>>>
>>> [=C2=A0=C2=A0 14.072883] brcmfmac: brcmf_fw_alloc_request: using
>>> brcm/brcmfmac4329-sdio for chip BCM4329/3
>>>
>>> [=C2=A0=C2=A0 14.130287] brcmfmac mmc1:0001:1: Direct firmware load for
>>> brcm/brcmfmac4329-sdio.nvidia,cardhu-a04.txt failed with error -2
>>>
>>> [=C2=A0=C2=A0 14.156283] brcmfmac mmc1:0001:1: Direct firmware load for
>>> brcm/brcmfmac4329-sdio.txt failed with error -2
>>>
>>> [=C2=A0=C2=A0 14.177769] Unable to handle kernel NULL pointer dereferen=
ce at
>>> virtual address 00000008
>>>
>>> [=C2=A0=C2=A0 14.197303] pgd =3D 60bfa5f1
>>>
>>> [=C2=A0=C2=A0 14.211842] [00000008] *pgd=3D00000000
>>>
>>> [=C2=A0=C2=A0 14.227373] Internal error: Oops: 5 [#1] SMP ARM
>>>
>>> [=C2=A0=C2=A0 14.244244] Modules linked in: brcmfmac sha256_generic sha=
256_arm
>>> snd cfg80211 brcmutil soundcore snd_soc_tegra30_ahub tegra_wdt
>>>
>>> [=C2=A0=C2=A0 14.269109] CPU: 1 PID: 114 Comm: kworker/1:2 Not tainted
>>> 4.20.0-rc1-next-20181107-gd881de3 #1
>>>
>>> [=C2=A0=C2=A0 14.269114] Hardware name: NVIDIA Tegra SoC (Flattened Dev=
ice Tree)
>>>
>>> [=C2=A0=C2=A0 14.269154] Workqueue: events request_firmware_work_func
>>>
>>> [=C2=A0=C2=A0 14.269177] PC is at efivar_entry_size+0x28/0x90
>>>
>>> [=C2=A0=C2=A0 14.269362] LR is at brcmf_fw_complete_request+0x3f8/0x8d4=
 [brcmfmac]
>>>
>>> [=C2=A0=C2=A0 14.269369] pc : [<c0c40718>]=C2=A0=C2=A0=C2=A0 lr : [<bf2=
a3ef4>]=C2=A0=C2=A0=C2=A0 psr: a00d0113
>>>
>>> [=C2=A0=C2=A0 14.269374] sp : ede7fe28=C2=A0 ip : ee983410=C2=A0 fp : c=
1787f30
>>>
>>> [=C2=A0=C2=A0 14.269378] r10: 00000000=C2=A0 r9 : 00000000=C2=A0 r8 : b=
f2b2258
>>>
>>> [=C2=A0=C2=A0 14.269384] r7 : ee983000=C2=A0 r6 : c1604c48=C2=A0 r5 : e=
de7fe88=C2=A0 r4 :
>>> edf337c0
>>>
>>> [=C2=A0=C2=A0 14.269389] r3 : 00000000=C2=A0 r2 : 00000000=C2=A0 r1 : e=
de7fe88=C2=A0 r0 :
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
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 310:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
e1a05001=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mov=C2=A0=C2=A0=C2=A0=C2=
=A0 r5, r1
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct efivar_ope=
rations *ops =3D __efivars->ops;
>> =3D=3D>=C2=A0 314:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 e5936008=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ldr=C2=A0=C2=A0=C2=A0=C2=A0 r6, [r3, #8]
>>
>> So I think __efivars is NULL on your platform. It is private to the
>> source file. Not sure how the driver should deal with this. Maybe use
>> efi_enabled() but not sure what feature to use. My best bet would be
>> EFI_RUNTIME_SERVICES.
>=20
> Ah right, thank you for catching this I had looking into this
> on my TODO list, but you beat me to it.
>=20
> IMHO the best fix here would be to modify efivar_entry_size(),
> adding:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0if (!ops)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOENT;
>=20
> Which makes it return the same error as when we do have efivar
> support but the requested variable is not found.

So the above did not work. I see a patch from Arend and I will give this
a try.

Cheers
Jon

--=20
nvpublic
