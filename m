Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:37708 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab2I0Kig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:36 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 00/31] wlcore/wl18xx/wl12xx patches for 3.7
Date: Thu, 27 Sep 2012 13:37:38 +0300
Message-Id: <1348742289-6587-1-git-send-email-luca@coelho.fi> (sfid-20120927_124018_344117_112EF8E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is a bunch of patches that have accumulated in our internal tree
and are intended for 3.7.  Mostly bug-fixes and small improvements all
over.

Cheers,
Luca.

Arik Nemtsov (9):
  wlcore: AP mode - send non-data packets with basic rates
  wlcore: allow only the lowest OFDM rate for p2p setup frames
  wlcore: make Tx flush timings more verbose
  wlcore: tx_flush - optimize flow and force Tx during the flush
  wlcore/wl18xx/wl12xx: allow up to 3 mac addresses
  wlcore: make debug prints work without dynamic debug
  wlcore: allow up to 3 running STA interfaces in combinations
  wlcore: spi: use private max-buf-size limit
  wl18xx: default to siso40 in 2.4ghz with a single antenna

Eliad Peller (9):
  wlcore: consider single fw case
  wlcore: cancel recovery_work on stop() instead of remove_interface()
  wlcore: resume() only if sta is associated
  wlcore: always use wlvif->role_id for scans
  wlcore: lazy-enable device roles
  wlcore: invalidate keep-alive template on disconnection
  wlcore: use dynamic keep-alive template ids
  wlcore: decrease elp timeout
  wlcore: protect wlcore_op_set_key with mutex

Eyal Shapira (1):
  wlcore: configure wowlan regardless of wakeup conditions

Ido Reis (2):
  wl18xx: update default phy configuration for pg2
  wl18xx: increase rx_ba_win_size to 32

Ido Yariv (6):
  wlcore: Prevent interaction with HW after recovery is queued
  wlcore: Don't recover during boot
  wlcore: Fix unbalanced interrupts enablement
  wlcore: Allow memory access when the FW crashes
  wlcore: Refactor probe
  wlcore: Load the NVS file asynchronously

Igal Chernobelsky (2):
  wl18xx/wl12xx: defines for Tx/Rx descriptors num
  wlcore/wl18xx/wl12xx: aggregation buffer size set

Yair Shapira (2):
  wl18xx: number_of_assembled_ant5 indicates if A band is enabled
  wlcore/wl18xx: add phy_fw_version_str to debugfs driver_state

 drivers/net/wireless/ti/wl12xx/main.c     |   66 ++++--
 drivers/net/wireless/ti/wl12xx/wl12xx.h   |    7 +
 drivers/net/wireless/ti/wl18xx/debugfs.c  |    2 +-
 drivers/net/wireless/ti/wl18xx/main.c     |  115 ++++-----
 drivers/net/wireless/ti/wl18xx/wl18xx.h   |    7 +
 drivers/net/wireless/ti/wlcore/cmd.c      |   21 +-
 drivers/net/wireless/ti/wlcore/cmd.h      |    5 -
 drivers/net/wireless/ti/wlcore/conf.h     |    3 +-
 drivers/net/wireless/ti/wlcore/debug.h    |   16 +-
 drivers/net/wireless/ti/wlcore/debugfs.c  |   32 ++-
 drivers/net/wireless/ti/wlcore/init.c     |   12 +-
 drivers/net/wireless/ti/wlcore/io.h       |    4 +-
 drivers/net/wireless/ti/wlcore/main.c     |  365 +++++++++++++++++------------
 drivers/net/wireless/ti/wlcore/ps.c       |   10 +-
 drivers/net/wireless/ti/wlcore/rx.c       |    2 +-
 drivers/net/wireless/ti/wlcore/scan.c     |   20 +-
 drivers/net/wireless/ti/wlcore/spi.c      |   10 +-
 drivers/net/wireless/ti/wlcore/testmode.c |    4 +-
 drivers/net/wireless/ti/wlcore/tx.c       |   51 ++--
 drivers/net/wireless/ti/wlcore/wlcore.h   |   23 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h |   13 +-
 21 files changed, 473 insertions(+), 315 deletions(-)

-- 
1.7.10.4

