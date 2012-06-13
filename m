Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4491 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab2FMRdS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 13:33:18 -0400
Message-ID: <4FD8CED9.6030901@broadcom.com> (sfid-20120613_193323_362012_62A9856D)
Date: Wed, 13 Jun 2012 10:33:13 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Wei Ni" <wni@nvidia.com>
cc: "Stephen Warren" <swarren@nvidia.com>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"'linux-mmc@vger.kernel.org'" <linux-mmc@vger.kernel.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"Mursalin Akon" <makon@nvidia.com>,
	"Rakesh Kumar" <krakesh@nvidia.com>
Subject: Re: Where to power on the wifi device before loading the
 driver.
References: <6B4D417B830BC44B8026029FD256F7F1C377BFFE88@HKMAIL01.nvidia.com>
In-Reply-To: <6B4D417B830BC44B8026029FD256F7F1C377BFFE88@HKMAIL01.nvidia.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wei,

On 06/13/2012 03:40 AM, Wei Ni wrote:
> In the brcmfmac init routine, it call sdio_register_driver() to register driver, if the wifi device is powered on, then the mmc driver will enumerate it, and call the probe callback routine.
>
> On the Cardhu, the wifi's power is controlled by two gpios (power-gpio and reset-gpio), the default state is power-off. So we need to power on it before calling sdio_register_driver(), if not, the mmc driver can't enumerate it, and will not call the probe routine.
> This power on sequence is:
> set power-gpio to 1 ;
> mdelay(100) ;
> set reset-gpio to 1 ;
> mdelay(200);
>
> My question is where to power on the wifi. We may have three places to power on it:
> 1. power on it in the brcmfmac driver before calling sdio_register_driver(). But I think this power sequence is special for tegra30 cardhu, it's not good to add it in the generic wifi driver, because different board may use the different way to power on the wifi.
> 2. power on it in the mmc driver. In our tegra SD driver, it has power-gpios property, which allow the slot to be powered. But this power is for mmc slot, could we add this wifi power sequence in the tegra SD driver?
> 3. hard-coded into DT. Set these gpios in the DT, something like pinmux settings, but in this way, it's not good to put the mdelay() value in the DT.

We introduced oob interrupt support in 3.5 [1]. We are using a virtual 
platform device to retrieve board specific oob interrupt GPIO setting. 
You should be able to implement the power control in this way as well. 
Brcmfmac gets the GPIOs through platform device interface, powers up the 
chip and triggers a card detection. Then 4329 should be enumerated by 
MMC stack. The reason we didn't implement this is the card detection. 
Some design doesn't have hardware card detection since the WiFi chip is 
already on board. And the current MMC stack doesn't have virtual card 
detection interface.

Franky

[1]: http://www.spinics.net/lists/linux-wireless/msg89335.html

