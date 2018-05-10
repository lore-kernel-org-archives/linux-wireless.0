Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35093 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756729AbeEJKsR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 06:48:17 -0400
MIME-Version: 1.0
In-Reply-To: <CACna6rxb9KSQfGwi__xxSMACAxh-bOV9SR1NsnUVe8ASdA0Liw@mail.gmail.com>
References: <7bbc067a-c412-3d2e-174a-abc31b46e246@lwfinger.net> <CACna6rxb9KSQfGwi__xxSMACAxh-bOV9SR1NsnUVe8ASdA0Liw@mail.gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Thu, 10 May 2018 12:48:15 +0200
Message-ID: <CACna6ry4AYpwOguzDoP4XsonF4_eWW2PpxonwbuAXMVw3wrQ+g@mail.gmail.com> (sfid-20180510_124833_099220_590F8F80)
Subject: Re: Regression caused by commit 882164a4a928
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Matt Redfearn <matt.redfearn@mips.com>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 May 2018 at 12:41, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:
> On 7 May 2018 at 17:44, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> Although commit 882164a4a928 ("ssb: Prevent build of PCI host features i=
n
>> module") appeared to be harmless, it leads to complete failure of driver=
s
>> b43. and b43legacy, and likely affects b44 as well. The problem is that
>> CONFIG_SSB_PCIHOST is undefined, which prevents the compilation of the c=
ode
>> that controls the PCI cores of the device. See
>> https://bugzilla.redhat.com/show_bug.cgi?id=3D1572349 for details.
>>
>> As the underlying errors ("pcibios_enable_device" undefined, and
>> "register_pci_controller" undefined) do not appear on the architectures =
that
>> I have tested (x86_64, x86, and ppc), I suspect something in the
>> arch-specific code for your setup (MIPS?). As I have no idea on how to f=
ix
>> that problem, would the following patch work for you?
>>
>> diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
>> index 9371651d8017..3743533c8057 100644
>> --- a/drivers/ssb/Kconfig
>> +++ b/drivers/ssb/Kconfig
>> @@ -117,7 +117,7 @@ config SSB_SERIAL
>>
>>  config SSB_DRIVER_PCICORE_POSSIBLE
>>         bool
>> -       depends on SSB_PCIHOST && SSB =3D y
>> +       depends on SSB_PCIHOST && (SSB =3D y || !MIPS)
>>         default y
>>
>>  config SSB_DRIVER_PCICORE
>
> I strongly suggest we take a step back, slow down a bit and look at
> the original problem.
>
> In driver_pcicore.c there is MIPS specific code. It's protected using
> #ifdef CONFIG_SSB_PCICORE_HOSTMODE
> (...)
> #endif
>
> If anyone has ever seen
> ERROR: "pcibios_enable_device" [drivers/ssb/ssb.ko] undefined!
> ERROR: "register_pci_controller" [drivers/ssb/ssb.ko] undefined!
> make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1
> it means he managed to get CONFIG_SSB_PCICORE_HOSTMODE set on non-MIPS sy=
stem.
>
> We should rather answer how did that happen and fix it.
>
> SSB_PCICORE_HOSTMODE depends on SSB_DRIVER_MIPS
> SSB_DRIVER_MIPS depends on MIPS
>
> How is that possible to set SSB_PCICORE_HOSTMODE with non-MIPS config?
> Is there some mistake in Kconfig I can't see?

I think SSB =3D y should be added as dependency for
SSB_PCICORE_HOSTMODE. See also commit 79ca239a68f8f ("bcma: Prevent
build of PCI host features in module").

--=20
Rafa=C5=82
