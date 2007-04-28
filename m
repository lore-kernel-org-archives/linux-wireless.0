Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:62141 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbXD1UrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 16:47:08 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1031330uga
        for <linux-wireless@vger.kernel.org>; Sat, 28 Apr 2007 13:47:06 -0700 (PDT)
To: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Please pull 'upstream' branch of rt2x00
Date: Sat, 28 Apr 2007 22:45:54 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200704282245.54394.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

A new update of rt2x00 is ready. :)

Perhaps the most interesting thing would be the removal
of passive scan support, because it was a purely software based
solution that (if really required) could best be resolved in mac80211
rather then the driver for devices that don't support such a thing in the
hardware.
The rest is just code being moved around, (more specifically code being moved
from the drivers toward rt2x00lib/pci/usb. There aren't any specific bugfixes made.

Ivo

---

The following changes since commit 9e4fd17309d0acddd1748c76f6bd35a0c85446b6:
  Johannes Berg (1):
        clarify locking comment in cfg80211

are found in the git repository at:

  http://git.serialmonkey.com/rt2x00.git/ upstream

Ivo van Doorn (38):
      rt2x00: Move beaconhandling into rt2x00{usb,pci} modules
      rt2x00: Fix rt2x00pci, rt2x00usb, rt2x00mac module/debug enviroment
      rt2x00: Move common rxdone and txdone code into rt2x00lib
      rt2x00: Set rf_base during channel configuration
      rt2x00: Move initialize() and uninitialize() into rt2x00pci/rt2x00usb
      rt2x00: Fix spellin error
      rt2x00: Move ieee80211_hw init & registration into rt2x00lib
      rt2x00: Fix hardware mode registration order
      rt2x00: Add struct debugsfs pointer to rt2x00dev
      rt2x00: Fix debugfs related compile problem
      rt2x00: Explicit return type for rt2x00debug_register
      rt2x00: Fix sparse errors
      rt2x00: Move alloc_rings into rt2x00lib
      rt2x00: Move device allocation into rt2x00lib
      rt2x00: Make rt2x00debug const
      rt2x00: Minor fixes (comment & headers)
      rt2x00: Create rt2x00_ops structure
      rt2x00: rt2x00pci shouldn't use DRV_NAME for irq registration
      rt2x00: Rename rt(25)73 identifications
      rt2x00: Move PCI/USB handlers into rt2x00pci/usb modules
      rt2x00: Fix hw mode registration
      rt2x00: Fix NULL pointer exeption during init_hw
      rt2x00: Fix sparse warnings
      rt2x00: Fix ERROR strings
      rt2x00: Move rf values outside functions
      rt2x00: Allocate enough rings
      rt2x00: Move write_tx_data functions into rt2x00pci/usb
      rt2x00: Fix compilation error when not selecting rt61pci and rt73usb
      rt2x00: Add return statement to rt2x00lib_alloc_dev
      rt2x00: Create dummy rt2x00lib_firmware_load_wait()
      rt2x00: Move write_tx_desc initialization into rt2x00lib
      rt2x00: Remove ENTRY_RTS_CTS_FRAME flag
      rt2x00: Fix check for Acked frames
      Merge branch 'wireless-dev'
      rt2x00: Remove passive scanning support
      rt2x00: Set channel_change_time to 0
      rt2x00: Move USB txdone handler into rt2x00usb
      rt2x00: rt61 should call ieee80211_wake_queue only for correct queues

 drivers/net/wireless/mac80211/rt2x00/Makefile      |    2 +
 drivers/net/wireless/mac80211/rt2x00/rt2400pci.c   | 1303 +++------------
 drivers/net/wireless/mac80211/rt2x00/rt2400pci.h   |    9 +-
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.c   | 1496 ++++--------------
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.h   |    7 -
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.c   | 1448 +++--------------
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.h   |    2 -
 drivers/net/wireless/mac80211/rt2x00/rt2x00.h      |  165 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c |   27 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h |    7 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c   |  689 +++++++-
 drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h   |   70 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c   |  166 +--
 drivers/net/wireless/mac80211/rt2x00/rt2x00pci.c   |  587 +++++++
 drivers/net/wireless/mac80211/rt2x00/rt2x00pci.h   |   50 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00usb.c   |  637 +++++++
 drivers/net/wireless/mac80211/rt2x00/rt2x00usb.h   |   44 +-
 drivers/net/wireless/mac80211/rt2x00/rt61pci.c     | 1731 ++++---------------
 drivers/net/wireless/mac80211/rt2x00/rt61pci.h     |    7 -
 drivers/net/wireless/mac80211/rt2x00/rt73usb.c     | 1597 ++++---------------
 drivers/net/wireless/mac80211/rt2x00/rt73usb.h     |    4 +-
 21 files changed, 3553 insertions(+), 6495 deletions(-)
 create mode 100644 drivers/net/wireless/mac80211/rt2x00/rt2x00pci.c
 create mode 100644 drivers/net/wireless/mac80211/rt2x00/rt2x00usb.c
