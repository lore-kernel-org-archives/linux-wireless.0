Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:53844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbYCIVui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:50:38 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1676623fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:50:37 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Sun, 9 Mar 2008 22:37:43 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092237.43451.IvDoorn@gmail.com> (sfid-20080309_215043_636444_16618327)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the latest version of rt2x00: 2.1.4

All drivers are now showing excellent progress, rt2400pci, rt2500pci, rt61pci and rt73usb
seem to be working as expected now. And only rt2500usb is spoiling things by having
only a working RX but no TX.

After this patch series, it is highly likely you can close a lot of rt2x00 related bugs
in the Fedora bugzilla. :)
Ivo

---
The following changes since commit 4f739cf30891f277a6353d61275489528fab64e3:
  Pavel Roskin (1):
        at76_usb: make the driver depend on MAC80211

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Adam Baker (2):
      rt2x00: never disable multicast because it disables broadcast too
      rt2x00:correct rx packet length for USB devices

Ivo van Doorn (18):
      rt2x00: Align RX descriptor to 4 bytes
      rt2x00: Don't use uninitialized desc_len
      rt2x00: Use skbdesc fields for descriptor initialization
      rt2x00: Add new D-Link USB ID
      rt2x00: Only disable beaconing just before beacon update
      rt2x00: Upgrade queue->lock to use irqsave
      rt2x00: Move firmware checksumming to driver
      rt2x00: Start bugging when rt2x00lib doesn't filter SW diversity
      rt2x00: Check IEEE80211_TXCTL_SEND_AFTER_DTIM flag
      rt2x00: Rename config_preamble() to config_erp()
      rt2x00: Add suspend/resume handlers to rt2x00rfkill
      rt2x00: Make rt2x00leds_register return void
      rt2x00: Always enable TSF ticking
      rt2x00: Fix basic rate initialization
      rt2x00: Fix compile error when rfkill is disabled
      rt2x00: Fix RX DMA ring initialization
      rt2x00: Fix rt2400pci signal
      rt2x00: Release rt2x00 2.1.4

Luis Correia (1):
      rt2x00: Fix trivial log message

Mattias Nissler (3):
      rt2x00: Initialize TX control field in data entries
      rt2x00: Use the correct size when copying the control info in txdone
      rt2x00: Don't use unitialized rxdesc->size

 drivers/net/wireless/rt2x00/Kconfig          |    4 +-
 drivers/net/wireless/rt2x00/rt2400pci.c      |   67 +++++++------
 drivers/net/wireless/rt2x00/rt2400pci.h      |    6 +-
 drivers/net/wireless/rt2x00/rt2500pci.c      |   71 ++++++++------
 drivers/net/wireless/rt2x00/rt2500usb.c      |   97 ++++++++++---------
 drivers/net/wireless/rt2x00/rt2x00.h         |   31 ++++--
 drivers/net/wireless/rt2x00/rt2x00config.c   |   62 +++++++-----
 drivers/net/wireless/rt2x00/rt2x00debug.c    |    5 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c      |  108 +++++++++------------
 drivers/net/wireless/rt2x00/rt2x00firmware.c |   34 +-------
 drivers/net/wireless/rt2x00/rt2x00leds.c     |    7 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h      |   45 ++++-----
 drivers/net/wireless/rt2x00/rt2x00mac.c      |   22 +++--
 drivers/net/wireless/rt2x00/rt2x00pci.c      |    1 +
 drivers/net/wireless/rt2x00/rt2x00queue.c    |   17 ++-
 drivers/net/wireless/rt2x00/rt2x00queue.h    |    3 +
 drivers/net/wireless/rt2x00/rt2x00rfkill.c   |  116 +++++++++++++++--------
 drivers/net/wireless/rt2x00/rt2x00usb.c      |   19 ++++-
 drivers/net/wireless/rt2x00/rt61pci.c        |  104 ++++++++++++--------
 drivers/net/wireless/rt2x00/rt73usb.c        |  131 +++++++++++++++-----------
 20 files changed, 524 insertions(+), 426 deletions(-)
