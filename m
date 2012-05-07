Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50128 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab2EGKbv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:31:51 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 00/20] NFC updates for 3.5
Date: Mon,  7 May 2012 12:31:11 +0200
Message-Id: <1336386691-24840-1-git-send-email-sameo@linux.intel.com> (sfid-20120507_123157_019537_9362236C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here comes my 2nd NFC batch for the next 3.5 merge window.

Besides the sparse, warning and LLCP fixes, we have a new pn544 driver based
on the existing NFC HCI APIs. We will be living with 2 pn544 drivers for a
while as I wanted to keep a transition period for whoever is using the
existing driver. I'm planning to remove it for 3.6, but this could be extended
if someone screams about it.

You can also pull those patches from:

git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-3.0.git nfc-next

They should apply cleanly on top of your wireless-next tree.

Dan Carpenter (1):
  NFC: Remove unneeded pn533 dev NULL check

Eric Lapuyade (7):
  NFC: Cache the core NFC active target pointer instead of its index
  NFC: Remove useless HCI private nfc target table
  NFC: Specify usage for targets found and target lost events
  NFC: Add HCI/SHDLC support to let driver check for tag presence
  NFC: Update Documentation/nfc-hci.txt
  NFC: HCI based pn544 driver
  NFC: HCI drivers don't have to keep track of polling state

H Hartley Sweeten (5):
  NFC: Quiet nci/data.c sparse noise about plain integer as NULL
    pointer
  NFC: Include nci_core.h to nci/lib.c
  NFC: Quiet nci/ntf.c sparse noise about plain integer as NULL pointer
  NFC: HCI ops should not be exposed globally
  NFC: The NFC genl family structure should not be exposed globally

Samuel Ortiz (5):
  NFC: LLCP connect must wait for a CC frame
  NFC: Update the LLCP poll mask
  NFC: Return the amount of LLCP bytes queued to sock_sendmsg
  NFC: Send device index instead of its name when target is lost
  feature-removal: Remove pn544 raw driver

Stephen Rothwell (1):
  NFC: Fix up for NLA_PUT_ api changes

joseph daniel (1):
  NFC: Fix LLCP compilation warning

 Documentation/feature-removal-schedule.txt |   12 +
 Documentation/nfc/nfc-hci.txt              |   45 +-
 drivers/nfc/Kconfig                        |   13 +
 drivers/nfc/Makefile                       |    1 +
 drivers/nfc/pn533.c                        |   19 +-
 drivers/nfc/pn544_hci.c                    |  947 ++++++++++++++++++++++++++++
 include/linux/nfc/pn544.h                  |    7 +
 include/net/nfc/hci.h                      |    6 +-
 include/net/nfc/nfc.h                      |   19 +-
 include/net/nfc/shdlc.h                    |    2 +
 net/nfc/core.c                             |  112 +++-
 net/nfc/hci/core.c                         |   78 +--
 net/nfc/hci/shdlc.c                        |   12 +
 net/nfc/llcp/commands.c                    |    2 +-
 net/nfc/llcp/llcp.c                        |    7 +
 net/nfc/llcp/sock.c                        |   57 ++-
 net/nfc/nci/core.c                         |   27 +-
 net/nfc/nci/data.c                         |    8 +-
 net/nfc/nci/lib.c                          |    1 +
 net/nfc/nci/ntf.c                          |    2 +-
 net/nfc/netlink.c                          |   12 +-
 net/nfc/nfc.h                              |    2 +-
 22 files changed, 1248 insertions(+), 143 deletions(-)
 create mode 100644 drivers/nfc/pn544_hci.c

-- 
1.7.9.1

