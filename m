Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58469 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764Ab2ITPZ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 11:25:59 -0400
Received: by wibhi8 with SMTP id hi8so875320wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2012 08:25:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <505B2F3A.9070504@hauke-m.de>
References: <1348123339-15210-1-git-send-email-zajec5@gmail.com>
	<505B11A7.4040001@hauke-m.de>
	<505B2F3A.9070504@hauke-m.de>
Date: Thu, 20 Sep 2012 17:25:57 +0200
Message-ID: <CACna6rwyVkj6GCWOLZDK3Hsh1bA6zfxf1WaHxyizGrvy+Oz2iA@mail.gmail.com> (sfid-20120920_172602_271345_9A616E9A)
Subject: Re: [PATCH] bcma: use udelay for short waits
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/9/20 Hauke Mehrtens <hauke@hauke-m.de>:
> On 09/20/2012 02:52 PM, Hauke Mehrtens wrote:
>> On 09/20/2012 08:42 AM, Rafał Miłecki wrote:
>>> msleep shouldn't be used for less than 20ms
>>>
>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>> ---
>>>  drivers/bcma/driver_pci.c |    6 +++---
>>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
>>> index c32ebd5..e78e6a8 100644
>>> --- a/drivers/bcma/driver_pci.c
>>> +++ b/drivers/bcma/driver_pci.c
>>> @@ -51,7 +51,7 @@ static void bcma_pcie_mdio_set_phy(struct bcma_drv_pci *pc, u8 phy)
>>>              v = pcicore_read32(pc, BCMA_CORE_PCI_MDIO_CONTROL);
>>>              if (v & BCMA_CORE_PCI_MDIOCTL_ACCESS_DONE)
>>>                      break;
>>> -            msleep(1);
>>> +            udelay(1000);
>>>      }
>>>  }
>>>
>>> @@ -92,7 +92,7 @@ static u16 bcma_pcie_mdio_read(struct bcma_drv_pci *pc, u8 device, u8 address)
>>>                      ret = pcicore_read32(pc, BCMA_CORE_PCI_MDIO_DATA);
>>>                      break;
>>>              }
>>> -            msleep(1);
>>> +            udelay(1000);
>>>      }
>>>      pcicore_write32(pc, BCMA_CORE_PCI_MDIO_CONTROL, 0);
>>>      return ret;
>>> @@ -132,7 +132,7 @@ static void bcma_pcie_mdio_write(struct bcma_drv_pci *pc, u8 device,
>>>              v = pcicore_read32(pc, BCMA_CORE_PCI_MDIO_CONTROL);
>>>              if (v & BCMA_CORE_PCI_MDIOCTL_ACCESS_DONE)
>>>                      break;
>>> -            msleep(1);
>>> +            udelay(1000);
>>>      }
>>>      pcicore_write32(pc, BCMA_CORE_PCI_MDIO_CONTROL, 0);
>>>  }
>>>
>>
>> Using msleep(1) here is not correct, but I do not know if udelay(1000)
>> is better. The BCM4706 SoC or more the kernel code you are using seams
>> to have problems with sleeping, at least that is my current assumption.
>> when I add an msleep(1) somewhere into the code the exception stops
>> there without an exception from the CPU.
>>
>> According to Documentation/timers/timers-howto.txt we should use
>> usleep_range for values from 10us to 20ms, but that also causes the same
>> problem as msleep() on this SoC.
>>
>> Hauke
>
> The BCM4706 SoC has problems with the Mips wait instruction and that is
> not activated in the Broadcom SDK, but in the OpenWrt kernel. I
> deactivated it [0] in my kernel and now the device boots without this
> patch for bcma. The patch to deactivate the mips wait instruction can
> not be mainlined, like it is now.
>
> Please drop this patch and use usleep_range(), that should work now.

Any suggestion about values? 900, 1100? 1000, 1200? 1000, 1500?

-- 
Rafał
