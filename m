Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:2689 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab0LOIjG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 03:39:06 -0500
Subject: pull request:  staging: ath6kl: linux kernel style cleanups
From: Joe Perches <joe@perches.com>
To: Vipin Mehta <Vipin.Mehta@Atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, devel@driverdev.osuosl.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <35B17FE5076C7040809188FBE7913F98406D8912FE@SC1EXMB-MBCL.global.atheros.com>
References: <AANLkTimfPFeLy5sfDDS5fXiK8X8UT2x8dhzZ+_FEjrTo@mail.gmail.com>
	 <1292363199.26726.34.camel@Joe-Laptop>
	 ,<AANLkTikD440S8AWcOdib7BfTR5a7CaTuYjkysi43oaQZ@mail.gmail.com>
	 <35B17FE5076C7040809188FBE7913F98406D8912FE@SC1EXMB-MBCL.global.atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 00:39:03 -0800
Message-ID: <1292402343.26726.155.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A too-large-to-post (~2MB) changeset to ath6kl, sent separately to Vipin and Luis.

Mostly done mechanically.  Compile tested only.

The following changes since commit e3d7018ee7b5205a80b1011f5a86432de40ce74a:

  Add linux-next specific files for 20101215 (2010-12-15 14:37:00 +1100)

are available in the git repository at:
  git://repo.or.cz/linux-2.6/trivial-mods.git 20101215-ath6kl

Joe Perches (14):
      staging: ath6kl: Convert enum A_STATUS to int
      staging: ath6kl: Remove A_SUCCESS macro
      staging: ath6kl: Remove A_FAILED macro
      staging: ath6kl: Remove A_BOOL and TRUE/FALSE
      staging: ath6kl: Convert A_CHAR to char
      staging: ath6kl: Convert A_UINT8 to u8
      staging: ath6kl: Convert A_UINT16 to u16
      staging: ath6kl: Convert A_UINT32 to u32
      staging: ath6kl: Convert A_UINT64 to u64
      staging: ath6kl: Convert A_INT8 to s8
      staging: ath6kl: Convert A_INT16 to s16
      staging: ath6kl: Convert A_INT32 to s32
      staging: ath6kl: Convert (status != A_OK) to (!status)
      staging: ath6kl: Remove #define A_OK

 drivers/staging/ath6kl/bmi/include/bmi_internal.h  |   12 +-
 drivers/staging/ath6kl/bmi/src/bmi.c               |  352 +++---
 .../staging/ath6kl/hif/common/hif_sdio_common.h    |    4 +-
 .../hif/sdio/linux_sdio/include/hif_internal.h     |   24 +-
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |  174 ++--
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |   36 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          |  294 ++--
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |  204 ++--
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c   |  136 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c    |  140 +-
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |  227 ++--
 drivers/staging/ath6kl/htc2/htc.c                  |   72 +-
 drivers/staging/ath6kl/htc2/htc_internal.h         |   40 +-
 drivers/staging/ath6kl/htc2/htc_recv.c             |  254 ++--
 drivers/staging/ath6kl/htc2/htc_send.c             |   66 +-
 drivers/staging/ath6kl/htc2/htc_services.c         |   48 +-
 drivers/staging/ath6kl/include/a_debug.h           |   20 +-
 drivers/staging/ath6kl/include/a_drv_api.h         |    4 +-
 drivers/staging/ath6kl/include/aggr_recv_api.h     |   10 +-
 drivers/staging/ath6kl/include/ar3kconfig.h        |   20 +-
 drivers/staging/ath6kl/include/ar6000_diag.h       |   26 +-
 drivers/staging/ath6kl/include/ar6kap_common.h     |   10 +-
 drivers/staging/ath6kl/include/athbtfilter.h       |    2 +-
 drivers/staging/ath6kl/include/bmi.h               |   90 +-
 .../ath6kl/include/common/AR6002/AR6002_regdump.h  |   34 +-
 .../staging/ath6kl/include/common/AR6002/addrs.h   |    6 +-
 drivers/staging/ath6kl/include/common/a_hci.h      |  386 +++---
 drivers/staging/ath6kl/include/common/athdefs.h    |   85 +-
 drivers/staging/ath6kl/include/common/bmi_msg.h    |   92 +-
 drivers/staging/ath6kl/include/common/btcoexGpio.h |    4 +-
 drivers/staging/ath6kl/include/common/dbglog.h     |   26 +-
 .../staging/ath6kl/include/common/dset_internal.h  |    6 +-
 drivers/staging/ath6kl/include/common/dsetid.h     |   12 +-
 .../staging/ath6kl/include/common/epping_test.h    |   44 +-
 drivers/staging/ath6kl/include/common/gmboxif.h    |   16 +-
 drivers/staging/ath6kl/include/common/htc.h        |   84 +-
 drivers/staging/ath6kl/include/common/ini_dset.h   |    6 +-
 drivers/staging/ath6kl/include/common/pkt_log.h    |    8 +-
 drivers/staging/ath6kl/include/common/regdump.h    |    8 +-
 .../include/common/regulatory/reg_dbschema.h       |   96 +-
 drivers/staging/ath6kl/include/common/targaddrs.h  |   96 +-
 drivers/staging/ath6kl/include/common/testcmd.h    |   60 +-
 drivers/staging/ath6kl/include/common/wlan_dset.h  |    6 +-
 drivers/staging/ath6kl/include/common/wmi.h        | 1362 +++++++++---------
 drivers/staging/ath6kl/include/common/wmi_thin.h   |  156 +-
 drivers/staging/ath6kl/include/common/wmix.h       |   88 +-
 drivers/staging/ath6kl/include/common_drv.h        |   46 +-
 drivers/staging/ath6kl/include/dset_api.h          |   30 +-
 drivers/staging/ath6kl/include/gpio_api.h          |   22 +-
 drivers/staging/ath6kl/include/hci_transport_api.h |   38 +-
 drivers/staging/ath6kl/include/hif.h               |   82 +-
 drivers/staging/ath6kl/include/htc_api.h           |  108 +-
 drivers/staging/ath6kl/include/htc_packet.h        |   20 +-
 drivers/staging/ath6kl/include/target_reg_table.h  |   84 +-
 drivers/staging/ath6kl/include/wlan_api.h          |   76 +-
 drivers/staging/ath6kl/include/wmi_api.h           |  463 +++---
 drivers/staging/ath6kl/miscdrv/ar3kconfig.c        |  166 ++--
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |  130 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h   |    4 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   |  112 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h   |   25 +-
 drivers/staging/ath6kl/miscdrv/common_drv.c        |  275 ++--
 drivers/staging/ath6kl/miscdrv/credit_dist.c       |    8 +-
 drivers/staging/ath6kl/miscdrv/miscdrv.h           |    2 +-
 drivers/staging/ath6kl/os/linux/ar6000_android.c   |   22 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       | 1008 +++++++-------
 drivers/staging/ath6kl/os/linux/ar6000_pm.c        |  166 ++--
 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c    |   54 +-
 drivers/staging/ath6kl/os/linux/ar6k_pal.c         |   60 +-
 drivers/staging/ath6kl/os/linux/cfg80211.c         |  174 ++--
 drivers/staging/ath6kl/os/linux/eeprom.c           |   62 +-
 .../staging/ath6kl/os/linux/export_hci_transport.c |   42 +-
 drivers/staging/ath6kl/os/linux/hci_bridge.c       |  154 +-
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |  261 ++--
 drivers/staging/ath6kl/os/linux/include/ar6k_pal.h |    4 +-
 .../ath6kl/os/linux/include/ar6xapi_linux.h        |  158 +-
 .../staging/ath6kl/os/linux/include/athdrv_linux.h |  240 ++--
 .../ath6kl/os/linux/include/athtypes_linux.h       |    1 -
 drivers/staging/ath6kl/os/linux/include/cfg80211.h |   20 +-
 .../ath6kl/os/linux/include/export_hci_transport.h |   22 +-
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |   30 +-
 .../ath6kl/os/linux/include/wmi_filter_linux.h     |    6 +-
 drivers/staging/ath6kl/os/linux/ioctl.c            |  818 ++++++------
 drivers/staging/ath6kl/os/linux/netbuf.c           |   60 +-
 drivers/staging/ath6kl/os/linux/wireless_ext.c     |  287 ++--
 drivers/staging/ath6kl/reorder/aggr_rx_internal.h  |   42 +-
 drivers/staging/ath6kl/reorder/rcv_aggr.c          |   94 +-
 drivers/staging/ath6kl/wlan/include/ieee80211.h    |   72 +-
 .../staging/ath6kl/wlan/include/ieee80211_node.h   |   10 +-
 drivers/staging/ath6kl/wlan/src/wlan_node.c        |   48 +-
 drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c |   40 +-
 drivers/staging/ath6kl/wlan/src/wlan_utils.c       |    6 +-
 drivers/staging/ath6kl/wmi/wmi.c                   | 1539 ++++++++++----------
 drivers/staging/ath6kl/wmi/wmi_host.h              |   42 +-
 94 files changed, 6072 insertions(+), 6107 deletions(-)


