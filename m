Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:43838 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110Ab2FSB1t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 21:27:49 -0400
From: Philip Rakity <prakity@marvell.com>
To: Wei Ni <wni@nvidia.com>, 'Stephen Warren' <swarren@wwwdotorg.org>,
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
Date: Mon, 18 Jun 2012 18:23:35 -0700
Subject: RE: Where to power on the wifi device before loading the driver.
Message-ID: <43E4817426ED174AA81263BCECB4351D138E8ACD6B@sc-vexch3.marvell.com> (sfid-20120619_032754_033892_663C504C)
References: <6B4D417B830BC44B8026029FD256F7F1C377BFFE88@HKMAIL01.nvidia.com>
 <4FD90352.9090606@wwwdotorg.org>
 <20120614063120.GA20167@avionic-0098.mockup.avionic-design.de>
 <20120614121234.GC3913@opensource.wolfsonmicro.com>
 <4FDA092E.10301@wwwdotorg.org>
 <6B4D417B830BC44B8026029FD256F7F1C377BFFE8D@HKMAIL01.nvidia.com>
 <4FDB5976.20809@wwwdotorg.org>,<6B4D417B830BC44B8026029FD256F7F1C6EE2DD61F@HKMAIL01.nvidia.com>
In-Reply-To: <6B4D417B830BC44B8026029FD256F7F1C6EE2DD61F@HKMAIL01.nvidia.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Why can't you use the regulator notify to get called back on power or voltage change options to plumb in the manipulation of the gpio. I can imagine you might need to add a notify call in core.c if you need to assert the gpio before power is applied


________________________________________
From: linux-mmc-owner@vger.kernel.org [linux-mmc-owner@vger.kernel.org] On Behalf Of Wei Ni [wni@nvidia.com]
Sent: Sunday, June 17, 2012 11:20 PM
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
To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
