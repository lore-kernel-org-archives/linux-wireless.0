Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:20485 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab0BVGlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:19 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/22] wl1271: driver implementation patch blast (2/3)
Date: Mon, 22 Feb 2010 08:38:20 +0200
Message-Id: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches progressively add implementation and fix bugs in the wl1271
driver. This patch set is the second of three.

First of all apologies for the huge number of patches - quite a few have
accumulated since our last contribution. The good news in this is that these
patches have now received relatively good verification against the
wireless-testing mac80211/cfg80211 stack.

For those who wonder who I am: I am the co-maintainer of the wl1271 driver,
submitting these patches now in place of Luciano Coelho, while he is enjoying
the last moments of his well deserved vacation.

Executive summary of the changes of this patch set:
 - SDIO support
 - Optimizations of the TX and RX paths

Juuso Oikarinen (12):
  wl1271: Improvements to the TX path
  wl1271: Fix ad-hoc mode neighborhood detection
  wl1271: Fix queue stopping/waking for TX path
  wl1271: Remove annoying PSM entry/exit kernel traces
  wl1271: Aggregate RX acknowledgements to FW
  wl1271: Don't mask interrupts while handling interrupt
  wl1271: Implement looped IRQ handling
  wl1271: Update TX packet life time handling with higher resolution
    time
  wl1271: Clean up firmware block allocation calculation
  wl1271: Clean up TX security sequence number handling
  wl1271: Disable host TX rate control
  wl1271: Remove tx-power level workaround

Kalle Valo (1):
  wl1271: don't get received frames from hardware in PLT mode

Teemu Paasikivi (9):
  wl1271: Moved module basics to wl1271_spi.c
  wl1271: Added functions to enable/disable interrupt handling
  wl1271: Implemented abstraction of IO functions.
  wl1271: Inlined IO functions
  wl1271: Removed wl1271_spi.h and made some functions static
  wl1271: Divided driver to two separate modules
  wl1271: Initial SDIO implementation
  wl1271: Changed access to fw status register to use raw read
  wl1271: Fixed unloading of the wl1271_sdio module

 drivers/net/wireless/wl12xx/Kconfig           |   24 ++
 drivers/net/wireless/wl12xx/Makefile          |    6 +-
 drivers/net/wireless/wl12xx/wl1271.h          |   33 ++-
 drivers/net/wireless/wl12xx/wl1271_acx.c      |    8 +-
 drivers/net/wireless/wl12xx/wl1271_boot.c     |    3 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c      |    8 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.h      |    2 +-
 drivers/net/wireless/wl12xx/wl1271_event.c    |    1 -
 drivers/net/wireless/wl12xx/wl1271_io.c       |   87 ++-----
 drivers/net/wireless/wl12xx/wl1271_io.h       |  122 ++++++++--
 drivers/net/wireless/wl12xx/wl1271_main.c     |  336 ++++++------------------
 drivers/net/wireless/wl12xx/wl1271_ps.c       |    1 -
 drivers/net/wireless/wl12xx/wl1271_rx.c       |   11 +-
 drivers/net/wireless/wl12xx/wl1271_sdio.c     |  307 ++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_spi.c      |  267 +++++++++++++++++++-
 drivers/net/wireless/wl12xx/wl1271_spi.h      |   96 -------
 drivers/net/wireless/wl12xx/wl1271_testmode.c |    1 -
 drivers/net/wireless/wl12xx/wl1271_tx.c       |   94 ++++----
 drivers/net/wireless/wl12xx/wl1271_tx.h       |    4 +-
 19 files changed, 893 insertions(+), 518 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_sdio.c
 delete mode 100644 drivers/net/wireless/wl12xx/wl1271_spi.h

