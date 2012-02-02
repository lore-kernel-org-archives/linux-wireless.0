Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60958 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab2BBKqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 05:46:18 -0500
Message-ID: <4F2A6972.30702@qca.qualcomm.com> (sfid-20120202_114622_426886_F0589F7A)
Date: Thu, 2 Feb 2012 12:46:10 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: ath6kl-devel <ath6kl-devel@qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Pull request: ath6kl 20120202
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's a request to pull latest ath6kl changes. The biggest changes this
time is adding ath6kl_core.ko module to make it possible to support for
SDIO and USB at the same and adding back the USB code which was reverted
during the last merge window. Also adding support for new firmware
version, UAPSD support for AP mode and lots of small fixes everywhere.

I have no build tested with various configurations, including
allyesconfig. Hopefully there are no build issues this time.

Please let me know if there are any problems.

Kalle

The following changes since commit b0302aba812bcc39291cdab9ad7e37008f352a91:

  rtlwifi: Convert to asynchronous firmware load (2012-01-30 15:48:50 -0500)

are available in the git repository at:
  git://github.com/kvalo/ath6kl.git for-linville

Alex Yang (1):
      ath6kl: add testmode 2 for 6003 ART

Chilam Ng (1):
      ath6kl: initialize the 'nominal_phy' field in the
'wmi_create_pstream_cmd' struct for create_qos command

Jouni Malinen (3):
      ath6kl: Fix connect command to clear previously used IEs
      ath6kl: Add del_station cfg80211_ops
      ath6kl: Advertise TX/RX support for frames in AP mode

Kalle Valo (16):
      ath6kl: handle firmware names more dynamically
      ath6kl: add support for FW API 3
      Merge remote branch 'wireless-next/master' into ath6kl-next
      ath6kl: use netdev_features_t
      ath6kl: remove -D__CHECK_ENDIAN__ from Makefile
      ath6kl: fix uninitialized warning in ath6kl_process_uapsdq()
      ath6kl: rename vif init and cleanup functions
      ath6kl: unify cfg80211 init/cleanup functions
      ath6kl: add ATH6KL_CONF_UART_DEBUG
      ath6kl: create core.c
      ath6kl: get rid of AR_DBG_LVL_CHECK()
      ath6kl: convert ath6kl_dbg() and ath6kl_dbg_dump() into functions
      ath6kl: create ath6kl_core.ko
      ath6kl: add back beginnings of USB support
      ath6kl: fix testmode when fw-2.bin or fw-3.bin is used
      ath6kl: fix compiler warning in ath6kl_init_hw_params()

Masanari Iida (1):
      ath6kl: Fix typo in cfg80211.c

Raja Mani (7):
      ath6kl: Avoid taking struct as argument in ath6kl_wmi_set_ip_cmd
      ath6kl: Send own IP addr to the firmware during WOW suspend
      ath6kl: Remove useless initialization in ath6kl_read_fwlogs()
      ath6kl: Re-architect suspend mode handling in ath6kl_sdio_suspend
      ath6kl: Configure WOW patterns while going to wow_suspend
      ath6kl: Wait for host sleep mode cmd processed event during WOW
suspend
      ath6kl: Return a proper error code when not in connected state

Rishi Panjwani (1):
      ath6kl: Support for TCP checksum offload to firmware

Santosh Sajjan (1):
      ath6kl: Workaround to support Deep Sleep with MSM.

Stephen Hemminger (1):
      ath6kl: make net_device_ops const

Sujith Manoharan (5):
      ath6kl: Fix panic when setting a channel
      ath6kl: Fix SDIO error path
      ath6kl: Remove redundant pointer check
      ath6kl: Initialize a variable properly
      ath6kl: Fix listen interval handling

Thirumalai Pachamuthu (1):
      ath6kl: Add support for uAPSD

Thomas Pedersen (1):
      ath6kl: send TCMD response through testmode events

Vasanthakumar Thiagarajan (16):
      ath6kl: Use cfg80211_roamed_bss() to report roaming event
      ath6kl: Remove few unnecessary spin_locks around set_bit()
      ath6kl: Add a module parameter to enable uart debug
      ath6kl: Add a function in wmi to send WMI_MCAST_FILTER_CMDID
      ath6kl: Add a function in wmi.c to add/delete a multicast filter
      ath6kl: Implement ndo_set_rx_mode()
      ath6kl: Remove deadcode in main.c
      ath6kl: Change ielen in ath6kl_add_new_sta() from u8 to size_t
      ath6kl: Use a mutex_lock to avoid race in diabling and handling irq
      ath6kl: Make sure to delete rx aggregation timer in aggr_reset_state()
      ath6kl: Fix memory leak when unloading ath6kl_sdio
      ath6kl: Define a structure for connection specific aggregation
information
      ath6kl: Pass vif instead of ar to ath6kl_add_new_sta()
      ath6kl: Fix bug in using tid given by addba/delba req events
      ath6kl: Fix bug in maintaining aggregation state in AP mode
      ath6kl: Fix kernel panic during rx aggregation

Vivek Natarajan (1):
      ath6kl: Remove redundant key_index check.

 drivers/net/wireless/ath/ath6kl/Kconfig    |   25 +-
 drivers/net/wireless/ath/ath6kl/Makefile   |   30 +-
 drivers/net/wireless/ath/ath6kl/bmi.c      |   10 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  606
++++++++++++++++++----------
 drivers/net/wireless/ath/ath6kl/cfg80211.h |   12 +-
 drivers/net/wireless/ath/ath6kl/common.h   |    3 -
 drivers/net/wireless/ath/ath6kl/core.c     |  316 +++++++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |  107 ++++--
 drivers/net/wireless/ath/ath6kl/debug.c    |  114 ++++--
 drivers/net/wireless/ath/ath6kl/debug.h    |   28 +-
 drivers/net/wireless/ath/ath6kl/hif.c      |   15 +-
 drivers/net/wireless/ath/ath6kl/htc.c      |   11 +-
 drivers/net/wireless/ath/ath6kl/init.c     |  472 ++++++++++------------
 drivers/net/wireless/ath/ath6kl/main.c     |  182 ++++++++-
 drivers/net/wireless/ath/ath6kl/sdio.c     |  140 ++++---
 drivers/net/wireless/ath/ath6kl/testmode.c |  102 +----
 drivers/net/wireless/ath/ath6kl/testmode.h |    6 +-
 drivers/net/wireless/ath/ath6kl/txrx.c     |  534 ++++++++++++++++++-------
 drivers/net/wireless/ath/ath6kl/usb.c      |  431 ++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.c      |  148 ++++++-
 drivers/net/wireless/ath/ath6kl/wmi.h      |   67 +++-
 21 files changed, 2437 insertions(+), 922 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/core.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/usb.c

