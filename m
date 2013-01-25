Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1507 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904Ab3AYJ0y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 04:26:54 -0500
Message-ID: <51024FD6.7060407@broadcom.com> (sfid-20130125_102701_337004_5B67DED3)
Date: Fri, 25 Jan 2013 10:26:46 +0100
From: "Piotr Haber" <phaber@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "Rafal Milecki" <zajec5@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: bcma: trouble with gpio
References: <50F95D45.6060601@broadcom.com>
 <50FAD54F.8080601@hauke-m.de>
In-Reply-To: <50FAD54F.8080601@hauke-m.de>
Content-Type: text/plain;
 charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/19/13 18:18, Hauke Mehrtens wrote:
> On 01/18/2013 03:33 PM, Piotr Haber wrote:
>> Hi,
>>
>> I turned GPIO support in bcma (CONFIG_BCMA_DRIVER_GPIO)
>> and get this in log:
>>
>> bcma: bus0: Found chip with id 0xA8D8, rev 0x01 and package 0x0A
>> bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
>> bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
>> bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)
>> bcma: bus0: Found rev 6 PMU (capabilities 0x108C2606)
>> bcma: bus0: SPROM offset 0x830
>> bcma: bus0: PMU resource config unknown or not needed for device 0xA8D8
>> gpiochip_add: gpios -1..14 (bcma_gpio) failed to register
>> bcma: bus0: Error registering GPIO driver: -28
>> bcma: bus0: Bus registered
>> bcma: bus1: Found chip with id 0x4313, rev 0x01 and package 0x08
>> bcma: bus1: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x24, class 0x0)
>> bcma: bus1: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x18, class 0x0)
>> bcma: bus1: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x11, class 0x0)
>> bcma: bus1: Found rev 8 PMU (capabilities 0x084C3008)
>> bcma: bus1: SPROM offset 0x830
>> gpiochip_add: gpios -1..14 (bcma_gpio) failed to register
>> bcma: bus1: Error registering GPIO driver: -28
>> bcma: bus1: Bus registered
>> bcma: bus2: Found chip with id 0x4313, rev 0x01 and package 0x08
>> bcma: bus2: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x24, class 0x0)
>> bcma: bus2: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x18, class 0x0)
>> bcma: bus2: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x11, class 0x0)
>> bcma: bus2: Found rev 8 PMU (capabilities 0x084C3008)
>> bcma: bus2: SPROM offset 0x830
>> gpiochip_add: gpios -1..14 (bcma_gpio) failed to register
>> bcma: bus2: Error registering GPIO driver: -28
>> bcma: bus2: Bus registered
>>
>> does that mean that gpio is not usable?
> 
> At least it is not usable through the standard linux gpio interface.
> 
>> what might be the problem?
> 
> Is this -28 (ENOSPC) originally returned in gpiochip_find_base() in
> drivers/gpio/gpiolib.c?
> I have no idea what's going wrong here, could you provide me with your
> kernel config and what kernel version are you using?
> 
i'm on v3.8-rc2,
will update to latest wireless-testing and give it a try again





