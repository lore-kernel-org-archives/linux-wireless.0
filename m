Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4609 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab2IXWqr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 18:46:47 -0400
Date: Tue, 25 Sep 2012 00:46:43 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	linux-nfc@lists.01.org
Subject: [GIT] [3.7] NFC pull request
Message-ID: <20120924224643.GI28670@sortiz-mobl> (sfid-20120925_004651_792485_46222CF2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Later than I hoped for, but this is the NFC pull request for 3.7.

With this one we get:

- HCI and LLC layers separation. We now can support various LLC
  protocols for HCI drivers, SHDLC being one of them. This will be needed as
  we're planning to support raw HCI chipsets that do the SHDLC encapsulation
  in firmware. So for now we have an SHDLC and a NOP LLC layers.

- pn533 command queueing implementation. This simplifies the pn533 locking
  logic and fixes a kernel warning.

- NCI p2p initiator mode implementation.

- Replace custom workqueues with system ones, for HCI and LLCP.

- Raw pn544 driver removal, as schedule on the features-removal.txt file.

- A few HCI, SHDLC and LLCP fixes.

Thanks in advance for pulling them in.

The following changes since commit 90e6274d2ecf3bcb44e3727a395e56b7ef467218:

  ath5k: disable HW crypto in management frame (2012-09-24 15:02:08 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-3.0.git tags/nfc-next-3.7-1

for you to fetch changes up to 4c0ba9ac4bf5f20ada774f5d181d03044e0147e7:

  NFC: Fix typo negociating -> negotiating (2012-09-25 00:17:28 +0200)

Cong Wang (1):
      NFC: Remove the pn544 raw driver

Eric Lapuyade (9):
      NFC: Changed the HCI cmd execution callback prototype
      NFC: Add a public nfc_hci_send_cmd_async method
      NFC: Modified hci_transceive to become an asynchronous operation
      NFC: Add an LLC Core layer to HCI
      NFC: Add a nop (passthrough) llc module to llc core
      NFC: Add an shdlc llc module to llc core
      NFC: Changed HCI and PN544 HCI driver to use the new HCI LLC Core
      NFC: Fix LLC registration definitions for ANSI compliance
      NFC: Add HCI module description

Ilan Elias (3):
      NFC: Set local general bytes in nci_start_poll
      NFC: Parse NCI NFC-DEP activation params
      NFC: Implement NCI dep_link_up and dep_link_down

Samuel Ortiz (4):
      NFC: Queue pn533 commands
      NFC: Set the IRQF_ONESHOT flag from the pn544_hci IRQ handler request
      NFC: Remove unneeded LLC symbols export
      MAINTAINERS: Add NFC specific mailing list

Syam Sidhardhan (2):
      NFC: Use module_platform_driver macro for nfcwilink.c
      NFC: Remove repeated code for NULL check

Tejun Heo (2):
      NFC: Use system_nrt_wq instead of custom ones
      NFC: Don't use WQ_MEM_RECLAIM for pn533

Waldemar Rymarkiewicz (6):
      NFC: Remove crc generation from shdlc layer
      NFC: Correct outgoing frame before requeueing
      NFC: xmit from hci ops must return 0 or negative
      NFC: Handle RSET in SHDLC_CONNECTING state
      NFC: Don't handle consequent RSET frames after UA
      NFC: Fix typo negociating -> negotiating

Wei Yongjun (4):
      NFC: Remove pointless conditional before HCI kfree_skb()
      NFC: Fix possible LLCP memory leak
      NFC: Move the nfcwilink dereference below the NULL test
      NFC: Move the pn544_hci dereference below the NULL test

 Documentation/feature-removal-schedule.txt |   12 -
 MAINTAINERS                                |    1 +
 drivers/nfc/Kconfig                        |   14 +-
 drivers/nfc/Makefile                       |    1 -
 drivers/nfc/nfcwilink.c                    |   20 +-
 drivers/nfc/pn533.c                        |  106 +++-
 drivers/nfc/pn544.c                        |  893 ----------------------------
 drivers/nfc/pn544_hci.c                    |  177 ++++--
 include/net/nfc/hci.h                      |   21 +-
 include/net/nfc/llc.h                      |   54 ++
 include/net/nfc/nci.h                      |   29 +
 include/net/nfc/nci_core.h                 |    5 +
 include/net/nfc/nfc.h                      |    2 +-
 include/net/nfc/shdlc.h                    |  107 ----
 net/nfc/core.c                             |   13 +-
 net/nfc/hci/Makefile                       |    4 +-
 net/nfc/hci/command.c                      |   45 +-
 net/nfc/hci/core.c                         |  336 ++++++-----
 net/nfc/hci/hci.h                          |   15 +-
 net/nfc/hci/hcp.c                          |    6 +-
 net/nfc/hci/llc.c                          |  170 ++++++
 net/nfc/hci/llc.h                          |   61 ++
 net/nfc/hci/llc_nop.c                      |   99 +++
 net/nfc/hci/{shdlc.c => llc_shdlc.c}       |  544 +++++++----------
 net/nfc/llcp/llcp.c                        |   71 +--
 net/nfc/llcp/llcp.h                        |    3 -
 net/nfc/llcp/sock.c                        |    3 -
 net/nfc/nci/core.c                         |   91 ++-
 net/nfc/nci/ntf.c                          |   52 ++
 net/nfc/nci/rsp.c                          |   14 +
 30 files changed, 1283 insertions(+), 1686 deletions(-)
 delete mode 100644 drivers/nfc/pn544.c
 create mode 100644 include/net/nfc/llc.h
 delete mode 100644 include/net/nfc/shdlc.h
 create mode 100644 net/nfc/hci/llc.c
 create mode 100644 net/nfc/hci/llc.h
 create mode 100644 net/nfc/hci/llc_nop.c
 rename net/nfc/hci/{shdlc.c => llc_shdlc.c} (54%)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
