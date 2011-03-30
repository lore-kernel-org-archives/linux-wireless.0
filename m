Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47070 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122Ab1C3A4g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:56:36 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:56:12 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 00/34] ath6kl: cleanup series III
Date: Tue, 29 Mar 2011 17:55:57 -0700
Message-ID: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg,

here's my third series of cleanup on ath6kl. Worth noting is the
removal of all that ioctl and Androd crap, and in total about 10K LOC of
cleanup. It also starts focusingon the initialization aspects of the driver,
with focus on passing more error values in places where it should have. The
cleanup works seems to also have a huge impact on driver load time, the driver
scan also now feels a bit more snappier for whatever reason. My end goal
was to help with cleanup on the init for speed and also to get us to get
this thing to work on x86_64. Unfortunately I was unable to get all that
far with that but all this should help.

At this point our cleanup work will likely slow down for a bit until
further notice. Particularly our team will send in the near future
some AR6003 2.1.1 support and fix any bugs and enhancements required
to get ath6kl to work properly and as expected.

I have test compiled and load tested with a scan each patch, and tested
connectivity on the last patch. I've given our team more than enough
time to review these changes and so far no objections so I'm shooting
this out now. The only downside is I had to test all this on
wireless-testing instead of staging-next given that staging-next
is unstable at the moment. To do this I sucked in all patches for
ath6kl from staging-next and applied them to wireless-testing, then
I applied my series from staging-next.

This should apply cleanly to today's staging-next tree. Please let
me know if you have any issues.

Luis R. Rodriguez (34):
  ath6kl: s|A_FREE|kfree|g
  ath6kl: remove BMIENABLE_SET define
  ath6kl: propagate error values on ar6000_avail_ev()
  ath6kl: replace do while loop with function helpers on
    ar6000_avail_ev()
  ath6kl: remove SET_MODULE_OWNER usage
  ath6kl: move setting netdev for non-cf80211 case
  ath6kl: remove Bluetooth PAL code and WMI ACL TX/RX data support
  ath6kl: kill Android specific code
  ath6kl: remove all the wext and super extended private ioctl crap
  ath6kl: remove define ATH_AR6K_11N_SUPPORT
  ath6kl: remove dependency on LINUX and KERNEL_2_6 macros
  ath6kl: remove SEND_EVENT_TO_APP define
  ath6kl: remove USER_KEYS define
  ath6kl: remove unused define NO_SYNC_FLUSH
  ath6kl: remove define HTC_EP_STAT_PROFILING
  ath6kl: remove unused define WLAN_HEADERS
  ath6kl: remove INIT_MODE_DRV_ENABLED define
  ath6kl: use CONFIG_AR600x_SD31_XXX
  ath6kl: use CONFIG_AR600x_WB31_XXX
  ath6kl: use CONFIG_AR600x_SD32_XXX
  ath6kl: remove AR600x_CUSTOM_XXX define
  ath6kl: use CONFIG_ATH6KL_ENABLE_COEXISTENCE
  ath6kl: simplify btcoex parameter programming
  ath6kl: propagate errors on module setup
  ath6kl: remove useless plat_setup_power() calls
  ath6kl: propagate errors on hifEnableFunc() failures
  ath6kl: cleanup allocation and getting of the hif dev
  ath6kl: style cleanup on struct sdio_driver components
  ath6kl: remove completely pointles platform driver
  ath6kl: cleanup and move the ath6kl pm ops to be assigned statically
  ath6kl: rename the pm ops to something more sensible
  ath6kl: remove chatty debug messages on ath6kl driver ops
  ath6kl: remove ar6000_prepare_target() crap
  ath6kl: remove the HTC raw interface

 drivers/staging/ath6kl/Kconfig                     |   12 -
 drivers/staging/ath6kl/Makefile                    |   44 +-
 drivers/staging/ath6kl/bmi/src/bmi.c               |    8 +-
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |  380 +-
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |   10 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          |    2 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |    3 -
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |    2 +-
 drivers/staging/ath6kl/htc2/htc.c                  |   10 +-
 drivers/staging/ath6kl/htc2/htc_internal.h         |    8 -
 drivers/staging/ath6kl/htc2/htc_recv.c             |    6 -
 drivers/staging/ath6kl/htc2/htc_send.c             |    5 -
 drivers/staging/ath6kl/include/a_config.h          |   22 -
 drivers/staging/ath6kl/include/a_debug.h           |   28 -
 drivers/staging/ath6kl/include/a_drv.h             |   22 -
 drivers/staging/ath6kl/include/a_drv_api.h         |   28 -
 drivers/staging/ath6kl/include/a_osapi.h           |   29 -
 drivers/staging/ath6kl/include/a_types.h           |   26 -
 drivers/staging/ath6kl/include/ar6000_api.h        |   22 -
 drivers/staging/ath6kl/include/athendpack.h        |   52 -
 drivers/staging/ath6kl/include/athstartpack.h      |   55 -
 .../common/AR6002/hw4.0/hw/analog_intf_reg.h       |   13 -
 .../include/common/AR6002/hw4.0/hw/apb_map.h       |    8 -
 .../include/common/AR6002/hw4.0/hw/gpio_reg.h      |    8 -
 .../include/common/AR6002/hw4.0/hw/mbox_host_reg.h |   13 -
 .../include/common/AR6002/hw4.0/hw/mbox_reg.h      |    8 -
 .../include/common/AR6002/hw4.0/hw/rtc_reg.h       |    8 -
 .../include/common/AR6002/hw4.0/hw/umbox_reg.h     |   14 -
 .../include/common/AR6002/hw4.0/hw/vmc_reg.h       |    8 -
 drivers/staging/ath6kl/include/common/bmi_msg.h    |    8 -
 drivers/staging/ath6kl/include/common/dbglog.h     |    8 -
 .../staging/ath6kl/include/common/dset_internal.h  |    8 -
 drivers/staging/ath6kl/include/common/dsetid.h     |    8 -
 .../staging/ath6kl/include/common/epping_test.h    |    9 -
 drivers/staging/ath6kl/include/common/gmboxif.h    |    8 -
 drivers/staging/ath6kl/include/common/htc.h        |    9 -
 drivers/staging/ath6kl/include/common/regdump.h    |    8 -
 drivers/staging/ath6kl/include/common/targaddrs.h  |    8 -
 drivers/staging/ath6kl/include/common/wmi.h        |   10 +-
 drivers/staging/ath6kl/include/common/wmix.h       |    7 -
 drivers/staging/ath6kl/include/common_drv.h        |    4 -
 drivers/staging/ath6kl/miscdrv/ar3kconfig.c        |   22 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |   22 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   |   28 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h   |    5 -
 drivers/staging/ath6kl/miscdrv/common_drv.c        |   34 -
 drivers/staging/ath6kl/os/linux/ar6000_android.c   |  388 --
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |  666 +---
 drivers/staging/ath6kl/os/linux/ar6000_pm.c        |   77 -
 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c    |  455 --
 drivers/staging/ath6kl/os/linux/ar6k_pal.c         |  479 --
 drivers/staging/ath6kl/os/linux/cfg80211.c         |    4 +-
 drivers/staging/ath6kl/os/linux/eeprom.c           |  213 -
 drivers/staging/ath6kl/os/linux/hci_bridge.c       |    4 +-
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |  103 +-
 .../ath6kl/os/linux/include/ar6xapi_linux.h        |    8 -
 .../staging/ath6kl/os/linux/include/athdrv_linux.h |   41 +-
 .../staging/ath6kl/os/linux/include/config_linux.h |    7 -
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |   49 +-
 .../staging/ath6kl/os/linux/include/wlan_config.h  |   10 -
 .../ath6kl/os/linux/include/wmi_filter_linux.h     |    2 +-
 drivers/staging/ath6kl/os/linux/ioctl.c            | 4767 --------------------
 drivers/staging/ath6kl/os/linux/wireless_ext.c     | 2723 -----------
 drivers/staging/ath6kl/reorder/rcv_aggr.c          |   10 +-
 drivers/staging/ath6kl/wlan/include/ieee80211.h    |    4 -
 drivers/staging/ath6kl/wlan/src/wlan_node.c        |    6 +-
 drivers/staging/ath6kl/wmi/wmi.c                   |  223 +-
 67 files changed, 424 insertions(+), 10875 deletions(-)
 delete mode 100644 drivers/staging/ath6kl/include/athendpack.h
 delete mode 100644 drivers/staging/ath6kl/include/athstartpack.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6000_android.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6k_pal.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/ioctl.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/wireless_ext.c

