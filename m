Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19957 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab3ICIO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 04:14:29 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
	<ath6kl-devel@qca.qualcomm.com>
Subject: Pull request: ath 20130930
Date: Tue, 3 Sep 2013 11:14:22 +0300
Message-ID: <87wqmyz5i9.fsf@kamboji.qca.qualcomm.com> (sfid-20130903_101443_930786_7C5A351B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here are latest ath10k changes, I hope it's still time to get these to
3.12. The changelog for the pull request:

Bartosz dropped support for qca98xx hw1.0 hardware from ath10k, it's
just too much to support it. Michal added support for the new firmware
interface. Marek fixed WEP in AP and IBSS mode. Rest of the changes are
minor fixes or cleanups.

The following changes since commit 9d0e2f0772d394060bf3b17cd1f3a35574365103:

  ath6kl: Fix invalid pointer access on fuzz testing with AP mode (2013-08-07 10:58:59 +0300)

are available in the git repository at:

  git://github.com/kvalo/ath.git for-linville

for you to fetch changes up to 763b8cd31493f452094fd0eaeedb8cad37c756a2:

  ath10k: add chip_id file to debugfs (2013-09-03 09:59:53 +0300)

----------------------------------------------------------------
Bartosz Markowski (2):
      ath10k: Remove qca98xx hw1.0 support
      ath10k: update supported FW build version

Janusz Dziedzic (2):
      ath10k: setup peer UAPSD flag correctly
      ath10k: check allocation errors in CE

Kalle Valo (10):
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

Marek Puzyniak (1):
      ath10k: fix WEP in AP and IBSS mode

Michal Kazior (15):
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

Mohammed Shafi Shajakhan (1):
      ath10k: Fix mutex unlock balance

 drivers/net/wireless/ath/ath10k/ce.c     |  291 +++++++++++++-------------
 drivers/net/wireless/ath/ath10k/ce.h     |   74 +++----
 drivers/net/wireless/ath/ath10k/core.c   |   46 +++--
 drivers/net/wireless/ath/ath10k/core.h   |   13 +-
 drivers/net/wireless/ath/ath10k/debug.c  |   23 ++-
 drivers/net/wireless/ath/ath10k/htc.c    |    8 +-
 drivers/net/wireless/ath/ath10k/htt.c    |   19 +-
 drivers/net/wireless/ath/ath10k/htt.h    |    6 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c |   12 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |   74 +++++--
 drivers/net/wireless/ath/ath10k/hw.h     |   19 +-
 drivers/net/wireless/ath/ath10k/mac.c    |   22 +-
 drivers/net/wireless/ath/ath10k/pci.c    |  325 ++++++++++++++++++++----------
 drivers/net/wireless/ath/ath10k/pci.h    |   73 +++----
 drivers/net/wireless/ath/ath10k/wmi.c    |   33 ++-
 drivers/net/wireless/ath/ath10k/wmi.h    |   16 +-
 16 files changed, 626 insertions(+), 428 deletions(-)

-- 
Kalle Valo
