Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:2025 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875Ab2H3Tkf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 15:40:35 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 00/14] rt2x00: Fixes and cleanups.
Date: Thu, 30 Aug 2012 21:33:59 +0200
Message-Id: <1346355248-5331-1-git-send-email-gwingerde@gmail.com> (sfid-20120830_214042_496264_53A21288)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains:
1. Moving the ASUS USB-N53 device ID from the set of unknown devices to the
   set of RT3572 devices.
2. A large set of fixes for the various rt2x00 drivers to fix the issue that
   the value of the rfkill switch wasn't read properly at device startup,
   preventing users to create an interface on the device and start that
   interface.
   Thanks to Andreas Messer for reporting the issue and
   finding the root cause of the issue.
3. A clean-up of the rt2800 drivers, in which now more code is shared
   between rt2800pci and rt2800usb.

John, all but the last patches are marked to be included in stable as well,
so the logical tree would be wireless for them. The last patch is a
cleanup, however, which would be targetted at wireless-next. Unfortunately,
that patch depends on the first 13 in the series.
I'll leave it up to you to decide how that handle the series.

---
Gertjan.

Gertjan van Wingerde (14):
  rt2x00: Identify ASUS USB-N53 device.
  rt2x00: Align rt2400pci GPIOCSR definition with datasheet.
  rt2x00: Fix rt2400pci rfkill polling prior to interface start.
  rt2x00: Align rt2500pci GPIOCSR definition with datasheet.
  rt2x00: Fix rt2500pci rfkill polling prior to interface start.
  rt2x00: Align rt2500usb MAC_CSR19 definition with datasheet.
  rt2x00: Fix rt2500usb rfkill polling prior to interface start.
  rt2x00: Align rt61pci MAC_CSR13 definition with datasheet.
  rt2x00: Fix rt61pci rfkill polling prior to interface start.
  rt2x00: Align rt73usb MAC_CSR13 definition with datasheet.
  rt2x00: Fix rt73usb rfkill polling prior to interface start.
  rt2x00: Align rt2800 GPIO_CTRL definition with datasheet.
  rt2x00: Fix rt2800 rfkill polling prior to interface start.
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

