Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:32395 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161286Ab3BOMun (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 07:50:43 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Subject: Pull request: ath6kl 20130215
Date: Fri, 15 Feb 2013 14:50:36 +0200
Message-ID: <87liap68rn.fsf@kamboji.qca.qualcomm.com> (sfid-20130215_135058_504178_657BC14F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's a small pull request for ath6kl. I don't know if there's enough
time for 3.9, but I'll try my luck.

There's not anything special here, most of the patches are just code
cleanup. The only functional changes are using the beacon interval from user
space and fixing a crash which happens when inserting and removing the
module in a loop.

Please let me know if there are any problems.

The following changes since commit ff7e68670c49b6404acc4fce6ca90d6c89ef0efe:

  ath6kl: support NL80211_USER_REG_HINT_CELL_BASE events (2012-11-16 10:39:01 +0200)

are available in the git repository at:

  git://github.com/kvalo/ath6kl.git for-linville

for you to fetch changes up to 6f7c1adb7529935df6e288a1436003c1f6dc0653:

  ath6kl: minor optimization using if, else if (2012-11-27 21:44:28 +0200)

----------------------------------------------------------------
Julia Lawall (1):
      drivers/net/wireless/ath/ath6kl/hif.c: drop if around WARN_ON

Mohammed Shafi Shajakhan (9):
      ath6kl: Fix a mismatch in power management debug message
      ath6kl: Remove erroneous flag clearing
      ath6kl: Use standard way to assign the boolean variable
      ath6kl: remove unnecessary check for NULL skb
      ath6kl: Fix kernel panic on continuous driver load/unload
      ath6kl: trivial cleanup on interface type selection
      ath6kl: Parse beacon interval from userspace
      ath6kl: Move and rename ath6kl_cleanup_vif function
      ath6kl: minor optimization using if, else if

 drivers/net/wireless/ath/ath6kl/cfg80211.c |  109 ++++++++++++++++++----------
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    2 -
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +-
 drivers/net/wireless/ath/ath6kl/hif.c      |    6 +-
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |   26 +++++--
 drivers/net/wireless/ath/ath6kl/init.c     |   36 +--------
 drivers/net/wireless/ath/ath6kl/usb.c      |    6 +-
 drivers/net/wireless/ath/ath6kl/wmi.c      |   28 +++++--
 drivers/net/wireless/ath/ath6kl/wmi.h      |    6 ++
 9 files changed, 121 insertions(+), 100 deletions(-)
