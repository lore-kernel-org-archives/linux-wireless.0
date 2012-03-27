Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:57464 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2C0T2A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 15:28:00 -0400
Message-ID: <4F7214A1.6080100@windriver.com> (sfid-20120327_212805_097804_DAD38668)
Date: Tue, 27 Mar 2012 15:27:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: Julian Calaby <julian.calaby@gmail.com>, <zajec5@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] bcma: fix build error on MIPS; implicit pcibios_enable_device
References: <1332720175-7659-1-git-send-email-paul.gortmaker@windriver.com> <CAGRGNgVBwKppzMa7HZeWm+ZW1a7u0JKwxxFS2xCRv=bpxXnk+Q@mail.gmail.com> <20120326012038.GA7722@windriver.com> <CAGRGNgVm_cNAdXZcSjj1oUz98vAVNEsdpZZ9L6=cc_sX_AZ8Rg@mail.gmail.com> <4F70543F.2010007@hauke-m.de> <20120326185641.GA22375@windriver.com> <4F719C46.9030006@hauke-m.de>
In-Reply-To: <4F719C46.9030006@hauke-m.de>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12-03-27 06:53 AM, Hauke Mehrtens wrote:
> On 03/26/2012 09:56 PM, Paul Gortmaker wrote:
>> The following is seen during allmodconfig builds for MIPS:
>>
>> drivers/bcma/driver_pci_host.c:518:2: error: implicit declaration
>> of function 'pcibios_enable_device' [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>> make[3]: *** [drivers/bcma/driver_pci_host.o] Error 1
>>
>> Most likey introduced by commit 49dc9577155576b10ff79f0c1486c816b01f58bf
>>
>>    "bcma: add PCIe host controller"
>>
>> Add the header instead of implicitly assuming it will be present.
>> Sounds like a good idea, but that alone doesn't fix anything.
>>
>> The real problem is that the Kconfig has settings related to whether
>> PCI is possible, i.e.
>>
>>  config BCMA_HOST_PCI_POSSIBLE
>>        bool
>>        depends on BCMA && PCI = y
>>        default y
>>
>>  config BCMA_HOST_PCI
>>        bool "Support for BCMA on PCI-host bus"
>>        depends on BCMA_HOST_PCI_POSSIBLE
>>
>> ...but what is missing is that BCMA_DRIVER_PCI_HOSTMODE doesn't
>> have any dependencies on the above.  Add one.
>>
>> CC: Hauke Mehrtens <hauke@hauke-m.de>
>> CC: John W. Linville <linville@tuxdriver.com>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>> ---
>>
>> [ v2: depend on BCMA_HOST_PCI_POSSIBLE, not BCMA_HOST_PCI ]
>>
>> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
>> index c1172da..6a0082d 100644
>> --- a/drivers/bcma/Kconfig
>> +++ b/drivers/bcma/Kconfig
>> @@ -29,7 +29,7 @@ config BCMA_HOST_PCI
>>  
>>  config BCMA_DRIVER_PCI_HOSTMODE
>>  	bool "Driver for PCI core working in hostmode"
>> -	depends on BCMA && MIPS
>> +	depends on BCMA && MIPS && BCMA_HOST_PCI_POSSIBLE
> 
> This is wrong the first patch you send was correct. Now it is possible
> to select BCMA_DRIVER_PCI_HOSTMODE without selecting BCMA_DRIVER_PCI
> which will cause build errors as host mode part uses bcma_pcie_read().
> 
> You should do this:
> +	depends on BCMA && MIPS && BCMA_DRIVER_PCI

OK, the text in your follow-up here was confusing.

http://marc.info/?l=linux-wireless&m=133276175202412&w=2

It made me think you agreed with the proposed correction
and wanted a v2, vs. agreeing with my v1 interpretation.

If John can grab the v1 and your ack'd by from here:

http://marc.info/?l=linux-wireless&m=133272031621916&w=2

then great. I'll leave it in the hands of the wireless
folks from here.

Paul.

> 
> Maybe I should make it possible to build it with pcie host mode support,
> but without pcie client mode support. For now it is not needed as all
> device I know of have an other bcma device behind the pcie bus.
> 
>>  	help
>>  	  PCI core hostmode operation (external PCI bus).
>>  
>> diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
>> index 4e20bcf..d2097a1 100644
>> --- a/drivers/bcma/driver_pci_host.c
>> +++ b/drivers/bcma/driver_pci_host.c
>> @@ -10,6 +10,7 @@
>>   */
>>  
>>  #include "bcma_private.h"
>> +#include <linux/pci.h>
>>  #include <linux/export.h>
>>  #include <linux/bcma/bcma.h>
>>  #include <asm/paccess.h>
> 
