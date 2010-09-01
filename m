Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57376 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab0IAWve (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 18:51:34 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 01 Sep 2010 15:51:29 -0700
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<vmehta@atheros.com>, <devel@linuxdriverproject.org>
Subject: [PATCH 0/1] ath6kl: add ath6kl driver for AR6003 chip
Date: Wed, 1 Sep 2010 15:51:13 -0700
Message-ID: <1283381473-20415-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch adds support for the 802.11 chip, AR6003. It has been 
generated against the linux-next tree and is being targeted 
for the staging area.

A little bit about the chip and driver:
(Pls refer to http://wireless.kernel.org/en/users/Drivers/ath6kl
for details)

AR6003 is a single stream, SDIO based WiFi chip from Atheros
for mobile and embedded devices. 'ath6kl' is a full mac driver for
AR6003 and features both the station and AP mode. The station
mode supports 802.11 a/b/g/n with HT20(2.4/5GHz) and HT40(5GHz)
capabilities. Some of the other features include frame
aggregation, WPA/WPA2-PSK, WPA2 Enterprise, WPS, WoS, WMM,
WMM-PS, WAPI and BT coexistence. The AP mode can be operated only
in b/g mode with support for a subset of features mentioned above.

The actual patch can be downloaded from the following location:
http://www.kernel.org/~vmehta/0001-staging-add-ath6kl-driver-for-AR6003-chip.patch.gz
sha1sum: 97abbd1fe83619775c9db34967c8a21de20f7545

Vipin Mehta (1):
  ath6kl: add ath6kl driver for AR6003 chip

 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 drivers/staging/ath6kl/Kconfig                     |  163 +
 drivers/staging/ath6kl/Makefile                    |  159 +
 drivers/staging/ath6kl/TODO                        |    8 +
 drivers/staging/ath6kl/bmi/include/bmi_internal.h  |   55 +
 drivers/staging/ath6kl/bmi/src/bmi.c               | 1010 +++
 .../staging/ath6kl/hif/common/hif_sdio_common.h    |   87 +
 .../hif/sdio/linux_sdio/include/hif_internal.h     |  134 +
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   | 1298 ++++
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |  393 ++
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          | 1471 ++++
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |  398 ++
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c   |  784 +++
 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c    |  756 +++
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        | 1280 ++++
 drivers/staging/ath6kl/htc2/htc.c                  |  579 ++
 drivers/staging/ath6kl/htc2/htc_debug.h            |   38 +
 drivers/staging/ath6kl/htc2/htc_internal.h         |  220 +
 drivers/staging/ath6kl/htc2/htc_recv.c             | 1578 +++++
 drivers/staging/ath6kl/htc2/htc_send.c             | 1023 +++
 drivers/staging/ath6kl/htc2/htc_services.c         |  450 ++
 drivers/staging/ath6kl/include/a_config.h          |   53 +
 drivers/staging/ath6kl/include/a_debug.h           |  224 +
 drivers/staging/ath6kl/include/a_drv.h             |   54 +
 drivers/staging/ath6kl/include/a_drv_api.h         |  232 +
 drivers/staging/ath6kl/include/a_osapi.h           |   61 +
 drivers/staging/ath6kl/include/a_types.h           |   58 +
 drivers/staging/ath6kl/include/aggr_recv_api.h     |  140 +
 drivers/staging/ath6kl/include/ar3kconfig.h        |   65 +
 drivers/staging/ath6kl/include/ar6000_api.h        |   54 +
 drivers/staging/ath6kl/include/ar6000_diag.h       |   48 +
 drivers/staging/ath6kl/include/ar6kap_common.h     |   44 +
 drivers/staging/ath6kl/include/athbtfilter.h       |  135 +
 drivers/staging/ath6kl/include/athendpack.h        |   52 +
 drivers/staging/ath6kl/include/athstartpack.h      |   55 +
 drivers/staging/ath6kl/include/bmi.h               |  135 +
 .../ath6kl/include/common/AR6002/AR6002_regdump.h  |   60 +
 .../ath6kl/include/common/AR6002/AR6K_version.h    |   52 +
 .../staging/ath6kl/include/common/AR6002/addrs.h   |   90 +
 .../include/common/AR6002/hw.0/analog_intf_reg.h   |   64 +
 .../ath6kl/include/common/AR6002/hw.0/analog_reg.h | 1932 ++++++
 .../ath6kl/include/common/AR6002/hw.0/apb_map.h    |   13 +
 .../ath6kl/include/common/AR6002/hw.0/gpio_reg.h   |  977 +++
 .../include/common/AR6002/hw.0/mbox_host_reg.h     |  386 ++
 .../ath6kl/include/common/AR6002/hw.0/mbox_reg.h   |  481 ++
 .../ath6kl/include/common/AR6002/hw.0/rtc_reg.h    | 1163 ++++
 .../ath6kl/include/common/AR6002/hw.0/si_reg.h     |  186 +
 .../ath6kl/include/common/AR6002/hw.0/uart_reg.h   |  327 +
 .../ath6kl/include/common/AR6002/hw.0/vmc_reg.h    |   76 +
 .../staging/ath6kl/include/common/AR6002/hw2.0/hw  |    1 +
 .../common/AR6002/hw4.0/hw/analog_intf_ares_reg.h  | 3291 +++++++++
 .../AR6002/hw4.0/hw/analog_intf_athr_wlan_reg.h    | 3674 ++++++++++
 .../common/AR6002/hw4.0/hw/analog_intf_reg.h       |   37 +
 .../common/AR6002/hw4.0/hw/apb_athr_wlan_map.h     |   40 +
 .../include/common/AR6002/hw4.0/hw/apb_map.h       |   48 +
 .../include/common/AR6002/hw4.0/hw/bb_lc_reg.h     | 7076 ++++++++++++++++++++
 .../include/common/AR6002/hw4.0/hw/efuse_reg.h     |  108 +
 .../common/AR6002/hw4.0/hw/gpio_athr_wlan_reg.h    | 1253 ++++
 .../include/common/AR6002/hw4.0/hw/gpio_reg.h      | 1094 +++
 .../include/common/AR6002/hw4.0/hw/mac_dma_reg.h   |  605 ++
 .../include/common/AR6002/hw4.0/hw/mac_pcu_reg.h   | 3065 +++++++++
 .../include/common/AR6002/hw4.0/hw/mbox_host_reg.h |   37 +
 .../include/common/AR6002/hw4.0/hw/mbox_reg.h      |  560 ++
 .../common/AR6002/hw4.0/hw/mbox_wlan_host_reg.h    |  522 ++
 .../include/common/AR6002/hw4.0/hw/mbox_wlan_reg.h |  638 ++
 .../include/common/AR6002/hw4.0/hw/rdma_reg.h      |  564 ++
 .../include/common/AR6002/hw4.0/hw/rtc_reg.h       |  975 +++
 .../include/common/AR6002/hw4.0/hw/rtc_wlan_reg.h  | 2065 ++++++
 .../ath6kl/include/common/AR6002/hw4.0/hw/si_reg.h |  209 +
 .../include/common/AR6002/hw4.0/hw/uart_reg.h      |  260 +
 .../include/common/AR6002/hw4.0/hw/umbox_reg.h     |   37 +
 .../common/AR6002/hw4.0/hw/umbox_wlan_reg.h        |  322 +
 .../include/common/AR6002/hw4.0/hw/vmc_reg.h       |  167 +
 .../include/common/AR6002/hw4.0/hw/vmc_wlan_reg.h  |  195 +
 drivers/staging/ath6kl/include/common/a_hci.h      |  682 ++
 drivers/staging/ath6kl/include/common/athdefs.h    |   84 +
 drivers/staging/ath6kl/include/common/bmi_msg.h    |  241 +
 drivers/staging/ath6kl/include/common/btcoexGpio.h |   86 +
 drivers/staging/ath6kl/include/common/cnxmgmt.h    |   36 +
 drivers/staging/ath6kl/include/common/dbglog.h     |  134 +
 drivers/staging/ath6kl/include/common/dbglog_id.h  |  558 ++
 drivers/staging/ath6kl/include/common/discovery.h  |   75 +
 .../staging/ath6kl/include/common/dset_internal.h  |   63 +
 drivers/staging/ath6kl/include/common/dsetid.h     |  134 +
 .../staging/ath6kl/include/common/epping_test.h    |  120 +
 drivers/staging/ath6kl/include/common/gmboxif.h    |   78 +
 drivers/staging/ath6kl/include/common/gpio.h       |   45 +
 drivers/staging/ath6kl/include/common/htc.h        |  236 +
 .../staging/ath6kl/include/common/htc_services.h   |   52 +
 drivers/staging/ath6kl/include/common/ini_dset.h   |   82 +
 drivers/staging/ath6kl/include/common/pkt_log.h    |   45 +
 drivers/staging/ath6kl/include/common/regDb.h      |   29 +
 drivers/staging/ath6kl/include/common/regdump.h    |   59 +
 .../include/common/regulatory/reg_dbschema.h       |  237 +
 .../include/common/regulatory/reg_dbvalues.h       |  504 ++
 drivers/staging/ath6kl/include/common/roaming.h    |   41 +
 drivers/staging/ath6kl/include/common/targaddrs.h  |  245 +
 drivers/staging/ath6kl/include/common/testcmd.h    |  185 +
 drivers/staging/ath6kl/include/common/tlpm.h       |   38 +
 drivers/staging/ath6kl/include/common/wlan_defs.h  |   79 +
 drivers/staging/ath6kl/include/common/wlan_dset.h  |   33 +
 drivers/staging/ath6kl/include/common/wmi.h        | 3119 +++++++++
 drivers/staging/ath6kl/include/common/wmi_thin.h   |  347 +
 drivers/staging/ath6kl/include/common/wmix.h       |  279 +
 drivers/staging/ath6kl/include/common_drv.h        |  108 +
 drivers/staging/ath6kl/include/dbglog_api.h        |   52 +
 drivers/staging/ath6kl/include/dl_list.h           |  153 +
 drivers/staging/ath6kl/include/dset_api.h          |   65 +
 drivers/staging/ath6kl/include/gpio_api.h          |   59 +
 drivers/staging/ath6kl/include/hci_transport_api.h |  259 +
 drivers/staging/ath6kl/include/hif.h               |  458 ++
 drivers/staging/ath6kl/include/host_version.h      |   52 +
 drivers/staging/ath6kl/include/htc_api.h           |  575 ++
 drivers/staging/ath6kl/include/htc_packet.h        |  227 +
 drivers/staging/ath6kl/include/target_reg_table.h  |  244 +
 drivers/staging/ath6kl/include/wlan_api.h          |  128 +
 drivers/staging/ath6kl/include/wmi_api.h           |  441 ++
 drivers/staging/ath6kl/miscdrv/ar3kconfig.c        |  566 ++
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |  572 ++
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h   |   79 +
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   |  980 +++
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h   |  127 +
 drivers/staging/ath6kl/miscdrv/common_drv.c        | 1027 +++
 drivers/staging/ath6kl/miscdrv/credit_dist.c       |  418 ++
 drivers/staging/ath6kl/miscdrv/miscdrv.h           |   42 +
 drivers/staging/ath6kl/os/linux/ar6000_android.c   |  413 ++
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       | 6453 ++++++++++++++++++
 drivers/staging/ath6kl/os/linux/ar6000_pm.c        |  731 ++
 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c    |  455 ++
 drivers/staging/ath6kl/os/linux/ar6k_pal.c         |  481 ++
 drivers/staging/ath6kl/os/linux/cfg80211.c         | 1478 ++++
 drivers/staging/ath6kl/os/linux/eeprom.c           |  576 ++
 .../staging/ath6kl/os/linux/export_hci_transport.c |  125 +
 drivers/staging/ath6kl/os/linux/hci_bridge.c       | 1144 ++++
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |  770 +++
 drivers/staging/ath6kl/os/linux/include/ar6k_pal.h |   36 +
 .../ath6kl/os/linux/include/ar6xapi_linux.h        |  197 +
 .../staging/ath6kl/os/linux/include/athdrv_linux.h | 1219 ++++
 .../ath6kl/os/linux/include/athtypes_linux.h       |   53 +
 drivers/staging/ath6kl/os/linux/include/cfg80211.h |   50 +
 .../staging/ath6kl/os/linux/include/config_linux.h |   60 +
 .../staging/ath6kl/os/linux/include/debug_linux.h  |   50 +
 .../ath6kl/os/linux/include/export_hci_transport.h |   76 +
 .../ath6kl/os/linux/include/ieee80211_ioctl.h      |  179 +
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |  387 ++
 .../staging/ath6kl/os/linux/include/wlan_config.h  |  111 +
 .../ath6kl/os/linux/include/wmi_filter_linux.h     |  293 +
 drivers/staging/ath6kl/os/linux/ioctl.c            | 4649 +++++++++++++
 drivers/staging/ath6kl/os/linux/netbuf.c           |  236 +
 drivers/staging/ath6kl/os/linux/wireless_ext.c     | 2725 ++++++++
 drivers/staging/ath6kl/reorder/aggr_rx_internal.h  |  116 +
 drivers/staging/ath6kl/reorder/rcv_aggr.c          |  666 ++
 drivers/staging/ath6kl/wlan/include/ieee80211.h    |  401 ++
 .../staging/ath6kl/wlan/include/ieee80211_node.h   |   93 +
 drivers/staging/ath6kl/wlan/src/wlan_node.c        |  636 ++
 drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c |  200 +
 drivers/staging/ath6kl/wlan/src/wlan_utils.c       |   61 +
 drivers/staging/ath6kl/wmi/wmi.c                   | 6672 ++++++++++++++++++
 drivers/staging/ath6kl/wmi/wmi_host.h              |  102 +
 160 files changed, 92419 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/ath6kl/Kconfig
 create mode 100644 drivers/staging/ath6kl/Makefile
 create mode 100644 drivers/staging/ath6kl/TODO
 create mode 100644 drivers/staging/ath6kl/bmi/include/bmi_internal.h
 create mode 100644 drivers/staging/ath6kl/bmi/src/bmi.c
 create mode 100644 drivers/staging/ath6kl/hif/common/hif_sdio_common.h
 create mode 100644 drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
 create mode 100644 drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
 create mode 100644 drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
 create mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k.c
 create mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k.h
 create mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
 create mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
 create mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
 create mode 100644 drivers/staging/ath6kl/htc2/htc.c
 create mode 100644 drivers/staging/ath6kl/htc2/htc_debug.h
 create mode 100644 drivers/staging/ath6kl/htc2/htc_internal.h
 create mode 100644 drivers/staging/ath6kl/htc2/htc_recv.c
 create mode 100644 drivers/staging/ath6kl/htc2/htc_send.c
 create mode 100644 drivers/staging/ath6kl/htc2/htc_services.c
 create mode 100644 drivers/staging/ath6kl/include/a_config.h
 create mode 100644 drivers/staging/ath6kl/include/a_debug.h
 create mode 100644 drivers/staging/ath6kl/include/a_drv.h
 create mode 100644 drivers/staging/ath6kl/include/a_drv_api.h
 create mode 100644 drivers/staging/ath6kl/include/a_osapi.h
 create mode 100644 drivers/staging/ath6kl/include/a_types.h
 create mode 100644 drivers/staging/ath6kl/include/aggr_recv_api.h
 create mode 100644 drivers/staging/ath6kl/include/ar3kconfig.h
 create mode 100644 drivers/staging/ath6kl/include/ar6000_api.h
 create mode 100644 drivers/staging/ath6kl/include/ar6000_diag.h
 create mode 100644 drivers/staging/ath6kl/include/ar6kap_common.h
 create mode 100644 drivers/staging/ath6kl/include/athbtfilter.h
 create mode 100644 drivers/staging/ath6kl/include/athendpack.h
 create mode 100644 drivers/staging/ath6kl/include/athstartpack.h
 create mode 100644 drivers/staging/ath6kl/include/bmi.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/AR6002_regdump.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/AR6K_version.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/addrs.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/analog_intf_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/analog_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/apb_map.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/gpio_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/mbox_host_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/mbox_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/rtc_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/si_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/uart_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/vmc_reg.h
 create mode 120000 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/analog_intf_ares_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/analog_intf_athr_wlan_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/analog_intf_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/apb_athr_wlan_map.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/apb_map.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/bb_lc_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/efuse_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/gpio_athr_wlan_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/gpio_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mac_dma_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mac_pcu_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_host_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_wlan_host_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_wlan_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/rdma_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/rtc_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/rtc_wlan_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/si_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/uart_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/umbox_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/umbox_wlan_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/vmc_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/vmc_wlan_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/a_hci.h
 create mode 100644 drivers/staging/ath6kl/include/common/athdefs.h
 create mode 100644 drivers/staging/ath6kl/include/common/bmi_msg.h
 create mode 100644 drivers/staging/ath6kl/include/common/btcoexGpio.h
 create mode 100644 drivers/staging/ath6kl/include/common/cnxmgmt.h
 create mode 100644 drivers/staging/ath6kl/include/common/dbglog.h
 create mode 100644 drivers/staging/ath6kl/include/common/dbglog_id.h
 create mode 100644 drivers/staging/ath6kl/include/common/discovery.h
 create mode 100644 drivers/staging/ath6kl/include/common/dset_internal.h
 create mode 100644 drivers/staging/ath6kl/include/common/dsetid.h
 create mode 100644 drivers/staging/ath6kl/include/common/epping_test.h
 create mode 100644 drivers/staging/ath6kl/include/common/gmboxif.h
 create mode 100644 drivers/staging/ath6kl/include/common/gpio.h
 create mode 100644 drivers/staging/ath6kl/include/common/htc.h
 create mode 100644 drivers/staging/ath6kl/include/common/htc_services.h
 create mode 100644 drivers/staging/ath6kl/include/common/ini_dset.h
 create mode 100644 drivers/staging/ath6kl/include/common/pkt_log.h
 create mode 100644 drivers/staging/ath6kl/include/common/regDb.h
 create mode 100644 drivers/staging/ath6kl/include/common/regdump.h
 create mode 100644 drivers/staging/ath6kl/include/common/regulatory/reg_dbschema.h
 create mode 100644 drivers/staging/ath6kl/include/common/regulatory/reg_dbvalues.h
 create mode 100644 drivers/staging/ath6kl/include/common/roaming.h
 create mode 100644 drivers/staging/ath6kl/include/common/targaddrs.h
 create mode 100644 drivers/staging/ath6kl/include/common/testcmd.h
 create mode 100644 drivers/staging/ath6kl/include/common/tlpm.h
 create mode 100644 drivers/staging/ath6kl/include/common/wlan_defs.h
 create mode 100644 drivers/staging/ath6kl/include/common/wlan_dset.h
 create mode 100644 drivers/staging/ath6kl/include/common/wmi.h
 create mode 100644 drivers/staging/ath6kl/include/common/wmi_thin.h
 create mode 100644 drivers/staging/ath6kl/include/common/wmix.h
 create mode 100644 drivers/staging/ath6kl/include/common_drv.h
 create mode 100644 drivers/staging/ath6kl/include/dbglog_api.h
 create mode 100644 drivers/staging/ath6kl/include/dl_list.h
 create mode 100644 drivers/staging/ath6kl/include/dset_api.h
 create mode 100644 drivers/staging/ath6kl/include/gpio_api.h
 create mode 100644 drivers/staging/ath6kl/include/hci_transport_api.h
 create mode 100644 drivers/staging/ath6kl/include/hif.h
 create mode 100644 drivers/staging/ath6kl/include/host_version.h
 create mode 100644 drivers/staging/ath6kl/include/htc_api.h
 create mode 100644 drivers/staging/ath6kl/include/htc_packet.h
 create mode 100644 drivers/staging/ath6kl/include/target_reg_table.h
 create mode 100644 drivers/staging/ath6kl/include/wlan_api.h
 create mode 100644 drivers/staging/ath6kl/include/wmi_api.h
 create mode 100644 drivers/staging/ath6kl/miscdrv/ar3kconfig.c
 create mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
 create mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
 create mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
 create mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h
 create mode 100644 drivers/staging/ath6kl/miscdrv/common_drv.c
 create mode 100644 drivers/staging/ath6kl/miscdrv/credit_dist.c
 create mode 100644 drivers/staging/ath6kl/miscdrv/miscdrv.h
 create mode 100644 drivers/staging/ath6kl/os/linux/ar6000_android.c
 create mode 100644 drivers/staging/ath6kl/os/linux/ar6000_drv.c
 create mode 100644 drivers/staging/ath6kl/os/linux/ar6000_pm.c
 create mode 100644 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
 create mode 100644 drivers/staging/ath6kl/os/linux/ar6k_pal.c
 create mode 100644 drivers/staging/ath6kl/os/linux/cfg80211.c
 create mode 100644 drivers/staging/ath6kl/os/linux/eeprom.c
 create mode 100644 drivers/staging/ath6kl/os/linux/export_hci_transport.c
 create mode 100644 drivers/staging/ath6kl/os/linux/hci_bridge.c
 create mode 100644 drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/ar6k_pal.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/athendpack_linux.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/athstartpack_linux.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/athtypes_linux.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/cfg80211.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/config_linux.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/debug_linux.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/export_hci_transport.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/ieee80211_ioctl.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/osapi_linux.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/wlan_config.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/wmi_filter_linux.h
 create mode 100644 drivers/staging/ath6kl/os/linux/ioctl.c
 create mode 100644 drivers/staging/ath6kl/os/linux/netbuf.c
 create mode 100644 drivers/staging/ath6kl/os/linux/wireless_ext.c
 create mode 100644 drivers/staging/ath6kl/reorder/aggr_rx_internal.h
 create mode 100644 drivers/staging/ath6kl/reorder/rcv_aggr.c
 create mode 100644 drivers/staging/ath6kl/wlan/include/ieee80211.h
 create mode 100644 drivers/staging/ath6kl/wlan/include/ieee80211_node.h
 create mode 100644 drivers/staging/ath6kl/wlan/src/wlan_node.c
 create mode 100644 drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c
 create mode 100644 drivers/staging/ath6kl/wlan/src/wlan_utils.c
 create mode 100644 drivers/staging/ath6kl/wmi/wmi.c
 create mode 100644 drivers/staging/ath6kl/wmi/wmi_host.h

