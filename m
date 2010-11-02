Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:19668 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab0KBTAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 15:00:22 -0400
Subject: pull request: wl12xx 2010-11-02
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 21:04:45 +0200
Message-ID: <1288724685.30476.14.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here's the first pull-request for 2.6.38.  It contains some bugfixes,
some improvements in TX handling and the beginning of 802.11n
implementation.

The patches have accumulated a bit, because of the merge window.

Please pull or let me know if there's any problem.  This tree is based
on wireless-next/master.

Thanks!

The following changes since commit 229aebb873e29726b91e076161649cf45154b0bf:
  Linus Torvalds (1):
        Merge branch 'for-next' of git://git.kernel.org/.../jikos/trivial

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git wl12xx-next

Eliad Peller (4):
      wl1271: set wl->vif only if add_interface succeeded.
      wl1271: refactor debugfs function generation code
      wl1271: handle HW watchdog interrupt
      wl1271: add recover testmode command

Gery Kahn (1):
      wl1271: ref_clock cosmetic changes

Ido Yariv (4):
      wl1271: TX aggregation optimization
      wl1271: Fix TX starvation
      wl1271: Allocate TX descriptors more efficiently
      wl1271: Fix TX queue low watermark handling

Juuso Oikarinen (3):
      wl1271: Fix RX path stall
      wl1271: Fix scan failure detection
      wl1271: Check interface state in op_* functions

Luciano Coelho (1):
      wl1271: exit ELP mode when setting enabled rates in tx

Nicolas Kaiser (1):
      wireless/wl1271: remove redundant if-statement v2

Shahar Levi (3):
      wl1271: 11n Support, Add Definitions
      wl1271: 11n Support, ACX Commands
      wl1271: 11n Support, functionality and configuration ability

Teemu Paasikivi (1):
      wl1271: Fix warning about unsupported RX rate

 drivers/net/wireless/wl12xx/Kconfig           |   10 +
 drivers/net/wireless/wl12xx/wl1271.h          |   13 ++-
 drivers/net/wireless/wl12xx/wl1271_acx.c      |   83 +++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h      |   89 ++++++++++-
 drivers/net/wireless/wl12xx/wl1271_boot.c     |   10 +-
 drivers/net/wireless/wl12xx/wl1271_debugfs.c  |  215 +++++++++++++------------
 drivers/net/wireless/wl12xx/wl1271_event.c    |    2 -
 drivers/net/wireless/wl12xx/wl1271_main.c     |  220 ++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/wl1271_rx.c       |   28 +++-
 drivers/net/wireless/wl12xx/wl1271_rx.h       |    2 +-
 drivers/net/wireless/wl12xx/wl1271_scan.c     |    5 +-
 drivers/net/wireless/wl12xx/wl1271_testmode.c |   12 ++
 drivers/net/wireless/wl12xx/wl1271_tx.c       |  132 ++++++++++-----
 drivers/net/wireless/wl12xx/wl1271_tx.h       |    3 +-
 include/linux/wl12xx.h                        |    8 +
 15 files changed, 624 insertions(+), 208 deletions(-)

-- 
Cheers,
Luca.

