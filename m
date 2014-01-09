Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38860 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbaAIXQH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 18:16:07 -0500
Date: Fri, 10 Jan 2014 00:15:46 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [GIT] [3.14] NFC update
Message-ID: <20140109231546.GA11700@zurbaran> (sfid-20140110_001611_250970_91AC03DB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the first NFC pull request for 3.14

It includes:

* A new NFC driver for Marvell's 8897, and a few NCI fixes and
  improvements needed to support this chipset.

* An LLCP fix for how we were setting the default MIU on a p2p link. If
  there is no explicit MIU extension announced at connection time, we
  must use the default one and not the one announced at LLCP link
  establishement time.

* A pn544 EEPROM config update. Some of the currently EEPROM configured
  values are overwriting the firmware ones while other should not be set
  by the driver itself.

* Some NFC digital stack fixes and improvements. Asynchronous functions
  are better documented, RF technologies and CRC functions are set upon
  PSL_REQ reception, and a few minor bugs are fixed.

* Minor and miscelaneous pn533, mei_phy and port100 fixes.

Thanks in advance for pulling those bits in.

The following changes since commit c8bf40ad4f8f5d26f6744020ad51be420a707385:

  wireless: delete non-required instances of include <linux/init.h> (2014-01-03 15:37:01 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.14-1

for you to fetch changes up to bb55dc2ae4367b8f711d43a2f8668a6ed42c4fd3:

  NFC: nfcmrvl: Fix possible memory leak issue (2014-01-09 01:27:20 +0100)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      NFC: port100: Fix device leak

Amitkumar Karwar (7):
      NFC: NCI: Cancel cmd_timer in nci_close_device()
      NFC: NCI: Don't reverse local general bytes
      NFC: NCI: Add setup handler
      NFC: NCI: Add set_config API
      NFC: nfcmrvl: Initial commit for Marvell NFC driver
      NFC: nfcmrvl: Add setup handler
      NFC: nfcmrvl: Fix possible memory leak issue

Arman Uguray (1):
      NFC: pn544: Refactor hw_config values

Salil Kapur (1):
      NFC: mei_phy: Using kfree_skb() instead of kfree()

Samuel Ortiz (3):
      NFC: Return driver failure upon unknown event reception
      NFC: Only warn on SE discovery error
      NFC: pn533: Frame is invalid if ccid.datalen is 0

Szymon Janc (2):
      NFC: llcp: Fix possible memory leak while sending I frames
      NFC: llcp: Use default MIU if none was specified on connect

Thierry Escande (5):
      NFC: digital: Add a note about asynchronous functions
      NFC: digital: Fix incorrect use of ERR_PTR and PTR_ERR macros
      NFC: digital: Use NFC_NFCID3_MAXSIZE from nfc.h
      NFC: digital: Set current target active on activate_target() call
      NFC: digital: Set rf tech and crc functions when receiving a PSL_REQ

 drivers/nfc/Kconfig           |   1 +
 drivers/nfc/Makefile          |   1 +
 drivers/nfc/mei_phy.c         |   2 +-
 drivers/nfc/nfcmrvl/Kconfig   |  23 +++
 drivers/nfc/nfcmrvl/Makefile  |   9 +
 drivers/nfc/nfcmrvl/main.c    | 165 +++++++++++++++
 drivers/nfc/nfcmrvl/nfcmrvl.h |  48 +++++
 drivers/nfc/nfcmrvl/usb.c     | 459 ++++++++++++++++++++++++++++++++++++++++++
 drivers/nfc/pn533.c           |   3 +
 drivers/nfc/pn544/pn544.c     |  48 ++---
 drivers/nfc/port100.c         |   1 +
 include/net/nfc/digital.h     |  10 +
 include/net/nfc/nci_core.h    |   2 +
 net/nfc/core.c                |   7 +-
 net/nfc/digital_core.c        |  28 ++-
 net/nfc/digital_dep.c         |  54 +++--
 net/nfc/hci/core.c            |   7 +-
 net/nfc/llcp_commands.c       |   6 +-
 net/nfc/llcp_core.c           |   1 -
 net/nfc/llcp_sock.c           |   1 -
 net/nfc/nci/core.c            |  27 ++-
 21 files changed, 838 insertions(+), 65 deletions(-)
 create mode 100644 drivers/nfc/nfcmrvl/Kconfig
 create mode 100644 drivers/nfc/nfcmrvl/Makefile
 create mode 100644 drivers/nfc/nfcmrvl/main.c
 create mode 100644 drivers/nfc/nfcmrvl/nfcmrvl.h
 create mode 100644 drivers/nfc/nfcmrvl/usb.c
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
