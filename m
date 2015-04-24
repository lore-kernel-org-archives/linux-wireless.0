Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbbDXTyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 15:54:40 -0400
Date: Fri, 24 Apr 2015 21:54:36 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	tony.cho@atmel.com, Nicolas.FERRE@atmel.com,
	DL-NMI-KR-Kernel@atmel.com
Subject: Re: [PATCH 1/2] staging: wilc1000: Add SDIO/SPI 802.11 driver
Message-ID: <20150424195436.GB13603@kroah.com> (sfid-20150424_215443_957514_C45B18F0)
References: <8899ee1d8570c87be1934c685f188b8f04d374b6.1429868048.git.johnny.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8899ee1d8570c87be1934c685f188b8f04d374b6.1429868048.git.johnny.kim@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 24, 2015 at 07:20:00PM +0900, Johnny Kim wrote:
> This driver is for the wilc1000 which is a single chip IEEE 802.11
> b/g/n device.
> The driver works together with cfg80211, which is the kernel side of
> configuration management for wireless devices because the wilc1000
> chipset is fullmac where the MLME is managed in hardware.
> 
> The driver worked from kernel version 2.6.38 and being now ported
> to several others since then.
> A TODO file is included as well in this commit.
> 
> Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
> Signed-off-by: Rachel Kim <rachel.kim@atmel.com>
> Signed-off-by: Dean Lee <dean.lee@atmel.com>
> Signed-off-by: Chris Park <chris.park@atmel.com>
> ---
>  drivers/staging/Kconfig                            |    2 +
>  drivers/staging/Makefile                           |    1 +
>  drivers/staging/atmel/Kconfig                      |   14 +
>  drivers/staging/atmel/Makefile                     |    1 +
>  drivers/staging/atmel/TODO                         |    8 +
>  drivers/staging/atmel/wilc1000/Kconfig             |   61 +
>  drivers/staging/atmel/wilc1000/Makefile            |   41 +
>  .../staging/atmel/wilc1000/coreconfigsimulator.h   |   20 +
>  drivers/staging/atmel/wilc1000/coreconfigurator.c  | 2201 ++++++
>  drivers/staging/atmel/wilc1000/coreconfigurator.h  |  498 ++
>  drivers/staging/atmel/wilc1000/fifo_buffer.c       |  142 +
>  drivers/staging/atmel/wilc1000/fifo_buffer.h       |   23 +
>  drivers/staging/atmel/wilc1000/host_interface.c    | 8074 ++++++++++++++++++++
>  drivers/staging/atmel/wilc1000/host_interface.h    | 1344 ++++
>  drivers/staging/atmel/wilc1000/itypes.h            |   60 +
>  drivers/staging/atmel/wilc1000/linux_mon.c         |  643 ++
>  drivers/staging/atmel/wilc1000/linux_wlan.c        | 2953 +++++++
>  drivers/staging/atmel/wilc1000/linux_wlan_common.h |  170 +
>  drivers/staging/atmel/wilc1000/linux_wlan_sdio.c   |  249 +
>  drivers/staging/atmel/wilc1000/linux_wlan_sdio.h   |   14 +
>  drivers/staging/atmel/wilc1000/linux_wlan_spi.c    |  510 ++
>  drivers/staging/atmel/wilc1000/linux_wlan_spi.h    |   14 +
>  drivers/staging/atmel/wilc1000/wilc_debugfs.c      |  185 +
>  drivers/staging/atmel/wilc1000/wilc_errorsupport.h |   84 +
>  drivers/staging/atmel/wilc1000/wilc_event.h        |  123 +
>  drivers/staging/atmel/wilc1000/wilc_exported_buf.c |   76 +
>  drivers/staging/atmel/wilc1000/wilc_log.h          |   47 +
>  drivers/staging/atmel/wilc1000/wilc_memory.c       |   63 +
>  drivers/staging/atmel/wilc1000/wilc_memory.h       |  330 +
>  drivers/staging/atmel/wilc1000/wilc_msgqueue.c     |  211 +
>  drivers/staging/atmel/wilc1000/wilc_msgqueue.h     |  133 +
>  drivers/staging/atmel/wilc1000/wilc_osconfig.h     |   55 +
>  drivers/staging/atmel/wilc1000/wilc_oswrapper.h    |  133 +
>  drivers/staging/atmel/wilc1000/wilc_platform.h     |  181 +
>  drivers/staging/atmel/wilc1000/wilc_sdio.c         | 1298 ++++
>  drivers/staging/atmel/wilc1000/wilc_semaphore.c    |   70 +
>  drivers/staging/atmel/wilc1000/wilc_semaphore.h    |  115 +
>  drivers/staging/atmel/wilc1000/wilc_sleep.c        |   36 +
>  drivers/staging/atmel/wilc1000/wilc_sleep.h        |   45 +
>  drivers/staging/atmel/wilc1000/wilc_spi.c          | 1475 ++++
>  drivers/staging/atmel/wilc1000/wilc_strutils.c     |  431 ++
>  drivers/staging/atmel/wilc1000/wilc_strutils.h     |  412 +
>  drivers/staging/atmel/wilc1000/wilc_thread.c       |   35 +
>  drivers/staging/atmel/wilc1000/wilc_thread.h       |  153 +
>  drivers/staging/atmel/wilc1000/wilc_time.c         |  163 +
>  drivers/staging/atmel/wilc1000/wilc_time.h         |  205 +
>  drivers/staging/atmel/wilc1000/wilc_timer.c        |   51 +
>  drivers/staging/atmel/wilc1000/wilc_timer.h        |  153 +
>  drivers/staging/atmel/wilc1000/wilc_type.h         |   34 +
>  .../atmel/wilc1000/wilc_wfi_cfgoperations.c        | 4550 +++++++++++
>  .../atmel/wilc1000/wilc_wfi_cfgoperations.h        |  134 +
>  .../staging/atmel/wilc1000/wilc_wfi_netdevice.c    |  960 +++
>  .../staging/atmel/wilc1000/wilc_wfi_netdevice.h    |  277 +
>  drivers/staging/atmel/wilc1000/wilc_wlan.c         | 2434 ++++++
>  drivers/staging/atmel/wilc1000/wilc_wlan.h         |  321 +
>  drivers/staging/atmel/wilc1000/wilc_wlan_cfg.c     |  643 ++
>  drivers/staging/atmel/wilc1000/wilc_wlan_cfg.h     |   33 +
>  drivers/staging/atmel/wilc1000/wilc_wlan_if.h      |  991 +++
>  58 files changed, 33683 insertions(+)
>  mode change 100644 => 100755 drivers/staging/Kconfig
>  mode change 100644 => 100755 drivers/staging/Makefile

Why did you change these files to be executable?

>  create mode 100755 drivers/staging/atmel/Kconfig
>  create mode 100755 drivers/staging/atmel/Makefile
>  create mode 100755 drivers/staging/atmel/TODO
>  create mode 100755 drivers/staging/atmel/wilc1000/Kconfig
>  create mode 100755 drivers/staging/atmel/wilc1000/Makefile

Why do you have two levels of directories here?  Just move this to
drivers/staging/wlc1000, no need for "atmel" to be in the middle, right?


>  create mode 100755 drivers/staging/atmel/wilc1000/coreconfigsimulator.h
>  create mode 100755 drivers/staging/atmel/wilc1000/wilc_wlan_if.h

Ugh, all of these are executable, I think you need a better editor that
doesn't do that to the files :(

Can you fix this up and resend?


> 
> diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
> old mode 100644
> new mode 100755
> index bfacf69..8d09adf
> --- a/drivers/staging/Kconfig
> +++ b/drivers/staging/Kconfig
> @@ -112,4 +112,6 @@ source "drivers/staging/i2o/Kconfig"
>  
>  source "drivers/staging/fsl-mc/Kconfig"
>  
> +source "drivers/staging/atmel/Kconfig"
> +
>  endif # STAGING
> diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> old mode 100644
> new mode 100755
> index 2bbd1bf..b90f173
> --- a/drivers/staging/Makefile
> +++ b/drivers/staging/Makefile
> @@ -48,3 +48,4 @@ obj-$(CONFIG_COMMON_CLK_XLNX_CLKWZRD)	+= clocking-wizard/
>  obj-$(CONFIG_FB_TFT)		+= fbtft/
>  obj-$(CONFIG_I2O)		+= i2o/
>  obj-$(CONFIG_FSL_MC_BUS)	+= fsl-mc/
> +obj-$(CONFIG_ATMEL_SMARTCONNECT)	+= atmel/
> diff --git a/drivers/staging/atmel/Kconfig b/drivers/staging/atmel/Kconfig
> new file mode 100755
> index 0000000..d8a9bab
> --- /dev/null
> +++ b/drivers/staging/atmel/Kconfig
> @@ -0,0 +1,14 @@
> +menuconfig ATMEL_SMARTCONNECT
> +    bool "Atmel SmartConnect wireless cards Driver"
> +    depends on WLAN && CFG80211
> +#    select WIRELESS_EXT
> +#    select WEXT_PRIV
> +    ---help---
> +      This module adds support for wireless adapters based on
> +      Atmel chipsets.
> +
> +if ATMEL_SMARTCONNECT
> +
> +source "drivers/staging/atmel/wilc1000/Kconfig"
> +
> +endif
> diff --git a/drivers/staging/atmel/Makefile b/drivers/staging/atmel/Makefile
> new file mode 100755
> index 0000000..09dd414
> --- /dev/null
> +++ b/drivers/staging/atmel/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_ATMEL_SMARTCONNECT)		+= wilc1000/
> diff --git a/drivers/staging/atmel/TODO b/drivers/staging/atmel/TODO
> new file mode 100755
> index 0000000..78196a9
> --- /dev/null
> +++ b/drivers/staging/atmel/TODO
> @@ -0,0 +1,8 @@
> +TODO:
> +- remove the dependencies of kernel versions

What do you mean by this?

> +- remove OS wrapper functions
> +- remove custom debug and tracing functions
> +- rework comments and function headers(also coding style)
> +- remove warnings

Build warnings?  Or something else?

Just curious.

thanks,

greg k-h
