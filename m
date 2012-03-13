Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61898 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab2CMMwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 08:52:13 -0400
Message-ID: <4F5F42F7.2090504@qca.qualcomm.com> (sfid-20120313_135217_273428_0F7A5042)
Date: Tue, 13 Mar 2012 14:52:07 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Pull request: ath6kl 20120313
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's a pull request for latest ath6kl changes. There are quite a few
small fixes and also some fixes for strict checkpatch warnings. If
there's still enough time please consider taking these to 3.4.

Please let me know if there are any problems.

Kalle

The following changes since commit 5d6a1b069b7f72298aff2306a2d02b0188668218:

  mac80211: set basic rates earlier (2012-03-12 14:22:16 -0400)

are available in the git repository at:
  git://github.com/kvalo/ath6kl.git for-linville

Aarthi Thiruvengadam (2):
      ath6kl: Clear the IE in firmware if not set
      ath6kl: Fix merge error in ath6kl_set_ies()

Chilam Ng (2):
      ath6kl: prioritize Tx bundling based on AC priorities
      ath6kl: assign Tx packet drop threshold per endpoint based on AC
priority

Etay Luz (2):
      ath6kl: add padding to firmware log records
      ath6kl: Collect residue firmware logs

Kalle Valo (20):
      ath6kl: store firmware logs in skbuffs
      ath6kl: add blocking debugfs file for retrieving firmware logs
      Merge remote branch 'wireless-next/master' into ath6kl-next
      ath6kl: fix pointer style
      ath6kl: fix checkpatch error with EPSTAT() macro
      ath6kl: alignment should match open parenthesis
      ath6kl: logical continuations should be on the previous line
      ath6kl: remove multiple assignments
      ath6kl: add ath6kl_bmi_write_hi32()
      ath6kl: add ath6kl_bmi_read_hi32()
      ath6kl: fix error handling ath6kl_target_config_wlan_params()
      ath6kl: fix open paranthesis alignment in ath6kl_cfg80211_connect()
      ath6kl: document all spinlocks
      ath6kl: fix too long lines
      ath6kl: make ath6kl_bmi_[read|write]_hi32() endian safe
      ath6kl: fix regression in ath6kl_upload_board_file()
      ath6kl: replace strict_strtoul() with kstrtoul()
      ath6kl: fix open parenthesis alignment in ath6kl_sdio_suspend()
      ath6kl: use max_t() in ath6kl_cfg80211_connect()
      ath6kl: fix debug.c file mode

Naveen Gangadharan (2):
      ath6kl: Fix firmware crash dump
      ath6kl: Add unicast mgmt frame buffering

Prasanna Kumar (1):
      ath6kl: add support for AR6003 2048 byte board file

Raja Mani (7):
      ath6kl: Lower SDIO pad drive strength for hw2.1.1 board
      ath6kl: Fix random system lockup
      ath6kl: Restrict memcpy to bounce buffer only for write request
      ath6kl: Add provision to define suspend policy in disconnected state.
      ath6kl: Check wow state before sending control and data pkt
      ath6kl: Maintain the listen interval per VIF specific
      ath6kl: Set optimal listen intvl,bmiss,scan params while going to
wow suspend

Thomas Pedersen (1):
      ath6kl: implement hidden ssid

Vasanthakumar Thiagarajan (14):
      ath6kl: Update license header
      ath6kl: Fix missing release of semaphore in ath6kl_stop_txrx()
      ath6kl: Remove bogus non-NULL pointer check
      ath6kl: Make sure to allocate rx buffers after the endpoint connection
      ath6kl: Fix memory leak of rx packets in endpoint 0
      ath6kl: Make foreground scan a deterministic one
      ath6kl: Register driver ht capabilities in wiphy
      ath6kl: Group wiphy initialization into ath6kl_cfg80211_init()
      ath6kl: Initialize netdev hw_features for every interface
      ath6kl: Refactor ath6kl_wmi_control_rx()
      ath6kl: Skip vif index validation in ath6kl_rx() for wmi events
      ath6kl: Defer wiphy and netdev registration till the end of
ath6kl_core_init()
      ath6kl: Make sure wiphy is registered before calling regulatory_hint()
      ath6kl: Fix kernel panic while receiving fwlog during boot

 drivers/net/wireless/ath/ath6kl/Makefile   |    3 +-
 drivers/net/wireless/ath/ath6kl/bmi.c      |    7 +-
 drivers/net/wireless/ath/ath6kl/bmi.h      |   24 ++
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  342
+++++++++++++++++++++-------
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    1 +
 drivers/net/wireless/ath/ath6kl/common.h   |    1 +
 drivers/net/wireless/ath/ath6kl/core.c     |  117 ++++------
 drivers/net/wireless/ath/ath6kl/core.h     |   64 +++++-
 drivers/net/wireless/ath/ath6kl/debug.c    |  325
++++++++++++++++-----------
 drivers/net/wireless/ath/ath6kl/debug.h    |   10 +-
 drivers/net/wireless/ath/ath6kl/hif-ops.h  |    1 +
 drivers/net/wireless/ath/ath6kl/hif.c      |   12 +-
 drivers/net/wireless/ath/ath6kl/hif.h      |    4 +
 drivers/net/wireless/ath/ath6kl/htc.c      |  202 ++++++++++++-----
 drivers/net/wireless/ath/ath6kl/htc.h      |   16 ++-
 drivers/net/wireless/ath/ath6kl/init.c     |  210 +++++++-----------
 drivers/net/wireless/ath/ath6kl/main.c     |   72 ++++--
 drivers/net/wireless/ath/ath6kl/sdio.c     |   77 +++++--
 drivers/net/wireless/ath/ath6kl/target.h   |    2 +
 drivers/net/wireless/ath/ath6kl/testmode.c |    1 +
 drivers/net/wireless/ath/ath6kl/testmode.h |    1 +
 drivers/net/wireless/ath/ath6kl/txrx.c     |   72 +++++--
 drivers/net/wireless/ath/ath6kl/usb.c      |    1 +
 drivers/net/wireless/ath/ath6kl/wmi.c      |  307 +++++++++++++++----------
 drivers/net/wireless/ath/ath6kl/wmi.h      |   23 ++-
 25 files changed, 1228 insertions(+), 667 deletions(-)

