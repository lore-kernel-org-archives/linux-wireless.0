Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19861 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2FSJNw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 05:13:52 -0400
From: Wei Ni <wni@nvidia.com>
To: 'Stephen Warren' <swarren@wwwdotorg.org>,
	Laxman Dewangan <ldewangan@nvidia.com>
CC: Rakesh Kumar <krakesh@nvidia.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
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
Date: Tue, 19 Jun 2012 17:13:47 +0800
Subject: RE: Where to power on the wifi device before loading the driver.
Message-ID: <6B4D417B830BC44B8026029FD256F7F1C6EE2DD625@HKMAIL01.nvidia.com> (sfid-20120619_111357_793817_769526DA)
References: <6B4D417B830BC44B8026029FD256F7F1C377BFFE88@HKMAIL01.nvidia.com>
 <4FD90352.9090606@wwwdotorg.org>
 <20120614063120.GA20167@avionic-0098.mockup.avionic-design.de>
 <20120614121234.GC3913@opensource.wolfsonmicro.com>
 <4FDA092E.10301@wwwdotorg.org>
 <6B4D417B830BC44B8026029FD256F7F1C377BFFE8D@HKMAIL01.nvidia.com>
 <4FDB5976.20809@wwwdotorg.org>
 <6B4D417B830BC44B8026029FD256F7F1C6EE2DD61F@HKMAIL01.nvidia.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DE14CB4DF@BGMAIL01.nvidia.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DE14CB4E8@BGMAIL01.nvidia.com>
 <4FDF42D9.2050305@wwwdotorg.org>
In-Reply-To: <4FDF42D9.2050305@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 18, 2012 at 23:01:45, Stephen Warren wrote:
>On 06/18/2012 02:03 AM, Laxman Dewangan wrote:
>> Rakesh Kumar wrote at Monday, June 18, 2012 1:11 PM:
>> > Stephen Warren wrote:
>> >> Now if this means adding a child node under the SDIO controller to 
>> >> represent the attached device, and storing any settings required 
>> >> by that device in that child node, that's probably a reasonable 
>> >> basic approach.
>> >>
>> >> BTW, which GPIO is the power GPIO; is it WF_EN on the schematic?
>> >> That seems reasonable to represent as a GPIO rather than a 
>> >> regulator since it connects directly into the WiFi device as a 
>> >> GPIO, and its use within the WiFi device can indeed be governed 
>> >> purely internally to the WiFi driver/HW. However, if this is some 
>> >> GPIO that controls the power to e.g. VBAT3V3_IN_WF, VDDIO_WF, or 
>> >> other power supply to the WiFi card, then it'd be better 
>> >> represented as a regulator, since the control point is outside the 
>> >> WiFi device.
>> >
>> > Tegra uses two GPIO (WF_EN and WF_RST) to power on and reset 
>> > bcm4329 card. In case of bcm4329, these two lines are shorted. 
>> > Tegra does not control VBAT3V3_IN_WF, VDDIO_WF, or other power 
>> > supply to the WiFi card based on these GPIO. Uses of these GPIO are 
>> > internal to WiFi HW.  It is reasonable to represent as a GPU rather 
>> > than regulator.
>>
>> If it is for power then it has to go via regulator. It does not make 
>> sense to directly control the gpio inside the wifi driver.
>
>As far as the board goes, WF_EN is just a GPIO signal to the WiFi card; 
>it doesn't gate power to the card. If it gates power inside the card, 
>that's an internal implementation detail of the card, and something I'd 
>be fine with the driver knowing directly, and hence I'm OK with representing
>this as a GPIO rather than a regulator - that's what it is externally to the WiFi device.

Because these gpio is just for wifi device, could we use the rfkill-gpio driver for this isse? We just need to add DT support in rfkill-gpio driver and add a device node in the DT. And the user also can use the rfkill interface to control the wifi device.

>
>(BTW everyone, many of the emails in this thread are awfully formatted 
>- top-posted and not word- wrapped. It's very hard to read them... I tried to reformat everything and fix it in this email)


