Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5169 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab3G3PUy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 11:20:54 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Pull request: ath 20130730
Date: Tue, 30 Jul 2013 18:20:44 +0300
Message-ID: <87txjct6pf.fsf@kamboji.qca.qualcomm.com> (sfid-20130730_172120_873519_D8561022)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's a new pull request containing just ath10k patches from Michal.

A major new feature is that we can now restart the firmware when it
crashes. For this Michal needed quite a few preparation patches. It's
now possible to to crash the firmware from debugfs, which makes it
easier to test the restart feature.

Michal also sent fixes and cleanup to various parts in the driver. Most
visible to users are RTS and fragmentation related fixes.

Please pull and do let me know if there are any problems.

Kalle

The following changes since commit 2cdf359a521bb72286b6714478dfdbcd2691f3fe:

  mwifiex: code rearrangement in sdio.c (2013-07-26 16:57:45 -0400)

are available in the git repository at:

  git://github.com/kvalo/ath6kl.git tags/for-linville-20130730

for you to fetch changes up to 424121c365aed6ec93bbc8b515548df79c5af61c:

  ath10k: fix rts/fragmentation threshold setup (2013-07-30 18:01:21 +0300)

----------------------------------------------------------------
Michal Kazior (34):
      ath10k: fix teardown ordering
      ath10k: fix possible deadlock
      ath10k: setup rts/frag thresholds upon vdev creation
      ath10k: do not setup rts/frag thresholds for suspended interfaces
      ath10k: remove ath10k_bus
      ath10k: fix typo in define name
      ath10k: silent warning in IBSS mode
      ath10k: lower print level for a message
      ath10k: provide errno if bmi read/write fails
      ath10k: change function to take struct ath10k as arg
      ath10k: rename hif callback
      ath10k: embed HTC struct inside ath10k
      ath10k: embed HTT struct inside ath10k
      ath10k: improve locking
      ath10k: abort scan properly if wmi_scan_stop fails
      ath10k: add missing debug prints
      ath10k: decouple pci start/stop logic
      ath10k: decouple core start/stop logic
      ath10k: allow deferred regd update
      ath10k: reset BMI state upon init
      ath10k: decouple suspend code
      ath10k: move free_vdev_map initialization
      ath10k: make sure all resources are freed upon ath10k_stop()
      ath10k: defer hw setup to start/stop mac80211 hooks
      ath10k: store firmware files in memory
      ath10k: skip fw stats debugfs interface if device is down
      ath10k: implement device recovery
      ath10k: implement fw crash simulation command
      ath10k: fix NULL dereference for injected packets
      ath10k: create debugfs interface to trigger fw crash
      ath10k: prevent HTC from being used after stopping
      ath10k: don't reset HTC endpoints unnecessarily
      ath10k: fix memleak in mac setup
      ath10k: fix rts/fragmentation threshold setup

 drivers/net/wireless/ath/ath10k/bmi.c    |   12 +-
 drivers/net/wireless/ath/ath10k/bmi.h    |    1 +
 drivers/net/wireless/ath/ath10k/ce.c     |    2 +-
 drivers/net/wireless/ath/ath10k/core.c   |  321 +++++++++++++++--------
 drivers/net/wireless/ath/ath10k/core.h   |   50 +++-
 drivers/net/wireless/ath/ath10k/debug.c  |   87 ++++++-
 drivers/net/wireless/ath/ath10k/hif.h    |   49 +++-
 drivers/net/wireless/ath/ath10k/htc.c    |   61 ++---
 drivers/net/wireless/ath/ath10k/htc.h    |    8 +-
 drivers/net/wireless/ath/ath10k/htt.c    |   27 +-
 drivers/net/wireless/ath/ath10k/htt.h    |    3 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c |    3 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |   12 +-
 drivers/net/wireless/ath/ath10k/mac.c    |  409 +++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/mac.h    |    1 +
 drivers/net/wireless/ath/ath10k/pci.c    |  304 ++++++++++------------
 drivers/net/wireless/ath/ath10k/pci.h    |    4 +-
 drivers/net/wireless/ath/ath10k/wmi.c    |   40 ++-
 drivers/net/wireless/ath/ath10k/wmi.h    |   19 ++
 19 files changed, 959 insertions(+), 454 deletions(-)
