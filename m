Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:28480 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbYAFWju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 17:39:50 -0500
Received: by ug-out-1314.google.com with SMTP id z38so3071045ugc.16
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 14:39:48 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Sun, 6 Jan 2008 23:37:35 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801062337.35904.IvDoorn@gmail.com> (sfid-20080106_224003_091189_B1D7D470)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the 2.0.14 release of rt2x00. Again lots of bugfixes,
and unfortunately we are still not there yet. I am afraid
rt2500usb and rt61pci are lost causes for the 2.6.24 release,
they are both broken, and I haven't figured out what is causing
this.

Next release will contain more interesting stuff, most of those
patches are already done, but due to testing and fine tuning I
have kept those patches back for this release. They primarily
cover basic support for virtual interfaces, led triggers, and some
first patches to make rt2x00lib support rt2800 (Yes, work on those
drivers has begun).

All indivual patches can also be found here:
http://kernel.org//pub/linux/kernel/people/ivd/rt2x00-2.0.14/

Ivo

---
The following changes since commit 2d0811f5ed506397d85792abfd8ef0983f4e8b7c:
  John W. Linville (1):
        fixup 'everything' after 'upstream-davem' rebase and patch modification

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Ivo van Doorn (12):
      rt2x00: Fix chipset debugfs file
      rt2x00: Always call ieee80211_stop_queue() when return NETDEV_TX_BUSY
      rt2x00: Only set the TBCN flag when the interface is configured to send beacons.
      rt2x00: Store queue idx and entry idx in data_ring and data_entry
      rt2x00: Move start() and stop() handlers into rt2x00lib.c
      rt2x00: Put 802.11 data on 4 byte boundary
      rt2x00: Move packet filter flags
      rt2x00: Cleanup write_tx_desc() arguments
      rt2x00: Determine MY_BSS from descriptor
      rt2x00: Move init_txring and init_rxring into rt2x00lib
      rt2x00: Correctly initialize data and desc pointer
      rt2x00: Release rt2x00 2.0.14

 drivers/net/wireless/rt2x00/rt2400pci.c   |  102 +++++++--------------
 drivers/net/wireless/rt2x00/rt2500pci.c   |   88 ++++++------------
 drivers/net/wireless/rt2x00/rt2500usb.c   |   36 +++++---
 drivers/net/wireless/rt2x00/rt2x00.h      |   32 ++++---
 drivers/net/wireless/rt2x00/rt2x00debug.c |   13 +--
 drivers/net/wireless/rt2x00/rt2x00dev.c   |  142 ++++++++++++++++++++++++-----
 drivers/net/wireless/rt2x00/rt2x00lib.h   |    4 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c   |   59 +++---------
 drivers/net/wireless/rt2x00/rt2x00pci.c   |   28 ++++--
 drivers/net/wireless/rt2x00/rt2x00ring.h  |   13 +++
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   87 ++++++++----------
 drivers/net/wireless/rt2x00/rt2x00usb.h   |    5 +-
 drivers/net/wireless/rt2x00/rt61pci.c     |  114 +++++++++---------------
 drivers/net/wireless/rt2x00/rt73usb.c     |   35 ++++---
 14 files changed, 378 insertions(+), 380 deletions(-)
