Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18563 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaAMMAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 07:00:34 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Pull request: ath 20140113
Date: Mon, 13 Jan 2014 14:00:28 +0200
Message-ID: <87fvos3xcz.fsf@kamboji.qca.qualcomm.com> (sfid-20140113_130056_964679_B0387B47)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's another ath10k pull request. Major changes are:

Janusz added Kconfig option for DFS. The DFS code was there already, but
after fixes to mac80211 we can now enable it.

Bartosz added a runtime firmware feature flag to disable P2P. Our 10.1
firmware branch doesn't support P2P and ath10k can now disable that. He
also added a limit for how many clients can connect to ath10k AP.

Michal fixed WEP shared authentication, in case someone still uses it.
And I added firmware debug log to help the firmware engineers.

Please let me know if there any problems.

The following changes since commit 39731b78b4afebb7501c05b68e2443a1b250b41c:

  ath9k: simplify/fix tx packet TID handling (2013-12-19 14:41:57 -0500)

are available in the git repository at:

  git://github.com/kvalo/ath.git for-linville

for you to fetch changes up to 51ab1a0a09a894442e8b091d57222c5425b6d700:

  ath10k: add set_bitrate_mask callback (2014-01-10 11:54:49 +0200)

----------------------------------------------------------------
Bartosz Markowski (3):
      ath10k: split the if_limits and if_comb
      ath10k: introduce NO_P2P fw feature flag
      ath10k: track number of existing peers

Janusz Dziedzic (3):
      ath10k: handle TKIP MIC error correctly
      ath10k: add DFS_CERTIFIED option
      ath10k: add set_bitrate_mask callback

Kalle Valo (4):
      Merge remote-tracking branch 'wireless-next/master' into ath-next
      ath10k: handle WMI debug print events
      ath10k: add trace event for WMI_DEBUG_MESG_EVENTID
      ath10k: add debugfs file to control firmware dbglog

Marek Puzyniak (1):
      ath10k: disable STA kickout in FW

Michal Kazior (2):
      ath10k: fix WEP Shared authentication
      ath10k: fix band reporting for mgmt CCK frames on 5GHz

 drivers/net/wireless/ath/ath10k/Kconfig  |    7 +
 drivers/net/wireless/ath/ath10k/core.h   |   11 +
 drivers/net/wireless/ath/ath10k/debug.c  |   66 ++++++
 drivers/net/wireless/ath/ath10k/htt.h    |    1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |   15 ++
 drivers/net/wireless/ath/ath10k/hw.h     |    1 +
 drivers/net/wireless/ath/ath10k/mac.c    |  374 ++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/trace.h  |   21 ++
 drivers/net/wireless/ath/ath10k/txrx.c   |    2 +-
 drivers/net/wireless/ath/ath10k/wmi.c    |  106 ++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h    |   61 +++++
 11 files changed, 642 insertions(+), 23 deletions(-)

-- 
Kalle Valo
