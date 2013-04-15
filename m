Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28076 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513Ab3DOXFM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 19:05:12 -0400
Date: Tue, 16 Apr 2013 01:05:08 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [GIT] [3.10] NFC pull request
Message-ID: <20130415230508.GL8798@zurbaran> (sfid-20130416_010517_132387_3110B4EF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

A bit late, but this is the 2nd NFC pull request for 3.10.

With this one we have:

- A major pn533 update. The pn533 framing support has been changed in order to
  easily support all pn533 derivatives. For example we now support the ACR122
  USB dongle.

- An NFC MEI physical layer code factorization through the mei_phy NFC API.
  Both the microread and the pn544 drivers now use it.

- LLCP aggregation support. This allows NFC p2p devices to send aggregated
  frames containing all sort of LLCP frames except SYMM and aggregation
  frames.

- More LLCP socket options for getting the remote device link parameters.

- Fixes for the LLCP socket option code added with the first pull request for
  3.10.

- Some support for LLCP corner cases like 0 length SDUs and general DISC
  (tagged with a 0,0 dsap ssap couple) handling.

- RFKILL support for NFC.

Thanks in advance for pulling them in.

The following changes since commit fe29f54cd574eab7b521445419f355c0ecd995cc:

  ipw2x00: move to kstrto* functions (2013-04-10 14:10:34 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.10-2

for you to fetch changes up to bb03dceb83852614ae3ad6b3731a31422890b0b9:

  NFC: pn544: Add MEI physical layer (2013-04-16 00:39:41 +0200)

----------------------------------------------------------------
Eric Lapuyade (1):
      NFC: mei: Add a common mei bus API for NFC drivers

Marina Makienko (1):
      NFC: pn533: Add missing usb_put_dev

Olivier Guiter (1):
      NFC: llcp: Fix zero octets length SDU handling

Samuel Ortiz (11):
      NFC: pn533: Use dynamic debug for pn533 hex dumps
      NFC: llcp: Socket miux is a big endian field
      NFC: llcp: Fall back to local values when getting socket options
      NFC: llcp: Only keep raw sockets alive when the LLCP local leaves
      NFC: llcp: Remove local_cleanup last argument
      NFC: llcp: Terminate connection when receiving a DISC on (0,0)
      NFC: Prevent polling when device is down
      NFC: pn533: Turn radio on and off when bringing the device up and down
      rfkill: Add NFC to the list of supported radios
      NFC: RFKILL support
      NFC: pn544: Add MEI physical layer

Thierry Escande (4):
      NFC: llcp: Aggregated frames support
      NFC: llcp: Use localy stored remote_miu value if not set at socket level
      NFC: llcp: Reset RW, LTO, and MIU remote parameters when link goes down
      NFC: llcp: Add support in getsockopt for RW, LTO, and MIU remote parameters

Waldemar Rymarkiewicz (19):
      NFC: pn533: Reword all std frame logic funct
      NFC: pn533: Print out response status bits in hex
      NFC: pn533: Fix div by zero while stopping polling
      NFC: pn533: Update copyrights note
      NFC: pn533: Rename pn533_fw_reset appropriately
      NFC: pn533: Fix memleak while scheduling next cmd
      NFC: pn533: Optimise issued cmd context tracking
      NFC: pn533: Keep cmd context in pn533 struct
      NFC: pn533: Remove redundant cmd_ prefix in the struct
      NFC: pn533: Fix incorrect kfree of complete args
      NFC: pn533: Simplify __pn533_send_frame_async
      NFC: pn533: Avoid function declarations
      NFC: pn533: Re-group fields in struct pn533
      NFC: pn533: Move wq_in_error to cmd context
      NFC: pn533: Add protocol type for frame ops
      NFC: pn533: Add support for ACS ACR122U reader
      NFC: pn533: Add pn533_abort_cmd procedure
      NFC: pn533: Remove unused pn533_cmd_complete_t
      NFC: pn533: Increase version number

 drivers/nfc/Kconfig           |   10 +
 drivers/nfc/Makefile          |    1 +
 drivers/nfc/mei_phy.c         |  164 +++++++++++
 drivers/nfc/mei_phy.h         |   30 ++
 drivers/nfc/microread/Kconfig |    2 +-
 drivers/nfc/microread/mei.c   |  139 +--------
 drivers/nfc/pn533.c           |  653 ++++++++++++++++++++++++++++-------------
 drivers/nfc/pn544/Kconfig     |   13 +-
 drivers/nfc/pn544/Makefile    |    2 +
 drivers/nfc/pn544/mei.c       |  121 ++++++++
 include/net/nfc/nfc.h         |    2 +
 include/uapi/linux/nfc.h      |    7 +-
 include/uapi/linux/rfkill.h   |    2 +
 net/nfc/core.c                |   43 +++
 net/nfc/llcp/commands.c       |   30 +-
 net/nfc/llcp/llcp.c           |  127 +++++---
 net/nfc/llcp/llcp.h           |    5 +-
 net/nfc/llcp/sock.c           |   43 ++-
 net/rfkill/core.c             |    4 +-
 19 files changed, 1011 insertions(+), 387 deletions(-)
 create mode 100644 drivers/nfc/mei_phy.c
 create mode 100644 drivers/nfc/mei_phy.h
 create mode 100644 drivers/nfc/pn544/mei.c
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
