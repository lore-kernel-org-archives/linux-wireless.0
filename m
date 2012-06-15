Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:51773 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315Ab2FOPtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 11:49:14 -0400
Message-ID: <4FDB5976.20809@wwwdotorg.org> (sfid-20120615_174926_153647_1845423F)
Date: Fri, 15 Jun 2012 09:49:10 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"'frankyl@broadcom.com'" <frankyl@broadcom.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Mursalin Akon <makon@nvidia.com>,
	"'linux-mmc@vger.kernel.org'" <linux-mmc@vger.kernel.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	Rakesh Kumar <krakesh@nvidia.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Where to power on the wifi device before loading the driver.
References: <6B4D417B830BC44B8026029FD256F7F1C377BFFE88@HKMAIL01.nvidia.com> <4FD90352.9090606@wwwdotorg.org> <20120614063120.GA20167@avionic-0098.mockup.avionic-design.de> <20120614121234.GC3913@opensource.wolfsonmicro.com> <4FDA092E.10301@wwwdotorg.org> <6B4D417B830BC44B8026029FD256F7F1C377BFFE8D@HKMAIL01.nvidia.com>
In-Reply-To: <6B4D417B830BC44B8026029FD256F7F1C377BFFE8D@HKMAIL01.nvidia.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2012 12:09 AM, Wei Ni wrote:
> On Thu, Jun 14, 2012 at 23:54:22, Stephen Warren wrote:
>>>>> The core of the issue is that:
>>>
>>>>> * Tegra30 support is via device tree. * We have an SDIO bus, and 
>>>>> the WiFi device attached to that bus is enumerable. * Since the 
>>>>> WiFi device is enumerable, no node exists in the DT to represent 
>>>>> it. * However, the driver for the WiFi device needs certain 
>>>>> information, such as the reset GPIO ID and perhaps power GPIO.
>>>
>>>> PCI devices are also enumerable and yet they can be matched up with 
>>>> nodes in the device tree. Perhaps something similar could be added 
>>>> for the SDIO bus?
>>>
>>> This seems to make the most sense - pushing this through the 
>>> regulator API is just a bodge.
>>
>> Yes, that seems reasonable.
>>
>> Presumably the power GPIO should be a fixed regulator though, since it 
>> is a power control not just a plain old GPIO? That said, the current driver apparently deals with this as a GPIO already.
>>
>> The reset GPIO can separately/directly controlled by the WiFi driver though.
> 
> I talked with Franky, this power sequence is generally for 4329, so it mean this sequence can be put into the wifi driver.
> We can use the virtual platform device both for OOB and non OOB.
> I will send out patches later.

Can you please expand on what a "virtual platform device" is; device
tree typically represents real hardware rather than anything "virtual".

Now if this means adding a child node under the SDIO controller to
represent the attached device, and storing any settings required by that
device in that child node, that's probably a reasonable basic approach.

BTW, which GPIO is the power GPIO; is it WF_EN on the schematic? That
seems reasonable to represent as a GPIO rather than a regulator since it
connects directly into the WiFi device as a GPIO, and its use within the
WiFi device can indeed be governed purely internally to the WiFi
driver/HW. However, if this is some GPIO that controls the power to e.g.
VBAT3V3_IN_WF, VDDIO_WF, or other power supply to the WiFi card, then
it'd be better represented as a regulator, since the control point is
outside the WiFi device.
