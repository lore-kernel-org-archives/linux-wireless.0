Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58327 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab3CHLoU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 06:44:20 -0500
Date: Fri, 8 Mar 2013 12:44:06 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@lists.01.org>
Subject: [GIT] [3.10] NFC pull request
Message-ID: <20130308114406.GB27873@sortiz-mobl> (sfid-20130308_124424_010162_0254CAAF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the first NFC pull request for 3.10.

The 2 features we have with this one are:

- An LLCP Service Name Lookup (SNL) netlink interface for querying LLCP
  service availability from user space.
  Along the way, Thierry also improved the existing SNL interface for
  aggregating SNL responses.

- An initial LLCP socket options implementation, for setting the Receive
  Window (RW) and the Maximum Information Unit Extension (MIUX) per socket.
  This is need for the LLCP validation tests.

We also have a microread MEI build failure here: I am not sending this one to
3.9 because the MEI bus code is not there yet, so it won't break for anyone
else than me.

Thanks in advance for pulling those changes in.

The following changes since commit cd48d8ba149484c4723a2b75159deeb83f3d2273:

  NFC: microread: Fix mei physical layer (2013-02-11 18:35:36 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.10-1

for you to fetch changes up to ec97c981a6760f85543520fef40bfde32fe82b4a:

  NFC: llcp: Add cleanup support for unreplied SNL requests (2013-03-07 20:11:12 +0100)

----------------------------------------------------------------
Samuel Ortiz (5):
      NFC: microread: Fix MEI build failure
      NFC: llcp: Rename socket rw and miu fields
      NFC: llcp: Implement socket options
      NFC: llcp: Use socket specific link parameters before the local ones
      NFC: llcp: Remove redundant printk

Thierry Escande (4):
      NFC: Add missing type policies for netlink attributes
      NFC: llcp: Service Name Lookup SDRES aggregation
      NFC: llcp: Service Name Lookup netlink interface
      NFC: llcp: Add cleanup support for unreplied SNL requests

 drivers/nfc/microread/mei.c |    2 +-
 include/linux/socket.h      |    1 +
 include/uapi/linux/nfc.h    |   16 ++++
 net/nfc/llcp/commands.c     |  205 +++++++++++++++++++++++++++++++++++--------
 net/nfc/llcp/llcp.c         |  114 +++++++++++++++++++++---
 net/nfc/llcp/llcp.h         |   36 +++++++-
 net/nfc/llcp/sock.c         |  130 +++++++++++++++++++++++++--
 net/nfc/netlink.c           |  172 ++++++++++++++++++++++++++++++++++++
 net/nfc/nfc.h               |   14 +++
 9 files changed, 636 insertions(+), 54 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
