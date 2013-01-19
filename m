Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44545 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab3ASRST (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2013 12:18:19 -0500
Message-ID: <50FAD54F.8080601@hauke-m.de> (sfid-20130119_181824_491223_EC2AB5FC)
Date: Sat, 19 Jan 2013 18:18:07 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Piotr Haber <phaber@broadcom.com>
CC: Rafal Milecki <zajec5@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: bcma: trouble with gpio
References: <50F95D45.6060601@broadcom.com>
In-Reply-To: <50F95D45.6060601@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/18/2013 03:33 PM, Piotr Haber wrote:
> Hi,
> 
> I turned GPIO support in bcma (CONFIG_BCMA_DRIVER_GPIO)
> and get this in log:
> 
> bcma: bus0: Found chip with id 0xA8D8, rev 0x01 and package 0x0A
> bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
> bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
> bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)
> bcma: bus0: Found rev 6 PMU (capabilities 0x108C2606)
> bcma: bus0: SPROM offset 0x830
> bcma: bus0: PMU resource config unknown or not needed for device 0xA8D8
> gpiochip_add: gpios -1..14 (bcma_gpio) failed to register
> bcma: bus0: Error registering GPIO driver: -28
> bcma: bus0: Bus registered
> bcma: bus1: Found chip with id 0x4313, rev 0x01 and package 0x08
> bcma: bus1: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x24, class 0x0)
> bcma: bus1: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x18, class 0x0)
> bcma: bus1: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x11, class 0x0)
> bcma: bus1: Found rev 8 PMU (capabilities 0x084C3008)
> bcma: bus1: SPROM offset 0x830
> gpiochip_add: gpios -1..14 (bcma_gpio) failed to register
> bcma: bus1: Error registering GPIO driver: -28
> bcma: bus1: Bus registered
> bcma: bus2: Found chip with id 0x4313, rev 0x01 and package 0x08
> bcma: bus2: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x24, class 0x0)
> bcma: bus2: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x18, class 0x0)
> bcma: bus2: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x11, class 0x0)
> bcma: bus2: Found rev 8 PMU (capabilities 0x084C3008)
> bcma: bus2: SPROM offset 0x830
> gpiochip_add: gpios -1..14 (bcma_gpio) failed to register
> bcma: bus2: Error registering GPIO driver: -28
> bcma: bus2: Bus registered
> 
> does that mean that gpio is not usable?

At least it is not usable through the standard linux gpio interface.

> what might be the problem?

Is this -28 (ENOSPC) originally returned in gpiochip_find_base() in
drivers/gpio/gpiolib.c?
I have no idea what's going wrong here, could you provide me with your
kernel config and what kernel version are you using?

> 
> Kind regards
> Piotr
> 

