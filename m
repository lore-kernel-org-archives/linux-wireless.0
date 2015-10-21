Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40614 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbbJUKEf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 06:04:35 -0400
Message-ID: <562763BC.5030107@atmel.com> (sfid-20151021_120453_201270_5C186946)
Date: Wed, 21 Oct 2015 19:06:52 +0900
From: glen lee <glen.lee@atmel.com>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-wireless@vger.kernel.org>
CC: Rachel Kim <rachel.kim@atmel.com>, <devel@driverdev.osuosl.org>,
	"Chris Park" <chris.park@atmel.com>, <gregkh@linuxfoundation.org>,
	"Stanislav Kholmanskikh" <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	<linux-kernel@vger.kernel.org>, Tony Cho <tony.cho@atmel.com>,
	Leo Kim <leo.kim@atmel.com>
Subject: Re: [PATCH 00/19] staging/wilc1000 cleanups
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi arnd,

Thanks for the all the patches. :)
About the patch ( use proper naming for global symbols ),
We are planning to use this driver not only for wilc1000 but also for
other atmel wireless driver. I'd appreciate if you could use wl instead of wilc1000.

And the global variable g_linux_wlan will be placed in netdevice private data
and finally it will be removed. I already posted some of those patches.

Thanks,
Glen.


On 2015년 10월 21일 07:47, Arnd Bergmann wrote:
> After I screwed up two or three times trying to get the dependencies
> with the SPI and SDIO backends right, I ended up taking the time
> to do the real fix and make both coexist.
>
> This is a series of patches that address various issues with the
> driver, but is mainly targetted at splitting out the spi and sdio
> backends into separate drivers that can be built independent of
> one another.
>
> The last patch is more experimental than the others, hence the
> [RFC] annotation.
>
> Please review and test.
>
> 	Arnd
>
> Arnd Bergmann (19):
>    staging/wilc1000: remove unused functions
>    staging/wilc1000: make symbols static if possible
>    staging/wilc1000: use proper naming for global symbols
>    staging/wilc1000: move extern declarations to headers
>    staging/wilc1000: use NO_SECURITY instead of NO_ENCRYPT
>    staging/wilc1000: avoid static definitions in header
>    staging/wilc1000: remove linux_wlan_{device_power,device_detection}
>    staging/wilc1000: move wilc_wlan_inp_t into struct wilc
>    staging/wilc1000: move init/exit functions to driver files
>    staging/wilc1000: unify device pointer
>    staging/wilc1000: move wilc1000_ops to drivers
>    staging/wilc1000: use device pointer for phy creation
>    staging/wilc1000: move COMPLEMENT_BOOT code to linux_wlan_sdio.c
>    staging/wilc1000: get rid of WILC_SDIO_IRQ_GPIO
>    staging/wilc1000: turn enable_irq/disable_irq into callbacks
>    staging/wilc1000: remove WILC_SDIO/WILC_SPI macros
>    staging/wilc1000: pass hif operations through initialization
>    staging/wilc1000: split out bus specific modules
>    [RFC] staging/wilc1000: use more regular probing
>
>   drivers/staging/wilc1000/Kconfig                  |  66 +-
>   drivers/staging/wilc1000/Makefile                 |  16 +-
>   drivers/staging/wilc1000/coreconfigurator.c       |  12 +-
>   drivers/staging/wilc1000/coreconfigurator.h       |  12 +-
>   drivers/staging/wilc1000/host_interface.c         | 501 +++-------------
>   drivers/staging/wilc1000/host_interface.h         | 349 ++---------
>   drivers/staging/wilc1000/linux_mon.c              |  11 +-
>   drivers/staging/wilc1000/linux_wlan.c             | 695 +++++++---------------
>   drivers/staging/wilc1000/linux_wlan_common.h      |  18 +-
>   drivers/staging/wilc1000/linux_wlan_sdio.c        | 202 +++++--
>   drivers/staging/wilc1000/linux_wlan_sdio.h        |  14 -
>   drivers/staging/wilc1000/linux_wlan_spi.c         | 119 ++--
>   drivers/staging/wilc1000/linux_wlan_spi.h         |   8 -
>   drivers/staging/wilc1000/wilc_debugfs.c           |  20 +-
>   drivers/staging/wilc1000/wilc_sdio.c              | 213 +++----
>   drivers/staging/wilc1000/wilc_spi.c               | 276 +--------
>   drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 495 +++++++--------
>   drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |  87 +--
>   drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  21 +-
>   drivers/staging/wilc1000/wilc_wlan.c              | 180 +++---
>   drivers/staging/wilc1000/wilc_wlan.h              |  49 +-
>   drivers/staging/wilc1000/wilc_wlan_cfg.c          |   6 +-
>   drivers/staging/wilc1000/wilc_wlan_if.h           |  23 +-
>   23 files changed, 1171 insertions(+), 2222 deletions(-)
>   delete mode 100644 drivers/staging/wilc1000/linux_wlan_sdio.h
>

