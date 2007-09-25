Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:19600 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbXIYSoc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 14:44:32 -0400
Received: by ug-out-1314.google.com with SMTP id z38so993592ugc
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2007 11:44:31 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: Please pull 'upstream' branch of rt2x00
Date: Tue, 25 Sep 2007 20:52:34 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709252052.34803.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

(Finally) the rt2x00 2.0.9 release containing the patches
for the API changes from the mac80211-misc git tree.

NOTE: currently rt2x00.git is branched off from the mac80211-misc
tree to make the porting easier and to allow early testing.
So you might want to pull that tree before pulling rt2x00.

This release contains several bug fixes especially some kernel
panics during rmmod have been fixed by Modestas Vainius.

---

The following changes since commit 4cceb887147261d7fd9fe7ce3b6d6f236c8300bc:
  Michael Wu (1):
        adm8211: Adapt to filter configuration API

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Ivo van Doorn (11):
      rt2x00: Correct error in calculating rssi for link tuner
      rt2x00: Make *_beacon_update static
      rt2x00: Increase rt2x00usb_vendor_request timeout.
      rt2x00: Correctly identify rt2561turbo
      rt2x00: adapt to filter configuration API
      rt2x00: Reorganize rt2x00dev->flags
      rt2x00: Add rt2x00dev->flags to debugfs
      rt2x00: Stop link tuning when radio is down
      rt2x00: Fix obvious typo in comment
      rt2x00: Fix panic on rmmod with rfkill enabled
      rt2x00: Release rt2x00 2.0.9

Modestas Vainius (1):
      rt2x00: make rt2x00lib_stop_link_tuner() reentrant with link_tuner work

 drivers/net/wireless/rt2x00/rt2400pci.c    |  159 +++++++++++++-----------
 drivers/net/wireless/rt2x00/rt2500pci.c    |  171 ++++++++++++++------------
 drivers/net/wireless/rt2x00/rt2500usb.c    |  181 ++++++++++++++++------------
 drivers/net/wireless/rt2x00/rt2x00.h       |   70 ++++-------
 drivers/net/wireless/rt2x00/rt2x00config.c |   75 +-----------
 drivers/net/wireless/rt2x00/rt2x00debug.c  |   37 ++++++
 drivers/net/wireless/rt2x00/rt2x00dev.c    |  109 +++++++++++++-----
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    4 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c    |  155 ++++++++----------------
 drivers/net/wireless/rt2x00/rt2x00pci.c    |   31 ++---
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |   14 +--
 drivers/net/wireless/rt2x00/rt2x00ring.h   |   17 +++-
 drivers/net/wireless/rt2x00/rt2x00usb.c    |   26 ++---
 drivers/net/wireless/rt2x00/rt2x00usb.h    |    8 +-
 drivers/net/wireless/rt2x00/rt61pci.c      |  172 ++++++++++++++------------
 drivers/net/wireless/rt2x00/rt73usb.c      |  179 ++++++++++++++++------------
 drivers/net/wireless/rt2x00/rt73usb.h      |    2 +-
 17 files changed, 728 insertions(+), 682 deletions(-)
