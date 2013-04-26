Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63884 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab3DZOVJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 10:21:09 -0400
Date: Fri, 26 Apr 2013 16:21:06 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [GIT] [3.10] NFC pull request
Message-ID: <20130426142106.GB4796@zurbaran> (sfid-20130426_162123_936277_AEBBCCC6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Another NFC pull request for 3.10, in order to address Dave's request for
cleaning the LLCP Makefile up. If it's too late for the 3.10 merge window, or
if you want me to rebase this code on top of net-next and send the pull
request directly to Dave, please let me know.

Here it goes:

The following changes since commit b006ed545cbadf1ebd4683719554742d20dbcede:

  mwifiex: rework round robin scheduling of bss nodes. (2013-04-23 15:18:40 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.10-3

for you to fetch changes up to 30cc4587659e1c9b1bfade8b2a757d91e04758ab:

  NFC: Move LLCP code to the NFC top level diirectory (2013-04-26 12:37:28 +0200)

----------------------------------------------------------------
The last NFC pull request for 3.10:

This one only contains one patch for moving the LLCP code into net/nfc.
It fixes a build annoyance reported by Dave Miller caused by the fact
that the LLCP code object targets are not in the same directory as the
Makefile trying to build them is. It prevents us from doing e.g.

	make net/nfc/llcp/sock.o

Moving the LLCP code into net/nfc and not making it optional anymore
makes sense as LLCP is a fundamental piece of the NFC specifications
and thus should be in the core NFC directory.

----------------------------------------------------------------
Samuel Ortiz (1):
      NFC: Move LLCP code to the NFC top level diirectory

 net/nfc/Kconfig                              |    1 -
 net/nfc/Makefile                             |    6 ++-
 net/nfc/{llcp => }/llcp.h                    |    0
 net/nfc/llcp/Kconfig                         |    7 ---
 net/nfc/{llcp/commands.c => llcp_commands.c} |    2 +-
 net/nfc/{llcp/llcp.c => llcp_core.c}         |    2 +-
 net/nfc/{llcp/sock.c => llcp_sock.c}         |    2 +-
 net/nfc/netlink.c                            |    3 +-
 net/nfc/nfc.h                                |   64 --------------------------
 9 files changed, 8 insertions(+), 79 deletions(-)
 rename net/nfc/{llcp => }/llcp.h (100%)
 delete mode 100644 net/nfc/llcp/Kconfig
 rename net/nfc/{llcp/commands.c => llcp_commands.c} (99%)
 rename net/nfc/{llcp/llcp.c => llcp_core.c} (99%)
 rename net/nfc/{llcp/sock.c => llcp_sock.c} (99%)


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
