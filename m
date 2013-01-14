Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14104 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497Ab3ANSXL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 13:23:11 -0500
Date: Mon, 14 Jan 2013 19:23:08 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@lists.01.org>
Subject: [GIT] [3.9] NFC pull request
Message-ID: <20130114182308.GA5539@sortiz-mobl> (sfid-20130114_192315_993443_D87A0ECD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the first NFC pull request for 3.9.

It brings the following goodies:

- LLCP socket timestamping (To be used e.g with the recently released nfctool
  application for a more efficient skb timestamping when sniffing).
- A pretty big pn533 rework from Waldemar, preparing the driver to support
  more flavours of pn533 based devices.
- HCI changes from Eric in preparation for the microread driver support.
- Some LLCP memory leak fixes, cleanups and slight improvements.
- pn544 and nfcwilink move to the devm_kzalloc API.
- An initial Secure Element (SE) API.
- An nfc.h license change from the original author, allowing non GPL
  application code to safely include it.

Thanks in advance for pulling them in.


The following changes since commit e7f767a7d9f809c494bfffffeda2bbdbfec110b4:

  mwifiex: use map/unmap APIs in TX and RX to reduce memcpy (2013-01-07 15:18:30 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.9-1

for you to fetch changes up to d3710e74cf329839dea8d13b1ad56e572b06b173:

  NFC: Change nfc.h license (2013-01-14 12:28:54 +0100)

----------------------------------------------------------------
Eric Lapuyade (6):
      NFC: Fixed nfc core and hci unregistration and cleanup
      NFC: Added error handling in event_received hci ops
      NFC: Changed event_received hci ops result semantic
      NFC: Fixed skb leak in tm_send() nfc and hci ops implementations
      NFC: Add HCI quirks to support driver (non)standard implementations
      NFC: update HCI documentation

Julia Lawall (1):
      NFC: nfcwilink: Use devm_kzalloc

Lauro Ramos Venancio (1):
      NFC: Change nfc.h license

Samuel Ortiz (9):
      NFC: llcp: Remove the tx backlog queue
      NFC: llcp: Fix Rx memory leak
      NFC: pn544: Separate the core code and the i2c one into different modules
      NFC: pn544: Use module_i2c_driver
      NFC: pn544: Use devm_kzalloc API
      NFC: Initial Secure Element API
      NFC: Update pn544 documentation
      NFC: Avoid memcpy on LLCP connection less Rx path
      NFC: Use skb_copy_datagram_iovec

Thierry Escande (2):
      NFC: Add support for SO_TIMESTAMP LLCP socket option
      NFC: pn533: Fix bad allocation size

Waldemar Rymarkiewicz (28):
      NFC: pn533: Remove in/out_maxlen as it is not used
      NFC: pn533: Remove unused definitions
      NFC: pn533: Add frame header length define
      NFC: pn533: Remove pointless flags param
      NFC: pn533: Add a new pn533_send_cmd_async iface
      NFC: pn533: Add a new pn533_send_data_async iface
      NFC: pn533: Add a new pn533_send_sync iface
      NFC: pn533: Add pn533_alloc_skb for req allocation
      NFC: pn533: Remove pn533_send_cmd_frame_sync
      NFC: pn533: Del frame logic from TgGet/SetData cmd
      NFC: pn533: Del frame logic from InJumForDep cmd
      NFC: pn533: Del frame logic from Data Exchange cmd
      NFC: pn533: Dump tx and rx data in debug mode
      NFC: pn533: Remove frame logic from poll cmds
      NFC: pn533: Fix quoted strings split across lines
      NFC: pn533: Fix spacing issues
      NFC: pn533: Fix open parenthesis alignment
      NFC: pn533: Fix minor style issues
      NFC: pn533: Remove unused pn533_send_cmd_frame_asy
      NFC: pn533: Fix urb->status handling
      NFC: pn533: Cleanup debug messages
      NFC: pn533: Don't use out_frame in pn533_send_ack
      NFC: pn533: Use skb in __pn533_send_cmd_frame_asyn
      NFC: pn533: Remove deprecated dev->out_frame buff
      NFC: pn533: Cleanup pn533_cmd_complete_t
      NFC: pn533: Remove unused dev->wq_in_frame
      NFC: pn533: Introduce ops for frame logic
      NFC: pn533: Fix missing parenthesis

 Documentation/nfc/nfc-hci.txt   |  129 +++-
 Documentation/nfc/nfc-pn544.txt |   84 +--
 drivers/nfc/Kconfig             |   15 +-
 drivers/nfc/Makefile            |    2 +-
 drivers/nfc/nfcwilink.c         |   10 +-
 drivers/nfc/pn533.c             | 1593 ++++++++++++++++++++-------------------
 drivers/nfc/pn544/Kconfig       |   23 +
 drivers/nfc/pn544/Makefile      |    5 +-
 drivers/nfc/pn544/i2c.c         |   44 +-
 drivers/nfc/pn544/pn544.c       |   65 +-
 include/net/nfc/hci.h           |   22 +-
 include/net/nfc/nci_core.h      |    1 +
 include/net/nfc/nfc.h           |    8 +
 include/uapi/linux/nfc.h        |   37 +-
 net/nfc/core.c                  |   50 +-
 net/nfc/hci/command.c           |    7 +-
 net/nfc/hci/core.c              |   57 +-
 net/nfc/hci/hcp.c               |    7 +
 net/nfc/llcp/commands.c         |    2 +
 net/nfc/llcp/llcp.c             |   44 +-
 net/nfc/llcp/llcp.h             |    1 -
 net/nfc/llcp/sock.c             |   22 +-
 net/nfc/nci/core.c              |    2 +
 net/nfc/netlink.c               |    1 +
 24 files changed, 1201 insertions(+), 1030 deletions(-)
 create mode 100644 drivers/nfc/pn544/Kconfig


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
