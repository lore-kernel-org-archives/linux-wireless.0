Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:4126 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632Ab1LNPiX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 10:38:23 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 0/8] NFC update
Date: Wed, 14 Dec 2011 16:43:04 +0100
Message-Id: <1323877392-20567-1-git-send-email-sameo@linux.intel.com> (sfid-20111214_163826_518743_9E3B90AB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This NFC update includes adding function names to the NFC pr_fmt(), new
skb allocation routines, a locking fix and an atomic allocation one.
Patches 5,6 and 7 are preparation for the LLCP implementation. The last
one is the actual LLCP (a.k.a. NFC peer to peer mode) implementation.

Samuel Ortiz (8):
  NFC: Add function name to the NFC pr_fmt() routine
  NFC: Add tx skb allocation routine
  NFC: Do not take the genl mutex from the netlink release notifier
  NFC: Atomic socket allocation
  NFC: Add a DEP link control netlink command
  NFC: Set and get DEP general bytes
  NFC: DEP link hook implementation for pn533
  NFC: Initial LLCP support

 drivers/nfc/pn533.c     |  168 ++++++++-
 include/linux/nfc.h     |   29 ++-
 include/net/nfc/nfc.h   |   21 +-
 net/nfc/Kconfig         |    1 +
 net/nfc/Makefile        |    1 +
 net/nfc/core.c          |  143 +++++++-
 net/nfc/llcp/Kconfig    |    7 +
 net/nfc/llcp/commands.c |  399 +++++++++++++++++++
 net/nfc/llcp/llcp.c     |  973 +++++++++++++++++++++++++++++++++++++++++++++++
 net/nfc/llcp/llcp.h     |  193 ++++++++++
 net/nfc/llcp/sock.c     |  675 ++++++++++++++++++++++++++++++++
 net/nfc/nci/core.c      |    2 +-
 net/nfc/nci/data.c      |    2 +-
 net/nfc/nci/ntf.c       |    2 +-
 net/nfc/nci/rsp.c       |    2 +-
 net/nfc/netlink.c       |  148 +++++++-
 net/nfc/nfc.h           |   63 +++
 net/nfc/rawsock.c       |   11 +-
 18 files changed, 2818 insertions(+), 22 deletions(-)
 create mode 100644 net/nfc/llcp/Kconfig
 create mode 100644 net/nfc/llcp/commands.c
 create mode 100644 net/nfc/llcp/llcp.c
 create mode 100644 net/nfc/llcp/llcp.h
 create mode 100644 net/nfc/llcp/sock.c

-- 
1.7.7.3

