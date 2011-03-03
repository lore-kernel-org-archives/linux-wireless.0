Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:34848 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932123Ab1CCQ6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 11:58:00 -0500
Received: by mail-ww0-f43.google.com with SMTP id 15so1223783wwe.12
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 08:57:58 -0800 (PST)
Subject: pull request: wl12xx 2011-03-03
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 18:58:01 +0200
Message-ID: <1299171481.7039.72.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

One more pull request for 2.6.39, most likely the last.  The biggest
change is a series of patches to improve throughput by Ido.  The other
patches are mainly bugfixes and small cleanups.

Please pull or let me know if there's any problem.  This tree is based
on wireless-next/master.

Thanks!

The following changes since commit e46395a4b3d32d161d8b6d8e4a002972b1faae3e:

  mac80211: make rate control Kconfig warning depend on mac80211 (2011-03-01 13:48:22 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linville

Arik Nemtsov (1):
      wl12xx: wakeup chip from ELP during scan

Helmut Schaa (1):
      wl12xx: Correctly set up protection if non-GF STAs are present

Ido Yariv (9):
      wl12xx: Don't rely on runtime PM for toggling power
      wl12xx: Remove private headers in wl1271_tx_reset
      wl12xx: Reorder data handling in irq_work
      wl12xx: Do end-of-transactions transfers only if needed
      wl12xx: Change claiming of the SDIO bus
      wl12xx: Switch to a threaded interrupt handler
      wl12xx: Switch to level trigger interrupts
      wl12xx: Avoid redundant TX work
      wl12xx: Modify requested number of memory blocks

Sebastien Jan (1):
      wl12xx: fix the path to the wl12xx firmwares

 drivers/net/wireless/wl12xx/acx.c     |    3 +-
 drivers/net/wireless/wl12xx/boot.c    |    3 +
 drivers/net/wireless/wl12xx/boot.h    |    5 +
 drivers/net/wireless/wl12xx/cmd.c     |    1 +
 drivers/net/wireless/wl12xx/debugfs.c |    2 +-
 drivers/net/wireless/wl12xx/io.h      |    1 +
 drivers/net/wireless/wl12xx/main.c    |  170 ++++++++++++++++++++++-----------
 drivers/net/wireless/wl12xx/ps.c      |    6 +-
 drivers/net/wireless/wl12xx/ps.h      |    2 +-
 drivers/net/wireless/wl12xx/rx.c      |   11 ++-
 drivers/net/wireless/wl12xx/scan.c    |   20 +++-
 drivers/net/wireless/wl12xx/sdio.c    |   42 ++++----
 drivers/net/wireless/wl12xx/spi.c     |   19 ++---
 drivers/net/wireless/wl12xx/tx.c      |   47 +++++++---
 drivers/net/wireless/wl12xx/wl12xx.h  |   28 ++++-
 15 files changed, 235 insertions(+), 125 deletions(-)

--
Cheers,
Luca.




