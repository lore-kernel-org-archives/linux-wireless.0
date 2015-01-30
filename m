Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:41004 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbbA3XIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 18:08:52 -0500
Received: by mail-la0-f52.google.com with SMTP id ge10so26295921lab.11
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 15:08:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54CBE299.4070709@hauke-m.de>
References: <1422638566-7593-1-git-send-email-zajec5@gmail.com>
	<1422638566-7593-3-git-send-email-zajec5@gmail.com>
	<54CBE299.4070709@hauke-m.de>
Date: Sat, 31 Jan 2015 00:08:50 +0100
Message-ID: <CACna6rwarKekDeR6YL73HcErmu1WGENcN7wVq0gMUEyHq0HekA@mail.gmail.com> (sfid-20150131_000856_062144_9B47D25E)
Subject: Re: [PATCH 3/4] bcma: support bringing up bus hosted on PCIe Gen 2
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 January 2015 at 20:59, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 01/30/2015 06:22 PM, Rafał Miłecki wrote:
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>>  drivers/bcma/bcma_private.h            |  3 +++
>>  drivers/bcma/driver_pcie2.c            | 24 ++++++++++++++++++++++--
>>  drivers/bcma/host_pci.c                |  2 +-
>>  include/linux/bcma/bcma_driver_pcie2.h |  2 ++
>>  4 files changed, 28 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
>> index 351f4af..3692912 100644
>> --- a/drivers/bcma/bcma_private.h
>> +++ b/drivers/bcma/bcma_private.h
>> @@ -104,6 +104,9 @@ u32 bcma_pcie_read(struct bcma_drv_pci *pc, u32 address);
>>  void bcma_core_pci_up(struct bcma_drv_pci *pc);
>>  void bcma_core_pci_down(struct bcma_drv_pci *pc);
>>
>> +/* driver_pcie2.c */
>> +void bcma_core_pcie2_up(struct bcma_drv_pcie2 *pcie2);
>> +
>>  extern int bcma_chipco_watchdog_register(struct bcma_drv_cc *cc);
>>
>>  #ifdef CONFIG_BCMA_DRIVER_PCI_HOSTMODE
>> diff --git a/drivers/bcma/driver_pcie2.c b/drivers/bcma/driver_pcie2.c
>> index e4be537..c8913bc 100644
>> --- a/drivers/bcma/driver_pcie2.c
>> +++ b/drivers/bcma/driver_pcie2.c
>> @@ -156,14 +156,20 @@ static void pciedev_reg_pm_clk_period(struct bcma_drv_pcie2 *pcie2)
>>
>>  void bcma_core_pcie2_init(struct bcma_drv_pcie2 *pcie2)
>>  {
>> -     struct bcma_chipinfo *ci = &pcie2->core->bus->chipinfo;
>> +     struct bcma_bus *bus = pcie2->core->bus;
>> +     struct bcma_chipinfo *ci = &bus->chipinfo;
>>       u32 tmp;
>>
>>       tmp = pcie2_read32(pcie2, BCMA_CORE_PCIE2_SPROM(54));
>>       if ((tmp & 0xe) >> 1 == 2)
>>               bcma_core_pcie2_cfg_write(pcie2, 0x4e0, 0x17);
>>
>> -     /* TODO: Do we need pcie_reqsize? */
>> +     switch (bus->chipinfo.id) {
>> +     case BCMA_CHIP_ID_BCM4360:
>> +     case BCMA_CHIP_ID_BCM4352:
>> +             pcie2->reqsize = 0x3000; /* TODO: PCI_EXP_DEVCTL_READRQ_1024B */
>> +             break;
>> +     }
>
> In the PCIe controller used in the BCM4706 there was a bug, so that it
> did not support a request size bigger than 128 bytes. Broadcom "fixed"
> that in the PCIe device driver code by decreasing the value, but we
> fixed that in the PCIe controller code, see:
>
> commit f4a83e578e0011ddcfdbe1c62d0916dadb4802aa
> Author: Hauke Mehrtens <hauke@hauke-m.de>
> Date:   Fri Aug 23 23:22:29 2013 +0200
>
>     bcma: change max PCI read request size to 128
>
> It could be that the PCIe controller used on ARM SoCs has similar
> problems but supports bigger sizes now, but not so big ones.

Thanks for your comment! It seems indeed that Broadcom's shared code
provides function called si_pcie_set_request_size
My guess is that wl.ko has to contain something like
if (BCM4331)
        si_pcie_set_request_size(sih, 128);

So the question is: does wl.ko contain similar code for
BCM4352/BCM4360. It appears that wl.ko (at least for x86_64) uses
system calls for PCI R/W. So I've put debugging messages and there is
what I got:
[  235.036193] [pci_bus_read_config_dword]  pos:180 data:0x00102C10
[  235.036195] [pci_bus_write_config_dword] pos:180 value:0x00103C10
[  235.036199] [pci_bus_read_config_dword]  pos:180 data:0x00103C10
As you can see PCI_EXP_DEVCTL_READRQ has been changed from
boot-default 512B to default 1024B. It appears that wl.ko didn't call
si_pcie_set_request_size for my 14e4:43b1 BCM4352.

Of course it may be different for non x86_64 architectures, but I
can't say it at this point.

So the proposed code seems OK to me, we may need to modify it in the
future for some SoCs, but we can't say that right now.


> What is the default value for pcie2->reqsize?

0x0000 which is 128B.


>> +void bcma_core_pcie2_up(struct bcma_drv_pcie2 *pcie2)
>> +{
>> +     struct bcma_bus *bus = pcie2->core->bus;
>> +     struct pci_dev *dev = bus->host_pci;
>> +
>> +     pcie_capability_clear_and_set_word(dev, PCI_EXP_DEVCTL,
>> +                                        PCI_EXP_DEVCTL_READRQ,
>> +                                        pcie2->reqsize);
>
> Use pcie_set_readrq() if it is needed.

What do you mean by "if needed"? Is there anything wrong?

-- 
Rafał
