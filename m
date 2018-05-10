Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36199 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934002AbeEJLUD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 07:20:03 -0400
MIME-Version: 1.0
In-Reply-To: <20180510131725.111079af@wiggum>
References: <20180510111401.1161-1-zajec5@gmail.com> <20180510111401.1161-2-zajec5@gmail.com>
 <20180510131725.111079af@wiggum>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Thu, 10 May 2018 13:20:01 +0200
Message-ID: <CACna6ryWUCnrw9w4yhfiNXFHy1hFjVV-BqH07i7DQqxq8FtjMw@mail.gmail.com> (sfid-20180510_132018_402993_D93BD833)
Subject: Re: [PATCH 4.17 2/2] ssb: make SSB_PCICORE_HOSTMODE depend on SSB = y
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <larry.finger@lwfinger.net>,
        Matt Redfearn <matt.redfearn@mips.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 May 2018 at 13:17, Michael B=C3=BCsch <m@bues.ch> wrote:
> On Thu, 10 May 2018 13:14:01 +0200
> Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:
>
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> SSB_PCICORE_HOSTMODE protects MIPS specific code that calls not exported
>> symbols pcibios_enable_device and register_pci_controller. This code is
>> supposed to be compiled only with ssb builtin.
>>
>> This fixes:
>> ERROR: "pcibios_enable_device" [drivers/ssb/ssb.ko] undefined!
>> ERROR: "register_pci_controller" [drivers/ssb/ssb.ko] undefined!
>> make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1
>>
>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>> ---
>>  drivers/ssb/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
>> index b3f5cae98ea6..c574dd210500 100644
>> --- a/drivers/ssb/Kconfig
>> +++ b/drivers/ssb/Kconfig
>> @@ -131,7 +131,7 @@ config SSB_DRIVER_PCICORE
>>
>>  config SSB_PCICORE_HOSTMODE
>>       bool "Hostmode support for SSB PCI core"
>> -     depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS
>> +     depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS && SSB =3D y
>>       help
>>         PCIcore hostmode operation (external PCI bus).
>>
>
>
> I think we also need to depend on PCI_DRIVERS_LEGACY.
> See the other patch that floats around.

I believe it's already handled by SSB_PCIHOST_POSSIBLE's dependency on
PCI_DRIVERS_LEGACY.

--=20
Rafa=C5=82
