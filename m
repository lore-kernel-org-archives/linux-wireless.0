Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:42726 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534AbaGQPyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 11:54:39 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
	<ath6kl@lists.infradead.org>
Subject: Pull request: ath 20140717
Date: Thu, 17 Jul 2014 18:54:33 +0300
Message-ID: <87k37c6kw6.fsf@kamboji.qca.qualcomm.com> (sfid-20140717_175443_198664_7CA6302E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's new pull request for 3.17. Major changes are:

For ath6kl me and Jessica added support for ar6004 hw3.0, our latest
version of ar6004.

For ath10k Janusz added a printout so that it's easier to check what
ath10k kconfig options are enabled. He also added a debugfs file to
configure maximum amsdu and ampdu values. Also we had few fixes as
usual.

Please let me know if there are any problems.

Kalle

The following changes since commit a715c7ddd65a1a3b2839b8ebd759bb2d361f7675:

  wil6210: improve debug for WMI receive (2014-05-30 13:49:34 -0400)

are available in the git repository at:

  git://github.com/kvalo/ath.git tags/for-linville-20140717

for you to fetch changes up to 993619443774f7ef4df3b98655df4c3bf298548c:

  ath10k: sanitize tx ring index access properly (2014-07-15 11:19:45 +0300)

----------------------------------------------------------------
Frederic Danis (1):
      ath6kl: Fix ath6kl_bmi_read_hi32 macro

Janusz Dziedzic (2):
      ath10k: print Kconfig options
      ath10k: add implementation for configure max amsdu, ampdu

Jessica Wu (3):
      ath6kl: implement rx flush for htc pipe
      ath6kl: add support wmi rate tables with mcs15
      ath6kl: add support for ar6004 hw3.0

Kalle Valo (3):
      ath10k: remove unused len variables from wmi process rx functions
      ath6kl: convert ar6004 hardware flags to firmware feature flags
      ath6kl: don't set hi_refclk_hz if hardware version doesn't need it

Michal Kazior (3):
      ath10k: fix unregister deadlock when fw probe fails
      ath10k: fix bmi exchange tx/rx race
      ath10k: sanitize tx ring index access properly

 drivers/net/wireless/ath/ath10k/ce.c       |   11 ++--
 drivers/net/wireless/ath/ath10k/core.c     |   12 +++-
 drivers/net/wireless/ath/ath10k/core.h     |    3 +
 drivers/net/wireless/ath/ath10k/debug.c    |   73 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/htt.h      |   13 ++--
 drivers/net/wireless/ath/ath10k/htt_tx.c   |   46 ++++++++++++++
 drivers/net/wireless/ath/ath10k/pci.c      |   11 +---
 drivers/net/wireless/ath/ath10k/pci.h      |    3 +-
 drivers/net/wireless/ath/ath10k/wmi.c      |    6 --
 drivers/net/wireless/ath/ath6kl/bmi.h      |    3 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 +-
 drivers/net/wireless/ath/ath6kl/core.c     |   16 +++++
 drivers/net/wireless/ath/ath6kl/core.h     |   36 +++++++++--
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |   32 +++++++++-
 drivers/net/wireless/ath/ath6kl/init.c     |   90 ++++++++++++++++++++++------
 drivers/net/wireless/ath/ath6kl/main.c     |   17 ++++--
 drivers/net/wireless/ath/ath6kl/usb.c      |    7 ++-
 drivers/net/wireless/ath/ath6kl/wmi.c      |   72 ++++++++++++++++++++--
 drivers/net/wireless/ath/ath6kl/wmi.h      |    2 +-
 19 files changed, 388 insertions(+), 71 deletions(-)

-- 
Kalle Valo
