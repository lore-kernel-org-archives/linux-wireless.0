Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 9pmail.ess.barracuda.com ([64.235.154.210]:32955 "EHLO
        9pmail.ess.barracuda.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934328AbeEIMz2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 08:55:28 -0400
Subject: Re: Regression caused by commit 882164a4a928
To: Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <7bbc067a-c412-3d2e-174a-abc31b46e246@lwfinger.net>
From: Matt Redfearn <matt.redfearn@mips.com>
Message-ID: <372d149c-c34c-56a0-4e1a-5ab2c1e16e73@mips.com> (sfid-20180509_145541_508510_29F30881)
Date: Wed, 9 May 2018 13:55:43 +0100
MIME-Version: 1.0
In-Reply-To: <7bbc067a-c412-3d2e-174a-abc31b46e246@lwfinger.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry

On 07/05/18 16:44, Larry Finger wrote:
> Matt,
> 
> Although commit 882164a4a928 ("ssb: Prevent build of PCI host features 
> in module") appeared to be harmless, it leads to complete failure of 
> drivers b43. and b43legacy, and likely affects b44 as well. The problem 
> is that CONFIG_SSB_PCIHOST is undefined, which prevents the compilation 
> of the code that controls the PCI cores of the device. See 
> https://bugzilla.redhat.com/show_bug.cgi?id=1572349 for details.

Sorry for the breakage :-/

> 
> As the underlying errors ("pcibios_enable_device" undefined, and 
> "register_pci_controller" undefined) do not appear on the architectures 
> that I have tested (x86_64, x86, and ppc), I suspect something in the 
> arch-specific code for your setup (MIPS?). As I have no idea on how to 
> fix that problem, would the following patch work for you?
> 
> diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
> index 9371651d8017..3743533c8057 100644
> --- a/drivers/ssb/Kconfig
> +++ b/drivers/ssb/Kconfig
> @@ -117,7 +117,7 @@ config SSB_SERIAL
> 
>   config SSB_DRIVER_PCICORE_POSSIBLE
>          bool
> -       depends on SSB_PCIHOST && SSB = y
> +       depends on SSB_PCIHOST && (SSB = y || !MIPS)
>          default y
> 
>   config SSB_DRIVER_PCICORE

I believe that the problem stems from these drivers being used for some 
wireless AP functionality built into some MIPS based SoCs. The Kconfig 
rules sort out building this additional functionality when configured 
for MIPS (in a round about sort of way), but it allowed it even when SSB 
is a module, leading to build failures. My patch was intended to prevent 
that.

There was a similar issue in the same Kconfig file, introduced by 
c5611df96804 and fixed by a9e6d44ddecc. It was fixed the same way as you 
suggest. I've tested the above patch and it does work for MIPS 
(preventing the PCICORE being built into the module).

Tested-by: Matt Redfearn <matt.redfearn@mips.com>

Thanks & sorry again for the breakage,
Matt



> 
> Thanks,
> 
> Larry
