Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61673 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab3G3X7V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 19:59:21 -0400
Date: Wed, 31 Jul 2013 01:59:15 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@lists.01.org>
Subject: [GIT] [NFC] 3.11 fixes
Message-ID: <20130730235915.GA4641@zurbaran> (sfid-20130731_015924_572172_73D87B0E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the second NFC fixes pull request for 3.11.

We have:

1) A build failure fix for the NCI SPI transport layer due to a
   missing CRC_CCITT Kconfig dependency.

2) A netlink command rename: CMD_FW_UPLOAD was merged during the 3.11
   merge window but the typical terminology for loading a firmware to a
   target is firmware download rather than upload. In order to avoid any
   confusion in a file exported to userspace, we rename this command to
   CMD_FW_DOWNLOAD.

I realize 2) might not meet the net.git criteria for what fixes are. If
you don't want to take it then I'll have to push it through the
3.12 merge window. If that's the case, and you only want to take 1) then
please use tags/nfc-3.11-1 instead of tags/nfc-3.11-2 in your pull URL.

The following changes since commit 64b6f46f1141ad938e354f37af62e28da972e8eb:

  ath9k_hw: Fix multicast search for AR9002 family (2013-07-18 16:22:00 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes.git tags/nfc-fixes-3.11-2

for you to fetch changes up to 9ea7187c53f63e31f2d1b2b1e474e31808565009:

  NFC: netlink: Rename CMD_FW_UPLOAD to CMD_FW_DOWNLOAD (2013-07-31 01:19:43 +0200)

----------------------------------------------------------------
Frederic Danis (1):
      NFC: Fix NCI over SPI build

Samuel Ortiz (1):
      NFC: netlink: Rename CMD_FW_UPLOAD to CMD_FW_DOWNLOAD

 include/net/nfc/hci.h    |    2 +-
 include/net/nfc/nfc.h    |    4 ++--
 include/uapi/linux/nfc.h |    6 +++---
 net/nfc/core.c           |   20 ++++++++++----------
 net/nfc/hci/core.c       |    8 ++++----
 net/nfc/nci/Kconfig      |    1 +
 net/nfc/netlink.c        |   12 ++++++------
 net/nfc/nfc.h            |    6 +++---
 8 files changed, 30 insertions(+), 29 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
