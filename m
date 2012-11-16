Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:9926 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2KPJVM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 04:21:12 -0500
Message-ID: <50A60580.80509@qca.qualcomm.com> (sfid-20121116_102116_611834_ECD089F2)
Date: Fri, 16 Nov 2012 11:21:04 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qca.qualcomm.com>
Subject: Pull request: ath6kl 20121116
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's a pull request for ath6kl. Due to various reasons I wasn't able
to send a pull request for 3.6 so this a larger request as it should be,
sorry about that. I also considered splitting the request to two smaller
requests but in the end didn't do that as I didn't see any benefit.

Major changes this time are firmware recover support to gracefully
handle if firmware crashes, support for changing regulatory domain and
support for new ar6004 hardware revision 1.4. Otherwise there are just
smaller fixes or cleanups from different people.

Please let me know if there any problems.

Kalle

The following changes since commit b8d9e572cb8794335fb4ba63ff962acaa3c4473b:

  mwl8k: Set packet timestamp to 0 when life time expiry is not used
(2012-11-14 14:56:12 -0500)

are available in the git repository at:
  git://github.com/kvalo/ath6kl.git for-linville

Aarthi Thiruvengadam (1):
      ath6kl: use custom MAC address for newly created interfaces

Andi Kleen (1):
      ath6kl: fix uninitialized variable in ath6kl_sdio_enable_scatter()

Bala Shanmugam (1):
      ath6kl: Add support for AR6004 hardware version 1.3

Dengke Qiu (1):
      ath6kl: fix link speed when using sgi

Kalle Valo (5):
      ath6kl: move ath6kl_wmi_startscan_cmd()
      ath6kl: refactor wmi scan command
      ath6kl: add support for changing contry code
      ath6kl: fix incorrect use of IEEE80211_NUM_BANDS
      ath6kl: support NL80211_USER_REG_HINT_CELL_BASE events

Marina Makienko (1):
      ath6kl: check usb_register() return value

Mohammed Shafi Shajakhan (7):
      ath6kl: trivial cleanup on interface type selection
      ath6kl: Remove obselete USB device related checks
      ath6kl: Return error case when ath6kl_usb_alloc_pipe_resources fails
      ath6kl: Rename ATH6KL_HW_FLAG_64BIT_RATES
      ath6kl: Fix inactivity timeout for AR6004
      ath6kl: Fix mapping uplink endpoint for AR6004
      ath6kl: Add a hardware flag for SDIO CRC error workaround

Pandiyarajan Pitchaimuthu (5):
      ath6kl: Make use of return value from ath6kl_diag_read()
      ath6kl: Max clients reached notification
      ath6kl: Blocked client notification
      ath6kl: Array index out of bounds check
      ath6kl: Check for valid endpoint ID in ath6kl_tx_complete()

Raja Mani (3):
      ath6kl: Avoid null ptr dereference while printing reg domain pair
      ath6kl: Check for valid rate table index
      ath6kl: Check for valid endpoint ID values in ath6kl_control_tx()

Thomas Pedersen (7):
      ath6kl: support rssi threshold for sched scan
      ath6kl: support TX error rate notification
      ath6kl: configure wow filters per-vif
      ath6kl: restart concurrent vifs on failed connect
      ath6kl: reconfigure RSN capabilities when restarting AP
      ath6kl: rework scheduled scan
      ath6kl: consolidate WoW pattern length

Vasanthakumar Thiagarajan (12):
      ath6kl: Fix potential skb double free in ath6kl_wmi_sync_point()
      ath6kl: Fix potential memory leak in ath6kl_tx_complete()
      ath6kl: Refactor ath6kl_init_hw_start() and ath6kl_init_hw_stop()
      ath6kl: Recover from fw crash
      ath6kl: Add support to detect fw error through heart beat
      ath6kl: Recover from "wmi ctrl ep is full" condition
      ath6kl: Fix bug in scheduling hb_timer
      ath6kl: Remove unnecessary recovery state check in
ath6kl_recovery_hb_timer()
      ath6kl: Add a bit to ath6kl_dev_state for recovery cleanup state
      ath6kl: Make fw error recovery configurable
      ath6kl: Fix reconnection issue after recovery
      ath6kl: Fix random rx data corruption

Wei Yongjun (1):
      ath6kl: use list_move_tail instead of list_del/list_add_tail

 drivers/net/wireless/ath/ath6kl/Kconfig    |    9 +
 drivers/net/wireless/ath/ath6kl/Makefile   |    1 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  370
++++++++++++++++++----------
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    1 -
 drivers/net/wireless/ath/ath6kl/core.c     |   21 ++
 drivers/net/wireless/ath/ath6kl/core.h     |   69 +++++-
 drivers/net/wireless/ath/ath6kl/debug.h    |    1 +
 drivers/net/wireless/ath/ath6kl/hif.c      |    6 +-
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |   13 +-
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |   14 +-
 drivers/net/wireless/ath/ath6kl/init.c     |   92 ++++++-
 drivers/net/wireless/ath/ath6kl/main.c     |   55 ++++-
 drivers/net/wireless/ath/ath6kl/recovery.c |  160 ++++++++++++
 drivers/net/wireless/ath/ath6kl/sdio.c     |   27 +--
 drivers/net/wireless/ath/ath6kl/txrx.c     |   47 +++-
 drivers/net/wireless/ath/ath6kl/usb.c      |   32 ++-
 drivers/net/wireless/ath/ath6kl/wmi.c      |  279 ++++++++++++++++-----
 drivers/net/wireless/ath/ath6kl/wmi.h      |   78 +++++-
 18 files changed, 990 insertions(+), 285 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/recovery.c
