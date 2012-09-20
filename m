Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39433 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab2ITO7S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 10:59:18 -0400
Message-ID: <505B2F3A.9070504@hauke-m.de> (sfid-20120920_165921_853330_D5C293D0)
Date: Thu, 20 Sep 2012 16:59:06 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] bcma: use udelay for short waits
References: <1348123339-15210-1-git-send-email-zajec5@gmail.com> <505B11A7.4040001@hauke-m.de>
In-Reply-To: <505B11A7.4040001@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2012 02:52 PM, Hauke Mehrtens wrote:
> On 09/20/2012 08:42 AM, Rafał Miłecki wrote:
>> msleep shouldn't be used for less than 20ms
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>>  drivers/bcma/driver_pci.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
>> index c32ebd5..e78e6a8 100644
>> --- a/drivers/bcma/driver_pci.c
>> +++ b/drivers/bcma/driver_pci.c
>> @@ -51,7 +51,7 @@ static void bcma_pcie_mdio_set_phy(struct bcma_drv_pci *pc, u8 phy)
>>  		v = pcicore_read32(pc, BCMA_CORE_PCI_MDIO_CONTROL);
>>  		if (v & BCMA_CORE_PCI_MDIOCTL_ACCESS_DONE)
>>  			break;
>> -		msleep(1);
>> +		udelay(1000);
>>  	}
>>  }
>>  
>> @@ -92,7 +92,7 @@ static u16 bcma_pcie_mdio_read(struct bcma_drv_pci *pc, u8 device, u8 address)
>>  			ret = pcicore_read32(pc, BCMA_CORE_PCI_MDIO_DATA);
>>  			break;
>>  		}
>> -		msleep(1);
>> +		udelay(1000);
>>  	}
>>  	pcicore_write32(pc, BCMA_CORE_PCI_MDIO_CONTROL, 0);
>>  	return ret;
>> @@ -132,7 +132,7 @@ static void bcma_pcie_mdio_write(struct bcma_drv_pci *pc, u8 device,
>>  		v = pcicore_read32(pc, BCMA_CORE_PCI_MDIO_CONTROL);
>>  		if (v & BCMA_CORE_PCI_MDIOCTL_ACCESS_DONE)
>>  			break;
>> -		msleep(1);
>> +		udelay(1000);
>>  	}
>>  	pcicore_write32(pc, BCMA_CORE_PCI_MDIO_CONTROL, 0);
>>  }
>>
> 
> Using msleep(1) here is not correct, but I do not know if udelay(1000)
> is better. The BCM4706 SoC or more the kernel code you are using seams
> to have problems with sleeping, at least that is my current assumption.
> when I add an msleep(1) somewhere into the code the exception stops
> there without an exception from the CPU.
> 
> According to Documentation/timers/timers-howto.txt we should use
> usleep_range for values from 10us to 20ms, but that also causes the same
> problem as msleep() on this SoC.
> 
> Hauke

The BCM4706 SoC has problems with the Mips wait instruction and that is
not activated in the Broadcom SDK, but in the OpenWrt kernel. I
deactivated it [0] in my kernel and now the device boots without this
patch for bcma. The patch to deactivate the mips wait instruction can
not be mainlined, like it is now.

Please drop this patch and use usleep_range(), that should work now.

Hauke

[0]:
https://dev.openwrt.org/browser/trunk/target/linux/brcm47xx/patches-3.3/170-fix-74k-cpu.patch?rev=33496
