Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:63720 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbZFLLOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:14:30 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 00/33] wl12xx update for 2.6.32
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:14:13 +0300
Message-ID: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's a patchset for wl12xx. Sorry that it's so huge, 33 patches in
total. In the future I will send you patches in smaller sets.

The biggest change is that we had to split wl1251 and wl1271 code. There
are so many differences between the chipsets that having a one driver
supporting both would be a maintenance nightmare. So we decided to split
the drivers and in the future share the few parts which have common
functionality.

Also some power save improvements. Power save is not enabled yet, though.
I plan to do that soon.

Commit 'mac80211: fix managed mode BSSID handling' broke wl12xx and for now
it has to be reverted to get wl12xx working. This is a problem with wl12xx
filter handling and I'll fix it next week.

---

Ari Kauppi (2):
      wl12xx: Fix CMD_TEST regression via netlink.
      wl12xx: Fix incorrect warning message.

Juuso Oikarinen (4):
      wl12xx: Use chipset specific join commands
      wl12xx: Add support for block reading from a fixed register address
      wl12xx: Moved wl1251 TX path implementation into chip specific files
      wl12xx: removed chipset interrupt source configuration from fw wakeup

Kalle Valo (20):
      wl1251: fix a checkpatch warning
      wl1251: use wl1251 prefix everywhere
      wl12xx: remove unused wl12xx_hw_init_mem_config()
      wl1251: rename wl12xx.h to wl1251.h
      wl1251: add wl1251 prefix to all 1251 files
      wl1251: remove wl1271_setup()
      wl12xx: rename driver to wl1251
      wl12xx: rename wl1251.c wl1251_ops.c
      wl12xx: enable ELP mode
      wl12xx: check if elp wakeup failed
      wl12xx: optimise elp wakeup and sleep calls
      wl12xx: protect wl12xx_op_set_rts_threshold()
      wl12xx: fix rx descriptor use
      wl12xx: use wl12xx_mem_read32() to read the rx counter
      wl12xx: allocate buffer the spi busy word from struct wl12xx
      wl12xx: allocate buffer spi read/write command buffer kzalloc()
      wl12xx: reserve buffer for partition command in struct wl12xx
      wl12xx: fix error handling in wl12xx_probe()
      wl12xx: reserver buffer for read32()/write32() in struct wl12xx
      wl12xx: cmd and acx interface rework

Luciano Coelho (6):
      wl1251: change psm enabled/disabled info to debug
      wl12xx: pass the wake up condition when configuring the wake up event
      wl12xx: add support for fixed address in wl12xx_spi_read
      wl12xx: add support for new WL1271 chip revision
      wl12xx: moved firmware version reading routine to chip-specific functions
      wl12xx: add wl12xx_spi_reg_read() and wl12xx_spi_reg_write() functions

Vidhya Govindan (1):
      wl12xx: Assign value to rx msdu lifetime variable


 drivers/net/wireless/wl12xx/Kconfig          |   17 
 drivers/net/wireless/wl12xx/Makefile         |    9 
 drivers/net/wireless/wl12xx/acx.c            |  689 ------------
 drivers/net/wireless/wl12xx/acx.h            | 1245 ----------------------
 drivers/net/wireless/wl12xx/boot.c           |  295 -----
 drivers/net/wireless/wl12xx/boot.h           |   40 -
 drivers/net/wireless/wl12xx/cmd.c            |  353 ------
 drivers/net/wireless/wl12xx/cmd.h            |  265 -----
 drivers/net/wireless/wl12xx/debugfs.c        |  508 ---------
 drivers/net/wireless/wl12xx/debugfs.h        |   33 -
 drivers/net/wireless/wl12xx/event.c          |  127 --
 drivers/net/wireless/wl12xx/event.h          |  121 --
 drivers/net/wireless/wl12xx/init.c           |  200 ----
 drivers/net/wireless/wl12xx/init.h           |   40 -
 drivers/net/wireless/wl12xx/main.c           | 1358 ------------------------
 drivers/net/wireless/wl12xx/ps.c             |  151 ---
 drivers/net/wireless/wl12xx/ps.h             |   36 -
 drivers/net/wireless/wl12xx/reg.h            |    1 
 drivers/net/wireless/wl12xx/rx.c             |  208 ----
 drivers/net/wireless/wl12xx/rx.h             |  122 --
 drivers/net/wireless/wl12xx/spi.c            |  358 ------
 drivers/net/wireless/wl12xx/spi.h            |  109 --
 drivers/net/wireless/wl12xx/tx.c             |  557 ----------
 drivers/net/wireless/wl12xx/tx.h             |  215 ----
 drivers/net/wireless/wl12xx/wl1251.c         |  709 -------------
 drivers/net/wireless/wl12xx/wl1251.h         |  479 +++++++--
 drivers/net/wireless/wl12xx/wl1251_acx.c     |  840 +++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_acx.h     | 1146 +++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_boot.c    |  297 +++++
 drivers/net/wireless/wl12xx/wl1251_boot.h    |   40 +
 drivers/net/wireless/wl12xx/wl1251_cmd.c     |  428 ++++++++
 drivers/net/wireless/wl12xx/wl1251_cmd.h     |  407 +++++++
 drivers/net/wireless/wl12xx/wl1251_debugfs.c |  518 +++++++++
 drivers/net/wireless/wl12xx/wl1251_debugfs.h |   33 +
 drivers/net/wireless/wl12xx/wl1251_event.c   |  127 ++
 drivers/net/wireless/wl12xx/wl1251_event.h   |  121 ++
 drivers/net/wireless/wl12xx/wl1251_init.c    |  200 ++++
 drivers/net/wireless/wl12xx/wl1251_init.h    |   39 +
 drivers/net/wireless/wl12xx/wl1251_main.c    | 1448 ++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_netlink.c |  679 ++++++++++++
 drivers/net/wireless/wl12xx/wl1251_netlink.h |   30 +
 drivers/net/wireless/wl12xx/wl1251_ops.c     |  728 +++++++++++++
 drivers/net/wireless/wl12xx/wl1251_ops.h     |  165 +++
 drivers/net/wireless/wl12xx/wl1251_ps.c      |  147 +++
 drivers/net/wireless/wl12xx/wl1251_ps.h      |   36 +
 drivers/net/wireless/wl12xx/wl1251_rx.c      |  195 ++++
 drivers/net/wireless/wl12xx/wl1251_rx.h      |  124 ++
 drivers/net/wireless/wl12xx/wl1251_spi.c     |  393 +++++++
 drivers/net/wireless/wl12xx/wl1251_spi.h     |  115 ++
 drivers/net/wireless/wl12xx/wl1251_tx.c      |  559 ++++++++++
 drivers/net/wireless/wl12xx/wl1251_tx.h      |  216 ++++
 drivers/net/wireless/wl12xx/wl12xx.h         |  409 -------
 52 files changed, 9415 insertions(+), 8270 deletions(-)
 delete mode 100644 drivers/net/wireless/wl12xx/acx.c
 delete mode 100644 drivers/net/wireless/wl12xx/acx.h
 delete mode 100644 drivers/net/wireless/wl12xx/boot.c
 delete mode 100644 drivers/net/wireless/wl12xx/boot.h
 delete mode 100644 drivers/net/wireless/wl12xx/cmd.c
 delete mode 100644 drivers/net/wireless/wl12xx/cmd.h
 delete mode 100644 drivers/net/wireless/wl12xx/debugfs.c
 delete mode 100644 drivers/net/wireless/wl12xx/debugfs.h
 delete mode 100644 drivers/net/wireless/wl12xx/event.c
 delete mode 100644 drivers/net/wireless/wl12xx/event.h
 delete mode 100644 drivers/net/wireless/wl12xx/init.c
 delete mode 100644 drivers/net/wireless/wl12xx/init.h
 delete mode 100644 drivers/net/wireless/wl12xx/main.c
 delete mode 100644 drivers/net/wireless/wl12xx/ps.c
 delete mode 100644 drivers/net/wireless/wl12xx/ps.h
 delete mode 100644 drivers/net/wireless/wl12xx/rx.c
 delete mode 100644 drivers/net/wireless/wl12xx/rx.h
 delete mode 100644 drivers/net/wireless/wl12xx/spi.c
 delete mode 100644 drivers/net/wireless/wl12xx/spi.h
 delete mode 100644 drivers/net/wireless/wl12xx/tx.c
 delete mode 100644 drivers/net/wireless/wl12xx/tx.h
 delete mode 100644 drivers/net/wireless/wl12xx/wl1251.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_acx.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_acx.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_boot.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_boot.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_cmd.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_cmd.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_debugfs.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_debugfs.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_event.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_event.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_init.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_init.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_main.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_netlink.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_netlink.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_ops.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_ops.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_ps.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_ps.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_rx.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_rx.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_spi.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_spi.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_tx.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_tx.h
 delete mode 100644 drivers/net/wireless/wl12xx/wl12xx.h

-- 
Kalle Valo
