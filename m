Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:38899 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752148Ab2CMCfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 22:35:32 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 00/15] mwifiex: coding style cleanups
Date: Mon, 12 Mar 2012 19:35:07 -0700
Message-Id: <1331606116-32745-1-git-send-email-bzhao@marvell.com> (sfid-20120313_033536_406796_B0307C9C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This series of patches takes care of the coding style issues
in mwifiex driver.

These patches have been checked with "checkpatch.pl --strict"
using the patch from Joe Perches <joe@perches.com>:

[PATCH v3] checkpatch: Add some --strict coding style checks

Argument alignment across multiple lines should
match the open parenthesis.

Logical continuations should be at the end of
the previous line, not the start of a new line.

These are not required by CodingStyle so make the
tests active only when using --strict.

Improved_by_examples_from: "Bruce W. Allen" <bruce.w.allan@intel.com>
Signed-off-by: Joe Perches <joe@perches.com>

V3: Use perl 5.10 features
    Use a runtime check of perl version so $balanced_parens
    is not used in perl versions that don't support it.
    Update memset and min_t checks for newer $balanced_parens
    test.
    Improve alignment position test.
    Add message suggesting perl upgrade.
V2: Scan the entire line for balanced parentheses,
    use the position of the last non-balanced open parenthesis.
    Allow all space indentation too, checkpatch will complain
    in a different message about that if it's too long.

 scripts/checkpatch.pl |   94 +++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 84 insertions(+), 10 deletions(-)


Thanks,
Bing

--
Yogesh Ashok Powar (15):
  mwifiex: rename long function names to shorter ones
  mwifiex: rearrange switch statement
  mwifiex: merge functions to derive cfp by chan & freq in one
  mwifiex: use usleep_range instead of udelay
  mwifiex: rearrange if and else blocks to avoid extra indentation
  mwifiex: rename fuctions and variables for better readability
  mwifiex: fix checkpatch --strict warnings/errors  Part 1
  mwifiex: fix checkpatch --strict warnings/errors  Part 2
  mwifiex: fix checkpatch --strict warnings/errors  Part 3
  mwifiex: fix checkpatch --strict warnings/errors  Part 4
  mwifiex: fix checkpatch --strict warnings/errors  Part 5
  mwifiex: fix checkpatch --strict warnings/errors  Part 6
  mwifiex: fix checkpatch --strict warnings/errors  Part 7
  mwifiex: fix checkpatch --strict warnings/errors  Part 8
  mwifiex: fix checkpatch --strict warnings/errors  Part 9

 drivers/net/wireless/mwifiex/11n.c           |   82 +++----
 drivers/net/wireless/mwifiex/11n.h           |   16 +-
 drivers/net/wireless/mwifiex/11n_aggr.c      |   15 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |  207 ++++++++--------
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    5 +-
 drivers/net/wireless/mwifiex/cfg80211.c      |   83 +++---
 drivers/net/wireless/mwifiex/cfp.c           |   90 +++-----
 drivers/net/wireless/mwifiex/cmdevt.c        |  147 ++++++------
 drivers/net/wireless/mwifiex/fw.h            |    4 +-
 drivers/net/wireless/mwifiex/init.c          |   32 +--
 drivers/net/wireless/mwifiex/join.c          |  156 ++++++------
 drivers/net/wireless/mwifiex/main.c          |   44 ++--
 drivers/net/wireless/mwifiex/main.h          |   19 +-
 drivers/net/wireless/mwifiex/pcie.c          |  255 ++++++++++----------
 drivers/net/wireless/mwifiex/scan.c          |  335 ++++++++++++-------------
 drivers/net/wireless/mwifiex/sdio.c          |  163 ++++++------
 drivers/net/wireless/mwifiex/sta_cmd.c       |  175 +++++++-------
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |  348 ++++++++++++--------------
 drivers/net/wireless/mwifiex/sta_event.c     |   37 ++--
 drivers/net/wireless/mwifiex/sta_ioctl.c     |  115 ++++-----
 drivers/net/wireless/mwifiex/sta_rx.c        |   12 +-
 drivers/net/wireless/mwifiex/sta_tx.c        |   21 +-
 drivers/net/wireless/mwifiex/txrx.c          |   13 +-
 drivers/net/wireless/mwifiex/util.c          |   20 +-
 drivers/net/wireless/mwifiex/wmm.c           |  158 ++++++------
 25 files changed, 1227 insertions(+), 1325 deletions(-)

