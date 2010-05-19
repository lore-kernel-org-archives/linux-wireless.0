Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:3797 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751883Ab0ESP0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 11:26:14 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 0/7] rt2x00: Further cleanups and fixes.
Date: Wed, 19 May 2010 17:26:02 +0200
Message-Id: <1274282769-19244-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The next set up cleanups and fixes for rt2x00. Highlights of the patch
series include:
    - Fixes to the HT40 operation of rt2x00. This works now!!
    - Cleanup of rt2800lib.c. Now no bus details (USB or PCI specifics) are
      part of rt2800lib.c anymore.
    - Further preparations for the inclusion of support for RT3572 devices.

Patches are on top of all the previous patch series I sent out, and are
relative to wireless-next-2.6.

There are no critical bug-fixes in here that need to be merged into 2.6.35.


Gertjan van Wingerde (7):
  rt2x00: Remove RT2870 chipset identification.
  rt2x00: Move all register definitions for rt2800 to rt2800.h.
  rt2x00: Introduce separate interface type for PCI-express.
  rt2x00: Simplify check for external LNA in rt2800_init_rfcsr.
  rt2x00: Move PCI/USB specific register initializations to rt2800{pci,usb}.
  rt2x00: Sync rt2800 MCU boot signal with Ralink driver.
  rt2x00: Fix HT40 operation in rt2800.

 drivers/net/wireless/rt2x00/rt2800.h       |   49 +++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2800lib.c    |   80 ++++------------------------
 drivers/net/wireless/rt2x00/rt2800lib.h    |    9 +++
 drivers/net/wireless/rt2x00/rt2800pci.c    |   36 ++++++++++++-
 drivers/net/wireless/rt2x00/rt2800pci.h    |   19 -------
 drivers/net/wireless/rt2x00/rt2800usb.c    |   42 ++++++++++++++-
 drivers/net/wireless/rt2x00/rt2800usb.h    |   37 -------------
 drivers/net/wireless/rt2x00/rt2x00.h       |   12 +++-
 drivers/net/wireless/rt2x00/rt2x00config.c |   12 +++--
 drivers/net/wireless/rt2x00/rt2x00ht.c     |   27 +++++++++
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    9 +++
 drivers/net/wireless/rt2x00/rt2x00pci.c    |    5 ++-
 12 files changed, 200 insertions(+), 137 deletions(-)

