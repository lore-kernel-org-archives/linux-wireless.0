Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54284 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbaLaKiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2014 05:38:13 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Maithili Hinge <maithili@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 0/9] mwifiex enhancements
Date: Wed, 31 Dec 2014 02:36:37 -0800
Message-ID: <1420022206-11435-1-git-send-email-akarwar@marvell.com> (sfid-20141231_113815_684994_6B5CDC7D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds couple of fixes, recovery mechanism
when host fails to wakeup the firmware and wowlan disconnect
feature.

Amitkumar Karwar (5):
  mwifiex: remove redundant flag MWIFIEX_HW_STATUS_FW_READY
  mwifiex: add wakeup timer based recovery mechanism
  mwifiex: wakeup pending wait queues
  mwifiex: do not release lock during list_for_each_entry_safe()
  mwifiex: Increase priority of firmware download message

Maithili Hinge (2):
  mwifiex: Move code for wowlan magic-packet and patterns to a function
  mwifiex: Add support for wowlan disconnect

Marc Yang (2):
  Adjust calling place of mwifiex_terminate_workqueue
  mwifiex: increase delay during card reset

 drivers/net/wireless/mwifiex/cfg80211.c  | 95 +++++++++++++++++++++-----------
 drivers/net/wireless/mwifiex/cmdevt.c    |  6 --
 drivers/net/wireless/mwifiex/init.c      | 18 ++++++
 drivers/net/wireless/mwifiex/main.c      | 12 ++--
 drivers/net/wireless/mwifiex/main.h      |  2 +-
 drivers/net/wireless/mwifiex/pcie.c      |  5 +-
 drivers/net/wireless/mwifiex/sdio.c      |  8 +--
 drivers/net/wireless/mwifiex/sta_event.c |  3 +
 drivers/net/wireless/mwifiex/usb.c       |  4 +-
 9 files changed, 101 insertions(+), 52 deletions(-)

-- 
1.8.1.4

