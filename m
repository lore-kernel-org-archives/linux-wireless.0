Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60514 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab2FNMoe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 08:44:34 -0400
Message-ID: <4FD9DCAC.1000507@qca.qualcomm.com> (sfid-20120614_144439_344392_3F98710C)
Date: Thu, 14 Jun 2012 15:44:28 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Pull request: ath6kl 20120614
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's a pull request of latest ath6kl changes. New features there are
enhanced beacon miss detection, match ssid support in scheduled scan,
setting tx rateset and chanding DTIM in AP mode. But all the patches are
pretty small in size which makes me happy.

There's also few bugfixes and some code cleanup.

Please let me know if you have any problems.

Kalle

The following changes since commit 211c17aaee644bb808fbdeef547ac99db92c01ed:

  Merge branch 'master' of
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless
(2012-06-13 15:35:35 -0400)

are available in the git repository at:

  git://github.com/kvalo/ath6kl.git for-linville

Bala Shanmugam (1):
      ath6kl: Add support for setting tx rateset.

Etay Luz (1):
      ath6kl: support changing dtim period on AP mode

Joe Perches (1):
      ath6kl: Add missing newline terminations

Jouni Malinen (1):
      ath6kl: Use correct max-scan-SSIDs limit

Kalle Valo (1):
      Merge remote branch 'wireless-next/master' into ath6kl-next

Kiran Reddy (1):
      ath6kl: separate ht cap for each band

Naveen Gangadharan (1):
      ath6kl: Add wow multicast firmware capability support

Naveen Singh (2):
      ath6kl: Include match ssid list in scheduled scan
      ath6kl: use firmware version from FW IE

Raja Mani (2):
      ath6kl: Remove unneeded memset in roam related config func
      ath6kl: Fix typo in htc mbox debug print msg

Thomas Pedersen (3):
      ath6kl: enable enhanced bmiss detection
      ath6kl: issue wmi disconnect after notifying cfg80211
      ath6kl: fix fw capability parsing

Vasanthakumar Thiagarajan (3):
      ath6kl: Fix missing gpio pin 9 configuration
      ath6kl: Fix race in aggregation reorder logic
      ath6kl: Fix unstable downlink throughput

 drivers/net/wireless/ath/ath6kl/cfg80211.c |  208
+++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    2 +
 drivers/net/wireless/ath/ath6kl/core.h     |   38 +++++-
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |    2 +-
 drivers/net/wireless/ath/ath6kl/init.c     |   28 ++++-
 drivers/net/wireless/ath/ath6kl/main.c     |   27 +++--
 drivers/net/wireless/ath/ath6kl/target.h   |    1 +
 drivers/net/wireless/ath/ath6kl/txrx.c     |   48 ++++----
 drivers/net/wireless/ath/ath6kl/wmi.c      |  148 +++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/wmi.h      |   58 ++++++++-
 10 files changed, 477 insertions(+), 83 deletions(-)
