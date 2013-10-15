Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27549 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932994Ab3JOQTW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 12:19:22 -0400
Date: Tue, 15 Oct 2013 18:19:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@lists.01.org>
Subject: [GIT] [3.13] NFC updates
Message-ID: <20131015161917.GF30191@zurbaran> (sfid-20131015_181925_821217_32C7AFB0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the first NFC pull request for the 3.13 kernel.

It's a fairly big one, with the following highlights:

- NFC digital layer implementation: Most NFC chipsets implement the NFC
  digital layer in firmware, but others have more basic functionalities
  and expect the host to implement the digital layer. This layer sits
  below the NFC core.

- Sony's port100 support: This is "soft" NFC USB dongle that expects the
  digital layer to be implemented on the host. This is the first user of
  our NFC digital stack implementation.

- Secure element API: We now provide a netlink API for enabling,
  disabling and discovering NFC attached (embedded or UICC ones) secure
  elements. With some userspace help, this allows us to support NFC
  payments.
  Only the pn544 driver currently supports that API.

- NCI SPI fixes and improvements: In order to support NCI devices over
  SPI, we fixed and improved our NCI/SPI implementation. The currently
  most deployed NFC NCI chipset, Broadcom's bcm2079x, supports that mode
  and we're planning to use our NCI/SPI framework to implement a
  driver for it.

- pn533 fragmentation support in target mode: This was the only missing
  feature from our pn533 impementation. We now support fragmentation in
  both Tx and Rx modes, in target mode.

The following changes since commit b75ff5e84bb6c2d43a8ec39b240c80f0543821f0:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-09-19 13:57:28 -0500)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.13-1

for you to fetch changes up to ddc1a70b5f2a07a932ed31f989d63937bb813439:

  NFC: Fix SE API related sparse warning (2013-10-07 14:18:44 +0200)

----------------------------------------------------------------
Arron Wang (3):
      NFC: pn544: Add SE discover operation
      NFC: Export nfc_find_se()
      NFC: pn544: Add SE enable/disable operation

Eric Lapuyade (8):
      NFC: NCI: Fix wrong allocation size in nci_spi_allocate_device()
      NFC: NCI: Rename spi ndev -> nsdev and nci_dev -> ndev for consistency
      NFC: Move struct nfc_phy_ops out of HCI up to nfc core level
      NFC: NCI: Simplify NCI SPI to become a simple framing/checking layer
      NFC: NCI: Store the spi device pointer from the spi instance
      NFC: NCI: zero struct spi_transfer variables before usage
      NFC: NCI: nci_spi_recv_frame() now returns (not forward) the read frame
      NFC: NCI: Modify NCI SPI to implement CS/INT handshake per the spec

Fengguang Wu (1):
      NFC: digital: digital_tg_send_sensf_res() can be static

Joe Perches (3):
      NFC: Replace nfc_dev_dbg with dev_dbg
      NFC: Convert nfc_dev_info and nfc_dev_err to nfc_<level>
      NFC: Standardize logging style

Olivier Guiter (3):
      NFC: pn533: Add MI/TG bits only when in Initiator mode
      NFC: pn533: Add support for incoming fragmented frame in target mode
      NFC: pn533: Target mode Tx fragmentation support

Sachin Kamat (2):
      NFC: nfcwilink: Remove redundant dev_set_drvdata
      NFC: pn533: Staticize local symbols

Samuel Ortiz (9):
      NFC: Set active target upon DEP up event reception
      NFC: pn533: Send ATR_REQ directly for active device detection
      NFC: pn533: Start listen timer from start_poll
      NFC: digital: Remove PR_ERR and PR_DBG macros
      NFC: digital: Add newline to pr_* calls
      NFC: Document NFC targets sens_res field
      NFC: Define secure element IO API and commands
      NFC: netlink: SE API implementation
      NFC: Fix SE API related sparse warning

Thierry Escande (12):
      NFC: Digital Protocol stack implementation
      NFC Digital: Implement driver commands mechanism
      NFC Digital: Add NFC-A technology support
      NFC Digital: Add NFC-F technology support
      NFC Digital: Add initiator NFC-DEP support
      NFC Digital: Add target NFC-DEP support
      NFC: rawsock: Fix a memory leak
      NFC: digital: Fix sens_res endiannes handling
      NFC: Sony Port-100 Series driver
      NFC: port100: Commands mechanism implementation
      NFC: port100: Add initiator mode support
      NFC: port100: Add target mode support

 drivers/nfc/Kconfig               |   10 +
 drivers/nfc/Makefile              |    1 +
 drivers/nfc/mei_phy.c             |    6 +-
 drivers/nfc/microread/i2c.c       |   32 +-
 drivers/nfc/microread/mei.c       |    4 +-
 drivers/nfc/microread/microread.c |    7 +-
 drivers/nfc/nfcsim.c              |   38 +-
 drivers/nfc/nfcwilink.c           |   97 +--
 drivers/nfc/pn533.c               |  604 ++++++++++-----
 drivers/nfc/pn544/i2c.c           |   42 +-
 drivers/nfc/pn544/pn544.c         |  129 +++-
 drivers/nfc/port100.c             | 1529 +++++++++++++++++++++++++++++++++++++
 include/net/nfc/digital.h         |  227 ++++++
 include/net/nfc/hci.h             |    6 -
 include/net/nfc/nci.h             |    4 +
 include/net/nfc/nci_core.h        |   46 +-
 include/net/nfc/nfc.h             |   25 +-
 include/uapi/linux/nfc.h          |    4 +
 net/nfc/Kconfig                   |   14 +
 net/nfc/Makefile                  |    2 +
 net/nfc/core.c                    |   22 +-
 net/nfc/digital.h                 |  170 +++++
 net/nfc/digital_core.c            |  737 ++++++++++++++++++
 net/nfc/digital_dep.c             |  729 ++++++++++++++++++
 net/nfc/digital_technology.c      |  770 +++++++++++++++++++
 net/nfc/nci/spi.c                 |  239 +++---
 net/nfc/netlink.c                 |   91 +++
 net/nfc/rawsock.c                 |    7 +-
 28 files changed, 5065 insertions(+), 527 deletions(-)
 create mode 100644 drivers/nfc/port100.c
 create mode 100644 include/net/nfc/digital.h
 create mode 100644 net/nfc/digital.h
 create mode 100644 net/nfc/digital_core.c
 create mode 100644 net/nfc/digital_dep.c
 create mode 100644 net/nfc/digital_technology.c
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
