Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9891 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab3CKMou (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 08:44:50 -0400
Date: Mon, 11 Mar 2013 13:44:47 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [GIT] [3.10] NFC pull request
Message-ID: <20130311124447.GA2164@zurbaran> (sfid-20130311_134453_863802_3B6A85AC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the first NFC pull request for the 3.10 kernel. I have now rebased
those changes on top of wireless-next and they build fine.

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

Thanks in advance for pulling them in.

The following changes since commit c678fb2a915b71f8faa78d9ab6d409b8ff3276cc:

  mwifiex: fix potential null dereference 'mef_entry' (2013-03-08 16:02:48 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.10-1

for you to fetch changes up to 40213fa8513c2a92e7390f25571f7c17c7955e2b:

  NFC: llcp: Add cleanup support for unreplied SNL requests (2013-03-10 23:16:41 +0100)

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
 net/nfc/llcp/llcp.c         |  112 ++++++++++++++++++++---
 net/nfc/llcp/llcp.h         |   36 +++++++-
 net/nfc/llcp/sock.c         |  130 +++++++++++++++++++++++++--
 net/nfc/netlink.c           |  172 ++++++++++++++++++++++++++++++++++++
 net/nfc/nfc.h               |   14 +++
 9 files changed, 634 insertions(+), 54 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
