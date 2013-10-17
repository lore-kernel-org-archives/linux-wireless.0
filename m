Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31289 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab3JQJGj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 05:06:39 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
	<ath6kl-devel@qca.qualcomm.com>
Subject: Pull request: ath 20131017
Date: Thu, 17 Oct 2013 12:06:33 +0300
Message-ID: <87mwm82rmu.fsf@kamboji.qca.qualcomm.com> (sfid-20131017_110649_870257_755C45FE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's a pull request for ath6kl and ath10k. Notable changes:

Bartosz added support to ath10k for our 10.x AP firmware branch, which
gives us AP specific features and fixes. We still support the main
firmware branch as well just like before, ath10k detects runtime what
firmware is used. Unfortunately the firmware interface in 10.x branch is
somewhat different so there was quite a lot of changes in ath10k for
this.

Michal and Sujith did some performance improvements in ath10k. Vladimir
fixed a compiler warning and Fengguang removed an extra semicolon.

Please let me know if there are any problems.

Kalle

The following changes since commit 6e712d427cb0542afdd5220edb6e4f4f8a5b952d:

  ath10k: replenish HTT RX buffers in a tasklet (2013-09-26 17:22:54 +0300)

are available in the git repository at:

  git://github.com/kvalo/ath.git for-linville

for you to fetch changes up to 56b84287d14aa74823a9c290d0c5839d38365110:

  ath10k: add might_sleep() to ath10k_wmi_cmd_send() (2013-10-16 15:44:47 +0300)

----------------------------------------------------------------
Bartosz Markowski (18):
      ath10k: introduce dynamic WMI structures
      ath10k: add wmi_10x_<cmd/event> definitions
      ath10k: warn if give WMI command is not supported
      ath10k: implement WMI events handling frame for both firmwares
      ath10k: split ath10k_wmi_service_ready_event_rx
      ath10k: drop the fw versioning sanity check
      ath10k: implement host memory chunks
      ath10k: bring back the WMI path for mgmt frames
      ath10k: split wmi_cmd_init path
      ath10k: add TARGET values for 10.x firmware
      ath10k: introduce dynamic vdev parameters
      ath10k: introduce dynamic pdev parameters
      ath10k: handle FW API differences for scan structures
      ath10k: enable 10.x firmware branch support
      ath10k: extend the max_scan time
      ath10k: do not warn about unsupported vdev param
      ath10k: rename WMI_CMD_UNDEFINED
      ath10k: return better errno for unsupported pdev params

Fengguang Wu (1):
      ath10k: remove unneded semicolon from ath10k_core_fetch_firmware_api_n()

Kalle Valo (6):
      ath10k: rename board_data in struct ath10k
      ath10k: store separate pointers for firmware data
      ath10k: implement firmware IE container support
      ath10k: fix ath10k_debug_start() locking
      ath10k: fix ath10k_bss_assoc() to not sleep in atomic context
      ath10k: add might_sleep() to ath10k_wmi_cmd_send()

Marek Puzyniak (1):
      ath10k: make monitor vdev down before stoping it

Michal Kazior (12):
      ath10k: split tid calculation from tx function
      ath10k: split vdev_id calculation from tx function
      ath10k: remove ce_sendlist_send
      ath10k: remove num_sends_allowed
      ath10k: fix printf format string
      ath10k: fix possible memory leak in new FW loading
      ath10k: fix RX performance when using AP 10.X FW
      ath10k: use workqueue to set WEP TX key
      ath10k: fix add_interface failure handling
      ath10k: track vif list internally
      ath10k: fix scheduling while atomic config bug
      ath10k: remove unnecessary checks

Sujith Manoharan (1):
      ath10k: Fix bug in max. VHT A-MPDU size

Vladimir Murzin (1):
      ath6kl: fix compilation warning in ath6kl_htc_pipe_conn_service

 drivers/net/wireless/ath/ath10k/ce.c     |   35 +-
 drivers/net/wireless/ath/ath10k/ce.h     |   16 +-
 drivers/net/wireless/ath/ath10k/core.c   |  285 ++++++--
 drivers/net/wireless/ath/ath10k/core.h   |   47 +-
 drivers/net/wireless/ath/ath10k/debug.c  |   15 +-
 drivers/net/wireless/ath/ath10k/debug.h  |    5 +
 drivers/net/wireless/ath/ath10k/htt_tx.c |    4 +-
 drivers/net/wireless/ath/ath10k/hw.h     |   56 +-
 drivers/net/wireless/ath/ath10k/mac.c    |  512 ++++++++------
 drivers/net/wireless/ath/ath10k/mac.h    |    2 +
 drivers/net/wireless/ath/ath10k/pci.c    |   25 +-
 drivers/net/wireless/ath/ath10k/pci.h    |    3 -
 drivers/net/wireless/ath/ath10k/wmi.c    | 1087 ++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h    |  968 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/htc.h    |    2 +-
 15 files changed, 2674 insertions(+), 388 deletions(-)
