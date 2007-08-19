Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22855 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbXHSSb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:31:58 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446949ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:31:57 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Sun, 19 Aug 2007 20:18:30 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192018.30624.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Well finally rt2x00 2.0.7 is released, unfortunately it will
not be the last release in the 2.0.* series as promised earlier.

This series contains lots of bugfixes, but some of the more
critical issues are still present. rt2x00 is however becoming
more usable for more people, so the progress is there. ;)

I'll do my best to make the next release 2.0.8 the last in the
2.0.* series so 2.1.0 can be moved upstream. :)

Ivo

---
The following changes since commit f5a420590f3f6a45ee5bca0048640f0f24852315:
  John W. Linville (1):
        Merge branch 'b43' into everything

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Ivo van Doorn (27):
      rt2x00: Correctly configure packet filter in monitor mode
      rt2x00: Clear MAC and BSSID when non-monitor interface goes down
      rt2x00: Check return value of usb_control_msg()
      rt2x00: Clear all fields on start_link_tune()
      rt2x00: Don't increase rx_failed for individual frames
      rt2x00: Set vgc_level during reset_tuner
      rt2x00: Schedule beacon update
      rt2x00: Be consistent with unsigned
      rt2x00: Correctly reset TX/RX success/failed counters
      rt2x00: Rework RF register handling
      rt2x00: rt2x00_ring_free returns invalid length
      rt2x00: Use caching for USB transfers
      rt2x00: Cleanup set_state for rt61 and rt73
      rt2x00: Fix register initialization ordering
      rt2x00: memset descriptor before use
      rt2x00: Remove IEEE80211_HW_WEP_INCLUDE_IV flag
      rt2x00: Cleanup TXD flags
      rt2x00: Add byte-ordering annotation for MAC and BSSID
      rt2x00: Correctly set TXD retry flag
      rt2x00: Move rt2x00 files into rt2x00 folder
      rt2x00: Add file pattern to MAINTAINER entry
      rt2x00: Fix PLCP setup
      rt2x00: Clean up RATEMASK handling
      rt2x00: Add rt2x00lib_reset_link_tuner()
      rt2x00: Always check if mac80211 requested TX status update
      rt2x00: Lindent
      rt2x00: rt2x00 2.0.7

Luca Tettamanti (1):
      Fix off-by-one error in debugfs helpers

Mattias Nissler (2):
      rt2x00: Fix width of filter field.
      rt2x00: Store firmware in memory

 MAINTAINERS                                        |    1 +
 drivers/net/wireless/Kconfig                       |  131 +------
 drivers/net/wireless/Makefile                      |   23 +-
 drivers/net/wireless/rt2x00/Kconfig                |  130 ++++++
 drivers/net/wireless/rt2x00/Makefile               |   22 +
 drivers/net/wireless/{ => rt2x00}/rt2400pci.c      |  149 ++++---
 drivers/net/wireless/{ => rt2x00}/rt2400pci.h      |    0 
 drivers/net/wireless/{ => rt2x00}/rt2500pci.c      |  409 ++++++++++--------
 drivers/net/wireless/{ => rt2x00}/rt2500pci.h      |    0 
 drivers/net/wireless/{ => rt2x00}/rt2500usb.c      |  382 +++++++++-------
 drivers/net/wireless/{ => rt2x00}/rt2500usb.h      |    0 
 drivers/net/wireless/{ => rt2x00}/rt2x00.h         |   56 ++-
 drivers/net/wireless/{ => rt2x00}/rt2x00config.c   |   14 +-
 drivers/net/wireless/{ => rt2x00}/rt2x00debug.c    |   23 +-
 drivers/net/wireless/{ => rt2x00}/rt2x00debug.h    |    0 
 drivers/net/wireless/{ => rt2x00}/rt2x00dev.c      |  221 ++++++----
 drivers/net/wireless/{ => rt2x00}/rt2x00firmware.c |   43 ++-
 drivers/net/wireless/{ => rt2x00}/rt2x00lib.h      |    5 +
 drivers/net/wireless/{ => rt2x00}/rt2x00mac.c      |   15 +-
 drivers/net/wireless/{ => rt2x00}/rt2x00pci.c      |    7 +-
 drivers/net/wireless/{ => rt2x00}/rt2x00pci.h      |    0 
 drivers/net/wireless/{ => rt2x00}/rt2x00reg.h      |   56 ++-
 drivers/net/wireless/{ => rt2x00}/rt2x00rfkill.c   |    0 
 drivers/net/wireless/{ => rt2x00}/rt2x00ring.h     |    6 +-
 drivers/net/wireless/{ => rt2x00}/rt2x00usb.c      |  114 ++++-
 drivers/net/wireless/{ => rt2x00}/rt2x00usb.h      |   60 +++-
 drivers/net/wireless/{ => rt2x00}/rt61pci.c        |  466 ++++++++------------
 drivers/net/wireless/{ => rt2x00}/rt61pci.h        |    0 
 drivers/net/wireless/{ => rt2x00}/rt73usb.c        |  471 +++++++++++---------
 drivers/net/wireless/{ => rt2x00}/rt73usb.h        |    0 
 30 files changed, 1532 insertions(+), 1272 deletions(-)
 create mode 100644 drivers/net/wireless/rt2x00/Kconfig
 create mode 100644 drivers/net/wireless/rt2x00/Makefile
 rename drivers/net/wireless/{ => rt2x00}/rt2400pci.c (94%)
 rename drivers/net/wireless/{ => rt2x00}/rt2400pci.h (100%)
 rename drivers/net/wireless/{ => rt2x00}/rt2500pci.c (84%)
 rename drivers/net/wireless/{ => rt2x00}/rt2500pci.h (100%)
 rename drivers/net/wireless/{ => rt2x00}/rt2500usb.c (81%)
 rename drivers/net/wireless/{ => rt2x00}/rt2500usb.h (100%)
 rename drivers/net/wireless/{ => rt2x00}/rt2x00.h (94%)
 rename drivers/net/wireless/{ => rt2x00}/rt2x00config.c (92%)
 rename drivers/net/wireless/{ => rt2x00}/rt2x00debug.c (94%)
 rename drivers/net/wireless/{ => rt2x00}/rt2x00debug.h (100%)
 rename drivers/net/wireless/{ => rt2x00}/rt2x00dev.c (85%)
 rename drivers/net/wireless/{ => rt2x00}/rt2x00firmware.c (84%)
 rename drivers/net/wireless/{ => rt2x00}/rt2x00lib.h (94%)
 rename drivers/net/wireless/{ => rt2x00}/rt2x00mac.c (97%)
 rename drivers/net/wireless/{ => rt2x00}/rt2x00pci.c (98%)
 rename drivers/net/wireless/{ => rt2x00}/rt2x00pci.h (100%)
 rename drivers/net/wireless/{ => rt2x00}/rt2x00reg.h (80%)
 rename drivers/net/wireless/{ => rt2x00}/rt2x00rfkill.c (100%)
 rename drivers/net/wireless/{ => rt2x00}/rt2x00ring.h (96%)
 rename drivers/net/wireless/{ => rt2x00}/rt2x00usb.c (85%)
 rename drivers/net/wireless/{ => rt2x00}/rt2x00usb.h (65%)
 rename drivers/net/wireless/{ => rt2x00}/rt61pci.c (89%)
 rename drivers/net/wireless/{ => rt2x00}/rt61pci.h (100%)
 rename drivers/net/wireless/{ => rt2x00}/rt73usb.c (82%)
 rename drivers/net/wireless/{ => rt2x00}/rt73usb.h (100%)
