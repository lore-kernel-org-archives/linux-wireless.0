Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:24655 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbaJXLov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 07:44:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
	<ath6kl@lists.infradead.org>
Subject: Pull request: ath 20141024
Date: Fri, 24 Oct 2014 14:44:32 +0300
Message-ID: <87bnp1ofof.fsf@kamboji.qca.qualcomm.com> (sfid-20141024_134455_546443_FF1C4A7D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here are the latest ath10k patches plus a small logging change to ath6kl
and wil6210. Unfortunately this time there's a small conflict in
drivers/net/wireless/ath/wil6210/wil6210.h but luckily it's easy to fix.
Here's an example how I propose to resolve it:

----------------------------------------------------------------------
#define wil_to_ndev(i) (wil_to_wdev(i)->netdev)
#define ndev_to_wil(n) (wdev_to_wil(n->ieee80211_ptr))
#define wil_to_pcie_dev(i) (&i->pdev->dev)

__printf(2, 3)
void wil_dbg_trace(struct wil6210_priv *wil, const char *fmt, ...);
__printf(2, 3)
void wil_err(struct wil6210_priv *wil, const char *fmt, ...);
__printf(2, 3)
void wil_info(struct wil6210_priv *wil, const char *fmt, ...);
#define wil_dbg(wil, fmt, arg...) do { \
	netdev_dbg(wil_to_ndev(wil), fmt, ##arg); \
	wil_dbg_trace(wil, fmt, ##arg); \
} while (0)

#define wil_dbg_irq(wil, fmt, arg...) wil_dbg(wil, "DBG[ IRQ]" fmt, ##arg)
#define wil_dbg_txrx(wil, fmt, arg...) wil_dbg(wil, "DBG[TXRX]" fmt, ##arg)
----------------------------------------------------------------------

I think a lesson learned here is that I should not apply patches which
touch wil6210 and instead ask the submitter to split the patch. Sorry
for this.

Here's a changelog for the pull request:

----------------------------------------------------------------------
Major changes are:

o ethtool support (Ben)

o print dev string prefix with debug hex buffers dump (Michal)

o debugfs file to read calibration data from the firmware verification
  purposes (me)

o fix fw_stats debugfs file, now results are more reliable (Michal)

o firmware crash counters via debugfs (Ben&me)

o various tracing points to debug firmware (Rajkumar)

o make it possible to provide firmware calibration data via a file (me)

And we have quite a lot of smaller fixes and clean up.
----------------------------------------------------------------------

Please pull and let me know if you have any problems.

Kalle

----------------------------------------------------------------------

The following changes since commit b25f32cb02155d68c690255ba846796a1c248fd3:

  ath10k: use ether_addr_copy() (2014-09-18 10:47:03 +0300)

are available in the git repository at:

  git://github.com/kvalo/ath.git tags/for-linville-20141024

for you to fetch changes up to 84cbf3a7592879810f80cece6c7f736f099ab163:

  ath10k: split ce pipe init/alloc further (2014-10-23 16:41:32 +0300)

----------------------------------------------------------------
Bartosz Markowski (1):
      ath10k: advertise all possible firmware(-api) files

Ben Greear (3):
      ath10k: add firmware crash counters
      ath10k: support ethtool stats
      ath10k: use 64-bit vdev map

Janusz Dziedzic (2):
      ath10k: don't create bssid peer for ibss
      ath10k: fix WMI scan command length

Joe Perches (1):
      ath: change logging functions to return void

Kalle Valo (6):
      ath10k: don't enable interrupts for the diagnostic window
      ath10k: add diag_read() to hif ops
      ath10k: add cal_data debugfs file
      ath10k: add back enum ath10k_bus
      ath10k: refactor ath10k_init_download_firmware()
      ath10k: retrieve calibration data from file

Michal Kazior (26):
      ath10k: workaround fw beaconing bug
      ath10k: fix tx/rx chainmask init
      ath10k: remove unused pdev_set_channel command
      ath10k: deduplicate wmi_channel code
      ath10k: deduplicate host mem chunk code
      ath10k: relocate wmi attach/deatch functions
      ath10k: deduplicate wmi service ready logic
      ath10k: clean up phyerr code
      ath10k: unify wmi event function names
      ath10k: re-work scan start command building
      ath10k: print wmi version info
      ath10k: dump hex bytes with dev string prefix
      ath10k: add debug dump for pci rx
      ath10k: split wmi stats parsing
      ath10k: rename fw_stats related stuff
      ath10k: request fw_stats once on open
      ath10k: fix fw stats processing
      ath10k: warn on unhandled htt events
      ath10k: clean up assoc code
      ath10k: skip some commands on reassoc
      ath10k: clean up sta auth/assoc code
      ath10k: simplify computation of mgmt rx band
      ath10k: use bss_info as txpower source
      ath10k: re-disable interrupts after target init
      ath10k: mask/unmask msi fw irq
      ath10k: split ce pipe init/alloc further

Rajkumar Manoharan (6):
      ath10k: add support to configure pktlog filter
      ath10k: add tracing for ath10k_htt_pktlog
      ath10k: add tracing for rx descriptor
      ath10k: add tracing for tx info
      ath10k: add tracing for frame transmission
      ath10k: fix kernel panic while shutting down AP

 drivers/net/wireless/ath/ath10k/ce.c       |   83 ++-
 drivers/net/wireless/ath/ath10k/ce.h       |   21 +-
 drivers/net/wireless/ath/ath10k/core.c     |  111 ++-
 drivers/net/wireless/ath/ath10k/core.h     |   80 +-
 drivers/net/wireless/ath/ath10k/debug.c    |  891 ++++++++++++++++------
 drivers/net/wireless/ath/ath10k/debug.h    |   40 +-
 drivers/net/wireless/ath/ath10k/hif.h      |   10 +
 drivers/net/wireless/ath/ath10k/htt.h      |    2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c   |   20 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c   |    2 +
 drivers/net/wireless/ath/ath10k/hw.h       |   17 +-
 drivers/net/wireless/ath/ath10k/mac.c      |  509 +++++++------
 drivers/net/wireless/ath/ath10k/mac.h      |    1 +
 drivers/net/wireless/ath/ath10k/pci.c      |  203 +++--
 drivers/net/wireless/ath/ath10k/spectral.c |   34 +-
 drivers/net/wireless/ath/ath10k/spectral.h |    8 +-
 drivers/net/wireless/ath/ath10k/trace.h    |  163 ++++
 drivers/net/wireless/ath/ath10k/txrx.c     |    1 +
 drivers/net/wireless/ath/ath10k/wmi.c      | 1116 ++++++++++++++++------------
 drivers/net/wireless/ath/ath10k/wmi.h      |  273 ++-----
 drivers/net/wireless/ath/ath6kl/common.h   |    2 +-
 drivers/net/wireless/ath/ath6kl/debug.c    |   28 +-
 drivers/net/wireless/ath/ath6kl/debug.h    |   13 +-
 drivers/net/wireless/ath/wil6210/debug.c   |   14 +-
 drivers/net/wireless/ath/wil6210/wil6210.h |    7 +-
 25 files changed, 2264 insertions(+), 1385 deletions(-)

-- 
Kalle Valo
