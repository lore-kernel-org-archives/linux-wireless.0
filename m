Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1591 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754224Ab2HaRWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2012 13:22:20 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v2 0/6] GPIO related fixes and clean ups.
Date: Fri, 31 Aug 2012 19:22:08 +0200
Message-Id: <1346433734-3337-1-git-send-email-gwingerde@gmail.com> (sfid-20120831_192226_441093_9F76C40C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series mostly consists of GPIO related fixes and clean ups.
The patch series contains:
1. Moving the ASUS USB-N53 device ID from the set of unknown devices to the
   set of RT3572 devices.
2. A fix for rt2500usb to match the coded register width of the GPIO register
   with the actual register width.
3. A fix for the all rt2x00 drivers to correctly read the value of the rfkill
   switch at device startup. Previously we only could read that value properly
   after interface initialization time, which was too late, as the rfkill
   status would then prevent users to create an interface on the device.
   Special thanks go to Andreas Messer for reporting the issue and finding the
   root cause of the issue.
4. A patch aligning the GPIO register definitions with the various Ralink
   datasheets.
5. A patch cleaning up naming of GPIO register fields.
6. A clean-up of the rt2800 drivers, in which now more code is shared
   between rt2800pci and rt2800usb.

John, the first three patches are marked to be included in stable, so the
logical tree for them would be wireless. The last three patches are cleanups,
so they would be targetted at the wireless-next tree. Unfortunately, these
latter 3 patches depend on the first 3 in the series.
I'll leave it up to you to decide how that handle the series.

---
v1->v2:
- Refactored the patch series to ensure only the minimal fixes are targeted
  at the stable tree.
- Combined patches that logically belonged together in a single patch changing
  all rt2x00 drivers instead of having a separate patch for each rt2x00 driver.
- As a result of the above, the patch series now only consists of 6 patches
  instead of the previous 14.

---
Gertjan.

Gertjan van Wingerde (6):
  rt2x00: Identify ASUS USB-N53 device.
  rt2x00: Fix word size of rt2500usb MAC_CSR19 register.
  rt2x00: Fix rfkill polling prior to interface start.
  rt2x00: Align GPIO register definitions with the datasheets.
  rt2x00: Unify GPIO register field namings
  rt2x00: rt2800 - Make probe_hw function common between PCI and USB.

 drivers/net/wireless/rt2x00/rt2400pci.c |  11 ++-
 drivers/net/wireless/rt2x00/rt2400pci.h |  26 +++++--
 drivers/net/wireless/rt2x00/rt2500pci.c |  11 ++-
 drivers/net/wireless/rt2x00/rt2500pci.h |  18 +++--
 drivers/net/wireless/rt2x00/rt2500usb.c |  11 ++-
 drivers/net/wireless/rt2x00/rt2500usb.h |  26 +++++--
 drivers/net/wireless/rt2x00/rt2800.h    |  47 +++++++-----
 drivers/net/wireless/rt2x00/rt2800lib.c | 125 +++++++++++++++++++++++++-------
 drivers/net/wireless/rt2x00/rt2800lib.h |  14 +++-
 drivers/net/wireless/rt2x00/rt2800pci.c |  74 +------------------
 drivers/net/wireless/rt2x00/rt2800usb.c |  56 ++------------
 drivers/net/wireless/rt2x00/rt61pci.c   |  19 +++--
 drivers/net/wireless/rt2x00/rt61pci.h   |  27 +++----
 drivers/net/wireless/rt2x00/rt73usb.c   |  11 ++-
 drivers/net/wireless/rt2x00/rt73usb.h   |  31 ++++----
 15 files changed, 280 insertions(+), 227 deletions(-)

-- 
1.7.11.1

