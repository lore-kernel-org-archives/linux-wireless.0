Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:33148 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755364Ab1EEQiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 12:38:22 -0400
Received: by mail-ey0-f171.google.com with SMTP id d26so940672eyd.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2011 09:38:21 -0700 (PDT)
Subject: pull request: wl12xx 2011-05-05
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 19:38:18 +0300
Message-ID: <1304613498.12586.417.camel@cumari> (sfid-20110505_183826_591329_F44D37BD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello John,

One more pull for 2.6.40.  I've held this back a bit so that we could
run some tests internally.  In this series we add BT-coexistence in AP
mode, FM-coexistence, some more debugging info into debugfs, some fixes
in the chip's powersave modes and other small improvements and fixes.
This also includes the revert we talked about earlier.

Please pull or let me know if there's any problem.  This tree is based
on wireless-next/master.

Thanks!


The following changes since commit ff776cecec92fe7cac4a9ce1919576ad6e737e08:

  mwl8k: Reducing extra_tx_headroom for tx optimization in AP mode (2011-04-29 15:36:15 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linville

Arik Nemtsov (12):
      wl12xx: implement the tx_frames_pending mac80211 callback
      wl12xx: discard corrupted packets in RX
      wl12xx: add BT-coexistance for AP
      wl12xx: use wiphy values for setting rts, frag thresholds on init
      wl12xx: AP-mode - disable beacon filtering on start up
      wl12xx: schedule recovery on command timeout
      wl12xx: print firmware program counter during recovery
      wl12xx: AP-mode - overhaul rate policy configuration
      wl12xx: AP-mode - reconfigure templates after basic rates change
      wl12xx: add debugfs entry for starting recovery
      wl12xx: fix race condition during recovery in AP mode
      wl12xx: export driver state to debugfs

Eliad Peller (6):
      wl12xx: sleep instead of wakeup after tx work
      wl12xx: avoid premature elp entrance
      wl12xx: print actual rx packet size (without padding)
      wl12xx: avoid redundant join on interface reconfiguration
      wl12xx: configure rates when working in ibss mode
      wl12xx: add debugfs entries for dtim_interval and beacon_interval

Hauke Mehrtens (1):
      wl12xx: do not set queue_mapping directly

Ido Yariv (3):
      wl12xx: Modify memory configuration for 128x/AP
      wl12xx: Restart TX when TX descriptors are available
      wl12xx: Enable dynamic memory for 127x

Luciano Coelho (2):
      wl12xx: strict_stroul introduced converted to kstrtoul
      Revert "wl12xx: support FW TX inactivity triggers"

Shahar Levi (4):
      wl12xx: Set End-of-transaction Flag at Wl127x AP Mode
      wl12xx: Set correct REF CLK and TCXO CLK values to the FW
      wl12xx: FM WLAN coexistence
      wl12xx: Update Power Save Exit Retries Packets

 drivers/net/wireless/wl12xx/acx.c     |  190 +++++++++++++++++++-------
 drivers/net/wireless/wl12xx/acx.h     |  103 ++++++++++++---
 drivers/net/wireless/wl12xx/boot.c    |    6 +-
 drivers/net/wireless/wl12xx/cmd.c     |   18 ++-
 drivers/net/wireless/wl12xx/conf.h    |   90 +++++++++----
 drivers/net/wireless/wl12xx/debugfs.c |  239 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/event.c   |   47 -------
 drivers/net/wireless/wl12xx/event.h   |   12 +--
 drivers/net/wireless/wl12xx/init.c    |  110 +++++++++++----
 drivers/net/wireless/wl12xx/init.h    |    2 +
 drivers/net/wireless/wl12xx/main.c    |  232 ++++++++++++++++++++++----------
 drivers/net/wireless/wl12xx/ps.c      |   30 ++++-
 drivers/net/wireless/wl12xx/rx.c      |   36 ++++-
 drivers/net/wireless/wl12xx/tx.c      |   13 ++-
 drivers/net/wireless/wl12xx/tx.h      |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h  |    2 +
 16 files changed, 852 insertions(+), 280 deletions(-)


-- 
Cheers,
Luca.

