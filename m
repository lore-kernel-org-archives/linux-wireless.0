Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55070 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab2DJHzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 03:55:50 -0400
Message-ID: <4F83E781.7000003@qca.qualcomm.com> (sfid-20120410_095554_616609_55390F19)
Date: Tue, 10 Apr 2012 10:55:45 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Pull request: ath6kl 20120410
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's the first ath6kl pull request for 3.5. The biggest change is the
completion of USB support, now ath6kl properly supports AR6004 USB
devices. I have been careful so that there would not be any build issues
with the new USB code, but if you find something please let me know.

There are also small fixes to various issues we have found but they
should be relatively safe.

Kalle

The following changes since commit 47107e84446f4724d25c724493679cc50eeef53c:

  iwlwifi: split POWER_PMI status bit (2012-04-09 16:37:49 -0400)

are available in the git repository at:
  git://github.com/kvalo/ath6kl.git for-linville

Aarthi Thiruvengadam (2):
      ath6kl: handle probe response from P2P device in P2P GO mode
      ath6kl: add debug log for AP MLME operations

Bala Shanmugam (1):
      ath6kl: Set background scan period.

Joe Perches (1):
      ath6kl: Add __printf verification to ath6kl_printk

Kalle Valo (11):
      ath6kl: abort normal scan when scheduled scan is started
      Merge remote branch 'wireless-next/master' into ath6kl-next
      ath6kl: set ram reserved size only for ar6003
      ath6kl: Add tx_complete() to struct htc_ep_callbacks
      ath6kl: add tx_comp_multi() to struct htc_ep_callbacks
      ath6kl: add pointer to the skb in htc_packet
      ath6kl: add rx data padding support
      ath6kl: remove void pointer from ath6kl_credit_setup()
      ath6kl: add htc ops
      ath6kl: Add HTC pipe implementation
      ath6kl: add full USB support

Raja Mani (4):
      ath6kl: Add ARP offload related statistic info in tgt_stats
      ath6kl: Isolate host sleep mode config part from ath6kl_wow_suspend
      ath6kl: Optimize target power in deep sleep suspend
      ath6kl: Store scan request info in-advance before sending SCAN request

Vasanthakumar Thiagarajan (7):
      ath6kl: Dump htc header when invalid Rx frame length is detected
      ath6kl: Configure inactivity timeout in fw
      ath6kl: Support net_stats.multicast
      ath6kl: Fix target assert in p2p bringup with multi vif
      ath6kl: Don't advertise HT40 support in 2.4 Ghz
      ath6kl: Configure htcap in fw based on the channel type in AP mode
      ath6kl: Fix 4-way handshake failure in AP and P2P GO mode

Vivek Natarajan (2):
      ath6kl: Use vmalloc instead of kmalloc for fw
      ath6kl: Fix scan related issue on suspend-resume

 drivers/net/wireless/ath/ath6kl/Makefile           |    3 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  417 ++++-
 drivers/net/wireless/ath/ath6kl/common.h           |    4 +-
 drivers/net/wireless/ath/ath6kl/core.c             |   30 +-
 drivers/net/wireless/ath/ath6kl/core.h             |   34 +-
 drivers/net/wireless/ath/ath6kl/debug.c            |    6 +
 drivers/net/wireless/ath/ath6kl/debug.h            |    1 +
 drivers/net/wireless/ath/ath6kl/hif-ops.h          |   34 +
 drivers/net/wireless/ath/ath6kl/hif.h              |    6 +
 drivers/net/wireless/ath/ath6kl/htc-ops.h          |  113 ++
 drivers/net/wireless/ath/ath6kl/htc.h              |   98 +-
 .../net/wireless/ath/ath6kl/{htc.c => htc_mbox.c}  |   85 +-
 drivers/net/wireless/ath/ath6kl/htc_pipe.c         | 1713
++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/init.c             |   57 +-
 drivers/net/wireless/ath/ath6kl/main.c             |    4 +
 drivers/net/wireless/ath/ath6kl/sdio.c             |    2 +-
 drivers/net/wireless/ath/ath6kl/txrx.c             |   23 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |  785 +++++++++-
 drivers/net/wireless/ath/ath6kl/wmi.c              |   80 +
 drivers/net/wireless/ath/ath6kl/wmi.h              |   40 +
 20 files changed, 3370 insertions(+), 165 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc-ops.h
 rename drivers/net/wireless/ath/ath6kl/{htc.c => htc_mbox.c} (96%)
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc_pipe.c
