Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:37223 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbYGXHMU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 03:12:20 -0400
Date: Thu, 24 Jul 2008 03:12:18 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: pull request: my-wireless-testing.git ath9k 2008-07-24
Message-ID: <20080724071218.GV17936@ruslug.rutgers.edu> (sfid-20080724_091229_406319_DFED4571)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was becoming painful to keep patches in a directory so
instead I've set up a tree you can pull from. Hope this helps
ease the merge in of ath9k.

The following changes since commit a520bdbe7d344296482f9355e29b0018ea58760f:
  John W. Linville (1):
        iwl-scan.c: fixup merge damage in wireless-testing#master

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/my-wireless-testing.git ath9k

Christoph Hellwig (2):
      The test_bit/set_bit/etc family of routines operates on arrays of
      ath9: endianess fixes

Felix Fietkau (6):
      Replace udelay(3000) with mdelay(3)
      Add missing include statements
      Add missing device ID for AR9160
      Fix a return code check for ath9k_hw_nvram_read
      Remove the descriptor swap
      DMA descriptors must always be accessed in native endianness.

Luis R. Rodriguez (4):
      Add new Atheros IEEE 802.11n ath9k driver
      Remove Atheros 11n devices from ath5k
      list.h: Add list_splice_tail() and list_splice_tail_init()
      list.h: add list_cut_position()

Pavel Roskin (2):
      Avoid comparison of incompatible types.
      Use skb_end_pointer(skb), not skb->end

Sujith Manoharan (9):
      Use ath9k_hw_set11nmac2040 directly instead of ath_set_macmode
      move chainmask selection to ath_vap_up()
      call ath_vap_join() to set the bssid
      get beacon from mac80211
      Add IBSS interface creation feature
      Use dev_kfree_skb_any()
      Cleanup VAP management
      No multiple VAP support for now
      ath_setrxfilter is unused, remove it

Vasantha kumar Thiagaranjan (2):
      Configure the h/w with appropriate tx power
      Remove ineffective function call in ath_update_txpow()

 MAINTAINERS                              |    9 +
 drivers/net/wireless/Kconfig             |    1 +
 drivers/net/wireless/Makefile            |    1 +
 drivers/net/wireless/ath5k/base.c        |    2 -
 drivers/net/wireless/ath9k/Kconfig       |    8 +
 drivers/net/wireless/ath9k/Makefile      |   11 +
 drivers/net/wireless/ath9k/ath9k.h       | 1189 ++++
 drivers/net/wireless/ath9k/beacon.c      | 1033 ++++
 drivers/net/wireless/ath9k/core.c        | 2024 +++++++
 drivers/net/wireless/ath9k/core.h        | 1139 ++++
 drivers/net/wireless/ath9k/hw.c          | 8618 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/hw.h          |  969 ++++
 drivers/net/wireless/ath9k/initvals.h    | 3146 +++++++++++
 drivers/net/wireless/ath9k/main.c        | 1650 ++++++
 drivers/net/wireless/ath9k/phy.c         |  451 ++
 drivers/net/wireless/ath9k/phy.h         |  543 ++
 drivers/net/wireless/ath9k/rc.c          | 2131 ++++++++
 drivers/net/wireless/ath9k/rc.h          |  316 ++
 drivers/net/wireless/ath9k/recv.c        | 1395 +++++
 drivers/net/wireless/ath9k/reg.h         | 1385 +++++
 drivers/net/wireless/ath9k/regd.c        | 1078 ++++
 drivers/net/wireless/ath9k/regd.h        |  415 ++
 drivers/net/wireless/ath9k/regd_common.h | 1915 +++++++
 drivers/net/wireless/ath9k/xmit.c        | 2873 ++++++++++
 include/linux/list.h                     |   77 +-
 25 files changed, 32376 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/wireless/ath9k/Kconfig
 create mode 100644 drivers/net/wireless/ath9k/Makefile
 create mode 100644 drivers/net/wireless/ath9k/ath9k.h
 create mode 100644 drivers/net/wireless/ath9k/beacon.c
 create mode 100644 drivers/net/wireless/ath9k/core.c
 create mode 100644 drivers/net/wireless/ath9k/core.h
 create mode 100644 drivers/net/wireless/ath9k/hw.c
 create mode 100644 drivers/net/wireless/ath9k/hw.h
 create mode 100644 drivers/net/wireless/ath9k/initvals.h
 create mode 100644 drivers/net/wireless/ath9k/main.c
 create mode 100644 drivers/net/wireless/ath9k/phy.c
 create mode 100644 drivers/net/wireless/ath9k/phy.h
 create mode 100644 drivers/net/wireless/ath9k/rc.c
 create mode 100644 drivers/net/wireless/ath9k/rc.h
 create mode 100644 drivers/net/wireless/ath9k/recv.c
 create mode 100644 drivers/net/wireless/ath9k/reg.h
 create mode 100644 drivers/net/wireless/ath9k/regd.c
 create mode 100644 drivers/net/wireless/ath9k/regd.h
 create mode 100644 drivers/net/wireless/ath9k/regd_common.h
 create mode 100644 drivers/net/wireless/ath9k/xmit.c
