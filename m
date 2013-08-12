Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44577 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab3HLOOn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 10:14:43 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>,
	<ath10k@lists.infradead.org>
Subject: Pull request: ath 20130812
Date: Mon, 12 Aug 2013 17:14:37 +0300
Message-ID: <871u5zuhbm.fsf@kamboji.qca.qualcomm.com> (sfid-20130812_161446_723462_FE82D5A4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's a small pull request for ath10k and ath6kl. The changes are:

New features in ath10k are rx/tx checsumming in hw and survey scan
implemented by Michal. Also he made fixes to different areas of the
driver, most notable being fixing the case when using two streams and
reducing the number of interface combinations to avoid firmware crashes.
Bartosz did a clean related to how we handle SoC power save in PCI
layer.

For ath6kl Mohammed and Vasanth sent each a patch to fix two infrequent
crashes.

The following changes since commit 424121c365aed6ec93bbc8b515548df79c5af61c:

  ath10k: fix rts/fragmentation threshold setup (2013-07-30 18:01:21 +0300)

are available in the git repository at:

  git://github.com/kvalo/ath.git for-linville

for you to fetch changes up to 9d0e2f0772d394060bf3b17cd1f3a35574365103:

  ath6kl: Fix invalid pointer access on fuzz testing with AP mode (2013-08-07 10:58:59 +0300)

----------------------------------------------------------------
Bartosz Markowski (1):
      ath10k: add SoC power save option to PCI features map

Michal Kazior (11):
      ath10k: improve tx throughput on slow machines
      ath10k: detect the number of spatial streams supported by hw
      ath10k: implement rx checksum offloading
      ath10k: implement tx checksum offloading
      ath10k: implement get_survey()
      ath10k: prevent using invalid ringbuffer indexes
      ath10k: make sure to use passive scan when n_ssids is 0
      ath10k: advertise more conservative intf combinations
      ath10k: zero arvif memory on add_interface()
      ath10k: fix failpath in MSI-X setup
      ath10k: fix device teardown

Mohammed Shafi Shajakhan (1):
      ath6kl: Fix invalid pointer access on fuzz testing with AP mode

Vasanthakumar Thiagarajan (1):
      ath6kl: Fix race in heart beat polling

 drivers/net/wireless/ath/ath10k/ce.c     |    5 ++
 drivers/net/wireless/ath/ath10k/core.h   |    8 +++
 drivers/net/wireless/ath/ath10k/htt_rx.c |   40 ++++++++++++++
 drivers/net/wireless/ath/ath10k/htt_tx.c |    2 +
 drivers/net/wireless/ath/ath10k/mac.c    |   79 +++++++++++++++++++++------
 drivers/net/wireless/ath/ath10k/pci.c    |   70 +++++++++++++++++-------
 drivers/net/wireless/ath/ath10k/pci.h    |   11 ++--
 drivers/net/wireless/ath/ath10k/wmi.c    |   87 ++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h    |    5 ++
 drivers/net/wireless/ath/ath6kl/init.c   |    3 ++
 drivers/net/wireless/ath/ath6kl/main.c   |    3 ++
 11 files changed, 270 insertions(+), 43 deletions(-)
