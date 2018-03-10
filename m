Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:42650 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932130AbeCJLf7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 06:35:59 -0500
Received: by mail-ua0-f196.google.com with SMTP id b23so3939450uak.9
        for <linux-wireless@vger.kernel.org>; Sat, 10 Mar 2018 03:35:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7a1695c0-45cf-e3d6-8524-8d2aeccc6490@mips.com>
References: <1519898292-12155-1-git-send-email-matt.redfearn@mips.com>
 <87lgfcnkey.fsf@kamboji.qca.qualcomm.com> <c5929bb5-c50f-e73e-3117-fb0a862bb0fc@lwfinger.net>
 <7a1695c0-45cf-e3d6-8524-8d2aeccc6490@mips.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Sat, 10 Mar 2018 12:35:37 +0100
Message-ID: <CAOiHx=n7R35yfPZgGt9pq39y-jMYpH44eAGGSvNJ=sM5Rf5H3A@mail.gmail.com> (sfid-20180310_125058_954430_F2A97442)
Subject: Re: [PATCH v2] bcma: Prevent build of PCI host features in module
To: Matt Redfearn <matt.redfearn@mips.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org,
        MIPS Mailing List <linux-mips@linux-mips.org>,
        James Hogan <jhogan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 8 March 2018 at 13:00, Matt Redfearn <matt.redfearn@mips.com> wrote:
> Hi,
>
>
> On 02/03/18 17:56, Larry Finger wrote:
>>
>> On 03/01/2018 04:45 AM, Kalle Valo wrote:
>>>
>>> Matt Redfearn <matt.redfearn@mips.com> writes:
>>>
>>>> Attempting to build bcma.ko with BCMA_DRIVER_PCI_HOSTMODE=y results in
>>>> a build error due to use of symbols not exported from vmlinux:
>>>>
>>>> ERROR: "pcibios_enable_device" [drivers/bcma/bcma.ko] undefined!
>>>> ERROR: "register_pci_controller" [drivers/bcma/bcma.ko] undefined!
>>>> make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1
>>>>
>>>> To prevent this, don't allow the host mode feature to be built if
>>>> CONFIG_BCMA=m
>>>>
>>>> Signed-off-by: Matt Redfearn <matt.redfearn@mips.com>
>>>>
>>>> ---
>>>>
>>>> Changes in v2:
>>>> Rebase on v4.16-rc1
>>>>
>>>>   drivers/bcma/Kconfig | 2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
>>>> index ba8acca036df..cb0f1aad20b7 100644
>>>> --- a/drivers/bcma/Kconfig
>>>> +++ b/drivers/bcma/Kconfig
>>>> @@ -55,7 +55,7 @@ config BCMA_DRIVER_PCI
>>>>   config BCMA_DRIVER_PCI_HOSTMODE
>>>>       bool "Driver for PCI core working in hostmode"
>>>> -    depends on MIPS && BCMA_DRIVER_PCI && PCI_DRIVERS_LEGACY
>>>> +    depends on MIPS && BCMA_DRIVER_PCI && PCI_DRIVERS_LEGACY && BCMA =
>>>> y
>>>
>>>
>>> Due to the recent regression in bcma I would prefer extra careful review
>>> before I apply this. So does this look ok to everyone?
>>
>>
>> I have a preference for wireless device drivers to be modules. For that
>> reason, I would have submitted a patch exporting those two missing globals
>> rather than forcing bcma to be built in. That said, it seems that the patch
>> will do no further harm.
>
>
>
> This patch was purely intended to fix the build breakage caused by
> attempting to build host-mode PCI into a module, which fails due to
> necessary symbols not being exported by the kernel for use by modules.
>
> Making it possible to build the driver including host mode may not be as
> trivial as "lets just export the symbols", and testing that it works
> correctly once it can be built as a module will require hardware with this
> device present (which I don't have).
>
> So I would propose that this patch be merged as is, since as you say, it
> does no further harm - it should just fix build breakage - and if the
> driver, including this host mode feature, is really required as a module,
> perhaps someone with access to the hardware could spin a patch to implement
> that.


These aren't the actual wireless drivers, just the bus drivers. The
actual wireless drivers (b43 / brcmsmac) can still be built as a
module.

Also those systems that use/need the pci host driver of ssb/bcma
actually need ssb/bcma built-in anyway, as it also provides serial
console, interrupt routing, flash access, and other early init stuff.
At best one could rewrite the pci host core driver as a standalone
bcma driver, and then one could allow it to be built as a module. But
I'm not sure if it's worth it.


Regards
Jonas
