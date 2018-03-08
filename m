Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 9pmail.ess.barracuda.com ([64.235.154.211]:51368 "EHLO
        9pmail.ess.barracuda.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751538AbeCHMIk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 07:08:40 -0500
Subject: Re: [PATCH v2] bcma: Prevent build of PCI host features in module
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
CC: <zajec5@gmail.com>, <linux-wireless@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <jhogan@kernel.org>
References: <1519898292-12155-1-git-send-email-matt.redfearn@mips.com>
 <87lgfcnkey.fsf@kamboji.qca.qualcomm.com>
 <c5929bb5-c50f-e73e-3117-fb0a862bb0fc@lwfinger.net>
From: Matt Redfearn <matt.redfearn@mips.com>
Message-ID: <7a1695c0-45cf-e3d6-8524-8d2aeccc6490@mips.com> (sfid-20180308_130844_873905_EE31BB3B)
Date: Thu, 8 Mar 2018 12:00:27 +0000
MIME-Version: 1.0
In-Reply-To: <c5929bb5-c50f-e73e-3117-fb0a862bb0fc@lwfinger.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 02/03/18 17:56, Larry Finger wrote:
> On 03/01/2018 04:45 AM, Kalle Valo wrote:
>> Matt Redfearn <matt.redfearn@mips.com> writes:
>>
>>> Attempting to build bcma.ko with BCMA_DRIVER_PCI_HOSTMODE=y results in
>>> a build error due to use of symbols not exported from vmlinux:
>>>
>>> ERROR: "pcibios_enable_device" [drivers/bcma/bcma.ko] undefined!
>>> ERROR: "register_pci_controller" [drivers/bcma/bcma.ko] undefined!
>>> make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1
>>>
>>> To prevent this, don't allow the host mode feature to be built if
>>> CONFIG_BCMA=m
>>>
>>> Signed-off-by: Matt Redfearn <matt.redfearn@mips.com>
>>>
>>> ---
>>>
>>> Changes in v2:
>>> Rebase on v4.16-rc1
>>>
>>>   drivers/bcma/Kconfig | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
>>> index ba8acca036df..cb0f1aad20b7 100644
>>> --- a/drivers/bcma/Kconfig
>>> +++ b/drivers/bcma/Kconfig
>>> @@ -55,7 +55,7 @@ config BCMA_DRIVER_PCI
>>>   config BCMA_DRIVER_PCI_HOSTMODE
>>>       bool "Driver for PCI core working in hostmode"
>>> -    depends on MIPS && BCMA_DRIVER_PCI && PCI_DRIVERS_LEGACY
>>> +    depends on MIPS && BCMA_DRIVER_PCI && PCI_DRIVERS_LEGACY && BCMA 
>>> = y
>>
>> Due to the recent regression in bcma I would prefer extra careful review
>> before I apply this. So does this look ok to everyone?
> 
> I have a preference for wireless device drivers to be modules. For that 
> reason, I would have submitted a patch exporting those two missing 
> globals rather than forcing bcma to be built in. That said, it seems 
> that the patch will do no further harm.


This patch was purely intended to fix the build breakage caused by 
attempting to build host-mode PCI into a module, which fails due to 
necessary symbols not being exported by the kernel for use by modules.

Making it possible to build the driver including host mode may not be as 
trivial as "lets just export the symbols", and testing that it works 
correctly once it can be built as a module will require hardware with 
this device present (which I don't have).

So I would propose that this patch be merged as is, since as you say, it 
does no further harm - it should just fix build breakage - and if the 
driver, including this host mode feature, is really required as a 
module, perhaps someone with access to the hardware could spin a patch 
to implement that.

Thanks,
Matt

> 
> Larry
> 
> 
