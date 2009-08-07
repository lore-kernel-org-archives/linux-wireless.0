Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:45319 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbZHGKdH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 06:33:07 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 00/23] wl1251 sdio support
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2009 13:32:39 +0300
Message-ID: <20090807102732.31717.84006.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here are quite a few wl1251 patches for you. It would be good to get
them to 2.6.32 if possible. Major addition is the sdio support which
have been tested with the Google G1 phone. Also some code cleanup and
odd fixes.

---

Bob Copeland (8):
      wl1251: make irq handling interface specific
      wl1251: add sdio support
      wl1251: split spi interface into separate module
      wl1251: move module probe methods into spi.c
      wl1251: make wl1251_set_partition bus agnostic
      wl1251: introduce wl1251_if_operations struct
      wl1251: use wiphy_dev instead of wl->spi->dev
      wl1251: separate bus i/o code into io.c

Kalle Valo (15):
      wl1251: hack to disable filters for fixing association
      wl1251: add hw scan completed debug message
      wl1251: remove Luciano as maintainer
      wl1251: rename reg.h to wl1251_reg.h
      wl1251: use workqueue provided by mac80211
      wl1251: move wl1251_acx_wake_up_conditions() to wl1251_ps_set_mode()
      wl1251: fix channel setting in wl1251_op_config()
      wl1251: create wl1251_join()
      wl1251: add channel to wl1251_cmd_join() parameters
      wl1251: initialise default channel to zero
      wl1251: remove wait parameter from wl1251_cmd_join()
      wl1251: use beacon interval and dtim period provided by mac80211
      wl1251: reorder wl1251_cmd_join() arguments
      wl1251: remove wl1251_ops
      wl1251: remove fixed address support from spi commands


 drivers/net/wireless/wl12xx/Kconfig        |   28 +
 drivers/net/wireless/wl12xx/Makefile       |    7 
 drivers/net/wireless/wl12xx/reg.h          |  744 ----------------------------
 drivers/net/wireless/wl12xx/wl1251.h       |   78 ++-
 drivers/net/wireless/wl12xx/wl1251_acx.c   |   84 +++
 drivers/net/wireless/wl12xx/wl1251_acx.h   |  146 +++++
 drivers/net/wireless/wl12xx/wl1251_boot.c  |  266 +++++++++-
 drivers/net/wireless/wl12xx/wl1251_boot.h  |    1 
 drivers/net/wireless/wl12xx/wl1251_cmd.c   |   62 +-
 drivers/net/wireless/wl12xx/wl1251_cmd.h   |    4 
 drivers/net/wireless/wl12xx/wl1251_event.c |    7 
 drivers/net/wireless/wl12xx/wl1251_init.c  |  213 ++++++++
 drivers/net/wireless/wl12xx/wl1251_init.h  |    2 
 drivers/net/wireless/wl12xx/wl1251_io.c    |  196 +++++++
 drivers/net/wireless/wl12xx/wl1251_io.h    |   64 ++
 drivers/net/wireless/wl12xx/wl1251_main.c  |  375 ++++++++------
 drivers/net/wireless/wl12xx/wl1251_ops.c   |    5 
 drivers/net/wireless/wl12xx/wl1251_ops.h   |  165 ------
 drivers/net/wireless/wl12xx/wl1251_ps.c    |   18 +
 drivers/net/wireless/wl12xx/wl1251_reg.h   |  744 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_rx.c    |    9 
 drivers/net/wireless/wl12xx/wl1251_sdio.c  |  205 ++++++++
 drivers/net/wireless/wl12xx/wl1251_spi.c   |  327 +++++-------
 drivers/net/wireless/wl12xx/wl1251_spi.h   |   56 --
 drivers/net/wireless/wl12xx/wl1251_tx.c    |   64 +-
 25 files changed, 2402 insertions(+), 1468 deletions(-)
 delete mode 100644 drivers/net/wireless/wl12xx/reg.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_io.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_io.h
 delete mode 100644 drivers/net/wireless/wl12xx/wl1251_ops.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_reg.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_sdio.c

