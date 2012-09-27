Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19496 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab2I0Jyz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 05:54:55 -0400
Date: Thu, 27 Sep 2012 11:54:51 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@lists.01.org>
Subject: [GIT] [3.7] 2nd NFC pull request
Message-ID: <20120927095451.GA21047@sortiz-mobl> (sfid-20120927_115458_722097_02902BE1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is my 2nd pull NFC pull request for 3.7. It includes your build fix and
also a couple of 3.6 potential material. I just assumed it would be too late
for them to make it to 3.6 so I queued them here.
Please let me know if there is still time for 3.6 fixes.

With this pull request we have:

- A couple of wrong context sleep fixes.
- An LLCP rwlock intizialisation fix.
- A missing mutex unlocking for pn533.
- LLCP raw sockets support. This is going to be used for NFC sniffing.
- A build fix for llc_shdlc. It fixes a build error triggered by code that's
  living in wireless-next.

Thanks in advance for pulling them in.

The following changes since commit 944f8a1a6f5ff8b503f3544811d0aa4ac27dd2aa:

  ath5k: add missing breaks in ath5k_hw_set_spur_mitigation_filter (2012-09-25 15:57:44 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-3.0.git tags/nfc-next-3.7-2

for you to fetch changes up to 50b78b2a6500d0e97c204c1b6c51df8c17358bbe:

  NFC: Fix sleeping in atomic when releasing socket (2012-09-27 10:52:22 +0200)

John W. Linville (1):
      NFC: Add dummy nfc_llc_shdlc_register definition

Szymon Janc (4):
      NFC: Use dynamic initialization for rwlocks
      NFC: Fix missing mutex unlock in pn533_send_cmd_frame_async
      NFC: Fix sleeping in invalid context when netlink socket is closed
      NFC: Fix sleeping in atomic when releasing socket

Thierry Escande (1):
      NFC: LLCP raw socket support

 drivers/nfc/pn533.c     |   15 ++++----
 include/linux/nfc.h     |   11 ++++++
 net/nfc/hci/llc.h       |    8 +++++
 net/nfc/llcp/commands.c |    2 ++
 net/nfc/llcp/llcp.c     |   60 +++++++++++++++++++++++++++----
 net/nfc/llcp/llcp.h     |    3 ++
 net/nfc/llcp/sock.c     |   90 ++++++++++++++++++++++++++++++++++++++++++++---
 net/nfc/netlink.c       |   46 ++++++++++++++++++++----
 8 files changed, 210 insertions(+), 25 deletions(-)


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
