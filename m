Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:46930 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014Ab3CaX0R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Mar 2013 19:26:17 -0400
Date: Mon, 1 Apr 2013 01:26:10 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [GIT] [3.9] NFC fixes
Message-ID: <20130331232610.GQ2153@zurbaran> (sfid-20130401_012629_677408_C45270B8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the 2nd batch of NFC fixes for 3.9. This time we have:

- A crash fix for when a DGRAM LLCP socket is listening while the NFC adapter
  is physically removed.
- A potential double skb free when the LLCP socket receive queue is full.
- A fix for properly handling multiple and consecutive LLCP connections, and
  not trash the socket ack log.
- A build failure for the MEI microread physical layer, now that the MEI bus
  APIs have been merged into char-misc-next.

The following changes since commit 36ef0b473fbf43d5db23eea4616cc1d18cec245f:

  rtlwifi: usb: add missing freeing of skbuff (2013-03-18 15:20:38 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes.git tags/nfc-fixes-3.9-2

for you to fetch changes up to 9593b0b1179c526436f14849a9587fd2aae12040:

  NFC: microread: Fix build failure due to a new MEI bus API (2013-04-01 00:52:42 +0200)

----------------------------------------------------------------
Samuel Ortiz (3):
      NFC: llcp: Detach socket from process context only when releasing the socket
      NFC: llcp: Keep the connected socket parent pointer alive
      NFC: microread: Fix build failure due to a new MEI bus API

Thierry Escande (1):
      NFC: llcp: Remove possible double call to kfree_skb

 drivers/nfc/microread/mei.c |   38 +++++++++++++++++---------------------
 net/nfc/llcp/llcp.c         |    8 --------
 net/nfc/llcp/sock.c         |    6 +++---
 3 files changed, 20 insertions(+), 32 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
