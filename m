Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:53124 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab1AUTYW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 14:24:22 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 11:24:03 -0800
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>, <joe@perches.com>
Subject: [PATCH 00/83] staging: ath6kl: Style cleanup
Date: Fri, 21 Jan 2011 11:23:18 -0800
Message-ID: <1295637798-18355-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following set of patches fixes the driver's coding style in 
accordance with the Linux kernel coding style. The patches ended 
being huge so putting them up on a shared location where they can 
be retrieved using wget.

http://userweb.kernel.org/~vmehta/ath6kl-cleanup.tar.bz2

Joe Perches (83):
  staging: ath6kl: Convert enum A_STATUS to int
  staging: ath6kl: Remove A_SUCCESS macro
  staging: ath6kl: Remove A_FAILED macro
  staging: ath6kl: wmi.h: Convert packed structures with A_BOOL to u32
  staging: ath6kl: Convert bypasswmi to bool
  staging: ath6kl: Remove A_BOOL and TRUE/FALSE
  staging: ath6kl: Convert A_CHAR to char
  staging: ath6kl: Convert A_UINT8 to u8
  staging: ath6kl: Convert A_UINT16 to u16
  staging: ath6kl: Convert A_UINT32 to u32
  staging: ath6kl: Convert A_UINT64 to u64
  staging: ath6kl: Convert A_INT8 to s8
  staging: ath6kl: Convert A_INT16 to s16
  staging: ath6kl: Convert A_INT32 to s32
  staging: ath6kl: Convert (status != A_OK) to (status)
  staging: ath6kl: Remove #define A_OK
  staging: ath6kl: Convert leading spaces to tab indentation
  staging: ath6kl: Remove direct comparisons to true/false
  staging: ath6kl: Cuddle while open braces
  staging: ath6kl: Use do {} while (0) around #defines
  staging: ath6kl: Remove most uses of braces around single statements
  staging: ath6kl: Remove braces around single statement if { foo }
    else uses
  staging: ath6kl: Remove blank lines
  staging: ath6kl: Hoist assigns from ifs
  staging: ath6kl: Cuddle open brace to if
  staging: ath6kl: Cuddle else open brace
  staging: ath6kl: Add space after commas
  staging: ath6kl: Remove spaces before quoted newlines
  staging: ath6kl: Convert A_UCHAR to u8
  staging: ath6kl: Convert A_MEMCPY to memcpy
  staging: ath6kl: Convert A_MEMCMP to memcmp
  staging: ath6kl: Convert A_MALLOC to kmalloc/kzalloc
  staging: ath6kl: Convert A_MALLOC_NOWAIT to
    kmalloc/kzalloc(,GFP_ATOMIC)
  staging: ath6kl: Convert A_FREE to kfree
  staging: ath6kl: Convert A_MEMZERO to memset
  staging: ath6kl: Remove trailing whitespace
  staging: ath6kl: Convert AR_DEBUG_PRINTF to ath6k_dbg
  staging: ath6kl: Convert "if (NULL == var)" tests to "if (!var)"
  staging: ath6kl: Convert "if (var == NULL)" tests to "if (!var)"
  staging: ath6kl: Convert "(var != NULL)" tests to "(var)"
  staging: ath6kl: Convert "(NULL != var)" tests to "(var)"
  staging: ath6kl: Remove "== true" tests
  staging: ath6kl: Convert var == false to !var
  staging: ath6kl: Convert "false == " to !
  staging: ath6kl: Remove "true == "
  staging: ath6kl: Fix miscellaneous whitespace issues
  staging: ath6kl: Cleanup for loops and other whitespace
  staging: ath6kl: More miscelleous whitespace fixing
  staging: ath6kl: osapi_linux: Use ##__VA_ARGS__
  staging: ath6kl: Fix case statements
  staging: ath6kl: ioctl: Use a common status function
  staging: ath6kl: Whitespace corrections around {}
  staging: ath6kl: Deparenthesize returns
  staging: ath6kl: osapi_linux: More whitespace cruft removal
  staging: ath6kl: Add space before pointer
  staging: ath6kl: Convert ath6k_dbg(ATH_DEBUG_ERR to ath6k_err(
  staging: ath6kl: Convert ath6k_dbg(ATH_DEBUG_INFO to ath6k_info(
  staging: ath6kl: Convert ath6k_dbg(ATH_DEBUG_WARN to ath6k_warn(
  staging: ath6kl: Remove KERN_ALERT from A_PRINTF uses
  staging: ath6kl: Remove space after case label in .h file
  staging: ath6kl: Convert INLINE to inline
  staging: ath6kl: Cuddle do and open brace
  staging: ath6kl: Remove space between function and open parenthesis
  staging: ath6kl: Properly indent a switch/case block
  staging: ath6kl: Use proper spacing after u8*
  staging: ath6kl: Use consistent spacing for void *
  staging: ath6kl: Use consistent spacing around == and !=
  staging: ath6kl: Convert ath6k_dbg(ATH_DEBUG_ERROR to ath6k_err(
  staging: ath6kl: Convert __FUNCTION__ to __func__
  staging: ath6kl: Convert _A_FUNCNAME_ to __func__
  staging: ath6kl: Use compare_ether_addr and is_broadcast_ether_addr
  staging: ath6kl: Use is_broadcast_ether_addr and is_zero_ether_addr
  staging: ath6kl: Remove AR6000_ETH_ADDR_LEN use ETH_ALEN
  staging: ath6kl: Convert IEEE80211_IS_MULTICAST to
    is_multicast_ether_addr
  staging: ath6kl: Convert ATH_MAC_LEN to ETH_ALEN, remove ATH_MAC_ALEN
  staging: ath6kl: Convert IEEE80211_ADDR_LEN to ETH_ALEN
  staging: ath6kl: Remove unused #define MAC_ADDR_LEN
  staging: ath6kl: Convert "if (foo) kfree(foo)" to kfree(foo)
  staging: ath6kl: Convert if (ptr) { kfree(ptr); ptr=NULL; }
  staging: ath6kl: Use vsprintf extension %pM for mac addresses
  staging: ath6kl: Remove IS_MAC_NULL
  staging: ath6kl: Flatten directory structure
  staging: ath6kl: Convert include style from <foo> to "foo"

 drivers/staging/ath6kl/Makefile                    |   68 +-
 drivers/staging/ath6kl/ar3kconfig.c                |  524 ++
 drivers/staging/ath6kl/ar3kpsconfig.c              |  532 ++
 drivers/staging/ath6kl/ar3kpsparser.c              |  860 +++
 drivers/staging/ath6kl/ar6000_android.c            |  414 ++
 drivers/staging/ath6kl/ar6000_drv.c                | 6165 +++++++++++++++++
 drivers/staging/ath6kl/ar6000_pm.c                 |  724 ++
 drivers/staging/ath6kl/ar6000_raw_if.c             |  446 ++
 drivers/staging/ath6kl/ar6k.c                      | 1464 ++++
 drivers/staging/ath6kl/ar6k_events.c               |  773 +++
 drivers/staging/ath6kl/ar6k_gmbox.c                |  735 ++
 drivers/staging/ath6kl/ar6k_gmbox_hciuart.c        | 1302 ++++
 drivers/staging/ath6kl/ar6k_pal.c                  |  465 ++
 drivers/staging/ath6kl/bmi.c                       |  999 +++
 drivers/staging/ath6kl/bmi/include/bmi_internal.h  |   55 -
 drivers/staging/ath6kl/bmi/src/bmi.c               | 1010 ---
 drivers/staging/ath6kl/cfg80211.c                  | 1419 ++++
 drivers/staging/ath6kl/common_drv.c                |  981 +++
 drivers/staging/ath6kl/credit_dist.c               |  413 ++
 drivers/staging/ath6kl/dbglog.h                    |  120 +
 drivers/staging/ath6kl/dbglog_id.h                 |  544 ++
 drivers/staging/ath6kl/eeprom.c                    |  559 ++
 drivers/staging/ath6kl/export_hci_transport.c      |  125 +
 drivers/staging/ath6kl/hci_bridge.c                | 1111 +++
 drivers/staging/ath6kl/hif.c                       | 1303 ++++
 .../staging/ath6kl/hif/common/hif_sdio_common.h    |   87 -
 .../hif/sdio/linux_sdio/include/hif_internal.h     |  134 -
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   | 1298 ----
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |  393 --
 drivers/staging/ath6kl/hif_scatter.c               |  404 ++
 drivers/staging/ath6kl/htc.c                       |  563 ++
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          | 1471 ----
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |  398 --
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c   |  784 ---
 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c    |  756 ---
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        | 1280 ----
 drivers/staging/ath6kl/htc2/htc.c                  |  579 --
 drivers/staging/ath6kl/htc2/htc_debug.h            |   38 -
 drivers/staging/ath6kl/htc2/htc_internal.h         |  220 -
 drivers/staging/ath6kl/htc2/htc_recv.c             | 1578 -----
 drivers/staging/ath6kl/htc2/htc_send.c             | 1023 ---
 drivers/staging/ath6kl/htc2/htc_services.c         |  450 --
 drivers/staging/ath6kl/htc_recv.c                  | 1570 +++++
 drivers/staging/ath6kl/htc_send.c                  | 1052 +++
 drivers/staging/ath6kl/htc_services.c              |  440 ++
 drivers/staging/ath6kl/include/AR6002_regdump.h    |   60 +
 drivers/staging/ath6kl/include/AR6K_version.h      |   54 +
 drivers/staging/ath6kl/include/a_config.h          |   24 +-
 drivers/staging/ath6kl/include/a_debug.h           |   93 +-
 drivers/staging/ath6kl/include/a_drv.h             |   24 +-
 drivers/staging/ath6kl/include/a_drv_api.h         |  110 +-
 drivers/staging/ath6kl/include/a_hci.h             |  648 ++
 drivers/staging/ath6kl/include/a_osapi.h           |   31 +-
 drivers/staging/ath6kl/include/a_types.h           |   28 +-
 drivers/staging/ath6kl/include/addrs.h             |   86 +
 drivers/staging/ath6kl/include/aggr_recv_api.h     |   50 +-
 drivers/staging/ath6kl/include/aggr_rx_internal.h  |  114 +
 drivers/staging/ath6kl/include/ar3kconfig.h        |   35 +-
 drivers/staging/ath6kl/include/ar3kpsconfig.h      |   70 +
 drivers/staging/ath6kl/include/ar3kpsparser.h      |  113 +
 drivers/staging/ath6kl/include/ar6000_api.h        |   25 +-
 drivers/staging/ath6kl/include/ar6000_diag.h       |   29 +-
 drivers/staging/ath6kl/include/ar6000_drv.h        |  774 +++
 drivers/staging/ath6kl/include/ar6k.h              |  399 ++
 drivers/staging/ath6kl/include/ar6k_pal.h          |   36 +
 drivers/staging/ath6kl/include/ar6kap_common.h     |   14 +-
 drivers/staging/ath6kl/include/ar6xapi_linux.h     |  195 +
 drivers/staging/ath6kl/include/athbtfilter.h       |  145 +-
 drivers/staging/ath6kl/include/athdefs.h           |   75 +
 drivers/staging/ath6kl/include/athdrv_linux.h      | 1190 ++++
 drivers/staging/ath6kl/include/athendpack.h        |   27 +-
 drivers/staging/ath6kl/include/athstartpack.h      |   29 +-
 drivers/staging/ath6kl/include/athtypes_linux.h    |   51 +
 drivers/staging/ath6kl/include/bmi.h               |  108 +-
 drivers/staging/ath6kl/include/bmi_internal.h      |   54 +
 drivers/staging/ath6kl/include/bmi_msg.h           |  238 +
 drivers/staging/ath6kl/include/btcoexGpio.h        |   77 +
 drivers/staging/ath6kl/include/cfg80211.h          |   44 +
 drivers/staging/ath6kl/include/cnxmgmt.h           |   36 +
 .../ath6kl/include/common/AR6002/AR6002_regdump.h  |   60 -
 .../ath6kl/include/common/AR6002/AR6K_version.h    |   52 -
 .../staging/ath6kl/include/common/AR6002/addrs.h   |   90 -
 .../common/AR6002/hw2.0/hw/analog_intf_reg.h       |   64 -
 .../include/common/AR6002/hw2.0/hw/analog_reg.h    | 1932 ------
 .../include/common/AR6002/hw2.0/hw/apb_map.h       |   13 -
 .../include/common/AR6002/hw2.0/hw/gpio_reg.h      |  977 ---
 .../include/common/AR6002/hw2.0/hw/mbox_host_reg.h |  386 --
 .../include/common/AR6002/hw2.0/hw/mbox_reg.h      |  481 --
 .../include/common/AR6002/hw2.0/hw/rtc_reg.h       | 1163 ----
 .../ath6kl/include/common/AR6002/hw2.0/hw/si_reg.h |  186 -
 .../include/common/AR6002/hw2.0/hw/uart_reg.h      |  327 -
 .../include/common/AR6002/hw2.0/hw/vmc_reg.h       |   76 -
 .../common/AR6002/hw4.0/hw/analog_intf_ares_reg.h  | 3291 ---------
 .../AR6002/hw4.0/hw/analog_intf_athr_wlan_reg.h    | 3674 ----------
 .../common/AR6002/hw4.0/hw/analog_intf_reg.h       |   37 -
 .../common/AR6002/hw4.0/hw/apb_athr_wlan_map.h     |   40 -
 .../include/common/AR6002/hw4.0/hw/apb_map.h       |   48 -
 .../include/common/AR6002/hw4.0/hw/bb_lc_reg.h     | 7076 --------------------
 .../include/common/AR6002/hw4.0/hw/efuse_reg.h     |  108 -
 .../common/AR6002/hw4.0/hw/gpio_athr_wlan_reg.h    | 1253 ----
 .../include/common/AR6002/hw4.0/hw/gpio_reg.h      | 1094 ---
 .../include/common/AR6002/hw4.0/hw/mac_dma_reg.h   |  605 --
 .../include/common/AR6002/hw4.0/hw/mac_pcu_reg.h   | 3065 ---------
 .../include/common/AR6002/hw4.0/hw/mbox_host_reg.h |   37 -
 .../include/common/AR6002/hw4.0/hw/mbox_reg.h      |  560 --
 .../common/AR6002/hw4.0/hw/mbox_wlan_host_reg.h    |  522 --
 .../include/common/AR6002/hw4.0/hw/mbox_wlan_reg.h |  638 --
 .../include/common/AR6002/hw4.0/hw/rdma_reg.h      |  564 --
 .../include/common/AR6002/hw4.0/hw/rtc_reg.h       |  975 ---
 .../include/common/AR6002/hw4.0/hw/rtc_wlan_reg.h  | 2065 ------
 .../ath6kl/include/common/AR6002/hw4.0/hw/si_reg.h |  209 -
 .../include/common/AR6002/hw4.0/hw/uart_reg.h      |  260 -
 .../include/common/AR6002/hw4.0/hw/umbox_reg.h     |   37 -
 .../common/AR6002/hw4.0/hw/umbox_wlan_reg.h        |  322 -
 .../include/common/AR6002/hw4.0/hw/vmc_reg.h       |  167 -
 .../include/common/AR6002/hw4.0/hw/vmc_wlan_reg.h  |  195 -
 drivers/staging/ath6kl/include/common/a_hci.h      |  682 --
 drivers/staging/ath6kl/include/common/athdefs.h    |   84 -
 drivers/staging/ath6kl/include/common/bmi_msg.h    |  241 -
 drivers/staging/ath6kl/include/common/btcoexGpio.h |   86 -
 drivers/staging/ath6kl/include/common/cnxmgmt.h    |   36 -
 drivers/staging/ath6kl/include/common/dbglog.h     |  134 -
 drivers/staging/ath6kl/include/common/dbglog_id.h  |  558 --
 drivers/staging/ath6kl/include/common/discovery.h  |   75 -
 .../staging/ath6kl/include/common/dset_internal.h  |   63 -
 drivers/staging/ath6kl/include/common/dsetid.h     |  134 -
 .../staging/ath6kl/include/common/epping_test.h    |  120 -
 drivers/staging/ath6kl/include/common/gmboxif.h    |   78 -
 drivers/staging/ath6kl/include/common/gpio.h       |   45 -
 drivers/staging/ath6kl/include/common/htc.h        |  236 -
 .../staging/ath6kl/include/common/htc_services.h   |   52 -
 drivers/staging/ath6kl/include/common/ini_dset.h   |   82 -
 drivers/staging/ath6kl/include/common/pkt_log.h    |   45 -
 drivers/staging/ath6kl/include/common/regDb.h      |   29 -
 drivers/staging/ath6kl/include/common/regdump.h    |   59 -
 .../include/common/regulatory/reg_dbschema.h       |  237 -
 .../include/common/regulatory/reg_dbvalues.h       |  504 --
 drivers/staging/ath6kl/include/common/roaming.h    |   41 -
 drivers/staging/ath6kl/include/common/targaddrs.h  |  245 -
 drivers/staging/ath6kl/include/common/testcmd.h    |  185 -
 drivers/staging/ath6kl/include/common/tlpm.h       |   38 -
 drivers/staging/ath6kl/include/common/wlan_defs.h  |   79 -
 drivers/staging/ath6kl/include/common/wlan_dset.h  |   33 -
 drivers/staging/ath6kl/include/common/wmi.h        | 3119 ---------
 drivers/staging/ath6kl/include/common/wmi_thin.h   |  347 -
 drivers/staging/ath6kl/include/common/wmix.h       |  279 -
 drivers/staging/ath6kl/include/common_drv.h        |   58 +-
 drivers/staging/ath6kl/include/config_linux.h      |   60 +
 drivers/staging/ath6kl/include/dbglog.h            |  134 +
 drivers/staging/ath6kl/include/dbglog_api.h        |   10 +-
 drivers/staging/ath6kl/include/dbglog_id.h         |  557 ++
 drivers/staging/ath6kl/include/debug_linux.h       |   79 +
 drivers/staging/ath6kl/include/discovery.h         |   75 +
 drivers/staging/ath6kl/include/dl_list.h           |  162 +-
 drivers/staging/ath6kl/include/dset_api.h          |   33 +-
 drivers/staging/ath6kl/include/dset_internal.h     |   62 +
 drivers/staging/ath6kl/include/dsetid.h            |  133 +
 drivers/staging/ath6kl/include/epping_test.h       |  121 +
 .../staging/ath6kl/include/export_hci_transport.h  |   74 +
 drivers/staging/ath6kl/include/gmboxif.h           |   75 +
 drivers/staging/ath6kl/include/gpio.h              |   45 +
 drivers/staging/ath6kl/include/gpio_api.h          |   24 +-
 drivers/staging/ath6kl/include/hci_transport_api.h |  177 +-
 drivers/staging/ath6kl/include/hif.h               |  293 +-
 drivers/staging/ath6kl/include/hif_internal.h      |  133 +
 drivers/staging/ath6kl/include/hif_sdio_common.h   |   87 +
 drivers/staging/ath6kl/include/host_version.h      |    6 +-
 drivers/staging/ath6kl/include/htc.h               |  234 +
 drivers/staging/ath6kl/include/htc_api.h           |  453 +-
 drivers/staging/ath6kl/include/htc_debug.h         |   37 +
 drivers/staging/ath6kl/include/htc_internal.h      |  229 +
 drivers/staging/ath6kl/include/htc_packet.h        |  287 +-
 drivers/staging/ath6kl/include/htc_services.h      |   52 +
 .../staging/ath6kl/include/hw2.0/analog_intf_reg.h |   63 +
 drivers/staging/ath6kl/include/hw2.0/analog_reg.h  | 1931 ++++++
 drivers/staging/ath6kl/include/hw2.0/apb_map.h     |   13 +
 drivers/staging/ath6kl/include/hw2.0/gpio_reg.h    |  976 +++
 .../staging/ath6kl/include/hw2.0/mbox_host_reg.h   |  385 ++
 drivers/staging/ath6kl/include/hw2.0/mbox_reg.h    |  480 ++
 drivers/staging/ath6kl/include/hw2.0/rtc_reg.h     | 1162 ++++
 drivers/staging/ath6kl/include/hw2.0/si_reg.h      |  185 +
 drivers/staging/ath6kl/include/hw2.0/uart_reg.h    |  326 +
 drivers/staging/ath6kl/include/hw2.0/vmc_reg.h     |   75 +
 .../ath6kl/include/hw4.0/analog_intf_ares_reg.h    | 3288 +++++++++
 .../include/hw4.0/analog_intf_athr_wlan_reg.h      | 3671 ++++++++++
 .../staging/ath6kl/include/hw4.0/analog_intf_reg.h |   30 +
 .../ath6kl/include/hw4.0/apb_athr_wlan_map.h       |   39 +
 drivers/staging/ath6kl/include/hw4.0/apb_map.h     |   42 +
 drivers/staging/ath6kl/include/hw4.0/bb_lc_reg.h   | 7073 +++++++++++++++++++
 drivers/staging/ath6kl/include/hw4.0/efuse_reg.h   |  106 +
 .../ath6kl/include/hw4.0/gpio_athr_wlan_reg.h      | 1251 ++++
 drivers/staging/ath6kl/include/hw4.0/gpio_reg.h    | 1088 +++
 drivers/staging/ath6kl/include/hw4.0/mac_dma_reg.h |  599 ++
 drivers/staging/ath6kl/include/hw4.0/mac_pcu_reg.h | 3063 +++++++++
 .../staging/ath6kl/include/hw4.0/mbox_host_reg.h   |   30 +
 drivers/staging/ath6kl/include/hw4.0/mbox_reg.h    |  554 ++
 .../ath6kl/include/hw4.0/mbox_wlan_host_reg.h      |  520 ++
 .../staging/ath6kl/include/hw4.0/mbox_wlan_reg.h   |  636 ++
 drivers/staging/ath6kl/include/hw4.0/rdma_reg.h    |  562 ++
 drivers/staging/ath6kl/include/hw4.0/rtc_reg.h     |  969 +++
 .../staging/ath6kl/include/hw4.0/rtc_wlan_reg.h    | 2063 ++++++
 drivers/staging/ath6kl/include/hw4.0/si_reg.h      |  207 +
 drivers/staging/ath6kl/include/hw4.0/uart_reg.h    |  258 +
 drivers/staging/ath6kl/include/hw4.0/umbox_reg.h   |   30 +
 .../staging/ath6kl/include/hw4.0/umbox_wlan_reg.h  |  320 +
 drivers/staging/ath6kl/include/hw4.0/vmc_reg.h     |  161 +
 .../staging/ath6kl/include/hw4.0/vmc_wlan_reg.h    |  193 +
 drivers/staging/ath6kl/include/ieee80211.h         |  396 ++
 drivers/staging/ath6kl/include/ieee80211_ioctl.h   |  179 +
 drivers/staging/ath6kl/include/ieee80211_node.h    |   96 +
 drivers/staging/ath6kl/include/ini_dset.h          |   82 +
 drivers/staging/ath6kl/include/miscdrv.h           |   40 +
 drivers/staging/ath6kl/include/osapi_linux.h       |  421 ++
 drivers/staging/ath6kl/include/pkt_log.h           |   43 +
 drivers/staging/ath6kl/include/regDb.h             |   29 +
 drivers/staging/ath6kl/include/reg_dbschema.h      |  231 +
 drivers/staging/ath6kl/include/reg_dbvalues.h      |  495 ++
 drivers/staging/ath6kl/include/regdump.h           |   59 +
 drivers/staging/ath6kl/include/roaming.h           |   41 +
 drivers/staging/ath6kl/include/targaddrs.h         |  243 +
 drivers/staging/ath6kl/include/target_reg_table.h  |  256 +-
 drivers/staging/ath6kl/include/testcmd.h           |  185 +
 drivers/staging/ath6kl/include/tlpm.h              |   38 +
 drivers/staging/ath6kl/include/wlan_api.h          |  105 +-
 drivers/staging/ath6kl/include/wlan_config.h       |  111 +
 drivers/staging/ath6kl/include/wlan_defs.h         |   83 +
 drivers/staging/ath6kl/include/wlan_dset.h         |   33 +
 drivers/staging/ath6kl/include/wmi.h               | 3090 +++++++++
 drivers/staging/ath6kl/include/wmi_api.h           |  549 +-
 drivers/staging/ath6kl/include/wmi_filter_linux.h  |  289 +
 drivers/staging/ath6kl/include/wmi_host.h          |  102 +
 drivers/staging/ath6kl/include/wmi_thin.h          |  349 +
 drivers/staging/ath6kl/include/wmix.h              |  278 +
 drivers/staging/ath6kl/ioctl.c                     | 4123 ++++++++++++
 drivers/staging/ath6kl/miscdrv/ar3kconfig.c        |  566 --
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |  572 --
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h   |   75 -
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   |  969 ---
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h   |  127 -
 drivers/staging/ath6kl/miscdrv/common_drv.c        | 1027 ---
 drivers/staging/ath6kl/miscdrv/credit_dist.c       |  418 --
 drivers/staging/ath6kl/miscdrv/miscdrv.h           |   42 -
 drivers/staging/ath6kl/netbuf.c                    |  230 +
 drivers/staging/ath6kl/os/linux/ar6000_android.c   |  413 --
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       | 6444 ------------------
 drivers/staging/ath6kl/os/linux/ar6000_pm.c        |  731 --
 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c    |  455 --
 drivers/staging/ath6kl/os/linux/ar6k_pal.c         |  481 --
 drivers/staging/ath6kl/os/linux/cfg80211.c         | 1471 ----
 drivers/staging/ath6kl/os/linux/eeprom.c           |  574 --
 .../staging/ath6kl/os/linux/export_hci_transport.c |  125 -
 drivers/staging/ath6kl/os/linux/hci_bridge.c       | 1144 ----
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |  762 ---
 drivers/staging/ath6kl/os/linux/include/ar6k_pal.h |   36 -
 .../ath6kl/os/linux/include/ar6xapi_linux.h        |  197 -
 .../staging/ath6kl/os/linux/include/athdrv_linux.h | 1219 ----
 .../ath6kl/os/linux/include/athtypes_linux.h       |   53 -
 drivers/staging/ath6kl/os/linux/include/cfg80211.h |   50 -
 .../staging/ath6kl/os/linux/include/config_linux.h |   60 -
 .../staging/ath6kl/os/linux/include/debug_linux.h  |   50 -
 .../ath6kl/os/linux/include/export_hci_transport.h |   76 -
 .../ath6kl/os/linux/include/ieee80211_ioctl.h      |  179 -
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |  387 --
 .../staging/ath6kl/os/linux/include/wlan_config.h  |  111 -
 .../ath6kl/os/linux/include/wmi_filter_linux.h     |  293 -
 drivers/staging/ath6kl/os/linux/ioctl.c            | 4733 -------------
 drivers/staging/ath6kl/os/linux/netbuf.c           |  234 -
 drivers/staging/ath6kl/os/linux/wireless_ext.c     | 2725 --------
 drivers/staging/ath6kl/rcv_aggr.c                  |  636 ++
 drivers/staging/ath6kl/reorder/aggr_rx_internal.h  |  116 -
 drivers/staging/ath6kl/reorder/rcv_aggr.c          |  666 --
 drivers/staging/ath6kl/wireless_ext.c              | 2543 +++++++
 drivers/staging/ath6kl/wlan/include/ieee80211.h    |  401 --
 .../staging/ath6kl/wlan/include/ieee80211_node.h   |   93 -
 drivers/staging/ath6kl/wlan/src/wlan_node.c        |  636 --
 drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c |  200 -
 drivers/staging/ath6kl/wlan/src/wlan_utils.c       |   61 -
 drivers/staging/ath6kl/wlan_node.c                 |  561 ++
 drivers/staging/ath6kl/wlan_recv_beacon.c          |  198 +
 drivers/staging/ath6kl/wlan_utils.c                |   58 +
 drivers/staging/ath6kl/wmi.c                       | 6376 ++++++++++++++++++
 drivers/staging/ath6kl/wmi/wmi.c                   | 6670 ------------------
 drivers/staging/ath6kl/wmi/wmi_host.h              |  102 -
 283 files changed, 88023 insertions(+), 89618 deletions(-)
 create mode 100644 drivers/staging/ath6kl/ar3kconfig.c
 create mode 100644 drivers/staging/ath6kl/ar3kpsconfig.c
 create mode 100644 drivers/staging/ath6kl/ar3kpsparser.c
 create mode 100644 drivers/staging/ath6kl/ar6000_android.c
 create mode 100644 drivers/staging/ath6kl/ar6000_drv.c
 create mode 100644 drivers/staging/ath6kl/ar6000_pm.c
 create mode 100644 drivers/staging/ath6kl/ar6000_raw_if.c
 create mode 100644 drivers/staging/ath6kl/ar6k.c
 create mode 100644 drivers/staging/ath6kl/ar6k_events.c
 create mode 100644 drivers/staging/ath6kl/ar6k_gmbox.c
 create mode 100644 drivers/staging/ath6kl/ar6k_gmbox_hciuart.c
 create mode 100644 drivers/staging/ath6kl/ar6k_pal.c
 create mode 100644 drivers/staging/ath6kl/bmi.c
 delete mode 100644 drivers/staging/ath6kl/bmi/include/bmi_internal.h
 delete mode 100644 drivers/staging/ath6kl/bmi/src/bmi.c
 create mode 100644 drivers/staging/ath6kl/cfg80211.c
 create mode 100644 drivers/staging/ath6kl/common_drv.c
 create mode 100644 drivers/staging/ath6kl/credit_dist.c
 create mode 100644 drivers/staging/ath6kl/dbglog.h
 create mode 100644 drivers/staging/ath6kl/dbglog_id.h
 create mode 100644 drivers/staging/ath6kl/eeprom.c
 create mode 100644 drivers/staging/ath6kl/export_hci_transport.c
 create mode 100644 drivers/staging/ath6kl/hci_bridge.c
 create mode 100644 drivers/staging/ath6kl/hif.c
 delete mode 100644 drivers/staging/ath6kl/hif/common/hif_sdio_common.h
 delete mode 100644 drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
 delete mode 100644 drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
 delete mode 100644 drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
 create mode 100644 drivers/staging/ath6kl/hif_scatter.c
 create mode 100644 drivers/staging/ath6kl/htc.c
 delete mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k.c
 delete mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k.h
 delete mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
 delete mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
 delete mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
 delete mode 100644 drivers/staging/ath6kl/htc2/htc.c
 delete mode 100644 drivers/staging/ath6kl/htc2/htc_debug.h
 delete mode 100644 drivers/staging/ath6kl/htc2/htc_internal.h
 delete mode 100644 drivers/staging/ath6kl/htc2/htc_recv.c
 delete mode 100644 drivers/staging/ath6kl/htc2/htc_send.c
 delete mode 100644 drivers/staging/ath6kl/htc2/htc_services.c
 create mode 100644 drivers/staging/ath6kl/htc_recv.c
 create mode 100644 drivers/staging/ath6kl/htc_send.c
 create mode 100644 drivers/staging/ath6kl/htc_services.c
 create mode 100644 drivers/staging/ath6kl/include/AR6002_regdump.h
 create mode 100644 drivers/staging/ath6kl/include/AR6K_version.h
 create mode 100644 drivers/staging/ath6kl/include/a_hci.h
 create mode 100644 drivers/staging/ath6kl/include/addrs.h
 create mode 100644 drivers/staging/ath6kl/include/aggr_rx_internal.h
 create mode 100644 drivers/staging/ath6kl/include/ar3kpsconfig.h
 create mode 100644 drivers/staging/ath6kl/include/ar3kpsparser.h
 create mode 100644 drivers/staging/ath6kl/include/ar6000_drv.h
 create mode 100644 drivers/staging/ath6kl/include/ar6k.h
 create mode 100644 drivers/staging/ath6kl/include/ar6k_pal.h
 create mode 100644 drivers/staging/ath6kl/include/ar6xapi_linux.h
 create mode 100644 drivers/staging/ath6kl/include/athdefs.h
 create mode 100644 drivers/staging/ath6kl/include/athdrv_linux.h
 create mode 100644 drivers/staging/ath6kl/include/athtypes_linux.h
 create mode 100644 drivers/staging/ath6kl/include/bmi_internal.h
 create mode 100644 drivers/staging/ath6kl/include/bmi_msg.h
 create mode 100644 drivers/staging/ath6kl/include/btcoexGpio.h
 create mode 100644 drivers/staging/ath6kl/include/cfg80211.h
 create mode 100644 drivers/staging/ath6kl/include/cnxmgmt.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/AR6002_regdump.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/AR6K_version.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/addrs.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/analog_intf_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/analog_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/apb_map.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/gpio_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/mbox_host_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/mbox_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/rtc_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/si_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/uart_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/vmc_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/analog_intf_ares_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/analog_intf_athr_wlan_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/analog_intf_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/apb_athr_wlan_map.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/apb_map.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/bb_lc_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/efuse_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/gpio_athr_wlan_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/gpio_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mac_dma_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mac_pcu_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_host_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_wlan_host_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_wlan_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/rdma_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/rtc_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/rtc_wlan_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/si_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/uart_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/umbox_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/umbox_wlan_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/vmc_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/vmc_wlan_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/a_hci.h
 delete mode 100644 drivers/staging/ath6kl/include/common/athdefs.h
 delete mode 100644 drivers/staging/ath6kl/include/common/bmi_msg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/btcoexGpio.h
 delete mode 100644 drivers/staging/ath6kl/include/common/cnxmgmt.h
 delete mode 100644 drivers/staging/ath6kl/include/common/dbglog.h
 delete mode 100644 drivers/staging/ath6kl/include/common/dbglog_id.h
 delete mode 100644 drivers/staging/ath6kl/include/common/discovery.h
 delete mode 100644 drivers/staging/ath6kl/include/common/dset_internal.h
 delete mode 100644 drivers/staging/ath6kl/include/common/dsetid.h
 delete mode 100644 drivers/staging/ath6kl/include/common/epping_test.h
 delete mode 100644 drivers/staging/ath6kl/include/common/gmboxif.h
 delete mode 100644 drivers/staging/ath6kl/include/common/gpio.h
 delete mode 100644 drivers/staging/ath6kl/include/common/htc.h
 delete mode 100644 drivers/staging/ath6kl/include/common/htc_services.h
 delete mode 100644 drivers/staging/ath6kl/include/common/ini_dset.h
 delete mode 100644 drivers/staging/ath6kl/include/common/pkt_log.h
 delete mode 100644 drivers/staging/ath6kl/include/common/regDb.h
 delete mode 100644 drivers/staging/ath6kl/include/common/regdump.h
 delete mode 100644 drivers/staging/ath6kl/include/common/regulatory/reg_dbschema.h
 delete mode 100644 drivers/staging/ath6kl/include/common/regulatory/reg_dbvalues.h
 delete mode 100644 drivers/staging/ath6kl/include/common/roaming.h
 delete mode 100644 drivers/staging/ath6kl/include/common/targaddrs.h
 delete mode 100644 drivers/staging/ath6kl/include/common/testcmd.h
 delete mode 100644 drivers/staging/ath6kl/include/common/tlpm.h
 delete mode 100644 drivers/staging/ath6kl/include/common/wlan_defs.h
 delete mode 100644 drivers/staging/ath6kl/include/common/wlan_dset.h
 delete mode 100644 drivers/staging/ath6kl/include/common/wmi.h
 delete mode 100644 drivers/staging/ath6kl/include/common/wmi_thin.h
 delete mode 100644 drivers/staging/ath6kl/include/common/wmix.h
 create mode 100644 drivers/staging/ath6kl/include/config_linux.h
 create mode 100644 drivers/staging/ath6kl/include/dbglog.h
 create mode 100644 drivers/staging/ath6kl/include/dbglog_id.h
 create mode 100644 drivers/staging/ath6kl/include/debug_linux.h
 create mode 100644 drivers/staging/ath6kl/include/discovery.h
 create mode 100644 drivers/staging/ath6kl/include/dset_internal.h
 create mode 100644 drivers/staging/ath6kl/include/dsetid.h
 create mode 100644 drivers/staging/ath6kl/include/epping_test.h
 create mode 100644 drivers/staging/ath6kl/include/export_hci_transport.h
 create mode 100644 drivers/staging/ath6kl/include/gmboxif.h
 create mode 100644 drivers/staging/ath6kl/include/gpio.h
 create mode 100644 drivers/staging/ath6kl/include/hif_internal.h
 create mode 100644 drivers/staging/ath6kl/include/hif_sdio_common.h
 create mode 100644 drivers/staging/ath6kl/include/htc.h
 create mode 100644 drivers/staging/ath6kl/include/htc_debug.h
 create mode 100644 drivers/staging/ath6kl/include/htc_internal.h
 create mode 100644 drivers/staging/ath6kl/include/htc_services.h
 create mode 100644 drivers/staging/ath6kl/include/hw2.0/analog_intf_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw2.0/analog_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw2.0/apb_map.h
 create mode 100644 drivers/staging/ath6kl/include/hw2.0/gpio_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw2.0/mbox_host_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw2.0/mbox_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw2.0/rtc_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw2.0/si_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw2.0/uart_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw2.0/vmc_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/analog_intf_ares_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/analog_intf_athr_wlan_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/analog_intf_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/apb_athr_wlan_map.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/apb_map.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/bb_lc_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/efuse_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/gpio_athr_wlan_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/gpio_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/mac_dma_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/mac_pcu_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/mbox_host_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/mbox_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/mbox_wlan_host_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/mbox_wlan_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/rdma_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/rtc_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/rtc_wlan_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/si_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/uart_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/umbox_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/umbox_wlan_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/vmc_reg.h
 create mode 100644 drivers/staging/ath6kl/include/hw4.0/vmc_wlan_reg.h
 create mode 100644 drivers/staging/ath6kl/include/ieee80211.h
 create mode 100644 drivers/staging/ath6kl/include/ieee80211_ioctl.h
 create mode 100644 drivers/staging/ath6kl/include/ieee80211_node.h
 create mode 100644 drivers/staging/ath6kl/include/ini_dset.h
 create mode 100644 drivers/staging/ath6kl/include/miscdrv.h
 create mode 100644 drivers/staging/ath6kl/include/osapi_linux.h
 create mode 100644 drivers/staging/ath6kl/include/pkt_log.h
 create mode 100644 drivers/staging/ath6kl/include/regDb.h
 create mode 100644 drivers/staging/ath6kl/include/reg_dbschema.h
 create mode 100644 drivers/staging/ath6kl/include/reg_dbvalues.h
 create mode 100644 drivers/staging/ath6kl/include/regdump.h
 create mode 100644 drivers/staging/ath6kl/include/roaming.h
 create mode 100644 drivers/staging/ath6kl/include/targaddrs.h
 create mode 100644 drivers/staging/ath6kl/include/testcmd.h
 create mode 100644 drivers/staging/ath6kl/include/tlpm.h
 create mode 100644 drivers/staging/ath6kl/include/wlan_config.h
 create mode 100644 drivers/staging/ath6kl/include/wlan_defs.h
 create mode 100644 drivers/staging/ath6kl/include/wlan_dset.h
 create mode 100644 drivers/staging/ath6kl/include/wmi.h
 create mode 100644 drivers/staging/ath6kl/include/wmi_filter_linux.h
 create mode 100644 drivers/staging/ath6kl/include/wmi_host.h
 create mode 100644 drivers/staging/ath6kl/include/wmi_thin.h
 create mode 100644 drivers/staging/ath6kl/include/wmix.h
 create mode 100644 drivers/staging/ath6kl/ioctl.c
 delete mode 100644 drivers/staging/ath6kl/miscdrv/ar3kconfig.c
 delete mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
 delete mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
 delete mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
 delete mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h
 delete mode 100644 drivers/staging/ath6kl/miscdrv/common_drv.c
 delete mode 100644 drivers/staging/ath6kl/miscdrv/credit_dist.c
 delete mode 100644 drivers/staging/ath6kl/miscdrv/miscdrv.h
 create mode 100644 drivers/staging/ath6kl/netbuf.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6000_android.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6000_drv.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6000_pm.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6k_pal.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/cfg80211.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/eeprom.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/export_hci_transport.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/hci_bridge.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/ar6k_pal.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/athtypes_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/cfg80211.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/config_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/debug_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/export_hci_transport.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/ieee80211_ioctl.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/osapi_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/wlan_config.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/wmi_filter_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/ioctl.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/netbuf.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/wireless_ext.c
 create mode 100644 drivers/staging/ath6kl/rcv_aggr.c
 delete mode 100644 drivers/staging/ath6kl/reorder/aggr_rx_internal.h
 delete mode 100644 drivers/staging/ath6kl/reorder/rcv_aggr.c
 create mode 100644 drivers/staging/ath6kl/wireless_ext.c
 delete mode 100644 drivers/staging/ath6kl/wlan/include/ieee80211.h
 delete mode 100644 drivers/staging/ath6kl/wlan/include/ieee80211_node.h
 delete mode 100644 drivers/staging/ath6kl/wlan/src/wlan_node.c
 delete mode 100644 drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c
 delete mode 100644 drivers/staging/ath6kl/wlan/src/wlan_utils.c
 create mode 100644 drivers/staging/ath6kl/wlan_node.c
 create mode 100644 drivers/staging/ath6kl/wlan_recv_beacon.c
 create mode 100644 drivers/staging/ath6kl/wlan_utils.c
 create mode 100644 drivers/staging/ath6kl/wmi.c
 delete mode 100644 drivers/staging/ath6kl/wmi/wmi.c
 delete mode 100644 drivers/staging/ath6kl/wmi/wmi_host.h

