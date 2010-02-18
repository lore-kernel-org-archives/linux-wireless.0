Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50703 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab0BRL2E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:04 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/22] wl1271: driver implementation patch blast (1/3)
Date: Thu, 18 Feb 2010 13:25:35 +0200
Message-Id: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches progressively add implementation and fix bugs in the wl1271
driver. This patch set is the first of three.

First of all apologies for the huge number of patches - quite a few have
accumulated since our last contribution. The good news in this is that these
patches have now received relatively good verification against the
wireless-testing mac80211/cfg80211 stack.

For those who wonder who I am: I am the co-maintainer of the wl1271 driver,
submitting these patches now in place of Luciano Coelho, while he is enjoying
the last moments of his well deserved vacation.

Executive summary of the changes of this patch set:
 - Fixes to NVS/calibration handling
 - WMM implementation
 - Functional ad-hoc
 - Preparation for SDIO support


Juuso Oikarinen (11):
  wl1271: Fix PSM entry
  wl1271: Fix channel changing code
  wl1271: Add SSID configuration for JOIN in ad-hoc
  wl1271: Use NVS INI file configuration
  wl1271: Retrieve device mac address from the nvs file
  wl1271: Fix random MAC address setting
  wl1271: Optimized RX path packet retrieval
  wl1271: Fix key-remove error
  wl1271: Fix WEP key handling
  wl1271: Fix ad-hoc SSID update
  wl1271: Fix beacon filter table configuration

Kalle Valo (5):
  wl1271: modify wl1271_acx_ac_cfg() to use function parameters
  wl1271: modify wl1271_acx_tid_cfg() to use function parameters
  wl1271: implement WMM
  wl1271: wakeup chip in op_conf_tx()
  wl1271: add testmode support

Luciano Coelho (2):
  wl1271: add most of the normal initialization commands to PLT mode
  wl1271: skip 3 unused bytes from the NVS

Teemu Paasikivi (4):
  wl1271: Moved common IO functions from wl271_spi.c to wl1271_io.c
  wl1271: Renamed IO functions
  wl1271: Added IO reset and init functions
  wl1271: Added alloc and free hw functions

 drivers/net/wireless/wl12xx/Makefile          |    4 +-
 drivers/net/wireless/wl12xx/wl1271.h          |   34 ++-
 drivers/net/wireless/wl12xx/wl1271_acx.c      |   62 ++--
 drivers/net/wireless/wl12xx/wl1271_acx.h      |   13 +-
 drivers/net/wireless/wl12xx/wl1271_boot.c     |  106 +++---
 drivers/net/wireless/wl12xx/wl1271_cmd.c      |  136 ++------
 drivers/net/wireless/wl12xx/wl1271_cmd.h      |   88 +----
 drivers/net/wireless/wl12xx/wl1271_conf.h     |  144 +--------
 drivers/net/wireless/wl12xx/wl1271_event.c    |   50 +++-
 drivers/net/wireless/wl12xx/wl1271_init.c     |   38 ++-
 drivers/net/wireless/wl12xx/wl1271_init.h     |    4 +
 drivers/net/wireless/wl12xx/wl1271_io.c       |  213 +++++++++++
 drivers/net/wireless/wl12xx/wl1271_io.h       |   68 ++++
 drivers/net/wireless/wl12xx/wl1271_main.c     |  481 ++++++++++++++++---------
 drivers/net/wireless/wl12xx/wl1271_ps.c       |   22 +-
 drivers/net/wireless/wl12xx/wl1271_ps.h       |    3 +-
 drivers/net/wireless/wl12xx/wl1271_rx.c       |   11 +-
 drivers/net/wireless/wl12xx/wl1271_spi.c      |  157 --------
 drivers/net/wireless/wl12xx/wl1271_spi.h      |   30 --
 drivers/net/wireless/wl12xx/wl1271_testmode.c |  283 +++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_testmode.h |   31 ++
 drivers/net/wireless/wl12xx/wl1271_tx.c       |   28 +-
 drivers/net/wireless/wl12xx/wl1271_tx.h       |   36 ++
 23 files changed, 1196 insertions(+), 846 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_io.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_io.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_testmode.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_testmode.h

