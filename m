Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47006 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab2K0GpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:07 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so3808120wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:06 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 00/20] wlcore fixes for 3.8 (part2)
Date: Tue, 27 Nov 2012 08:44:41 +0200
Message-Id: <1353998701-18171-1-git-send-email-arik@wizery.com> (sfid-20121127_074516_007905_3D91AB59)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series applies on top of part 1 sent yesterday.

The main addition is a new Tx scheduling algorithm for
better multi-channel operation.

Arik Nemtsov (9):
  wlcore: clear roc_vif on iface removal
  wlcore: take the mutex before resetting Tx queues
  wlcore: consolidate free_link and always call it
  wlcore: initialize per-link FW freed blocks correctly
  wlcore: track wlvif inside per-link structure
  wlcore: count packets held per AC in each vif
  wlcore: track FW-allocated packets per link
  wlcore: improved Tx scheduling algorithm
  wl18xx: set last Tx rate from FW status

Eliad Peller (4):
  wlcore: allow fw commands to fail
  wlcore: allow ACX_BA_SESSION_RX_SETUP to fail
  wlcore: remove WLCORE_QUIRK_NO_ELP
  wl18xx: declare support for greenfield ht_cap

Ido Reis (3):
  wl18xx: update default mac/phy parameters
  wlcore: fwlog dynamic mem_block control
  wl18xx: FDSP Code RAM Corruption fix

Ido Yariv (1):
  wlcore: Allow memory access when the FW crashes

Victor Goldenshtein (2):
  wlcore: remove unnecessary WARN_ON in wl12xx_tx_reset
  wlcore: restore default channel configuration

Yair Shapira (1):
  wl18xx: support 2nd set of mac/phy tx-power params

 drivers/net/wireless/ti/wl12xx/main.c     |    2 +
 drivers/net/wireless/ti/wl18xx/conf.h     |   21 +++-
 drivers/net/wireless/ti/wl18xx/main.c     |   87 +++++++++++---
 drivers/net/wireless/ti/wl18xx/reg.h      |   20 ++++
 drivers/net/wireless/ti/wl18xx/tx.c       |   56 ++++++++-
 drivers/net/wireless/ti/wlcore/acx.c      |   13 ++-
 drivers/net/wireless/ti/wlcore/cmd.c      |   96 +++++++++++++---
 drivers/net/wireless/ti/wlcore/cmd.h      |    7 +-
 drivers/net/wireless/ti/wlcore/conf.h     |   76 ++++++++++---
 drivers/net/wireless/ti/wlcore/debugfs.c  |    8 +-
 drivers/net/wireless/ti/wlcore/init.c     |    3 -
 drivers/net/wireless/ti/wlcore/main.c     |  176 ++++++++++++++++++-----------
 drivers/net/wireless/ti/wlcore/ps.c       |    8 +-
 drivers/net/wireless/ti/wlcore/tx.c       |  157 +++++++++++++++++--------
 drivers/net/wireless/ti/wlcore/wlcore.h   |    9 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h |   13 ++-
 16 files changed, 566 insertions(+), 186 deletions(-)

-- 
1.7.9.5

