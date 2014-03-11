Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44807 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaCKKqd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 06:46:33 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Pull request: ath 20140311
Date: Tue, 11 Mar 2014 12:46:24 +0200
Message-ID: <87y50hgghr.fsf@kamboji.qca.qualcomm.com> (sfid-20140311_114636_610458_93280A8E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's a new pull request from me, but just ath10k patches this time.
Summary of the changes:

Michal now did some optimisations and was able to improve throughput by
100 Mbps on our MIPS based AP135 platform. Chun-Yeow added some
workarounds to be able to better use ad-hoc mode. Ben improved log
messages and added support for MSDU chaining. And, as usual, also some
smaller fixes.

Please let me know if there are any problems.

Kalle

The following changes since commit ef1b4141d0430583743a6045901e4d1a73557a33:

  ath5k: set SURVEY_INFO_IN_USE on get_survey (2014-02-24 15:38:39 -0500)

are available in the git repository at:

  git://github.com/kvalo/ath.git for-linville

for you to fetch changes up to 70dd77b4c50da518b57b8b9b125a8c9aabe9bc1a:

  ath10k: do not overwrite max_antenna_gain (2014-03-07 10:14:10 +0200)

----------------------------------------------------------------
Ben Greear (3):
      ath10k:  add more details to some debug messages
      ath10k: add vdev-id, return code to error codes
      ath10k: support msdu chaining

Chun-Yeow Yeoh (2):
      ath10k: implement drv_get_tsf for ibss merging
      ath10k: set the mactime of ieee80211_rx_status

Janusz Dziedzic (3):
      ath10k: enable spectrum management support
      ath10k: bitrate_mask add force_sgi support
      ath10k: skip management frames in HTT path

Marek Puzyniak (1):
      ath10k: do not overwrite max_antenna_gain

Michal Kazior (10):
      ath10k: fix 4addr rx
      ath10k: fix sta_rc_update for non-ap iftype
      ath10k: remove DMA mapping wrappers
      ath10k: remove is_aborted from skb_cb
      ath10k: replace send_head() with tx_sg()
      ath10k: bypass htc for htt tx path
      ath10k: batch htt tx/rx completions
      ath10k: reduce htt tx/rx spinlock overhead
      ath10k: remove pci completion list
      ath10k: minimize coherent dma accesses

 drivers/net/wireless/ath/ath10k/ce.c     |   16 +-
 drivers/net/wireless/ath/ath10k/ce.h     |    9 +-
 drivers/net/wireless/ath/ath10k/core.h   |   34 +--
 drivers/net/wireless/ath/ath10k/hif.h    |   25 +-
 drivers/net/wireless/ath/ath10k/htc.c    |   25 +-
 drivers/net/wireless/ath/ath10k/htt.h    |   18 ++
 drivers/net/wireless/ath/ath10k/htt_rx.c |  236 +++++++++++++-----
 drivers/net/wireless/ath/ath10k/htt_tx.c |  205 ++++++++--------
 drivers/net/wireless/ath/ath10k/mac.c    |  268 ++++++++++++--------
 drivers/net/wireless/ath/ath10k/pci.c    |  389 +++++++-----------------------
 drivers/net/wireless/ath/ath10k/pci.h    |   28 ---
 drivers/net/wireless/ath/ath10k/txrx.c   |   24 +-
 drivers/net/wireless/ath/ath10k/wmi.c    |   18 +-
 13 files changed, 638 insertions(+), 657 deletions(-)

-- 
Kalle Valo
