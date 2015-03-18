Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:38478 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964946AbbCRU6k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 16:58:40 -0400
Date: Wed, 18 Mar 2015 13:53:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	=?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH v7 0/6] wlcore: add device-tree support
Message-ID: <20150318205356.GW31346@atomide.com> (sfid-20150318_215846_545989_51BE988D)
References: <1426696710-6891-1-git-send-email-eliad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426696710-6891-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Eliad Peller <eliad@wizery.com> [150318 09:39]:
> Add device-tree support to the wlcore (wl12xx/wl18xx)
> driver.
> 
> Update the current users to use the bindings instead
> of pdata-quirks.
> 
> Finally, remove the deprecated wl12xx_platform_data
> struct (along with the da850 board file code that
> still uses it)
> 
> v7:
> * rebase (v4.0-rc4)
> * fix wlcore_spi compilation (remove platform data)
> * additional minor changes in driver code

Thanks for updating it, looks good to me now and still works
for me.

Regards,

Tony
 
> v6:
> * Add Luca's patches to pass irq_trigger/freq
> * Support wl12xx as well
> * Update all relevant platforms
> 
> Eliad Peller (4):
>   dt: bindings: add TI's wilink wireless device
>   wlcore: add device-tree support
>   ARM: dts: add wl12xx/wl18xx bindings
>   wlcore: remove wl12xx_platform_data
> 
> Luciano Coelho (2):
>   wlcore: set irq_trigger in board files instead of hiding behind a
>     quirk
>   wl12xx: use frequency instead of enumerations for pdata clocks
> 
>  .../devicetree/bindings/net/wireless/ti,wlcore.txt |  47 +++++++++
>  arch/arm/boot/dts/am335x-evmsk.dts                 |  11 ++
>  arch/arm/boot/dts/omap3-cm-t3517.dts               |  10 ++
>  arch/arm/boot/dts/omap3-cm-t3730.dts               |  10 ++
>  arch/arm/boot/dts/omap3-evm-common.dtsi            |  10 ++
>  arch/arm/boot/dts/omap3-igep0020-rev-f.dts         |   9 ++
>  arch/arm/boot/dts/omap3-igep0030-rev-g.dts         |   9 ++
>  arch/arm/boot/dts/omap3-zoom3.dts                  |  10 ++
>  arch/arm/boot/dts/omap4-panda-common.dtsi          |  10 ++
>  arch/arm/boot/dts/omap4-sdp.dts                    |  11 ++
>  arch/arm/boot/dts/omap4-var-som-om44-wlan.dtsi     |  10 ++
>  arch/arm/mach-davinci/Kconfig                      |  11 --
>  arch/arm/mach-davinci/board-da850-evm.c            | 112 ---------------------
>  arch/arm/mach-omap2/pdata-quirks.c                 |  74 --------------
>  drivers/net/wireless/ti/wilink_platform_data.c     |  25 -----
>  drivers/net/wireless/ti/wl12xx/main.c              |  63 ++++++++++--
>  drivers/net/wireless/ti/wl12xx/wl12xx.h            |  28 ++++++
>  drivers/net/wireless/ti/wlcore/boot.c              |   1 -
>  drivers/net/wireless/ti/wlcore/debugfs.c           |   2 +-
>  drivers/net/wireless/ti/wlcore/main.c              |  31 +++---
>  drivers/net/wireless/ti/wlcore/sdio.c              |  63 ++++++++++--
>  drivers/net/wireless/ti/wlcore/spi.c               |   6 +-
>  drivers/net/wireless/ti/wlcore/wlcore.h            |   5 +-
>  drivers/net/wireless/ti/wlcore/wlcore_i.h          |   6 +-
>  include/linux/wl12xx.h                             |  49 ---------
>  25 files changed, 311 insertions(+), 312 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt
> 
> -- 
> 1.8.5.2.229.g4448466.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
