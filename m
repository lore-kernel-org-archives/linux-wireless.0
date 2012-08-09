Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18689 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360Ab2HIKnp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 06:43:45 -0400
Subject: How to get the irq flags from the dts file
From: Wei Ni <wni@nvidia.com>
To: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	<frankyl@broadcom.com>
CC: <devicetree-discuss@lists.ozlabs.org>,
	<brcm80211-dev-list@broadcom.com>,
	<linux-wireless@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 9 Aug 2012 18:43:26 +0800
Message-ID: <1344509006.2295.148.camel@tegra-chromium-2> (sfid-20120809_124408_260639_0E6232DF)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, all
I'm working on tegra wlan upstream issue.
The tegra board use the Broadcom 4329 as wlan device, and the driver is
the brcmfmac. 

This wlan driver support out-band-interrupt (OOB), I want to add DT
support to use this OOB.
I can add following lines in the dts file to create platform device and
pass the interrupt resource to the driver.

wlan {
        compatible = "broadcome, brcmf_sdio_pd";
        interrupt-parten = <&gpio>;
        interrupts = <144, 0x04>; /* IRQF_TRIGGER_HIGH */
};

In the wlan driver, it will use platform_get_resource() to get the
res->irq, res->flags, the irq number is right, but the flags will be
IORESOURCE_IRQ, not the 0x04 (IRQF_TRIGGER_HIGH).
The wlan driver wish this flags include the IRQF_TRGGER_* information,
and it will use this flags to configure other hw settings. If it is
wrong, the wlan can't work.

I checked drivers/of/irq.c, in function of_irq_to_resource(), it will
set r->flags = IORESOURCE_IRQ directly, not read the flags from the dtb
file. And I didn't find any of_xx api to get this flags.

How can I get this flags, does anyone has suggestion?

Thanks.
Wei.

