Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:50894 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab3FFPUc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 11:20:32 -0400
Date: Thu, 6 Jun 2013 17:20:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@lists.01.org>
Subject: [GIT] [3.10] NFC fixes
Message-ID: <20130606152019.GT4793@zurbaran> (sfid-20130606_172035_949155_F73D8122)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the 2nd NFC pull request for 3.10.

I wish this one could have been part of the first one, but we came back from
the NFC plugfest with a few more LLCP fixes:

- The well known services bitmask was sent with the wrong endianness and with
  the first bit not set, which goes against the LLCP specifications. This
  won't prevent most use cases and tests to pass, only picky implementations
  seem to care about the WKS correctness.

- We were ignoring RNRs and were sending our pending frames regardless. We
  should just re-queue them and send a SYMM instead.

- Non blocking LLCP connections were not handled properly as we found out
  after implementing it from neard. Applications were immediatly woken up with
  a SIGHUP and connection failed. This is fixed now, allowing us to have a
  fully asynchronous NFC userspace daemon.

Thanks in advance for pulling them in.

The following changes since commit cee6dfa25831e0daac52fc582a04a7204f886220:

  Revert "ath9k_hw: Update rx gain initval to improve rx sensitivity" (2013-06-05 10:42:29 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes.git tags/nfc-fixes-3.10-2

for you to fetch changes up to fcd335b0010aeafb6e3dfd46360778ce59e1e201:

  NFC: llcp: Fix the well known services endianness (2013-06-06 16:43:51 +0200)

----------------------------------------------------------------
Samuel Ortiz (4):
      NFC: llcp: Fix non blocking sockets connections
      NFC: llcp: Do not send pending Tx frames when the remote is not ready
      NFC: llcp: Set the LLC Link Management well known service bit
      NFC: llcp: Fix the well known services endianness

 net/nfc/llcp.h      |    1 +
 net/nfc/llcp_core.c |    8 ++++++--
 net/nfc/llcp_sock.c |    8 +++++---
 3 files changed, 12 insertions(+), 5 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
