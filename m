Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:8005 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaFKKr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:47:59 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 00/28] ath9k: Multi-channel concurrency support
Date: Wed, 11 Jun 2014 16:17:48 +0530
Message-ID: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_124804_963165_07F4C543)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

The below patches add multi channel concurrency support in two diffent
channel context. This support can be enabled by modparam "use_chanctx".
As DFS and WDS are not supported in channel context, this feature
is limited modparam.

Thanks Felix for his initial prototype changes and this work is based
on Felix's initial patches for MCC.

-Rajkumar

Felix Fietkau (22):
  ath9k: Add channel context structure
  ath9k: Move txpower limit to channel context
  ath9k: Move acq to channel context
  ath9k: Add channel context worker thread
  ath9k: channel context based transmission
  ath9k: send powersave frame on channel switch
  ath9k: Implement hw_scan support
  ath9k: Implement remain-on-channal support
  ath9k: Implement channel context ops
  ath9k: Move caldata into channel context
  ath9k: Add ATH_OP_MULTI_CHANNEL
  ath9k: save tsf in channel context
  ath9k: switch channel context for beaconing
  ath9k: Add p2p go NoA attribute
  ath9k: switch channel after sending beacon
  ath9k: Adjust AP beacon tsf based on station context
  ath9k: Implement mgd_prepare_tx
  ath9k: Add multi-channel scheduling support
  ath9k: Add periodic NoA support
  ath9k: Handle beacon miss on multi channel context
  ath9k: Update channel switch timer
  ath9k: Add recovery mechanism for hw TSF timer

Rajkumar Manoharan (6):
  ath9k: Fetch appropriate operating channel context
  ath9k: Move beacon config to channel context
  ath9k: Summarize hw state per channel context
  ath9k: Store current offchannel duration
  ath9k: use separate HW queue for each channel context
  ath9k: Advertise multichannel support

 drivers/net/wireless/ath/ath.h           |   1 +
 drivers/net/wireless/ath/ath9k/Makefile  |   3 +-
 drivers/net/wireless/ath/ath9k/ath9k.h   | 159 +++++-
 drivers/net/wireless/ath/ath9k/beacon.c  |  97 +++-
 drivers/net/wireless/ath/ath9k/channel.c | 685 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/debug.c   |  28 +-
 drivers/net/wireless/ath/ath9k/hw.c      |  23 +-
 drivers/net/wireless/ath/ath9k/hw.h      |   1 +
 drivers/net/wireless/ath/ath9k/init.c    |  55 +-
 drivers/net/wireless/ath/ath9k/link.c    |   6 +-
 drivers/net/wireless/ath/ath9k/main.c    | 892 ++++++++++++++++++++++---------
 drivers/net/wireless/ath/ath9k/mci.c     |   4 +-
 drivers/net/wireless/ath/ath9k/pci.c     |   1 +
 drivers/net/wireless/ath/ath9k/recv.c    |  16 +-
 drivers/net/wireless/ath/ath9k/tx99.c    |   2 +-
 drivers/net/wireless/ath/ath9k/wow.c     |   1 +
 drivers/net/wireless/ath/ath9k/xmit.c    | 114 +++-
 17 files changed, 1743 insertions(+), 345 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/channel.c

-- 
2.0.0

