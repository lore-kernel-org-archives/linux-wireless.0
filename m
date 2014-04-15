Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:37226 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaDOGeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2014 02:34:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl@lists.infradead.org>,
	<ath10k@lists.infradead.org>
Subject: Pull request: ath 20140415
Date: Tue, 15 Apr 2014 09:34:31 +0300
Message-ID: <87mwfndrt4.fsf@kamboji.qca.qualcomm.com> (sfid-20140415_083441_877831_517932B2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's a pull request for ath6kl and ath10k with changes accumulated
just before and during the merge window. Please let me know if there any
problems.

Here's the list of changes:

----------------------------------------------------------------------

For ath6kl Kalle fixed a bunch of checkpatch warnings.

In ath10k we had more changes, major ones being:

* fix memory allocation failures after a firmware crash (Michal)

* some rework of DFS configuration to enable it correctly in all cases
  (Michal)

* add a new firmware crash option to make it possible to crash 10.1
  firmware for testing purposes (Marek P)

* fix RTS/CTS protection in certain cases (Marek K)

* fix wrong RSSI and rate reporting in some cases (Janusz)

* fix firmware stats reporting (Chun, Ben & Bartosz)

----------------------------------------------------------------------

The following changes since commit 70dd77b4c50da518b57b8b9b125a8c9aabe9bc1a:

  ath10k: do not overwrite max_antenna_gain (2014-03-07 10:14:10 +0200)

are available in the git repository at:

  git://github.com/kvalo/ath.git for-linville

for you to fetch changes up to 4bfee8e8c13fc9477eb9420efd5a5d12e32ac614:

  ath10k: improve htc tx credit debugging prints (2014-04-11 08:35:56 +0300)

----------------------------------------------------------------
Bartosz Markowski (1):
      ath10k: update wal_dbg_tx_stats structure with missing parameter.

Ben Greear (4):
      ath10k: better firmware loading error messages
      ath10k: add otp and firmware boot error messages
      ath10k: fix getting stats from firmware
      ath10k: add the Rx rate in FW stats

Chun-Yeow Yeoh (3):
      ath10k: allow the supported rate change by reassociate peer
      ath10k: fix the peer mac address in getting stats
      ath10k: add extra pdev stats on 10.1 firmware

Janusz Dziedzic (12):
      ath10k: add ath10k_htt_rx_amsdu_allowed function
      ath10k: Fill per-ppdu info in rx_info only once
      ath10k: move rx related functions to htt_rx.c
      ath10k: rename process_rx_rates to ath10k_htt_rx_h_rates
      ath10k: introduce ieee80211_rx_status to htt_rx_info
      ath10k: setup rx channel per ppdu
      ath10k: kill not needed fields from htt_rx_info
      ath10k: return error when ath10k_htt_rx_amsdu_pop() fail
      ath10k: improve way we play with attention flags
      ath10k: finally kill htt_rx_info
      ath10k: introduce rx_status htt template
      ath10k: fix rssi and rate reporting

Kalle Valo (18):
      ath6kl: fix struct hif_scatter_req list handling
      ath6kl: fix blank lines before and after braces
      ath6kl: use braces on both arms of if statement
      ath6kl: remove spaces before semicolon
      ath6kl: remove unnecessary line continuations
      ath6kl: update Kconfig descriptions
      ath10k: separate result parameter in ath10k_bmi_execute()
      ath10k: check otp.bin result
      ath10k: unify warning messages in mac.c
      ath10k: cleanup ath10k_pci_wait_for_target_init()
      ath10k: add module parameter to disable cold reset
      ath10k: fix name of target_ps module parameter
      ath10k: advertise only firmware API 2 files
      ath10k: delete ar_pci->fw_indicator_address
      ath10k: improve pci debug messages
      ath10k: add module parameter values to the pci info print
      ath10k: print chip id during boot
      ath10k: cleanup debug messages in ath10k_wmi_event_host_swba()

Marek Kwaczynski (1):
      ath10k: add recalc RTS/CTS protection method

Marek Puzyniak (2):
      ath10k: add soft/hard firmware crash option to simulate_fw_crash
      ath10k: update regulatory domain settings for 10.x firmware

Michal Kazior (7):
      ath10k: convert pci_alloc_consistent() to dma_alloc_coherent()
      ath10k: split ce initialization and allocation
      ath10k: deinit copy engine before resetting
      ath10k: refactor monitor code
      ath10k: reorder functions
      ath10k: refactor radar detection code
      ath10k: improve htc tx credit debugging prints

 drivers/net/wireless/ath/ath10k/bmi.c      |   13 +-
 drivers/net/wireless/ath/ath10k/bmi.h      |    2 +-
 drivers/net/wireless/ath/ath10k/ce.c       |  356 +++++++------
 drivers/net/wireless/ath/ath10k/ce.h       |   15 +-
 drivers/net/wireless/ath/ath10k/core.c     |   85 ++--
 drivers/net/wireless/ath/ath10k/core.h     |   18 +-
 drivers/net/wireless/ath/ath10k/debug.c    |  109 +++-
 drivers/net/wireless/ath/ath10k/htc.c      |   12 +-
 drivers/net/wireless/ath/ath10k/htt.h      |   21 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c   |  513 ++++++++++++-------
 drivers/net/wireless/ath/ath10k/hw.h       |    1 +
 drivers/net/wireless/ath/ath10k/mac.c      |  763 +++++++++++++++-------------
 drivers/net/wireless/ath/ath10k/pci.c      |  219 +++++---
 drivers/net/wireless/ath/ath10k/pci.h      |    3 -
 drivers/net/wireless/ath/ath10k/txrx.c     |  183 -------
 drivers/net/wireless/ath/ath10k/txrx.h     |    1 -
 drivers/net/wireless/ath/ath10k/wmi.c      |   62 ++-
 drivers/net/wireless/ath/ath10k/wmi.h      |   98 +++-
 drivers/net/wireless/ath/ath6kl/Kconfig    |   30 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    9 +-
 drivers/net/wireless/ath/ath6kl/core.c     |    6 +-
 drivers/net/wireless/ath/ath6kl/debug.c    |    4 -
 drivers/net/wireless/ath/ath6kl/debug.h    |    2 +-
 drivers/net/wireless/ath/ath6kl/hif.c      |    3 -
 drivers/net/wireless/ath/ath6kl/hif.h      |    4 +-
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |   23 +-
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |   10 +-
 drivers/net/wireless/ath/ath6kl/init.c     |    1 -
 drivers/net/wireless/ath/ath6kl/main.c     |   10 +-
 drivers/net/wireless/ath/ath6kl/sdio.c     |   17 +-
 drivers/net/wireless/ath/ath6kl/target.h   |    2 +-
 drivers/net/wireless/ath/ath6kl/txrx.c     |   31 +-
 drivers/net/wireless/ath/ath6kl/usb.c      |    2 -
 drivers/net/wireless/ath/ath6kl/wmi.c      |   19 +-
 drivers/net/wireless/ath/ath6kl/wmi.h      |    1 -
 35 files changed, 1499 insertions(+), 1149 deletions(-)

-- 
Kalle Valo
