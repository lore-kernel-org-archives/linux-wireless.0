Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3331 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2FRGUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 02:20:18 -0400
From: Wei Ni <wni@nvidia.com>
To: 'Stephen Warren' <swarren@wwwdotorg.org>,
	Rakesh Kumar <krakesh@nvidia.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"'frankyl@broadcom.com'" <frankyl@broadcom.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Mursalin Akon <makon@nvidia.com>,
	"'linux-mmc@vger.kernel.org'" <linux-mmc@vger.kernel.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 18 Jun 2012 14:20:11 +0800
Subject: RE: Where to power on the wifi device before loading the driver.
Message-ID: <6B4D417B830BC44B8026029FD256F7F1C6EE2DD61F@HKMAIL01.nvidia.com> (sfid-20120618_082025_356504_5A7AF96E)
References: <6B4D417B830BC44B8026029FD256F7F1C377BFFE88@HKMAIL01.nvidia.com>
 <4FD90352.9090606@wwwdotorg.org>
 <20120614063120.GA20167@avionic-0098.mockup.avionic-design.de>
 <20120614121234.GC3913@opensource.wolfsonmicro.com>
 <4FDA092E.10301@wwwdotorg.org>
 <6B4D417B830BC44B8026029FD256F7F1C377BFFE8D@HKMAIL01.nvidia.com>
 <4FDB5976.20809@wwwdotorg.org>
In-Reply-To: <4FDB5976.20809@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 15, 2012 at 23:49:10, Stephen Warren wrote:
>> I talked with Franky, this power sequence is generally for 4329, so 
>> it mean this sequence can be put into the wifi driver.
>> We can use the virtual platform device both for OOB and non OOB.
>> I will send out patches later.
>
>Can you please expand on what a "virtual platform device" is; device tree typically represents real hardware rather than anything "virtual".

The "virtual platform device" is created before the real wifi device, so that it can pass the gpios to the driver, and power up the device before calling sdio_register_driver.
But as Franky said, this power sequence is only generally for 4329, not for the USB dongle chips. So it's not a good idea to add this "power up" in brcmfmac.

>
>Now if this means adding a child node under the SDIO controller to represent the attached device, and storing any settings required by that device in that child node, that's probably a reasonable basic approach.
>
>BTW, which GPIO is the power GPIO; is it WF_EN on the schematic? That seems reasonable to represent as a GPIO rather than a regulator since it connects directly into the WiFi device as a GPIO, and its use within the WiFi device can indeed be governed purely internally to the WiFi driver/HW. However, if this is some GPIO that controls the power to e.g.
>VBAT3V3_IN_WF, VDDIO_WF, or other power supply to the WiFi card, then it'd be better represented as a regulator, since the control point is outside the WiFi device.

I think Rakesh may can answer this.

Wei.
---
nvpublic


