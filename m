Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39239 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab2K1Jmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:42:55 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm9so5345542wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:42:54 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 00/20] wlcore fixes for 3.8 (part3)
Date: Wed, 28 Nov 2012 11:42:29 +0200
Message-Id: <1354095769-8724-1-git-send-email-arik@wizery.com> (sfid-20121128_104301_028508_CF9B39E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series applies on top of part 2 sent a couple days ago.

The main addition is support for mac80211 HW queues and further
optimizations for Tx in the multi-channel case.

Arik Nemtsov (11):
  wlcore: remove support for injected Tx
  wlcore: improve handling for Rx errors
  wlcore: set 5Ghz probe-req template for DFS channels
  wlcore/wl18xx: change priority calculations for links
  wl18xx: limit Tx for the AP single-STA-in-PSM case
  wlcore: use link count for single-STA-PSM optimization
  wlcore: use separate HW queue for each AC in each vif
  wlcore: don't take mutex before stopping queues
  wlcore: consolidate Rx BA bitmap management to links struct
  wl18xx: support MIMO only if HT mode is not forced to SISO
  wl18xx: count HW block spare based correctly on keys

Eliad Peller (1):
  wlcore: add ACX_PEER_CAP command

Eyal Shapira (2):
  wlcore: increase scan dwell times if no activity
  wlcore: support scan reports during periodic scan

Ido Reis (1):
  wl12xx/wl18xx: update default fw logger's settings

Ido Yariv (1):
  wlcore: Always pass DMA-able buffers to mmc functions

Igal Chernobelsky (1):
  wlcore/wl18xx/wl12xx: FW log params per chip arch

Yair Shapira (3):
  wlcore: add new plt power-mode: CHIP_AWAKE
  wlcore: disable elp sleep while in plt mode
  wl18xx: fix a bug in wl->num_rx_desc initialization

 drivers/net/wireless/ti/wl12xx/event.c    |   10 +-
 drivers/net/wireless/ti/wl12xx/main.c     |   82 +++++++++--
 drivers/net/wireless/ti/wl12xx/wl12xx.h   |    2 +
 drivers/net/wireless/ti/wl18xx/acx.c      |   54 ++++++++
 drivers/net/wireless/ti/wl18xx/acx.h      |   33 +++++
 drivers/net/wireless/ti/wl18xx/event.c    |    8 ++
 drivers/net/wireless/ti/wl18xx/event.h    |    1 +
 drivers/net/wireless/ti/wl18xx/main.c     |  138 ++++++++++++++-----
 drivers/net/wireless/ti/wl18xx/scan.c     |   56 ++++----
 drivers/net/wireless/ti/wl18xx/scan.h     |   20 ++-
 drivers/net/wireless/ti/wl18xx/wl18xx.h   |   48 ++++++-
 drivers/net/wireless/ti/wlcore/acx.c      |    2 +
 drivers/net/wireless/ti/wlcore/cmd.c      |   11 +-
 drivers/net/wireless/ti/wlcore/conf.h     |   20 ++-
 drivers/net/wireless/ti/wlcore/debugfs.c  |    1 -
 drivers/net/wireless/ti/wlcore/event.c    |   15 +-
 drivers/net/wireless/ti/wlcore/event.h    |    2 -
 drivers/net/wireless/ti/wlcore/hw_ops.h   |   41 ++++++
 drivers/net/wireless/ti/wlcore/io.h       |   14 +-
 drivers/net/wireless/ti/wlcore/main.c     |  212 ++++++++++++++++++++++-------
 drivers/net/wireless/ti/wlcore/ps.c       |    4 +
 drivers/net/wireless/ti/wlcore/rx.c       |   29 ++--
 drivers/net/wireless/ti/wlcore/rx.h       |    3 +-
 drivers/net/wireless/ti/wlcore/scan.c     |   32 ++++-
 drivers/net/wireless/ti/wlcore/scan.h     |    2 +-
 drivers/net/wireless/ti/wlcore/testmode.c |   13 +-
 drivers/net/wireless/ti/wlcore/tx.c       |  158 +++++++++++----------
 drivers/net/wireless/ti/wlcore/tx.h       |   20 ++-
 drivers/net/wireless/ti/wlcore/wlcore.h   |   23 +++-
 drivers/net/wireless/ti/wlcore/wlcore_i.h |   14 +-
 30 files changed, 811 insertions(+), 257 deletions(-)

-- 
1.7.9.5

