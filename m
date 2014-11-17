Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:52485 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaKQPah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 10:30:37 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl@lists.infradead.org>,
	<ath10k@lists.infradead.org>
Subject: Pull request: ath 20141117
Date: Mon, 17 Nov 2014 17:30:07 +0200
Message-ID: <87r3x1oneo.fsf@kamboji.qca.qualcomm.com> (sfid-20141117_163041_019564_7E65AE05)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

new pull request again, here's the changelog:

----------------------------------------------------------------------
One ath6kl patch and rest for ath10k, but nothing really major which
stands out. Most notable:

o fix resume (Bartosz)

o firmware restart is now faster and more reliable (Michal)

o it's now possible to test hardware restart functionality without
  crashing the firmware using hw-restart parameter with
  simulate_fw_crash debugfs file (Michal)

----------------------------------------------------------------------

The following changes since commit 84cbf3a7592879810f80cece6c7f736f099ab163:

  ath10k: split ce pipe init/alloc further (2014-10-23 16:41:32 +0300)

are available in the git repository at:

  git://github.com/kvalo/ath.git for-linville

for you to fetch changes up to 9de8f26f0038133bdfb8cf847936645dab949d88:

  ath10k: fix mismatched wmi api call (2014-11-17 16:48:49 +0200)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      ath6kl: remove incorrect reset_resume handler

Bartosz Markowski (1):
      ath10k: fix pm resume after suspend

Felix Fietkau (1):
      ath10k: add SURVEY_INFO_IN_USE for current channel on survey

Michal Kazior (20):
      ath10k: don't drop control and null func Rx
      ath10k: remove unused variable
      ath10k: use ieee80211 defines for crypto param lengths
      ath10k: fix rx buffer tracing
      ath10k: deduplicate htt rx dma unmapping
      ath10k: don't drop frames aggressively
      ath10k: add extra sanity check when popping amsdu
      ath10k: don't forget to replenish after fragmented Rx
      ath10k: clear htt->rx_confused on load
      ath10k: remove tsf argument from rx_desc tracing
      ath10k: re-use trace class
      ath10k: call correct function for frag threshold
      ath10k: avoid possible deadlock with scan timeout
      ath10k: change ce ring cleanup logic
      ath10k: make warm reset a bit safer and faster
      ath10k: split reset logic from power up
      ath10k: don't reset chip on power_down
      ath10k: fix possible bmi crash
      ath10k: expose hw restart via debugfs
      ath10k: speed up hw recovery

Peter Oh (1):
      ath10k: fix mismatched wmi api call

Rajkumar Manoharan (3):
      ath10k: handle ieee80211 header and payload tracing separately
      ath10k: add modpram 'skip_otp' to ignore empty otp error during BMI
      ath10k: advertise support for AP mode channel width changes

 drivers/net/wireless/ath/ath10k/ce.c     |    9 +-
 drivers/net/wireless/ath/ath10k/core.c   |   30 ++-
 drivers/net/wireless/ath/ath10k/core.h   |    5 +
 drivers/net/wireless/ath/ath10k/debug.c  |    7 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c |   99 ++++----
 drivers/net/wireless/ath/ath10k/htt_tx.c |    4 +-
 drivers/net/wireless/ath/ath10k/mac.c    |   27 ++-
 drivers/net/wireless/ath/ath10k/mac.h    |    1 +
 drivers/net/wireless/ath/ath10k/pci.c    |  364 ++++++++++++++++--------------
 drivers/net/wireless/ath/ath10k/trace.h  |  109 +++++----
 drivers/net/wireless/ath/ath10k/txrx.c   |    3 +-
 drivers/net/wireless/ath/ath10k/wmi.c    |   16 +-
 drivers/net/wireless/ath/ath6kl/usb.c    |    9 -
 13 files changed, 388 insertions(+), 295 deletions(-)

-- 
Kalle Valo
