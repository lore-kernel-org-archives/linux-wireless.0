Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:50004 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab2FMVRL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 17:17:11 -0400
Message-ID: <4FD90352.9090606@wwwdotorg.org> (sfid-20120613_231719_411217_CCADF99D)
Date: Wed, 13 Jun 2012 15:17:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"'linux-mmc@vger.kernel.org'" <linux-mmc@vger.kernel.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Mursalin Akon <makon@nvidia.com>,
	Rakesh Kumar <krakesh@nvidia.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Olof Johansson <olof@lixom.net>
Subject: Re: Where to power on the wifi device before loading the driver.
References: <6B4D417B830BC44B8026029FD256F7F1C377BFFE88@HKMAIL01.nvidia.com>
In-Reply-To: <6B4D417B830BC44B8026029FD256F7F1C377BFFE88@HKMAIL01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/13/2012 04:40 AM, Wei Ni wrote:
> Hi, all
> I'm working on the tegra30 wifi upstream issue.
> 
> The tegra30 board (Cardhu) use Broadcom 4329 as wifi device, and use brcmfmac as the wifi driver.
> 
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
> 
> I have no good idea for it, does anyone has suggestion?

The core of the issue is that:

* Tegra30 support is via device tree.
* We have an SDIO bus, and the WiFi device attached to that bus is
enumerable.
* Since the WiFi device is enumerable, no node exists in the DT to
represent it.
* However, the driver for the WiFi device needs certain information,
such as the reset GPIO ID and perhaps power GPIO.

For the power GPIO, it seems reasonable to either use the existing Tegra
SD controller's power-gpios DT property, or replace that property with a
real regulator binding. The SD driver would then control this. Still,
that approach would mean the WiFi driver wouldn't be able to control
power to the device directly, which might not be a good thing.

However, I'm not sure that the reset GPIO is also something that should
be controlled by the SD card driver; it seems like it's much more
closely related to the WiFi device/driver.

I wonder if the power and reset GPIO shouldn't be represented as a
combined custom regulator type, which knows how to sequence multiple GPIOs.

Perhaps SDIO "client" devices also need a way to communicate with their
"host port" to obtain services such as power and reset control?

This is all very similar to the WiFi rfkill discussion we have re: the
Toshiba AC100 a little while back, although that was USB rather than SDIO.
