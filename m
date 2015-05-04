Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:38506 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbbEDJOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 05:14:48 -0400
Message-ID: <55473847.7040507@atmel.com> (sfid-20150504_111452_347621_E6D73EA2)
Date: Mon, 4 May 2015 11:13:43 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
MIME-Version: 1.0
To: Johnny Kim <johnny.kim@atmel.com>, <gregkh@linuxfoundation.org>,
	<linux-wireless@vger.kernel.org>
CC: <chris.park@atmel.com>, <rachel.kim@atmel.com>,
	<tony.cho@atmel.com>
Subject: Re: [PATCH v2 1/2] staging: wilc1000: Add SDIO/SPI 802.11 driver
References: <90c05bda434a068796547a599e8ea5e3ad3acb21.1430301575.git.johnny.kim@atmel.com>
In-Reply-To: <90c05bda434a068796547a599e8ea5e3ad3acb21.1430301575.git.johnny.kim@atmel.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 29/04/2015 14:50, Johnny Kim a écrit :
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

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
> Changes in v2:
> - fix the permissions
> - fix the folder tree

Nitpicking: This ^^^ should go there vvv, just after the "---".


> ---
>  drivers/staging/Kconfig                           |    2 +
>  drivers/staging/Makefile                          |    1 +
>  drivers/staging/wilc1000/Kconfig                  |   55 +
>  drivers/staging/wilc1000/Makefile                 |   41 +
>  drivers/staging/wilc1000/TODO                     |    8 +
>  drivers/staging/wilc1000/coreconfigsimulator.h    |   20 +
>  drivers/staging/wilc1000/coreconfigurator.c       | 2201 ++++++
>  drivers/staging/wilc1000/coreconfigurator.h       |  498 ++
>  drivers/staging/wilc1000/fifo_buffer.c            |  142 +
>  drivers/staging/wilc1000/fifo_buffer.h            |   23 +
>  drivers/staging/wilc1000/host_interface.c         | 8074 +++++++++++++++++++++
>  drivers/staging/wilc1000/host_interface.h         | 1344 ++++
>  drivers/staging/wilc1000/itypes.h                 |   60 +
>  drivers/staging/wilc1000/linux_mon.c              |  643 ++
>  drivers/staging/wilc1000/linux_wlan.c             | 2953 ++++++++
>  drivers/staging/wilc1000/linux_wlan_common.h      |  170 +
>  drivers/staging/wilc1000/linux_wlan_sdio.c        |  249 +
>  drivers/staging/wilc1000/linux_wlan_sdio.h        |   14 +
>  drivers/staging/wilc1000/linux_wlan_spi.c         |  510 ++
>  drivers/staging/wilc1000/linux_wlan_spi.h         |   14 +
>  drivers/staging/wilc1000/wilc_debugfs.c           |  185 +
>  drivers/staging/wilc1000/wilc_errorsupport.h      |   84 +
>  drivers/staging/wilc1000/wilc_event.h             |  123 +
>  drivers/staging/wilc1000/wilc_exported_buf.c      |   76 +
>  drivers/staging/wilc1000/wilc_log.h               |   47 +
>  drivers/staging/wilc1000/wilc_memory.c            |   63 +
>  drivers/staging/wilc1000/wilc_memory.h            |  330 +
>  drivers/staging/wilc1000/wilc_msgqueue.c          |  211 +
>  drivers/staging/wilc1000/wilc_msgqueue.h          |  133 +
>  drivers/staging/wilc1000/wilc_osconfig.h          |   55 +
>  drivers/staging/wilc1000/wilc_oswrapper.h         |  133 +
>  drivers/staging/wilc1000/wilc_platform.h          |  181 +
>  drivers/staging/wilc1000/wilc_sdio.c              | 1298 ++++
>  drivers/staging/wilc1000/wilc_semaphore.c         |   70 +
>  drivers/staging/wilc1000/wilc_semaphore.h         |  115 +
>  drivers/staging/wilc1000/wilc_sleep.c             |   36 +
>  drivers/staging/wilc1000/wilc_sleep.h             |   45 +
>  drivers/staging/wilc1000/wilc_spi.c               | 1475 ++++
>  drivers/staging/wilc1000/wilc_strutils.c          |  431 ++
>  drivers/staging/wilc1000/wilc_strutils.h          |  412 ++
>  drivers/staging/wilc1000/wilc_thread.c            |   35 +
>  drivers/staging/wilc1000/wilc_thread.h            |  153 +
>  drivers/staging/wilc1000/wilc_time.c              |  163 +
>  drivers/staging/wilc1000/wilc_time.h              |  205 +
>  drivers/staging/wilc1000/wilc_timer.c             |   51 +
>  drivers/staging/wilc1000/wilc_timer.h             |  153 +
>  drivers/staging/wilc1000/wilc_type.h              |   34 +
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4592 ++++++++++++
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |  134 +
>  drivers/staging/wilc1000/wilc_wfi_netdevice.c     |  960 +++
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  277 +
>  drivers/staging/wilc1000/wilc_wlan.c              | 2434 +++++++
>  drivers/staging/wilc1000/wilc_wlan.h              |  321 +
>  drivers/staging/wilc1000/wilc_wlan_cfg.c          |  643 ++
>  drivers/staging/wilc1000/wilc_wlan_cfg.h          |   33 +
>  drivers/staging/wilc1000/wilc_wlan_if.h           |  991 +++
>  56 files changed, 33704 insertions(+)
>  create mode 100644 drivers/staging/wilc1000/Kconfig
>  create mode 100644 drivers/staging/wilc1000/Makefile
>  create mode 100644 drivers/staging/wilc1000/TODO
>  create mode 100644 drivers/staging/wilc1000/coreconfigsimulator.h
>  create mode 100644 drivers/staging/wilc1000/coreconfigurator.c
>  create mode 100644 drivers/staging/wilc1000/coreconfigurator.h
>  create mode 100644 drivers/staging/wilc1000/fifo_buffer.c
>  create mode 100644 drivers/staging/wilc1000/fifo_buffer.h
>  create mode 100644 drivers/staging/wilc1000/host_interface.c
>  create mode 100644 drivers/staging/wilc1000/host_interface.h
>  create mode 100644 drivers/staging/wilc1000/itypes.h
>  create mode 100644 drivers/staging/wilc1000/linux_mon.c
>  create mode 100644 drivers/staging/wilc1000/linux_wlan.c
>  create mode 100644 drivers/staging/wilc1000/linux_wlan_common.h
>  create mode 100644 drivers/staging/wilc1000/linux_wlan_sdio.c
>  create mode 100644 drivers/staging/wilc1000/linux_wlan_sdio.h
>  create mode 100644 drivers/staging/wilc1000/linux_wlan_spi.c
>  create mode 100644 drivers/staging/wilc1000/linux_wlan_spi.h
>  create mode 100644 drivers/staging/wilc1000/wilc_debugfs.c
>  create mode 100644 drivers/staging/wilc1000/wilc_errorsupport.h
>  create mode 100644 drivers/staging/wilc1000/wilc_event.h
>  create mode 100644 drivers/staging/wilc1000/wilc_exported_buf.c
>  create mode 100644 drivers/staging/wilc1000/wilc_log.h
>  create mode 100644 drivers/staging/wilc1000/wilc_memory.c
>  create mode 100644 drivers/staging/wilc1000/wilc_memory.h
>  create mode 100644 drivers/staging/wilc1000/wilc_msgqueue.c
>  create mode 100644 drivers/staging/wilc1000/wilc_msgqueue.h
>  create mode 100644 drivers/staging/wilc1000/wilc_osconfig.h
>  create mode 100644 drivers/staging/wilc1000/wilc_oswrapper.h
>  create mode 100644 drivers/staging/wilc1000/wilc_platform.h
>  create mode 100644 drivers/staging/wilc1000/wilc_sdio.c
>  create mode 100644 drivers/staging/wilc1000/wilc_semaphore.c
>  create mode 100644 drivers/staging/wilc1000/wilc_semaphore.h
>  create mode 100644 drivers/staging/wilc1000/wilc_sleep.c
>  create mode 100644 drivers/staging/wilc1000/wilc_sleep.h
>  create mode 100644 drivers/staging/wilc1000/wilc_spi.c
>  create mode 100644 drivers/staging/wilc1000/wilc_strutils.c
>  create mode 100644 drivers/staging/wilc1000/wilc_strutils.h
>  create mode 100644 drivers/staging/wilc1000/wilc_thread.c
>  create mode 100644 drivers/staging/wilc1000/wilc_thread.h
>  create mode 100644 drivers/staging/wilc1000/wilc_time.c
>  create mode 100644 drivers/staging/wilc1000/wilc_time.h
>  create mode 100644 drivers/staging/wilc1000/wilc_timer.c
>  create mode 100644 drivers/staging/wilc1000/wilc_timer.h
>  create mode 100644 drivers/staging/wilc1000/wilc_type.h
>  create mode 100644 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
>  create mode 100644 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
>  create mode 100644 drivers/staging/wilc1000/wilc_wfi_netdevice.c
>  create mode 100644 drivers/staging/wilc1000/wilc_wfi_netdevice.h
>  create mode 100644 drivers/staging/wilc1000/wilc_wlan.c
>  create mode 100644 drivers/staging/wilc1000/wilc_wlan.h
>  create mode 100644 drivers/staging/wilc1000/wilc_wlan_cfg.c
>  create mode 100644 drivers/staging/wilc1000/wilc_wlan_cfg.h
>  create mode 100644 drivers/staging/wilc1000/wilc_wlan_if.h
> 
> diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
> index bfacf69..da35af6 100644
> --- a/drivers/staging/Kconfig
> +++ b/drivers/staging/Kconfig
> @@ -112,4 +112,6 @@ source "drivers/staging/i2o/Kconfig"
>  
>  source "drivers/staging/fsl-mc/Kconfig"
>  
> +source "drivers/staging/wilc1000/Kconfig"
> +
>  endif # STAGING
> diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> index 2bbd1bf..edbe5ff 100644
> --- a/drivers/staging/Makefile
> +++ b/drivers/staging/Makefile
> @@ -48,3 +48,4 @@ obj-$(CONFIG_COMMON_CLK_XLNX_CLKWZRD)	+= clocking-wizard/
>  obj-$(CONFIG_FB_TFT)		+= fbtft/
>  obj-$(CONFIG_I2O)		+= i2o/
>  obj-$(CONFIG_FSL_MC_BUS)	+= fsl-mc/
> +obj-$(CONFIG_WILC1000)		+= wilc1000/
> diff --git a/drivers/staging/wilc1000/Kconfig b/drivers/staging/wilc1000/Kconfig
> new file mode 100644
> index 0000000..101f908
> --- /dev/null
> +++ b/drivers/staging/wilc1000/Kconfig
> @@ -0,0 +1,55 @@
> +config WILC1000
> +	tristate "WILC1000 support (WiFi only)"
> +	---help---
> +		This module only support IEEE 802.11n WiFi.
> +
> +choice
> +        prompt "Memory Allocation"
> +        depends on WILC1000
> +        default WILC1000_PREALLOCATE_AT_LOADING_DRIVER
> +
> +        config WILC1000_PREALLOCATE_AT_LOADING_DRIVER
> +                bool "Preallocate memory at loading driver"
> +                ---help---
> +                        This choice supports static allocation of the memory
> +                        for the receive buffer. The driver will allocate the RX buffer 
> +                        during initial time. The driver will also free the buffer
> +                        by calling network device stop.
> +
> +        config WILC1000_DYNAMICALLY_ALLOCATE_MEMROY
> +                bool "Dynamically allocate memory in real time"
> +                ---help---
> +                        This choice supports dynamic allocation of the memory
> +                        for the receive buffer. The driver will allocate the RX buffer
> +                        when it is required.
> +endchoice
> +
> +
> +choice
> +    prompt "Bus Type"
> +    depends on WILC1000 
> +    default WILC1000_SDIO
> +    
> +	config WILC1000_SDIO
> +	    bool "SDIO support"
> +	    depends on MMC
> +		---help---
> +			This module adds support for the SDIO interface of adapters using
> +			WILC chipset. Select this if your platform is using the SDIO bus. 
> +
> +	config WILC1000_SPI
> +	    bool "SPI support"
> +		---help---
> +			This module adds support for the SPI interface of adapters using
> +			WILC chipset. Select this if your platform is using the SPI bus. 
> +endchoice
> +
> +
> +config WILC1000_HW_OOB_INTR
> +    bool "Use out of band interrupt"
> +    depends on WILC1000 && WILC1000_SDIO
> +    default n
> +    ---help---
> +		If your platform don't recognize SDIO IRQ, connect chipset external IRQ pin
> +		and check this option. Or, Use this to get all interrupts including SDIO interrupts.
> +
> diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
> new file mode 100644
> index 0000000..84bd975
> --- /dev/null
> +++ b/drivers/staging/wilc1000/Makefile
> @@ -0,0 +1,41 @@
> +obj-$(CONFIG_WILC1000) += wilc1000.o
> +obj-$(CONFIG_WILC1000_PREALLOCATE_DURING_SYSTEM_BOOT) += wilc_exported_buf.o
> +
> +
> +ccflags-$(CONFIG_WILC1000_SDIO) += -DWILC_SDIO -DCOMPLEMENT_BOOT
> +ccflags-$(CONFIG_WILC1000_HW_OOB_INTR) += -DWILC_SDIO_IRQ_GPIO
> +ccflags-$(CONFIG_WILC1000_SPI) += -DWILC_SPI
> +
> +ccflags-y += -DSTA_FIRMWARE=\"atmel/wilc1000_fw.bin\" \
> +		-DAP_FIRMWARE=\"atmel/wilc1000_ap_fw.bin\" \
> +		-DP2P_CONCURRENCY_FIRMWARE=\"atmel/wilc1000_p2p_fw.bin\"
> +
> +ccflags-y += -I$(src)/ -DEXPORT_SYMTAB  -D__CHECK_ENDIAN__ -DWILC_ASIC_A0 \
> +		-DPLL_WORKAROUND -DCONNECT_DIRECT  -DAGING_ALG \
> +		-DWILC_PARSE_SCAN_IN_HOST -DDISABLE_PWRSAVE_AND_SCAN_DURING_IP \
> +		-DWILC_PLATFORM=WILC_LINUXKERNEL -Wno-unused-function -DUSE_WIRELESS \
> +		-DWILC_DEBUGFS
> +#ccflags-y += -DTCP_ACK_FILTER
> +
> +ccflags-$(CONFIG_WILC1000_PREALLOCATE_DURING_SYSTEM_BOOT) += -DMEMORY_STATIC \
> +								-DWILC_PREALLOC_AT_BOOT
> +
> +ccflags-$(CONFIG_WILC1000_PREALLOCATE_AT_LOADING_DRIVER) += -DMEMORY_STATIC \
> +								-DWILC_PREALLOC_AT_INSMOD
> +
> +ccflags-$(CONFIG_WILC1000_DYNAMICALLY_ALLOCATE_MEMROY) += -DWILC_NORMAL_ALLOC
> +
> +
> +wilc1000-objs := wilc_wfi_netdevice.o wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
> +			wilc_memory.o wilc_msgqueue.o wilc_semaphore.o wilc_sleep.o wilc_strutils.o \
> +			wilc_thread.o wilc_time.o wilc_timer.o coreconfigurator.o host_interface.o \
> +			fifo_buffer.o wilc_sdio.o wilc_spi.o wilc_wlan_cfg.o wilc_debugfs.o
> +
> +wilc1000-$(CONFIG_WILC1000_SDIO) += linux_wlan_sdio.o
> +wilc1000-$(CONFIG_WILC1000_SPI) += linux_wlan_spi.o
> +
> +WILC1000_SRC_VERSION = 10.0
> +PATCHLEVEL = 2
> +WILC1000_FW_VERSION = 0
> +
> +ccflags-y += -D__DRIVER_VERSION__=\"$(WILC1000_SRC_VERSION).$(PATCHLEVEL)\"
> diff --git a/drivers/staging/wilc1000/TODO b/drivers/staging/wilc1000/TODO
> new file mode 100644
> index 0000000..4dc807b
> --- /dev/null
> +++ b/drivers/staging/wilc1000/TODO
> @@ -0,0 +1,8 @@
> +TODO:
> +- remove the dependencies of kernel versions
> +- remove OS wrapper functions
> +- remove custom debug and tracing functions
> +- rework comments and function headers(also coding style)
> +- remove build warnings
> +- support soft-ap and p2p mode
> +- support resume/suspend function
> diff --git a/drivers/staging/wilc1000/coreconfigsimulator.h b/drivers/staging/wilc1000/coreconfigsimulator.h
> new file mode 100644
> index 0000000..6c3f431
> --- /dev/null
> +++ b/drivers/staging/wilc1000/coreconfigsimulator.h

[..]

-- 
Nicolas Ferre
