Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:14955 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168AbXFCM1T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2007 08:27:19 -0400
Received: by ug-out-1314.google.com with SMTP id j3so529886ugf
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jun 2007 05:27:16 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Sun, 3 Jun 2007 14:25:21 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200706031425.21172.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the new rt2x00 release: 2.0.1
It contains many patches since the previous release.
It doesn't address any major bugs that have been
reported, but the code has been cleaned up.

The most notable change is the addition of rfkill support. :)

Ivo

---

The following changes since commit 2e6c9eed7541f3e2a23a469f08e5be3ec28a129f:
  James Ketrenos (1):
        Add iwlwifi wireless drivers

are available in the git repository at:

  git://git.serialmonkey.com/rt2x00.git/ upstream

Gertjan van Wingerde (8):
      rt2x00: Move rxd_size and txd_size fields.
      rt2x00: Update firmware loading interface.
      rt2x00: Initialisation cleanup.
      Move firmware loading code out of main rt2x00lib source file.
      Fix debug support.
      Let lowlevel driver decide on firmware names.
      rt2x00: Provide cleaner firmware loading interface to lowlevel driver.
      rt2x00: Deregister debugs at firmware loading failure.

Ivo van Doorn (34):
      rt2x00: Add rfkill support
      rt2x00: Use MODULE_FIRMWARE
      rt2x00: cosmetic - rename CONFIG_RT2X00_DEBUGFS
      rt2x00: Move crc-itu-t usage into rt2x00lib
      rt2x00: Remove channel_change_time usage
      rt2x00: Apply the 80 character line rule
      rt2x00: Prevent forward declaration of functions
      rt2x00: When toggling RX the link tuner should also be toggled
      rt2x00: Move generic link_tuner code into rt2x00lib
      rt2x00: Make rt2400 link tuner work like legacy driver
      rt2x00: Remove activity_led
      rt2x00: Make sure link tuning follows Legacy guidelines
      rt2x00: Use correct values for r24, r25 and r26
      rt2x00: Add EEPROM recovery data
      rt2x00: Correctly initialize rt73usb PHY_CSR1
      rt2x00: Use defines for chipset assignments
      rt2x00: Merge kick_beacon_gen and kick_tx_queue
      rt2x00: Merge radio control functions into 1 callback function
      rt2x00: Make promisc mode available to USB devices
      rt2x00: Make use of open / stop handlers
      rt2x00: Cleanup flag handling
      rt2x00: Use linux/bitops.h
      rt2x00: Add FIELD8 and matching handlers
      rt2x00: Move drv_name field into rt2x00_ops
      rt2x00: rt2x00lib is in charge of forcing promisc mode
      rt2x00: Make debug messages more informative
      rt2x00: Fix rt61 typo
      rt2x00: Move CONFIG_RT2X00_LIB_DEBUGFS ifdef out of rt2x00dev.c
      rt2x00: Reduce indentation for txpower handlers
      rt2x00: Define ARCSR2, ARCSR3, ARCSR4 and ARCSR5 registers
      rt2x00: Fix compilation errors for rt2x00-rfkill
      Merge branch 'wireless-dev'
      rt2x00: Merge LENGTH_LOW and LENGTH_HIGH
      rt2x00: Release rt2x00 2.0.1

 drivers/net/wireless/mac80211/rt2x00/Kconfig       |   33 +-
 drivers/net/wireless/mac80211/rt2x00/Makefile      |   10 +-
 drivers/net/wireless/mac80211/rt2x00/rt2400pci.c   |  401 +++++++------
 drivers/net/wireless/mac80211/rt2x00/rt2400pci.h   |   65 ++-
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.c   |  486 +++++++++-------
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.h   |   61 ++-
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.c   |  542 +++++++++++-------
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.h   |   29 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00.h      |  407 +++++++------
 drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c |   39 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h |   22 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c   |  264 ++++-----
 .../net/wireless/mac80211/rt2x00/rt2x00firmware.c  |  129 +++++
 .../net/wireless/mac80211/rt2x00/rt2x00firmware.h  |   49 ++
 drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h   |   15 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c   |  179 +++---
 drivers/net/wireless/mac80211/rt2x00/rt2x00pci.c   |   98 ++--
 .../net/wireless/mac80211/rt2x00/rt2x00rfkill.c    |  133 +++++
 .../net/wireless/mac80211/rt2x00/rt2x00rfkill.h    |   51 ++
 drivers/net/wireless/mac80211/rt2x00/rt2x00usb.c   |   76 ++--
 drivers/net/wireless/mac80211/rt2x00/rt61pci.c     |  601 ++++++++++++--------
 drivers/net/wireless/mac80211/rt2x00/rt61pci.h     |   33 +-
 drivers/net/wireless/mac80211/rt2x00/rt73usb.c     |  589 +++++++++++--------
 drivers/net/wireless/mac80211/rt2x00/rt73usb.h     |   33 +-
 24 files changed, 2589 insertions(+), 1756 deletions(-)
 create mode 100644 drivers/net/wireless/mac80211/rt2x00/rt2x00firmware.c
 create mode 100644 drivers/net/wireless/mac80211/rt2x00/rt2x00firmware.h
 create mode 100644 drivers/net/wireless/mac80211/rt2x00/rt2x00rfkill.c
 create mode 100644 drivers/net/wireless/mac80211/rt2x00/rt2x00rfkill.h
