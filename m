Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:42596 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab3CRMzz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 08:55:55 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <ath6kl-devel@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Pull request: ath6kl 20130318
Date: Mon, 18 Mar 2013 14:55:50 +0200
Message-ID: <87obeg7tpl.fsf@kamboji.qca.qualcomm.com> (sfid-20130318_135559_567958_215EB331)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's an ath6kl pull request for 3.10. Please let me know if there are
any problems.

I added tracing support to ath6kl, along with a new Kconfig option. Now
there's also a workaround to reset USB devices when the firmware upload
fails, this happened when host was warm rebooted. There are also quite a
few small fixes or cleanup.

The following changes since commit b53cf458ea20dd7f5e32611366f63728e40c9021:

  net: wireless: hostap: hostap_ap.c: Return -ENOMEM instead of -1 for if kmalloc() fails. (2013-02-18 15:30:40 -0500)

are available in the git repository at:

  git://github.com/kvalo/ath6kl.git tags/for-linville-20130318

for you to fetch changes up to 243c028099c467186d126859848bdac3bbfe8da0:

  ath6kl: Fix a debugfs crash for USB devices (2013-03-18 14:09:40 +0200)

----------------------------------------------------------------
Andrei Epure (1):
      ath: changed kmalloc to kmemdup

Dan Carpenter (1):
      ath6kl: small cleanup in ath6kl_htc_pipe_rx_complete()

Kalle Valo (13):
      ath6kl: print firmware capabilities
      ath6kl: cleanup ath6kl_reset_device()
      ath6kl: fix usb related error handling and warnings
      ath6kl: cold reset target after host warm boot
      ath6kl: add tracing support and tracing points for wmi packets
      ath6kl: add tracing points for sdio transfers
      ath6kl: add tracing point for hif irqs
      ath6kl: adding tracing points for htc_mbox
      ath6kl: convert ath6kl_info/err/warn macros to real functions
      ath6kl: add tracing support to log functions
      ath6kl: add tracing support to debug message macros
      ath6kl: add an extra band check to ath6kl_wmi_beginscan_cmd()
      ath6kl: remove false check from ath6kl_rx()

Mohammed Shafi Shajakhan (5):
      ath6kl: Cosmetic change in checking for free vif slot
      ath6kl: Protect ath6kl_cfg80211_vif_cleanup using rtnl_locks
      ath6kl: Return error from ath6kl_bmi_done()
      ath6kl: Remove NETDEV_REGISTERED flag
      ath6kl: Fix a debugfs crash for USB devices

Myoungje Kim (1):
      ath6kl: Fix the byte alignment rule to avoid loss of bytes in a TCP segment

 drivers/net/wireless/ath/ath6kl/Kconfig    |    9 +
 drivers/net/wireless/ath/ath6kl/Makefile   |    5 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    7 +-
 drivers/net/wireless/ath/ath6kl/core.h     |    3 -
 drivers/net/wireless/ath/ath6kl/debug.c    |   72 +++++-
 drivers/net/wireless/ath/ath6kl/debug.h    |   11 +-
 drivers/net/wireless/ath/ath6kl/hif.c      |    3 +
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |   21 +-
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |   15 +-
 drivers/net/wireless/ath/ath6kl/init.c     |  116 ++++++++--
 drivers/net/wireless/ath/ath6kl/main.c     |   41 +---
 drivers/net/wireless/ath/ath6kl/sdio.c     |   16 +-
 drivers/net/wireless/ath/ath6kl/target.h   |    2 +-
 drivers/net/wireless/ath/ath6kl/trace.c    |   23 ++
 drivers/net/wireless/ath/ath6kl/trace.h    |  332 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/txrx.c     |    5 +-
 drivers/net/wireless/ath/ath6kl/usb.c      |   38 ++--
 drivers/net/wireless/ath/ath6kl/wmi.c      |    6 +
 18 files changed, 629 insertions(+), 96 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/trace.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/trace.h

-- 
Kalle Valo
