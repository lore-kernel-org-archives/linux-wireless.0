Return-Path: <SRS0=dsQx=NY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8514C43441
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 11:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EA7422419
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 11:29:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="GesMrJ+k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EA7422419
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732646AbeKMV1G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Nov 2018 16:27:06 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14200 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732037AbeKMV1F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Nov 2018 16:27:05 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5beab5810000>; Tue, 13 Nov 2018 03:29:05 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 13 Nov 2018 03:29:23 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 13 Nov 2018 03:29:23 -0800
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 13 Nov
 2018 11:29:21 +0000
Subject: Re: [REGRESSION] brcmfmac: NULL pointer deference starting
 next-20181107
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <dbc5e8f9-6f14-77d2-be2a-f0738e13b773@nvidia.com>
 <9f72ac4f-a83a-7af7-3c26-b1ced6d98653@broadcom.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <d3783759-9030-76bc-d218-6f92b462de7f@nvidia.com>
Date:   Tue, 13 Nov 2018 11:29:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <9f72ac4f-a83a-7af7-3c26-b1ced6d98653@broadcom.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1542108545; bh=hPhRAPNTPaOgtf1pXOHlbStm+78WyAc/lB+11BcBGOY=;
        h=X-PGP-Universal:Subject:To:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=GesMrJ+kRH2zZrrXT3ek8HS9byrqfyzhq1l0jhGOde9ZVKji0eAJV5lo/kHOApOa1
         3lYfUVGHlwmdWbQgZkCcAPVn8jYScIuuwgnouUxgvHhJkNZ5XjasWeiacBsYY4s63c
         +FB5vomUjuVJoeqvDks3CJakSzx81HjpXiK7PZU8cZx7dQ/LWaTc13nHm2BxZAMXNx
         9a255j66GDjpc/3qj73cJKnSR1dAf2EkEHOsG9oZf5bjN0pE7bA+9oELUsAUcRX1HS
         keBZ/A3fjRV+9TXlVzJ69KfYBzdCHyag5N1RRGdzeWMtskEO7SSEUOSolCg7rtEi/f
         /Np8wWY3SIcUQ==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Arend,

On 13/11/2018 10:24, Arend van Spriel wrote:

...

> I tried building drivers/firmware/efi/vars.c using tegra_defconfig. Had
> to enable CONFIG_EFI. So the null pointer access is a 0x00000008 so I
> looked at the disassembly below:
>=20
> int efivar_entry_size(struct efivar_entry *entry, unsigned long *size)
> {
> =C2=A0=C2=A0=C2=A0=C2=A0 310:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 e1a0500=
1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mov=C2=A0=C2=A0=C2=A0=C2=A0 r5,=
 r1
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct efivar_operations=
 *ops =3D __efivars->ops;
> =3D=3D>=C2=A0 314:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 e5936008=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ldr=C2=A0=C2=A0=C2=A0=C2=A0 r6, [r3, #8]
>=20
> So I think __efivars is NULL on your platform. It is private to the
> source file. Not sure how the driver should deal with this. Maybe use
> efi_enabled() but not sure what feature to use. My best bet would be
> EFI_RUNTIME_SERVICES.
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 efi_status_t status;
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *size =3D 0;
> =C2=A0=C2=A0=C2=A0=C2=A0 318:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 e3a0300=
0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mov=C2=A0=C2=A0=C2=A0=C2=A0 r3,=
 #0
> =C2=A0=C2=A0=C2=A0=C2=A0 31c:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 e581300=
0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 str=C2=A0=C2=A0=C2=A0=C2=A0 r3,=
 [r1]
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (down_interruptible(&efivar=
s_lock))
> =C2=A0=C2=A0=C2=A0=C2=A0 320:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ebfffff=
e=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bl=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0 <down_interruptible>
> =C2=A0=C2=A0=C2=A0=C2=A0 324:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 e250400=
0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 subs=C2=A0=C2=A0=C2=A0 r4, r0, =
#0
> =C2=A0=C2=A0=C2=A0=C2=A0 328:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1a00001=
2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bne=C2=A0=C2=A0=C2=A0=C2=A0 378=
 <efivar_entry_size+0x80>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 return -EINTR;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 status =3D ops->get_variable(e=
ntry->var.VariableName,

So actually, I am seeing the crash with the 'multi_v7_defconfig' and I
don't see it with the 'tegra_defconfig' (probably because CONFIG_EFI is
not enabled).

Cheers
Jon

--=20
nvpublic
