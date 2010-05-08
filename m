Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:2109 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285Ab0EHVkc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 17:40:32 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 0/9] rt2x00: Cleanups and fixes.
Date: Sat,  8 May 2010 23:40:17 +0200
Message-Id: <1273354826-4335-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some assorted cleanups and fixes for rt2x00.
First patch fixes the rt61pci security issues reported by Pavel Roskin.
The remaining patches clean up the code and work towards the final patch
which fixes beaconing on rt2800.

Gertjan van Wingerde (9):
  rt2x00: Fix setting of txdesc->length field.
  rt2x00: Clean up rt2800usb.h.
  rt2x00: Don't check whether hardware crypto is enabled when reading
    RXD.
  rt2x00: Factor out TXWI writing to common rt2800 code.
  rt2x00: Factor out RXWI processing to common rt2800 code.
  rt2x00: Clean up generic procedures on descriptor writing.
  rt2x00: Clean up all driver's kick_tx_queue callback functions.
  rt2x00: provide beacon's txdesc to write_beacon callback function.
  rt2x00: Fix beaconing on rt2800.

 drivers/net/wireless/rt2x00/rt2400pci.c    |   22 ++--
 drivers/net/wireless/rt2x00/rt2500pci.c    |   22 ++--
 drivers/net/wireless/rt2x00/rt2500usb.c    |   66 ++++------
 drivers/net/wireless/rt2x00/rt2800lib.c    |   98 +++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.h    |    3 +
 drivers/net/wireless/rt2x00/rt2800pci.c    |  166 ++++++--------------------
 drivers/net/wireless/rt2x00/rt2800usb.c    |  180 +++++++---------------------
 drivers/net/wireless/rt2x00/rt2800usb.h    |   40 ------
 drivers/net/wireless/rt2x00/rt2x00.h       |    3 +-
 drivers/net/wireless/rt2x00/rt2x00crypto.c |    1 +
 drivers/net/wireless/rt2x00/rt2x00queue.c  |   23 ++--
 drivers/net/wireless/rt2x00/rt61pci.c      |   41 +++----
 drivers/net/wireless/rt2x00/rt73usb.c      |   51 +++-----
 13 files changed, 280 insertions(+), 436 deletions(-)

