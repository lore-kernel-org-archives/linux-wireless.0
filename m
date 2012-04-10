Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:61140 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480Ab2DJRfn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 13:35:43 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 00/18] NFC changes for 3.5
Date: Tue, 10 Apr 2012 19:43:02 +0200
Message-Id: <1334079800-10671-1-git-send-email-sameo@linux.intel.com> (sfid-20120410_193545_711987_FA892679)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is my current NFC patchset for the next merge window. This is what we
mainly have:

* An HCI and SHDLC implementation from Eric.
* A bunch of LLCP fixes.
* Some pn533 changes (workqueue conversion and Rx chaining support).
* A new netlink API for exposing lost targets events.

Please note that the first patch from this serie is a 3.4 fix.

You can also fetch those patches from here:

git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-3.0.git nfc-next

Eric Lapuyade (7):
  NFC: Export target lost function
  NFC: HCI support
  NFC: SHDLC implementation
  NFC: Add HCI documentation
  NFC: Fix next target_idx type and rename for clarity
  NFC: Changed target activated state logic
  NFC: Add Core support to generate tag lost event

Samuel Ortiz (11):
  NFC: Fix the LLCP Tx fragmentation loop
  NFC: Add a target lost netlink event
  NFC: The core part should generate the target index
  NFC: Dump LLCP frames
  NFC: No need to apply twice the modulo op to LLCP's recv_n
  NFC: Fix LLCP TLV building routine
  NFC: Call llcp_add_header properly when sending LLCP DM or DISC
  NFC: Convert pn533 from tasklet to workqueues
  NFC: pn533 Rx chaining support
  NFC: Add MIUX to the local LLCP general bytes
  NFC: Fix LLCP link timeout typo

 Documentation/nfc/nfc-hci.txt |  155 +++++++
 drivers/nfc/pn533.c           |  228 ++++++++---
 include/linux/nfc.h           |    1 +
 include/net/nfc/hci.h         |  198 +++++++++
 include/net/nfc/nfc.h         |   12 +-
 include/net/nfc/shdlc.h       |  104 +++++
 net/nfc/Kconfig               |    1 +
 net/nfc/Makefile              |    1 +
 net/nfc/core.c                |  140 ++++++-
 net/nfc/hci/Kconfig           |   16 +
 net/nfc/hci/Makefile          |    8 +
 net/nfc/hci/command.c         |  354 +++++++++++++++
 net/nfc/hci/core.c            |  830 ++++++++++++++++++++++++++++++++++++
 net/nfc/hci/hci.h             |  139 ++++++
 net/nfc/hci/hcp.c             |  156 +++++++
 net/nfc/hci/shdlc.c           |  945 +++++++++++++++++++++++++++++++++++++++++
 net/nfc/llcp/commands.c       |   12 +-
 net/nfc/llcp/llcp.c           |   21 +-
 net/nfc/nci/core.c            |    2 +-
 net/nfc/nci/ntf.c             |   11 +-
 net/nfc/netlink.c             |   30 ++
 net/nfc/nfc.h                 |    1 +
 net/nfc/rawsock.c             |    6 +
 23 files changed, 3299 insertions(+), 72 deletions(-)
 create mode 100644 Documentation/nfc/nfc-hci.txt
 create mode 100644 include/net/nfc/hci.h
 create mode 100644 include/net/nfc/shdlc.h
 create mode 100644 net/nfc/hci/Kconfig
 create mode 100644 net/nfc/hci/Makefile
 create mode 100644 net/nfc/hci/command.c
 create mode 100644 net/nfc/hci/core.c
 create mode 100644 net/nfc/hci/hci.h
 create mode 100644 net/nfc/hci/hcp.c
 create mode 100644 net/nfc/hci/shdlc.c

-- 
1.7.9.1

