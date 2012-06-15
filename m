Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15483 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2FOGKL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 02:10:11 -0400
From: Wei Ni <wni@nvidia.com>
To: 'Stephen Warren' <swarren@wwwdotorg.org>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"'frankyl@broadcom.com'" <frankyl@broadcom.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
	Mursalin Akon <makon@nvidia.com>,
	"'linux-mmc@vger.kernel.org'" <linux-mmc@vger.kernel.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	Rakesh Kumar <krakesh@nvidia.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 15 Jun 2012 14:09:41 +0800
Subject: RE: Where to power on the wifi device before loading the driver.
Message-ID: <6B4D417B830BC44B8026029FD256F7F1C377BFFE8D@HKMAIL01.nvidia.com> (sfid-20120615_081018_180155_096DE4C9)
References: <6B4D417B830BC44B8026029FD256F7F1C377BFFE88@HKMAIL01.nvidia.com>
 <4FD90352.9090606@wwwdotorg.org>
 <20120614063120.GA20167@avionic-0098.mockup.avionic-design.de>
 <20120614121234.GC3913@opensource.wolfsonmicro.com>
 <4FDA092E.10301@wwwdotorg.org>
In-Reply-To: <4FDA092E.10301@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 14, 2012 at 23:54:22, Stephen Warren wrote:
>>>> The core of the issue is that:
>>
>>>> * Tegra30 support is via device tree. * We have an SDIO bus, and 
>>>> the WiFi device attached to that bus is enumerable. * Since the 
>>>> WiFi device is enumerable, no node exists in the DT to represent 
>>>> it. * However, the driver for the WiFi device needs certain 
>>>> information, such as the reset GPIO ID and perhaps power GPIO.
>>
>>> PCI devices are also enumerable and yet they can be matched up with 
>>> nodes in the device tree. Perhaps something similar could be added 
>>> for the SDIO bus?
>>
>> This seems to make the most sense - pushing this through the 
>> regulator API is just a bodge.
>
>Yes, that seems reasonable.
>
>Presumably the power GPIO should be a fixed regulator though, since it 
>is a power control not just a plain old GPIO? That said, the current driver apparently deals with this as a GPIO already.
>
>The reset GPIO can separately/directly controlled by the WiFi driver though.

I talked with Franky, this power sequence is generally for 4329, so it mean this sequence can be put into the wifi driver.
We can use the virtual platform device both for OOB and non OOB.
I will send out patches later.

---
nvpublic
