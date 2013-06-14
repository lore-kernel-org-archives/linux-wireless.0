Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21202 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357Ab3FNLuk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jun 2013 07:50:40 -0400
Date: Fri, 14 Jun 2013 13:50:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@lists.01.org>
Subject: [GIT] [3.11] NFC updates
Message-ID: <20130614115038.GI7998@zurbaran> (sfid-20130614_135044_050289_310522AF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the NFC pull request for 3.11. See below for all the details,
thanks in advance for pulling them in.

The following changes since commit b70727e8a61a8e6b4d818519b03fce2937d0ef40:

  Merge branch 'for-linville-ath10k' of git://github.com/kvalo/ath6kl (2013-06-13 13:54:21 -0400)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.11-1

for you to fetch changes up to bda7eb27635c4d7414fb05a5f55501b71f436cc0:

  NFC: mei_phy: Clean up file (2013-06-14 13:45:11 +0200)

----------------------------------------------------------------
These are the pending NFC patches for the 3.11 merge window.

It contains the pending fixes that were on nfc-fixes (nfc-fixes-3.10-2),
along with a few more for the pn544 and pn533 drivers, the LLCP
disconnection path and an LLCP memory leak.

Highlights for this one are:

- An initial secure element API. NFC chipsets can carry an embedded
  secure element or get access to the SIM one. In both cases they
  control the secure elements and this API provides a way to discover,
  enable and disable the available SEs. It also exports that to
  userspace in order for SE focused middleware to actually do something
  with them (e.g. payments).

- NCI over SPI support. SPI is the most complex NCI specified transport
  layer and we now have support for it in the kernel. The next step will
  be to implement drivers for NCI chipsets using this transport like
  e.g. bcm2079x.

- NFC p2p hardware simulation driver. We now have an nfcsim driver that
  is mostly a loopback device between 2 NFC interfaces. It also
  implements the rest of the NFC core API like polling and target
  detection. This driver, with neard running on top of it, allows us to
  completely test the LLCP, SNEP and Handover implementation without
  physical hardware.

- A Firmware update netlink API. Most (All ?) HCI chipsets have a
  special firmware update mode where applications can push a new
  firmware that will be flashed. We now have a netlink API for providing
  that mode to e.g. nfctool.

----------------------------------------------------------------
Arron Wang (2):
      NFC: pn544: Identify Type F NFC-DEP through NFCID2
      NFC: pn544: Remove Felica and Jewel device presence check

Eric Lapuyade (2):
      NFC: Add firmware upload netlink command
      NFC: HCI: Implement fw_upload ops

Frederic Danis (4):
      NFC: NCI: Fix skb->dev usage
      NFC: Add basic NCI over SPI
      NFC: Add NCI over SPI send
      NFC: Add NCI over SPI receive

Olivier Guiter (1):
      NFC: pn533: Fix ACR122 related debug output

Samuel Ortiz (14):
      NFC: HCI: Follow a positive code path in the HCI ops implementations
      NFC: pn533: Use 0x3 for SENSF_REQ Time Slot Number (TSN)
      NFC: pn533: Copy NFCID2 through ATR_REQ
      NFC: Remove the static supported_se field
      NFC: Extend and fix the internal secure element API
      NFC: Add secure elements addition and removal API
      NFC: Send netlink events for secure elements additions and removals
      NFC: Remove and free all SEs when releasing an NFC device
      NFC: Add secure element enablement internal API
      NFC: Add secure element enablement netlink API
      NFC: llcp: Fix non blocking sockets connections
      NFC: llcp: Do not send pending Tx frames when the remote is not ready
      NFC: llcp: Set the LLC Link Management well known service bit
      NFC: llcp: Fix the well known services endianness

Thierry Escande (4):
      NFC: Rename nfc_llcp_disconnect() to nfc_llcp_send_disconnect()
      NFC: Keep socket alive until the DISC PDU is actually sent
      NFC: Fix a potential memory leak
      NFC: Add a nfc hardware simulation driver

Valentin Ilie (1):
      NFC: mei_phy: Clean up file

Wei Yongjun (1):
      NFC: pn533: Fix error return code in pn533_probe()

 drivers/nfc/Kconfig               |   10 +
 drivers/nfc/Makefile              |    1 +
 drivers/nfc/mei_phy.c             |    6 +-
 drivers/nfc/microread/microread.c |    6 +-
 drivers/nfc/nfcsim.c              |  541 +++++++++++++++++++++++++++++++++++++
 drivers/nfc/nfcwilink.c           |   18 +-
 drivers/nfc/pn533.c               |   31 ++-
 drivers/nfc/pn544/pn544.c         |   40 +--
 include/net/nfc/hci.h             |    7 +-
 include/net/nfc/nci_core.h        |   58 +++-
 include/net/nfc/nfc.h             |   35 ++-
 include/uapi/linux/nfc.h          |   18 +-
 net/nfc/core.c                    |  224 ++++++++++++++-
 net/nfc/hci/core.c                |   75 +++--
 net/nfc/llcp.h                    |    3 +-
 net/nfc/llcp_commands.c           |   22 +-
 net/nfc/llcp_core.c               |   16 +-
 net/nfc/llcp_sock.c               |   19 +-
 net/nfc/nci/Kconfig               |   10 +
 net/nfc/nci/Makefile              |    4 +-
 net/nfc/nci/core.c                |   37 ++-
 net/nfc/nci/data.c                |    2 -
 net/nfc/nci/spi.c                 |  378 ++++++++++++++++++++++++++
 net/nfc/netlink.c                 |  183 ++++++++++++-
 net/nfc/nfc.h                     |   11 +
 25 files changed, 1629 insertions(+), 126 deletions(-)
 create mode 100644 drivers/nfc/nfcsim.c
 create mode 100644 net/nfc/nci/spi.c
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
