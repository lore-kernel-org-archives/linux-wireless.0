Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:56691 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757895Ab0BMT4G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 14:56:06 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 0/3] rt2x00: rt2800 detection improvements.
Date: Sat, 13 Feb 2010 20:55:46 +0100
Message-Id: <1266090949-5468-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some general rt2800 detection improvements. This make SOC a special
interface, and thus simplifying SOC detection a bit, and unifies
rt2800pci and rt2800usb further in detecting with what kind of 
rt2800 device we are dealing with.

Gertjan van Wingerde (3):
  rt2x00: Introduce SoC interface type.
  rt2x00: Reorganize RT chipset setting for PCI/SOC devices.
  rt2x00: rework RT chipset and revision determination for PCI an SOC
    devices.

 drivers/net/wireless/rt2x00/rt2400pci.c   |    4 +-
 drivers/net/wireless/rt2x00/rt2400pci.h   |    1 +
 drivers/net/wireless/rt2x00/rt2500pci.c   |    4 +-
 drivers/net/wireless/rt2x00/rt2500pci.h   |    1 +
 drivers/net/wireless/rt2x00/rt2500usb.c   |    4 +-
 drivers/net/wireless/rt2x00/rt2800.h      |   14 ++--
 drivers/net/wireless/rt2x00/rt2800lib.c   |  115 +++++++++++++++++------------
 drivers/net/wireless/rt2x00/rt2800pci.c   |   29 +++-----
 drivers/net/wireless/rt2x00/rt2800usb.c   |   20 ++---
 drivers/net/wireless/rt2x00/rt2x00.h      |   66 +++++++----------
 drivers/net/wireless/rt2x00/rt2x00debug.c |    4 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c   |    7 --
 drivers/net/wireless/rt2x00/rt2x00pci.h   |    1 +
 drivers/net/wireless/rt2x00/rt2x00soc.c   |   11 +--
 drivers/net/wireless/rt2x00/rt2x00soc.h   |   10 +--
 drivers/net/wireless/rt2x00/rt61pci.c     |   14 ++--
 drivers/net/wireless/rt2x00/rt61pci.h     |    9 ++
 drivers/net/wireless/rt2x00/rt73usb.c     |    7 +-
 drivers/net/wireless/rt2x00/rt73usb.h     |    2 +
 19 files changed, 156 insertions(+), 167 deletions(-)

