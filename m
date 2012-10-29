Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6511 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082Ab2J2ALD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2012 20:11:03 -0400
Date: Mon, 29 Oct 2012 01:00:57 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@lists.01.org>
Subject: [GIT] [3.8] NFC pull request
Message-ID: <20121029000057.GD5411@sortiz-mobl> (sfid-20121029_011108_231093_1A508198)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the first NFC pull request for 3.8.

With this one we have:

- pn544 p2p support.
- pn544 physical and HCI layers separation. We are getting the pn544 driver
  ready to support non i2c physical layers.
- LLCP SNL (Service Name Lookup). This is the NFC p2p service discovery
  protocol.
- LLCP datagram sockets (connection less) support.
- IDR library usage for NFC devices indexes assignement.
- NFC netlink extension for setting and getting LLCP link characteristics.
- Various code style fixes and cleanups spread over the pn533, LLCP, HCI and
  pn544 code.

Thanks in advance for pulling them in.

The following changes since commit 9b34f40c20111ba658f88e1669598db494be1fbc:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless (2012-10-23 11:41:46 -0400)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-3.0.git tags/nfc-next-3.8-1

for you to fetch changes up to 52feb444a90304eb13c03115bb9758101dbb9254:

  NFC: Extend netlink interface for LTO, RW, and MIUX parameters support (2012-10-29 00:25:11 +0100)

----------------------------------------------------------------
Arron Wang (7):
      NFC: Set local gb and DEP registries
      NFC: Pass hardware specific HCI event to driver
      NFC: Handle pn544 continue activation
      NFC: Implement HCI DEP link up and down
      NFC: Implement HCI DEP send and receive data
      NFC: Add pn544 presence check for different targets
      NFC: Fix sparse warnings due to missing static

Eric Lapuyade (2):
      NFC: HCI check presence must not fail when driver doesn't support it
      NFC: Separate pn544 hci driver in HW dependant and independant parts

Kees Cook (3):
      NFC: Remove CONFIG_EXPERIMENTAL
      NFC: Remove CONFIG_EXPERIMENTAL from the LLCP Makefile
      NFC: Remove CONFIG_EXPERIMENTAL from the NCI Makefile

Samuel Ortiz (14):
      NFC: Avoid falling back to SYMM when sk is NULL
      NFC: Use llcp_allocate_pdu to build the DISC frames
      NFC: Add SNL frame building routine
      NFC: Initial SNL support
      NFC: Reserve LLCP ssap when replying to an SNL frame
      NFC: Check for connection less sockets when looking for a service name
      NFC: Keep connection less bound sockets alive when DEP link goes down
      NFC: Handle LLCP UI frames
      NFC: Forward LLCP datagrams to userspace
      NFC: UI frame sending routine implementation
      NFC: Implement LLCP connection less Tx path
      NFC: Return NULL when no LLCP socket for a dsap,ssap couple is found
      NFC: Use IDR library to assing NFC devices IDs
      NFC: Purge LLCP socket Tx queues when being disconnected

Szymon Janc (7):
      NFC: Use NFC_MAX_GT_LEN to check len in nci_set_local_general_bytes
      NFC: Remove not needed local variable in nci_set_local_general_bytes
      NFC: Remove unneeded LLCP function return calls
      NFC: Small nfc_hci_create_pipe refactoring
      NFC: Fix not propagating return code in nfc_hci_clear_all_pipes
      NFC: Fix style issues with logical operations
      NFC: Fix some code style and whitespace issues

Thierry Escande (3):
      NFC: Set rf_mode to NFC_RF_NONE where necessary
      NFC: Add NFC_ATTR_RF_MODE when sending device netlink properties
      NFC: Extend netlink interface for LTO, RW, and MIUX parameters support

Waldemar Rymarkiewicz (2):
      NFC: pn533: Fix in/out frame buffer allocation
      NFC: pn533: Remove unused arg parameter

 drivers/nfc/Makefile                       |    2 +-
 drivers/nfc/pn533.c                        |   18 +-
 drivers/nfc/pn544/Makefile                 |    7 +
 drivers/nfc/pn544/i2c.c                    |  500 ++++++++++++++++++++
 drivers/nfc/{pn544_hci.c => pn544/pn544.c} |  679 +++++++++++-----------------
 drivers/nfc/pn544/pn544.h                  |   32 ++
 include/net/nfc/hci.h                      |   18 +-
 include/net/nfc/nfc.h                      |    2 +-
 include/uapi/linux/nfc.h                   |   15 +
 net/nfc/Kconfig                            |    4 +-
 net/nfc/core.c                             |   33 +-
 net/nfc/hci/command.c                      |   24 +-
 net/nfc/hci/core.c                         |   71 ++-
 net/nfc/hci/llc.c                          |    2 +-
 net/nfc/hci/llc_shdlc.c                    |    7 +-
 net/nfc/llcp/Kconfig                       |    4 +-
 net/nfc/llcp/commands.c                    |  120 ++++-
 net/nfc/llcp/llcp.c                        |  226 ++++++++-
 net/nfc/llcp/llcp.h                        |   13 +
 net/nfc/llcp/sock.c                        |   42 +-
 net/nfc/nci/Kconfig                        |    4 +-
 net/nfc/nci/core.c                         |   29 +-
 net/nfc/netlink.c                          |  157 ++++++-
 net/nfc/nfc.h                              |    6 +
 net/nfc/rawsock.c                          |    1 -
 25 files changed, 1472 insertions(+), 544 deletions(-)
 create mode 100644 drivers/nfc/pn544/Makefile
 create mode 100644 drivers/nfc/pn544/i2c.c
 rename drivers/nfc/{pn544_hci.c => pn544/pn544.c} (58%)
 create mode 100644 drivers/nfc/pn544/pn544.h

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
