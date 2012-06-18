Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11630 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2FRID3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 04:03:29 -0400
From: Laxman Dewangan <ldewangan@nvidia.com>
To: Rakesh Kumar <krakesh@nvidia.com>, Wei Ni <wni@nvidia.com>,
	'Stephen Warren' <swarren@wwwdotorg.org>
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
Date: Mon, 18 Jun 2012 13:33:19 +0530
Subject: RE: Where to power on the wifi device before loading the driver.
Message-ID: <96C9D994977DD0439FB6D3FE3B13DD907DE14CB4E8@BGMAIL01.nvidia.com> (sfid-20120618_100336_590246_85612964)
References: <6B4D417B830BC44B8026029FD256F7F1C377BFFE88@HKMAIL01.nvidia.com>
 <4FD90352.9090606@wwwdotorg.org>
 <20120614063120.GA20167@avionic-0098.mockup.avionic-design.de>
 <20120614121234.GC3913@opensource.wolfsonmicro.com>
 <4FDA092E.10301@wwwdotorg.org>
 <6B4D417B830BC44B8026029FD256F7F1C377BFFE8D@HKMAIL01.nvidia.com>
 <4FDB5976.20809@wwwdotorg.org>
 <6B4D417B830BC44B8026029FD256F7F1C6EE2DD61F@HKMAIL01.nvidia.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DE14CB4DF@BGMAIL01.nvidia.com>
In-Reply-To: <96C9D994977DD0439FB6D3FE3B13DD907DE14CB4DF@BGMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If it is for power then it has to go via regulator. It does not make sense to directly control the gpio inside the wifi driver.


-----Original Message-----
From: linux-tegra-owner@vger.kernel.org [mailto:linux-tegra-owner@vger.kernel.org] On Behalf Of Rakesh Kumar
Sent: Monday, June 18, 2012 1:11 PM
To: Wei Ni; 'Stephen Warren'
Cc: Mark Brown; 'frankyl@broadcom.com'; Thierry Reding; Mursalin Akon; 'linux-mmc@vger.kernel.org'; devicetree-discuss@lists.ozlabs.org; 'linux-wireless@vger.kernel.org'; linux-tegra@vger.kernel.org; linux-arm-kernel@lists.infradead.org
Subject: RE: Where to power on the wifi device before loading the driver.

>Now if this means adding a child node under the SDIO controller to represent the attached device, and storing any settings required by that device in that child node, that's probably a reasonable basic approach.
>
>BTW, which GPIO is the power GPIO; is it WF_EN on the schematic? That seems reasonable to represent as a GPIO rather than a regulator since it connects directly into the WiFi device as a GPIO, and its use within the WiFi device can indeed be governed purely internally to the WiFi driver/HW. However, if this is some GPIO that controls the power to e.g.
>VBAT3V3_IN_WF, VDDIO_WF, or other power supply to the WiFi card, then it'd be better represented as a regulator, since the control point is outside the WiFi device.

Tegra uses two GPIO (WF_EN and WF_RST) to power on and reset bcm4329 card. In case of bcm4329, these two lines are shorted. Tegra does not control VBAT3V3_IN_WF, VDDIO_WF, or other power supply to the WiFi card based on these GPIO. Uses of these GPIO are internal to WiFi HW.  It is reasonable to represent as a GPU rather than regulator.

Rakesh
---
nvpublic

-----Original Message-----
From: Wei Ni 
Sent: 18 June 2012 11:50
To: 'Stephen Warren'; Rakesh Kumar
Cc: Mark Brown; 'frankyl@broadcom.com'; Thierry Reding; Mursalin Akon; 'linux-mmc@vger.kernel.org'; devicetree-discuss@lists.ozlabs.org; 'linux-wireless@vger.kernel.org'; linux-tegra@vger.kernel.org; linux-arm-kernel@lists.infradead.org
Subject: RE: Where to power on the wifi device before loading the driver.

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


--
To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
