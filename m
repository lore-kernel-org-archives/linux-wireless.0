Return-Path: <SRS0=dsQx=NY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F32AC43441
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 13:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 670412081C
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 13:32:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="NLP44bM4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 670412081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733307AbeKMXaa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Nov 2018 18:30:30 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19266 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733229AbeKMXaa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Nov 2018 18:30:30 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5bead2520000>; Tue, 13 Nov 2018 05:32:03 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 13 Nov 2018 05:32:21 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 13 Nov 2018 05:32:21 -0800
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 13 Nov
 2018 13:32:19 +0000
Subject: Re: [REGRESSION] brcmfmac: NULL pointer deference starting
 next-20181107
From:   Jon Hunter <jonathanh@nvidia.com>
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
 <000bfd39-10cf-661c-9512-0410782168dc@nvidia.com>
Message-ID: <82736fa6-f3cc-f45f-a4b0-dba485531f7d@nvidia.com>
Date:   Tue, 13 Nov 2018 13:32:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <000bfd39-10cf-661c-9512-0410782168dc@nvidia.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1542115923; bh=uzW6qNZMyOVaJvpbCPUyx0mm8CkHxaQamcfM/dEk0bM=;
        h=X-PGP-Universal:Subject:From:To:References:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=NLP44bM4reiwF6Exi0M7k2IOXuVmduQSp5HJ9zXhan05RJI0zsi+/kb/DlTqaFGaM
         81R/7ZRuhjHXT38q2H8Nk1dLc2Q98qmlnQayXfNI8TfuAk4oW7oUi1PxE3C1tSnm97
         32DSCRa9Rr9c2G2m5cTHWoT2GtBVX82k48Rr9VO+RgOiYho6NNZ7y1XSfya7POkr8C
         s3YtnnVORGNgZkPvDQGSdak/oKUY3V7NGOz/YJDoofcLd6SbsGR8EqONCzosz+gyzx
         ZDte1quCJckDKdjqS4iPpMWe5Z2+uhxsaZhUewFbhUiae2ClBcLrn7h+BB9I7TLJoa
         /IRc+4LYAbJww==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 13/11/2018 13:21, Jon Hunter wrote:

...

>> IMHO the best fix here would be to modify efivar_entry_size(),
>> adding:
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0if (!ops)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOENT;
>>
>> Which makes it return the same error as when we do have efivar
>> support but the requested variable is not found.
>=20
> So the above did not work. I see a patch from Arend and I will give this
> a try.

FWIW, this did work ...

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 9336ffdf6e2c..8181e548f32b 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -829,9 +829,14 @@ struct efivar_entry *efivar_entry_find(efi_char16_t
*name, efi_guid_t guid,
  */
 int efivar_entry_size(struct efivar_entry *entry, unsigned long *size)
 {
-       const struct efivar_operations *ops =3D __efivars->ops;
+       const struct efivar_operations *ops;
        efi_status_t status;

+       if (!__efivars || !__efivars->ops)
+               return -ENOENT;
+
+       ops =3D __efivars->ops;
+
        *size =3D 0;

        if (down_interruptible(&efivars_lock))

I will let you know about Arend's patch as well.

Jon

--=20
nvpublic
