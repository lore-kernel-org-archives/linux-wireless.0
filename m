Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:14934 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbaE3IjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 04:39:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Pull request: ath 20140530
Date: Fri, 30 May 2014 11:38:54 +0300
Message-ID: <87vbsn4q5d.fsf@kamboji.qca.qualcomm.com> (sfid-20140530_103917_564782_FD2A468A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's a new pull request for ath10k and also a small change for ath9k.
I'm hoping to get these still to 3.16. The changelog is:

----------------------------------------------------------------------
Ben added support for setting antenna configurations. Michal improved
warm reset so that we would not need to fall back to cold reset that
often, an issue where ath10k stripped protected flag while in monitor
mode and made module initialisation asynchronous to fix the problems
with firmware loading when the driver is linked to the kernel.

Luca removed unused channel_switch_beacon callbacks both from ath9k and
ath10k. Marek fixed Protected Management Frames (PMF) when using Action
Frames. Also we had other small fixes everywhere in the driver.
----------------------------------------------------------------------

Please let me know if there are any problems.

Kalle


The following changes since commit 5f407acbb7d6a92841c455b37a6ad4833757740e:

  rsi: Changed the return value to enable BA set-up (2014-05-13 15:56:53 -0400)

are available in the git repository at:

  git://github.com/kvalo/ath.git tags/for-linville-20140530

for you to fetch changes up to 08b8aa0931830cc4b96b47f884fe623aef5c4b84:

  ath10k: abort incomplete scatter-gather pci tx properly (2014-05-27 12:32:10 +0300)

----------------------------------------------------------------
Bartosz Markowski (1):
      ath10k: get rid of pci_assign_resource() call from pci_probe

Ben Greear (3):
      ath10k: fix spelling mistake in comments
      ath10k: support get/set antenna configurations.
      ath10k: ensure rx-frag ignores rssi

Frederic Danis (1):
      ath10k: fix ath10k_bmi_read32 macro

Kalle Valo (1):
      Merge remote-tracking branch 'wireless-next/master' into ath-next

Luciano Coelho (1):
      ath9k/ath10k: remove unnecessary channel_switch_beacon callbacks

Marek Kwaczynski (1):
      ath10k: fix pmf for action frames

Michal Kazior (18):
      ath10k: fix htt rx ring clean up
      ath10k: fix handling of wierd MSDU chaining cases
      ath10k: improve warm reset reliability
      ath10k: retry warm reset a few times
      ath10k: enable early device dumps
      ath10k: fix core start sequence
      ath10k: prevent hif_stop being called twice
      ath10k: fix protected flag stripping
      ath10k: relocate core create/destroy functions
      ath10k: remove unnecessary tasklet_kill()
      ath10k: make core registering async
      ath10k: clean up start() callback
      ath10k: perform hw restart lazily
      ath10k: drain tx before restarting hw
      ath10k: protect wep tx key setup
      ath10k: dont configure bssid for ap mode
      ath10k: protect src_ring state with ce_lock in tx_sg()
      ath10k: abort incomplete scatter-gather pci tx properly

 drivers/net/wireless/ath/ath10k/bmi.h    |    3 +-
 drivers/net/wireless/ath/ath10k/ce.c     |   27 +++
 drivers/net/wireless/ath/ath10k/ce.h     |    2 +
 drivers/net/wireless/ath/ath10k/core.c   |  281 +++++++++++++++++-------------
 drivers/net/wireless/ath/ath10k/core.h   |    8 +
 drivers/net/wireless/ath/ath10k/htc.c    |    6 -
 drivers/net/wireless/ath/ath10k/htt.c    |   42 +----
 drivers/net/wireless/ath/ath10k/htt.h    |   18 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c |   92 +++++++---
 drivers/net/wireless/ath/ath10k/htt_tx.c |    8 +-
 drivers/net/wireless/ath/ath10k/mac.c    |  224 ++++++++++++++++++------
 drivers/net/wireless/ath/ath10k/pci.c    |  121 +++++++++----
 drivers/net/wireless/ath/ath10k/wmi.c    |   28 ++-
 drivers/net/wireless/ath/ath10k/wmi.h    |    6 +-
 drivers/net/wireless/ath/ath9k/main.c    |    9 -
 15 files changed, 570 insertions(+), 305 deletions(-)

-- 
Kalle Valo
