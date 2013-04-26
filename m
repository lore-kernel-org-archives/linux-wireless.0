Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:17955 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135Ab3DZX2M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 19:28:12 -0400
Date: Sat, 27 Apr 2013 01:28:05 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [GIT] [3.10] NFC pull request
Message-ID: <20130426232805.GB8192@zurbaran> (sfid-20130427_012816_412711_EA933857)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This pull request includes Marcel's Kconfig dependency fix on top of the LLCP
code move to net/nfc.

Thanks in advance for pulling these 2 in.

The following changes since commit b006ed545cbadf1ebd4683719554742d20dbcede:

  mwifiex: rework round robin scheduling of bss nodes. (2013-04-23 15:18:40 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.10-4

for you to fetch changes up to c204ea092eead40d2ac577fc3b5c77052ec22a59:

  NFC: Add missing RFKILL dependency for Kconfig (2013-04-27 01:02:46 +0200)

----------------------------------------------------------------
With this one we have:

- One patch for moving the LLCP code into net/nfc.
  It fixes a build annoyance reported by Dave Miller caused by the fact
  that the LLCP code object targets are not in the same directory as the
  Makefile trying to build them is. It prevents us from doing e.g.

        make net/nfc/llcp/sock.o

  Moving the LLCP code into net/nfc and not making it optional anymore
  makes sense as LLCP is a fundamental piece of the NFC specifications
  and thus should be in the core NFC directory.

- One patch that fixes the missing dependency against RFKILL. Without it NFC
  fails to properly build when it's builtin and CONFIG_RFKILL=m.

----------------------------------------------------------------
Marcel Holtmann (1):
      NFC: Add missing RFKILL dependency for Kconfig

Samuel Ortiz (1):
      NFC: Move LLCP code to the NFC top level diirectory

 net/nfc/Kconfig                              |    2 +-
 net/nfc/Makefile                             |    6 ++-
 net/nfc/{llcp => }/llcp.h                    |    0
 net/nfc/llcp/Kconfig                         |    7 ---
 net/nfc/{llcp/commands.c => llcp_commands.c} |    2 +-
 net/nfc/{llcp/llcp.c => llcp_core.c}         |    2 +-
 net/nfc/{llcp/sock.c => llcp_sock.c}         |    2 +-
 net/nfc/netlink.c                            |    3 +-
 net/nfc/nfc.h                                |   64 --------------------------
 9 files changed, 9 insertions(+), 79 deletions(-)
 rename net/nfc/{llcp => }/llcp.h (100%)
 delete mode 100644 net/nfc/llcp/Kconfig
 rename net/nfc/{llcp/commands.c => llcp_commands.c} (99%)
 rename net/nfc/{llcp/llcp.c => llcp_core.c} (99%)
 rename net/nfc/{llcp/sock.c => llcp_sock.c} (99%)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
