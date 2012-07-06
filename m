Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:64376 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab2GFT6l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:58:41 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 00/33] NFC updates for 3.6
Date: Fri,  6 Jul 2012 22:09:20 +0200
Message-Id: <1341605393-32056-1-git-send-email-sameo@linux.intel.com> (sfid-20120706_215845_509921_C70372B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the second (and probably last) NFC pull request for 3.6.
Here are the interesting bits:

- A better error management for the HCI stack.
- An LLCP "late" binding implementation for a better NFC SAP usage. SAPs are
  now reserved only when there's a client for it.
- Support for Sony RC-S360 (a.k.a. PaSoRi) pn533 based dongle. We can read and
  write NFC tags and also establish a p2p link with this dongle now.
- A few LLCP fixes.

You can either apply those patches manually or pull them from here:

git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-3.0.git tags/nfc-next-3.6-2


Eric Lapuyade (15):
  NFC: Prepare asynchronous error management for driver and shdlc
  NFC: Removed addressed shdlc TODOs
  NFC: Handle SHDLC RSET frames from an SHDLC connected chip
  NFC: Remove an impossible HCI error case
  NFC: Implement HCP reaggregation allocation error case
  NFC: Changed HCI cmd execution completion result to std linux errno
  NFC: Driver failure API
  NFC: Factorize HCI cmd completion
  NFC: Implement HCI driver or internal error management
  NFC: Core must test the device polling state inside the device lock
  NFC: nfc_targets_found() should accept zero target found
  NFC: nfc_driver_failure() implementation
  NFC: Error management documentation
  NFC: update PN544 HCI driver state when opened/closed
  NFC: Allow HCI driver to pre-open pipes to some gates

Samuel Ortiz (18):
  NFC: Add modules alias for NFC sockets
  NFC: Add netlink module alias for NFC
  NFC: Update LLCP socket target index when getting a connection
  NFC: Fix LLCP getname socket op
  NFC: Build LLCP general bytes upon request
  NFC: Close listening LLCP sockets when the device is gone
  NFC: Release LLCP SAP when the owner is released
  NFC: Forbid LLCP service name reusing
  NFC: Forbid SSAP binding to a not well known LLCP service
  NFC: LLCP late binding
  NFC: Handle LLCP Disconnected Mode frames
  NFC: Remove warning from nfc_llcp_local_put
  NFC: Do not return EBUSY when stopping a poll that's already stopped
  NFC: Dereference LLCP bind socket address after checking for it to be
    NULL
  NFC: Add initial Sony RC-S360 support to pn533
  NFC: Use communicate thru only for PaSoRi when trying to read Felica
    tags
  NFC: Add ISO 14443 type B protocol
  NFC: Check for llcp_sock and its device from llcp_sock_getname

 Documentation/nfc/nfc-hci.txt |   33 ++++
 drivers/nfc/nfcwilink.c       |    7 +-
 drivers/nfc/pn533.c           |  224 ++++++++++++++++++++++-----
 drivers/nfc/pn544_hci.c       |   37 +++--
 include/linux/nfc.h           |   14 +-
 include/net/nfc/hci.h         |   19 ++-
 include/net/nfc/nfc.h         |    2 +
 net/nfc/core.c                |   38 ++++-
 net/nfc/hci/command.c         |   26 ++--
 net/nfc/hci/core.c            |  104 ++++++++-----
 net/nfc/hci/hci.h             |   12 +-
 net/nfc/hci/shdlc.c           |   38 ++---
 net/nfc/llcp/llcp.c           |  342 +++++++++++++++++++++++++++--------------
 net/nfc/llcp/llcp.h           |    5 +
 net/nfc/llcp/sock.c           |   31 +++-
 net/nfc/nci/core.c            |    5 +-
 net/nfc/nci/ntf.c             |    5 +-
 net/nfc/netlink.c             |    9 ++
 18 files changed, 663 insertions(+), 288 deletions(-)

-- 
1.7.10

