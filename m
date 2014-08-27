Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25940 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933467AbaH0NKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 09:10:30 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl@lists.infradead.org>,
	<ath10k@lists.infradead.org>
Subject: Pull request: ath 20140827
Date: Wed, 27 Aug 2014 16:10:24 +0300
Message-ID: <87egw2w01r.fsf@kamboji.qca.qualcomm.com> (sfid-20140827_151036_709607_808D602B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's a new pull request containing latest ath10k and ath6kl patches
accumulated during the merge window, changelog below. Please let me know
if there are any problems.

Please note that commit 7aa7a72a2367 ("ath10k: improve logging to
include dev id") is huge but still a simple patch adding 'ar' variable
to every logging function we have.

Also note that 95752b759e2e ("ath: Move spectral debugfs structs to
shared header") moves code from ath9k to the generic ath.ko module.

----------------------------------------------------------------------
For ath6kl we had two small fixes and a new SDIO device id.

For ath10k the bigger changes are:

 * support for new firmware version 10.2 (Michal)

 * spectral scan support (Simon, Sven & Mathias)

 * export a firmware crash dump file (Ben & me)

 * cleaning up of pci.c (Michal)

 * print pci id in all messages, which causes most of the churn (Michal)

----------------------------------------------------------------------

The following changes since commit 0ccb7a3485e5526dca69f036b0d6c5148c78b3f8:

  ath10k: handle attention flags correctly when using A-MSDU (2014-07-25 11:51:07 +0300)

are available in the git repository at:

  git://github.com/kvalo/ath.git for-linville

for you to fetch changes up to 0fdc14e42b40ecd7115cc670981d39a89eeee6c3:

  ath10k: make target endianess more explicit (2014-08-27 15:03:32 +0300)

----------------------------------------------------------------
Ben Greear (4):
      ath10k: improve 'hard' simulate fw crash
      ath10k: improve vdev map handling
      ath10k: fix typo in error message
      ath10k: provide firmware crash info via debugfs

Hans Wennborg (1):
      ath6kl: fix %d confusingly prefixed with 0x in format strings

Himangi Saraogi (1):
      ath6kl: convert a driver to use module_usb_driver()

Janusz Dziedzic (1):
      ath10k: extend debug code for RX path

Kalle Valo (3):
      ath10k: add ath10k_pci_diag_* helpers
      ath10k: rename ath10k_pci_hif_dump_area() to ath10k_pci_fw_crashed_dump()
      ath10k: print more driver info when firmware crashes

Michal Kazior (28):
      ath10k: add support for 10.2 firmware
      ath10k: fix aggregated 4addr Rx
      ath10k: improve channel switching
      ath10k: fix wmi service bitmap debug
      ath10k: simplify scan debug prints
      ath10k: introduce a stricter scan state machine
      ath10k: embed ar_pci inside ar
      ath10k: remove target soc ps code
      ath10k: remove pci features var
      ath10k: group some pci probing helpers
      ath10k: remove htc->stopped
      ath10k: fix a conflict bug in wmi service bitmap
      ath10k: move fw init print
      ath10k: fix legacy irq workaround
      ath10k: setup irq method in probe
      ath10k: split ce irq/handler setup
      ath10k: make sure to really disable irqs
      ath10k: remove early irq handling
      ath10k: rework posting pci rx buffers
      ath10k: update comment regarding warm reset
      ath10k: ignore ar_pci->started in pipe cleanup
      ath10k: remove ar_pci->started
      ath10k: flush hif buffers before recovery
      ath10k: improve logging to include dev id
      ath10k: fix fw crash dumping
      ath10k: move pci init structures
      ath10k: dont duplicate service-pipe mapping
      ath10k: make target endianess more explicit

Simon Wunderlich (2):
      ath10k: add spectral scan feature
      ath10k: unregister spectral before mac

Srinivas Kandagatla (1):
      ath6kl: Add SDIO device ID for QCA6234X Support

Sven Eckelmann (1):
      ath: Move spectral debugfs structs to shared header

 drivers/net/wireless/ath/ath10k/Kconfig    |    1 +
 drivers/net/wireless/ath/ath10k/Makefile   |    1 +
 drivers/net/wireless/ath/ath10k/bmi.c      |   52 +-
 drivers/net/wireless/ath/ath10k/ce.c       |  185 ++--
 drivers/net/wireless/ath/ath10k/ce.h       |   28 +-
 drivers/net/wireless/ath/ath10k/core.c     |  246 ++---
 drivers/net/wireless/ath/ath10k/core.h     |   66 +-
 drivers/net/wireless/ath/ath10k/debug.c    |  339 +++++-
 drivers/net/wireless/ath/ath10k/debug.h    |   34 +-
 drivers/net/wireless/ath/ath10k/htc.c      |  115 +--
 drivers/net/wireless/ath/ath10k/htc.h      |    7 +-
 drivers/net/wireless/ath/ath10k/htt.c      |    9 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c   |  171 ++--
 drivers/net/wireless/ath/ath10k/htt_tx.c   |   46 +-
 drivers/net/wireless/ath/ath10k/hw.h       |    5 +-
 drivers/net/wireless/ath/ath10k/mac.c      |  717 +++++++------
 drivers/net/wireless/ath/ath10k/mac.h      |    6 +-
 drivers/net/wireless/ath/ath10k/pci.c      | 1537 ++++++++++++----------------
 drivers/net/wireless/ath/ath10k/pci.h      |  104 +-
 drivers/net/wireless/ath/ath10k/spectral.c |  561 ++++++++++
 drivers/net/wireless/ath/ath10k/spectral.h |   90 ++
 drivers/net/wireless/ath/ath10k/txrx.c     |   17 +-
 drivers/net/wireless/ath/ath10k/wmi.c      | 1089 +++++++++++++++-----
 drivers/net/wireless/ath/ath10k/wmi.h      |  699 +++++++++++--
 drivers/net/wireless/ath/ath6kl/init.c     |    2 +-
 drivers/net/wireless/ath/ath6kl/main.c     |    2 +-
 drivers/net/wireless/ath/ath6kl/sdio.c     |    1 +
 drivers/net/wireless/ath/ath6kl/usb.c      |   21 +-
 drivers/net/wireless/ath/ath9k/spectral.h  |   71 +-
 drivers/net/wireless/ath/spectral_common.h |  113 ++
 30 files changed, 4132 insertions(+), 2203 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/spectral.c
 create mode 100644 drivers/net/wireless/ath/ath10k/spectral.h
 create mode 100644 drivers/net/wireless/ath/spectral_common.h

-- 
Kalle Valo
