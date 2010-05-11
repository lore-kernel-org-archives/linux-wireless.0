Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:2293 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752889Ab0EKVvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 17:51:53 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 0/9] rt2x00: Further fixes and cleanups.
Date: Tue, 11 May 2010 23:51:36 +0200
Message-Id: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another set of rt2x00 fixes and cleanups.
Most of the patches are working towards a nice cleanup in which rt2x00 starts
properly reserving room in skbs for descriptors instead of fiddling with
pointers.
Also one fix for rt61pci that no-one ever hit, whereby, for beacons, rt61pci
wrote part of the tx descriptor out-of-bounds.

These patches can also be pulled from:
	git://git.gwingerde.nl/rt2x00-next-2.6.git

Gertjan van Wingerde (9):
  rt2x00: Consistently name skb frame descriptor skbdesc.
  rt2x00: Fix beacon descriptor writing for rt61pci.
  rt2x00: Re-order tx descriptor writing code in drivers.
  rt2x00: Simplify TXD handling of beacons.
  rt2x00: Dump beacons under a different identifier than TX frames.
  rt2x00: Push beacon TX descriptor writing to drivers.
  rt2x00: In debugfs frame dumping allow the TX descriptor to be part
    of the skb.
  rt2x00: Reverse calling order of bus write_tx_desc and driver
    write_tx_desc.
  rt2x00: Properly reserve room for descriptors in skbs.

 drivers/net/wireless/rt2x00/rt2400pci.c   |   42 ++++++++------
 drivers/net/wireless/rt2x00/rt2500pci.c   |   42 ++++++++------
 drivers/net/wireless/rt2x00/rt2500usb.c   |   68 ++++++++++++++---------
 drivers/net/wireless/rt2x00/rt2800lib.c   |    3 +-
 drivers/net/wireless/rt2x00/rt2800lib.h   |    2 +-
 drivers/net/wireless/rt2x00/rt2800pci.c   |   59 +++++++++++++-------
 drivers/net/wireless/rt2x00/rt2800usb.c   |   35 +++++++++++--
 drivers/net/wireless/rt2x00/rt2x00.h      |    9 +++
 drivers/net/wireless/rt2x00/rt2x00debug.c |   22 +++++---
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    5 --
 drivers/net/wireless/rt2x00/rt2x00dump.h  |    3 +
 drivers/net/wireless/rt2x00/rt2x00lib.h   |    7 ---
 drivers/net/wireless/rt2x00/rt2x00pci.c   |   49 +++++++++++++++--
 drivers/net/wireless/rt2x00/rt2x00pci.h   |    8 +++
 drivers/net/wireless/rt2x00/rt2x00queue.c |   39 +-------------
 drivers/net/wireless/rt2x00/rt2x00queue.h |    3 +
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   19 +++----
 drivers/net/wireless/rt2x00/rt61pci.c     |   50 ++++++++++++-----
 drivers/net/wireless/rt2x00/rt73usb.c     |   84 +++++++++++++++++------------
 19 files changed, 338 insertions(+), 211 deletions(-)

