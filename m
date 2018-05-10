Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 9pmail.ess.barracuda.com ([64.235.154.211]:36720 "EHLO
        9pmail.ess.barracuda.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935346AbeEJKti (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 06:49:38 -0400
Subject: Re: Regression caused by commit 882164a4a928
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
CC: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <7bbc067a-c412-3d2e-174a-abc31b46e246@lwfinger.net>
 <CACna6rxb9KSQfGwi__xxSMACAxh-bOV9SR1NsnUVe8ASdA0Liw@mail.gmail.com>
From: Matt Redfearn <matt.redfearn@mips.com>
Message-ID: <6e64abf4-a8c1-21db-e740-79f031b4560e@mips.com> (sfid-20180510_124951_961791_2731398D)
Date: Thu, 10 May 2018 11:49:52 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6rxb9KSQfGwi__xxSMACAxh-bOV9SR1NsnUVe8ASdA0Liw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rafał,

On 10/05/18 11:41, Rafał Miłecki wrote:
> On 7 May 2018 at 17:44, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> Although commit 882164a4a928 ("ssb: Prevent build of PCI host features in
>> module") appeared to be harmless, it leads to complete failure of drivers
>> b43. and b43legacy, and likely affects b44 as well. The problem is that
>> CONFIG_SSB_PCIHOST is undefined, which prevents the compilation of the code
>> that controls the PCI cores of the device. See
>> https://bugzilla.redhat.com/show_bug.cgi?id=1572349 for details.
>>
>> As the underlying errors ("pcibios_enable_device" undefined, and
>> "register_pci_controller" undefined) do not appear on the architectures that
>> I have tested (x86_64, x86, and ppc), I suspect something in the
>> arch-specific code for your setup (MIPS?). As I have no idea on how to fix
>> that problem, would the following patch work for you?
>>
>> diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
>> index 9371651d8017..3743533c8057 100644
>> --- a/drivers/ssb/Kconfig
>> +++ b/drivers/ssb/Kconfig
>> @@ -117,7 +117,7 @@ config SSB_SERIAL
>>
>>   config SSB_DRIVER_PCICORE_POSSIBLE
>>          bool
>> -       depends on SSB_PCIHOST && SSB = y
>> +       depends on SSB_PCIHOST && (SSB = y || !MIPS)
>>          default y
>>
>>   config SSB_DRIVER_PCICORE
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
> it means he managed to get CONFIG_SSB_PCICORE_HOSTMODE set on non-MIPS system.

I saw this on a MIPS system (to my knowledge, this does not happen on 
other arches due to the Kconfig rules you describe), which is what my 
original patch was attempting to fix, but appears to have caused 
problems on other arches.

Thanks,
Matt


> 
> We should rather answer how did that happen and fix it.
> 
> SSB_PCICORE_HOSTMODE depends on SSB_DRIVER_MIPS
> SSB_DRIVER_MIPS depends on MIPS
> 
> How is that possible to set SSB_PCICORE_HOSTMODE with non-MIPS config?
> Is there some mistake in Kconfig I can't see?
> 
