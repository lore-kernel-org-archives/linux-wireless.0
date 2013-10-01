Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:46550 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3JARsm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 13:48:42 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>,
	<ath10k@lists.infradead.org>
Subject: Pull request: ath 20131001
Date: Tue, 1 Oct 2013 20:48:36 +0300
Message-ID: <87wqlw6fwr.fsf@kamboji.qca.qualcomm.com> (sfid-20131001_194846_044791_7C0442D5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's a bigger pull request including patches applied during the merge
window. Major changes are:

* throughput improvements including aligning the RX frames correctly and
  optimising HTT layer (Michal)

* remove qca98xx hw1.0 support (Bartosz)

* add support for firmware version 999.999.0.636 (Michal)

* firmware htt statistics support (Kalle)

* fix WEP in AP and IBSS mode (Marek)

* fix a mutex unlock balance in debugfs file (Shafi)

And of course there's a lot of smaller fixes and cleanup.

To avoid the pull request getting too big, I didn't include the latest
patches from ath.git. I'm planning to send them once you have pulled
this one. Please let me know if there are any problems.

Kalle


The following changes since commit 9d0e2f0772d394060bf3b17cd1f3a35574365103:

  ath6kl: Fix invalid pointer access on fuzz testing with AP mode (2013-08-07 10:58:59 +0300)

are available in the git repository at:

  git://github.com/kvalo/ath.git tags/for-linville-20131001

for you to fetch changes up to 6e712d427cb0542afdd5220edb6e4f4f8a5b952d:

  ath10k: replenish HTT RX buffers in a tasklet (2013-09-26 17:22:54 +0300)

----------------------------------------------------------------
Bartosz Markowski (5):
      ath10k: Remove qca98xx hw1.0 support
      ath10k: update supported FW build version
      ath10k: set the UART baud rate to 19200
      ath10k: remove obsolete INIT STATUS definitions
      ath10k: define ath10k_debug_start/_stop as static inline

Dave Jones (1):
      ath10k: add missing braces to ath10k_pci_tx_pipe_cleanup

Janusz Dziedzic (2):
      ath10k: setup peer UAPSD flag correctly
      ath10k: check allocation errors in CE

Jingoo Han (1):
      wireless: ath10k: remove unnecessary pci_set_drvdata()

Kalle Valo (22):
      ath10k: remove un ar_pci->cacheline_sz field
      ath10k: pci: make host_ce_config_wlan[] more readable
      ath10k: make target_ce_config_wlan more readable
      ath10k: remove void pointer from struct ath10k_pci_compl
      ath10k: convert ath10k_pci_reg_read/write32() to take struct ath10k
      ath10k: clean up ath10k_ce_completed_send_next_nolock()
      ath10k: convert ath10k_pci_wake() to return
      ath10k: simplify ath10k_ce_init() wake up handling
      ath10k: check chip id from the soc register during probe
      ath10k: add chip_id file to debugfs
      ath10k: add trace event ath10k_htt_stats
      ath10k: implement ath10k_debug_start/stop()
      ath10k: add htt_stats_enable debugfs file
      ath10k: add BMI log level
      ath10k: rename ATH10K_DBG_CORE to BOOT
      ath10k: cleanup debug messages in core.c
      ath10k: add boot debug messages to pci.c and ce.c
      ath10k: add boot debug messages to htc.c
      ath10k: add boot messages to htt.c
      ath10k: clean mac.c debug messages
      ath10k: print phymode as a string
      ath10k: delete struct ce_sendlist

Marek Puzyniak (1):
      ath10k: fix WEP in AP and IBSS mode

Michal Kazior (36):
      ath10k: clean up monitor start code
      ath10k: use sizeof(*var) in kmalloc
      ath10k: clean up PCI completion states
      ath10k: print errcode when CE ring setup fails
      ath10k: fix HTT service setup
      ath10k: implement 802.3 SNAP rx decap type A-MSDU handling
      ath10k: plug possible memory leak in WMI
      ath10k: add support for firmware newer than 636
      ath10k: add support for HTT 3.0
      ath10k: use inline ce_state structure
      ath10k: remove ce_op_state
      ath10k: remove unused ce_attr parameters
      ath10k: rename hif_ce_pipe_info to ath10k_pci_pipe
      ath10k: rename ce_state to ath10k_ce_pipe
      ath10k: rename ce_ring_state to ath10k_ce_ring
      ath10k: prevent CE from looping indefinitely
      ath10k: simplify HTC credits calculation
      ath10k: add HTC TX credits replenishing notification
      ath10k: make WMI commands block by design
      ath10k: simplify HTC command submitting
      ath10k: improve beacon submission latency
      ath10k: remove wmi pending count limit
      ath10k: remove wmi event worker thread
      ath10k: fix tracing build for ath10k_wmi_cmd
      ath10k: fix num_sends_allowed replenishing
      ath10k: use num_pending_tx instead of msdu id bitmap
      ath10k: avoid needless memset on TX path
      ath10k: decouple HTT TX completions
      ath10k: cleanup HTT TX functions
      ath10k: use msdu headroom to store txfrag
      ath10k: report A-MSDU subframes individually
      ath10k: document decap modes
      ath10k: cleanup RX decap handling
      ath10k: fix Native Wifi decap mode RX
      ath10k: align RX frames properly
      ath10k: replenish HTT RX buffers in a tasklet

Mohammed Shafi Shajakhan (1):
      ath10k: Fix mutex unlock balance

Sujith Manoharan (1):
      ath10k: Calculate correct peer PHY mode for VHT

 drivers/net/wireless/ath/ath10k/bmi.c     |   42 ++-
 drivers/net/wireless/ath/ath10k/ce.c      |  382 +++++++++++-------------
 drivers/net/wireless/ath/ath10k/ce.h      |  120 ++------
 drivers/net/wireless/ath/ath10k/core.c    |   70 +++--
 drivers/net/wireless/ath/ath10k/core.h    |   35 ++-
 drivers/net/wireless/ath/ath10k/debug.c   |  144 +++++++++-
 drivers/net/wireless/ath/ath10k/debug.h   |   14 +-
 drivers/net/wireless/ath/ath10k/htc.c     |  241 ++++------------
 drivers/net/wireless/ath/ath10k/htc.h     |    5 +-
 drivers/net/wireless/ath/ath10k/htt.c     |   19 +-
 drivers/net/wireless/ath/ath10k/htt.h     |   13 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c  |  314 +++++++++++---------
 drivers/net/wireless/ath/ath10k/htt_tx.c  |  285 +++++++++---------
 drivers/net/wireless/ath/ath10k/hw.h      |   25 +-
 drivers/net/wireless/ath/ath10k/mac.c     |  244 ++++++++--------
 drivers/net/wireless/ath/ath10k/pci.c     |  446 +++++++++++++++++------------
 drivers/net/wireless/ath/ath10k/pci.h     |   73 ++---
 drivers/net/wireless/ath/ath10k/rx_desc.h |   24 +-
 drivers/net/wireless/ath/ath10k/trace.h   |   32 ++-
 drivers/net/wireless/ath/ath10k/txrx.c    |   67 ++---
 drivers/net/wireless/ath/ath10k/txrx.h    |    5 +-
 drivers/net/wireless/ath/ath10k/wmi.c     |  232 +++++++--------
 drivers/net/wireless/ath/ath10k/wmi.h     |   71 ++++-
 23 files changed, 1534 insertions(+), 1369 deletions(-)

-- 
Kalle Valo
