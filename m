Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:34775 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946259AbeCBR4Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 12:56:25 -0500
Received: by mail-ot0-f193.google.com with SMTP id n74so9471656ota.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2018 09:56:25 -0800 (PST)
Subject: Re: [PATCH v2] bcma: Prevent build of PCI host features in module
To: Kalle Valo <kvalo@codeaurora.org>,
        Matt Redfearn <matt.redfearn@mips.com>
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
        linux-mips@linux-mips.org, jhogan@kernel.org
References: <1519898292-12155-1-git-send-email-matt.redfearn@mips.com>
 <87lgfcnkey.fsf@kamboji.qca.qualcomm.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <c5929bb5-c50f-e73e-3117-fb0a862bb0fc@lwfinger.net> (sfid-20180302_185630_587330_368D305C)
Date: Fri, 2 Mar 2018 11:56:23 -0600
MIME-Version: 1.0
In-Reply-To: <87lgfcnkey.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/01/2018 04:45 AM, Kalle Valo wrote:
> Matt Redfearn <matt.redfearn@mips.com> writes:
> 
>> Attempting to build bcma.ko with BCMA_DRIVER_PCI_HOSTMODE=y results in
>> a build error due to use of symbols not exported from vmlinux:
>>
>> ERROR: "pcibios_enable_device" [drivers/bcma/bcma.ko] undefined!
>> ERROR: "register_pci_controller" [drivers/bcma/bcma.ko] undefined!
>> make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1
>>
>> To prevent this, don't allow the host mode feature to be built if
>> CONFIG_BCMA=m
>>
>> Signed-off-by: Matt Redfearn <matt.redfearn@mips.com>
>>
>> ---
>>
>> Changes in v2:
>> Rebase on v4.16-rc1
>>
>>   drivers/bcma/Kconfig | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
>> index ba8acca036df..cb0f1aad20b7 100644
>> --- a/drivers/bcma/Kconfig
>> +++ b/drivers/bcma/Kconfig
>> @@ -55,7 +55,7 @@ config BCMA_DRIVER_PCI
>>   
>>   config BCMA_DRIVER_PCI_HOSTMODE
>>   	bool "Driver for PCI core working in hostmode"
>> -	depends on MIPS && BCMA_DRIVER_PCI && PCI_DRIVERS_LEGACY
>> +	depends on MIPS && BCMA_DRIVER_PCI && PCI_DRIVERS_LEGACY && BCMA = y
> 
> Due to the recent regression in bcma I would prefer extra careful review
> before I apply this. So does this look ok to everyone?

I have a preference for wireless device drivers to be modules. For that reason, 
I would have submitted a patch exporting those two missing globals rather than 
forcing bcma to be built in. That said, it seems that the patch will do no 
further harm.

Larry
