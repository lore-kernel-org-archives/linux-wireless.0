Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20583 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbdDMI2z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 04:28:55 -0400
Subject: [PATCH v7 00/10] ath10k: sdio support
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Thu, 13 Apr 2017 11:28:44 +0300
Message-ID: <149207201649.4590.5821794186383265138.stgit@potku.adurom.net> (sfid-20170413_102901_004507_4F9500E0)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

More changes to Erik's SDIO patches. The biggest change in this round
is refactoring of the ugly ath10k_sdio_io() function.

Only compile tested, I don't have any SDIO boards at the moment.

Changes in v7:

* fix mutex unlock bug found by kbuild bot

* fix function rename mistake found by Ryan

* rename patch title to "ath10k: different fw file name for sdio"
  found by Ryan

* fix a conflict in patch 4 ath10k_htc_control_rx_complete() due to
  rebase to latest ath.git master branch

* move FIFO_TIMEOUT defines to sdio.h and ATH10K_ prefix

* refactored ath10k_sdio_io() and ath10k_sdio_read_write_sync() to
  more simple functions, should also fix the remaining memory leaks
  and endian conversion problems

* write commit log for patch "ath10k: sdio support"

* improve Kconfig description

Changes in v6:

* resubmit due to stgit problems

Changes in v5:

* promote from RFC to PATCH

* move "ath10k: sdio support" patch to last

* in "ath10k: sdio get target info" fix sparse warning by changing tmp
  variable to __le32:

drivers/net/wireless/ath/ath10k/bmi.c:145:19: warning: cast to restricted __le32

* fix checkpatch warnings by renaming to struct ath10k_htc_lookahead_bundle:

drivers/net/wireless/ath/ath10k/htc.c:265: line over 90 characters
drivers/net/wireless/ath/ath10k/htc.c:357: line over 90 characters

* use switch statement in ath10k_core_get_fw_name()

* remove enable of fwlog from ath10k_sdio_extra_initialization(),
  that's not sdio specific and should be enabled separately (with a
  module parameter?)

* rename ath10k_sdio_extra_initialization() to ath10k_init_sdio()

* add warning to probe() that sdio support is not complete

* unify error and debug messagess

* whitespace changes

* move variable declarations to the beginning of the function

* remove unnecessary gotos

* small cosmetic changes

* add FIXME comments to unclear cases

---

Erik Stromdahl (10):
      ath10k: htc: made static function public
      ath10k: htc: rx trailer lookahead support
      ath10k: htc: move htc ctrl ep connect to htc_init
      ath10k: htc: refactorization
      ath10k: various sdio related definitions
      ath10k: add sdio extra initializations
      ath10k: sdio get target info
      ath10k: htc: ready_ext msg support
      ath10k: different fw file name for sdio
      ath10k: add initial SDIO support


 drivers/net/wireless/ath/ath10k/Kconfig     |    7 
 drivers/net/wireless/ath/ath10k/Makefile    |    3 
 drivers/net/wireless/ath/ath10k/bmi.c       |   71 +
 drivers/net/wireless/ath/ath10k/bmi.h       |    2 
 drivers/net/wireless/ath/ath10k/core.c      |   36 
 drivers/net/wireless/ath/ath10k/core.h      |    3 
 drivers/net/wireless/ath/ath10k/debug.h     |    2 
 drivers/net/wireless/ath/ath10k/htc.c       |  244 ++-
 drivers/net/wireless/ath/ath10k/htc.h       |   39 
 drivers/net/wireless/ath/ath10k/hw.h        |   53 +
 drivers/net/wireless/ath/ath10k/sdio.c      | 2113 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/sdio.h      |  229 +++
 drivers/net/wireless/ath/ath10k/targaddrs.h |   24 
 13 files changed, 2749 insertions(+), 77 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/sdio.c
 create mode 100644 drivers/net/wireless/ath/ath10k/sdio.h
