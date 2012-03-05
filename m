Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8043 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab2CDX4l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:56:41 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 00/22] NFC changes for 3.4
Date: Mon,  5 Mar 2012 01:03:32 +0100
Message-Id: <1330905834-6994-1-git-send-email-sameo@linux.intel.com> (sfid-20120305_005720_252476_0494831F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is my NFC patchset for the next merge window.
I was hoping to include our HCI implementation, but it may have to wait a few
more days.
Anyway, the below patchset provides mostly LLCP fixes and enhancements. It
also implements the few missing NFC data exports from the pn533 driver, adds a
new powered netink attribute, and fixes the whole NFC code identation.

You can apply them manually or pull from here:

git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-3.0.git nfc-next

it should apply cleanly on top of wireless-next.

Samuel Ortiz (22):
  NFC: Export NFCID1 from pn533
  NFC: Add device powered netlink attribute
  NFC: Factorize the I frame queueing routine
  NFC: Handle Receiver Not Ready LLCP frame
  NFC: LLCP socket sendmsg implemetation
  NFC: Fix bitops usage in LLCP
  NFC: Clear pn533 target structure
  NFC: Clear LLCP SDPs whan MAC goes down
  NFC: Set the right LLCP N(R) value for I frames
  NFC: Send LLCP RR frames to acknowledge received I frames
  NFC: Set MIU and RW values from CONNECT and CC LLCP frames
  NFC: Fragment LLCP I frames
  NFC: Export sensf from pn533
  NFC: Export Jewel/Topaz ID from pn533
  NFC: Export NFCID when detecting a p2p target with pn533
  NFC: Unlink LLCP child sockets from llcp_sock_release
  NFC: SN is not an invalid GT value
  NFC: Remove the rf mode parameter from the DEP link up routine
  NFC: Fix LLCP sockets releasing path
  NFC: LLCP code identation fixes
  NFC: Core code identation fixes
  NFC: NCI code identation fixes

 drivers/nfc/pn533.c        |   31 ++++----
 include/linux/nfc.h        |    1 +
 include/net/nfc/nci_core.h |   10 +-
 include/net/nfc/nfc.h      |   30 +++----
 net/nfc/af_nfc.c           |    2 +-
 net/nfc/core.c             |   50 +++++------
 net/nfc/llcp/commands.c    |  163 ++++++++++++++++++++++++++++++++----
 net/nfc/llcp/llcp.c        |  201 +++++++++++++++++++++++++++-----------------
 net/nfc/llcp/llcp.h        |   12 ++-
 net/nfc/llcp/sock.c        |  120 ++++++++++++++++----------
 net/nfc/nci/core.c         |  113 ++++++++++++-------------
 net/nfc/nci/data.c         |   28 +++---
 net/nfc/nci/ntf.c          |   75 ++++++++---------
 net/nfc/nci/rsp.c          |   17 ++--
 net/nfc/netlink.c          |   71 +++++++--------
 net/nfc/nfc.h              |   18 ++--
 net/nfc/rawsock.c          |   16 ++--
 17 files changed, 573 insertions(+), 385 deletions(-)

-- 
1.7.7.3

