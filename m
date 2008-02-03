Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.250]:10585 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755481AbYBCOqj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:46:39 -0500
Received: by hs-out-2122.google.com with SMTP id 54so1606484hsz.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:46:38 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Sun, 3 Feb 2008 15:41:51 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031541.52167.IvDoorn@gmail.com> (sfid-20080203_144643_921420_1049209B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the 2.1.0 release of rt2x00.
The most important changes in this release:
 - Queue handling overhaul
 - Multiple virtual AP interfaces support for rt61 and rt73
 - LED class support
 - Adhoc & master mode enabled

Note that this patch series is _not_ intended for 2.6.25,
a lot might still be broken because the code has changed so much.
Adhoc and master mode is only enabled for testing purposes, in no way
it means that it is working for all drivers...

With these changes adding support for rt2800pci and rt2800usb will
be easier as well. Hopefully I can soon provide an initial version for
those 2 drivers as well.

All indivual patches can also be found here:
http://kernel.org//pub/linux/kernel/people/ivd/rt2x00-2.1.0/

Ivo

---

The following changes since commit e0e6138382c56aa99a1aabe5dddddbb332b5a4f8:
  Stefano Brivio (1):
        rc80211-pid: fix rate adjustment

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Adam Baker (1):
      rt2x00: don't write past the end when writing short descriptors on rt61

Ivo van Doorn (18):
      rt2x00: Update copyright notice
      rt2x00: Queue handling overhaul
      rt2x00: Add new USB ID to rt2500usb
      rt2x00: Fix tx parameter initialization
      rt2x00: Enable master and adhoc mode again
      rt2x00: Driver requiring firmware should select crc algo
      rt2x00: Add per-interface structure
      rt2x00: Rate structure overhaul
      rt2x00: Remove HWMODE_{A,B,G}
      rt2x00: Remove TX_MGMT queue usage
      rt2x00: Initialize QID from queue->qid
      rt2x00: Use ieee80211_channel_to_frequency()
      rt2x00: Make use of MAC80211_LED_TRIGGERS
      rt2x00: Enable LED class support for rt2500usb/rt73usb
      rt2x00: Fix rate initialization
      rt2x00: Move beacon and atim queue defines into rt2x00
      rt2x00: Fix queue index handling
      rt2x00: Release rt2x00 2.1.0

 drivers/net/wireless/rt2x00/Kconfig          |   43 ++
 drivers/net/wireless/rt2x00/Makefile         |    6 +-
 drivers/net/wireless/rt2x00/rt2400pci.c      |  431 +++++++++------
 drivers/net/wireless/rt2x00/rt2400pci.h      |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c      |  436 +++++++++------
 drivers/net/wireless/rt2x00/rt2500pci.h      |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c      |  497 ++++++++++--------
 drivers/net/wireless/rt2x00/rt2500usb.h      |    5 +-
 drivers/net/wireless/rt2x00/rt2x00.h         |  288 ++++++-----
 drivers/net/wireless/rt2x00/rt2x00config.c   |  140 +++---
 drivers/net/wireless/rt2x00/rt2x00debug.c    |   34 +-
 drivers/net/wireless/rt2x00/rt2x00debug.h    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c      |  756 +++++++++++---------------
 drivers/net/wireless/rt2x00/rt2x00dump.h     |    8 +-
 drivers/net/wireless/rt2x00/rt2x00firmware.c |   43 ++-
 drivers/net/wireless/rt2x00/rt2x00leds.c     |  217 ++++++++
 drivers/net/wireless/rt2x00/rt2x00leds.h     |   63 +++
 drivers/net/wireless/rt2x00/rt2x00lib.h      |  100 ++++-
 drivers/net/wireless/rt2x00/rt2x00mac.c      |  221 +++++---
 drivers/net/wireless/rt2x00/rt2x00pci.c      |  238 ++++-----
 drivers/net/wireless/rt2x00/rt2x00pci.h      |   57 ++-
 drivers/net/wireless/rt2x00/rt2x00queue.c    |  295 ++++++++++
 drivers/net/wireless/rt2x00/rt2x00queue.h    |  447 +++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00reg.h      |   75 +---
 drivers/net/wireless/rt2x00/rt2x00rfkill.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00ring.h     |  290 ----------
 drivers/net/wireless/rt2x00/rt2x00usb.c      |  345 ++++++++-----
 drivers/net/wireless/rt2x00/rt2x00usb.h      |  179 +++++--
 drivers/net/wireless/rt2x00/rt61pci.c        |  601 +++++++++++----------
 drivers/net/wireless/rt2x00/rt61pci.h        |   21 +-
 drivers/net/wireless/rt2x00/rt73usb.c        |  468 +++++++++-------
 drivers/net/wireless/rt2x00/rt73usb.h        |   20 +-
 32 files changed, 3831 insertions(+), 2501 deletions(-)
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00leds.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00leds.h
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00queue.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00queue.h
 delete mode 100644 drivers/net/wireless/rt2x00/rt2x00ring.h
