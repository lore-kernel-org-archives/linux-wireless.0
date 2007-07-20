Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:1989 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762280AbXGTIJS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 04:09:18 -0400
Received: by ug-out-1314.google.com with SMTP id j3so571111ugf
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jul 2007 01:09:17 -0700 (PDT)
To: "John Linville" <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Fri, 20 Jul 2007 10:11:13 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707201011.13156.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Finally the 2.0.3 release of rt2x00 is here :)

And as promised since actually contains bugfixes
The hightlights are a working link tuner which finally
makes sure all drivers come close to being actually
useable.

Also a small change in statistics, rt2x00 will now only report the RSSI to mac80211.
The reporting of Noise values have been removed,
since rt2x00 cannot measure the noise and previously
reported the sensitivity value determined by the link_tuner.
And I am not completely sure if that is a desired behavior, since the preference
would be a measured value I guess.

Also I still have to determine what a good value for the Signal reporting
should be. With only a RSSI reporting I feel rt2x00 isn't reporting all that it can...

Ivo

---

The following changes since commit a7008e4ecc4ec69a9868105ce7f805a6ab486d69:
  Johannes Berg (1):
        mac80211: regdomain.c needs to include ieee80211_i.h

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ master

Adam Baker (1):
      rt2x00: Set Maximum sensitivity when not receiving

Ivo van Doorn (42):
      rt2x00: Remove usage of open and stop callbacks
      rt2x00: Fix rfkill compilation
      rt2x00: rfkill should use input_poll device
      rt2x00: Fix promisc mode check
      rt2x00: Put debugfs_intf inbetween DEBUGFS defines
      rt2x00: Cleanup debug messages
      rt2x00: Remove ENTRY_TXD_NEW_SEQ flag
      rt2x00: Remove DRV_NAME define from rt2x00.h
      rt2x00: Remove device & mac_addr fields
      rt2x00: Use the mac80211 provided workqueue
      rt2x00: Don't wake device on resume
      rt2x00: Move interrupt toggling into seperate function
      rt2x00: Round LINK_TUNER_INTERVAL up
      rt2x00: Set the IEEE80211_HW_NO_PROBE_FILTERING flag
      rt2x00: Add rt2570 chipset revisions
      rt2x00: Split TXD_ENTRY_AVAILABLE
      rt2x00: rt61 should check the CIPHER_ERROR bit
      rt2x00: Fix reporting false rate during rx
      rt2x00: Correctly exit the firmware load function
      rt2x00: Fix link tuner limitation for rt2400pci
      rt2x00: Cleanup Kconfig dependencies and selects
      rt2x00: Defer firmware loading untill ifup
      rt2x00: Change register definition ordering
      rt2x00: Correctly initialize PSCSR2 in rt2400.
      rt2x00: Introduce the walking average
      rt2x00: Remove noise reporting
      rt2x00: Fix RSSI value reading / reporting / link tuning
      rt2x00: Use prefetch for ring loop
      rt2x00: Use the register field defines
      rt2x00: Move initialization of rings into rt2x00usb
      rt2x00: Move usb_interrupt_rxdone into rt2x00usb
      rt2x00: Fix RX skb allocation
      rt2x00: KConfig layout correction
      rt2x00: Set DEVICE_ENABLED_RADIO_HW when rfkill is disabled
      rt2x00: Change word argument for debug_access_t
      rt2x00: Suspend/Resume Don't register/reregister device
      Merge branch 'wireless-dev'
      rt2x00: Fix CTS frame requirement detection
      rt2x00: Don't cut FCS in RX frames
      rt2x00: Use delayed_work_pending
      rt2x00: Don't enable/disable link tuner twice
      rt2x00: Release 2.0.3

 drivers/net/wireless/mac80211/rt2x00/Kconfig       |   91 ++++----
 drivers/net/wireless/mac80211/rt2x00/rt2400pci.c   |  167 ++++++-------
 drivers/net/wireless/mac80211/rt2x00/rt2400pci.h   |   45 ++--
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.c   |  191 +++++++-------
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.h   |   54 +++--
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.c   |  176 ++++---------
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.h   |   61 +++--
 drivers/net/wireless/mac80211/rt2x00/rt2x00.h      |  141 +++++++----
 drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h |    2 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c   |   86 +------
 .../net/wireless/mac80211/rt2x00/rt2x00firmware.c  |   77 ++----
 .../net/wireless/mac80211/rt2x00/rt2x00firmware.h  |    6 -
 drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h   |    7 -
 drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c   |  131 ++++------
 drivers/net/wireless/mac80211/rt2x00/rt2x00pci.c   |   52 ++++-
 drivers/net/wireless/mac80211/rt2x00/rt2x00pci.h   |   16 +-
 .../net/wireless/mac80211/rt2x00/rt2x00rfkill.c    |   62 +++--
 .../net/wireless/mac80211/rt2x00/rt2x00rfkill.h    |    7 +
 drivers/net/wireless/mac80211/rt2x00/rt2x00usb.c   |  156 +++++++++---
 drivers/net/wireless/mac80211/rt2x00/rt61pci.c     |  264 +++++++++++++-------
 drivers/net/wireless/mac80211/rt2x00/rt61pci.h     |   77 ++++--
 drivers/net/wireless/mac80211/rt2x00/rt73usb.c     |  242 ++++++++++---------
 drivers/net/wireless/mac80211/rt2x00/rt73usb.h     |   81 ++++---
 23 files changed, 1166 insertions(+), 1026 deletions(-)
