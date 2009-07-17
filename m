Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:35792 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbZGQS4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 14:56:39 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [RFC PATCH v2 0/8] wl1251 sdio interface
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 17 Jul 2009 21:47:39 +0300
Message-ID: <20090717184643.25883.95065.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is v2 of Bob's wl1251 sdio patches. I have now rebased them on
top of wl1251/wl1271 split patches. Only compile-tested because I
don't have working test setup right now (neither spi or sdio), but I
should have access to one in two weeks.

We should get the patches into wireless-testing soon because there is
quite a lot of interest for wl1251 sdio support, sdio is more widely
used than spi. I would like to get the patches into 2.6.32 if at all
possible.

v2:
o rebase to current wireless-testing (after wl1251/wl1271 split)

---

Bob Copeland (7):
      wl1251: add sdio support
      wl1251: split spi interface into separate module
      wl1251: move module probe methods into spi.c
      wl1251: make wl1251_set_partition bus agnostic
      wl1251: introduce wl1251_if_operations struct
      wl1251: use wiphy_dev instead of wl->spi->dev
      wl1251: separate bus i/o code into io.c

Kalle Valo (1):
      wl1251: remove fixed address support from spi commands


 drivers/net/wireless/wl12xx/Kconfig        |   28 ++-
 drivers/net/wireless/wl12xx/Makefile       |    5 
 drivers/net/wireless/wl12xx/wl1251.h       |   14 +
 drivers/net/wireless/wl12xx/wl1251_acx.c   |    3 
 drivers/net/wireless/wl12xx/wl1251_boot.c  |    1 
 drivers/net/wireless/wl12xx/wl1251_cmd.c   |   11 -
 drivers/net/wireless/wl12xx/wl1251_event.c |    4 
 drivers/net/wireless/wl12xx/wl1251_io.c    |  181 ++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_io.h    |   64 ++++++
 drivers/net/wireless/wl12xx/wl1251_main.c  |  162 +++------------
 drivers/net/wireless/wl12xx/wl1251_ops.c   |    5 
 drivers/net/wireless/wl12xx/wl1251_ps.c    |    3 
 drivers/net/wireless/wl12xx/wl1251_rx.c    |    7 -
 drivers/net/wireless/wl12xx/wl1251_sdio.c  |  188 +++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_spi.c   |  310 +++++++++++-----------------
 drivers/net/wireless/wl12xx/wl1251_spi.h   |   54 -----
 drivers/net/wireless/wl12xx/wl1251_tx.c    |   62 +++---
 17 files changed, 678 insertions(+), 424 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_io.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_io.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_sdio.c

