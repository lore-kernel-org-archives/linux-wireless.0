Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29933 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629Ab1CKCzw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:55:52 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:55:30 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 00/20] ath6kl: first series of cleanups
Date: Thu, 10 Mar 2011 18:55:27 -0800
Message-ID: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg, here's the first series of cleanup patches for ath6kl.
I'm sending only 20, have gone tested by Naveen. I threw in
the patch from Javier which you requested to be changed. I
have some more I'll post after these get merged. These all go:

Acked-by: Naveen Singh <naveen.singh@atheros.com>

Javier Martinez Canillas (1):
  staging: ath6kl: Cast variable to size_t to avoid compile warning

Luis R. Rodriguez (19):
  ath6kl: s|A_MEMCPY|memcpy|g
  ath6kl: s|A_MEMCMP|memcmp|g
  ath6kl: remove-typedef: A_UCHAR
  ath6kl: remove-typedef AGGR_INFO
  ath6kl: remove-typedef AR3K_CONFIG_INFO
  ath6kl: remove-typedef AR6000_USER_SETKEYS_INFO
  ath6kl: remove-typedef AR6K_ASYNC_REG_IO_BUFFER
  ath6kl: remove-typedef AR6K_DEVICE
  ath6kl: remove-typedef AR6K_GMBOX_CTRL_REGISTERS
  ath6kl: remove-typedef AR6K_GMBOX_INFO
  ath6kl: remove-typedef AR6K_HCI_BRIDGE_INFO
  ath6kl: remove-typedef AR6K_IRQ_ENABLE_REGISTERS
  ath6kl: remove-typedef AR6K_IRQ_PROC_REGISTERS
  ath6kl: remove-typedef AR_VIRTUAL_INTERFACE_T
  ath6kl: remove-typedef ATHBT_FILTER_INSTANCE
  ath6kl: remove-typedef ATH_DEBUG_MASK_DESCRIPTION
  ath6kl: remove-typedef BUFFER_PROC_LIST
  ath6kl: remove-typedef COMMON_CREDIT_STATE_INFO
  ath6kl: remove-typedef DEV_SCATTER_DMA_VIRTUAL_INFO

 drivers/staging/ath6kl/bmi/include/bmi_internal.h  |    4 +-
 drivers/staging/ath6kl/bmi/src/bmi.c               |  110 +++++++-------
 .../hif/sdio/linux_sdio/include/hif_internal.h     |    2 +-
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |    4 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          |  114 +++++++-------
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |  116 +++++++-------
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c   |   36 ++--
 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c    |   44 +++---
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |   12 +-
 drivers/staging/ath6kl/htc2/htc.c                  |    8 +-
 drivers/staging/ath6kl/htc2/htc_internal.h         |    4 +-
 drivers/staging/ath6kl/htc2/htc_recv.c             |    6 +-
 drivers/staging/ath6kl/htc2/htc_services.c         |    6 +-
 drivers/staging/ath6kl/include/a_debug.h           |   12 +-
 drivers/staging/ath6kl/include/ar3kconfig.h        |    6 +-
 drivers/staging/ath6kl/include/ar6000_diag.h       |    4 +-
 drivers/staging/ath6kl/include/athbtfilter.h       |    4 +-
 drivers/staging/ath6kl/include/bmi.h               |   12 +-
 .../include/common/regulatory/reg_dbschema.h       |    2 +-
 drivers/staging/ath6kl/include/common/testcmd.h    |    2 +-
 drivers/staging/ath6kl/include/common/wmi.h        |    4 +-
 drivers/staging/ath6kl/include/common/wmi_thin.h   |    2 +-
 drivers/staging/ath6kl/include/common_drv.h        |    8 +-
 drivers/staging/ath6kl/include/hif.h               |    2 +-
 drivers/staging/ath6kl/include/wlan_api.h          |    4 +-
 drivers/staging/ath6kl/include/wmi_api.h           |   10 +-
 drivers/staging/ath6kl/miscdrv/ar3kconfig.c        |   22 ++--
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |   54 ++++----
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h   |    8 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   |   36 ++--
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h   |   13 +--
 drivers/staging/ath6kl/miscdrv/common_drv.c        |   38 +++---
 drivers/staging/ath6kl/miscdrv/credit_dist.c       |   18 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |  160 ++++++++++----------
 drivers/staging/ath6kl/os/linux/ar6000_pm.c        |    2 +-
 drivers/staging/ath6kl/os/linux/ar6k_pal.c         |    2 +-
 drivers/staging/ath6kl/os/linux/cfg80211.c         |   44 +++---
 drivers/staging/ath6kl/os/linux/eeprom.c           |    6 +-
 drivers/staging/ath6kl/os/linux/hci_bridge.c       |   98 ++++++------
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |   10 +-
 .../staging/ath6kl/os/linux/include/athdrv_linux.h |    7 +-
 .../ath6kl/os/linux/include/athtypes_linux.h       |    1 -
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |    4 -
 drivers/staging/ath6kl/os/linux/ioctl.c            |   36 ++--
 drivers/staging/ath6kl/os/linux/netbuf.c           |    8 +-
 drivers/staging/ath6kl/os/linux/wireless_ext.c     |   34 ++--
 drivers/staging/ath6kl/reorder/aggr_rx_internal.h  |    4 +-
 drivers/staging/ath6kl/reorder/rcv_aggr.c          |   44 +++---
 drivers/staging/ath6kl/wlan/include/ieee80211.h    |    4 +-
 drivers/staging/ath6kl/wlan/src/wlan_node.c        |   20 ++--
 drivers/staging/ath6kl/wmi/wmi.c                   |  164 ++++++++++----------
 51 files changed, 681 insertions(+), 694 deletions(-)

-- 
1.7.4.15.g7811d

