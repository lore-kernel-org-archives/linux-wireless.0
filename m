Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33169 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab1B0Way (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 17:30:54 -0500
Received: by wwb22 with SMTP id 22so2383975wwb.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 14:30:53 -0800 (PST)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH 0/7] wl12xx: Optimizing throughput and CPU usage
Date: Mon, 28 Feb 2011 00:30:38 +0200
Message-Id: <1298845845-12191-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patches tweak the driver in multiple places to achieve maximal
throughput and minimal CPU usage.

Throughput improved significantly with these patches, up to 50% increase in
some cases.

Ido Yariv (7):
  wl12xx: Reorder data handling in irq_work
  wl12xx: Do end-of-transactions transfers only if needed
  wl12xx: Change claiming of the SDIO bus
  wl12xx: Switch to a threaded interrupt handler
  wl12xx: Switch to level trigger interrupts
  wl12xx: Avoid redundant TX work
  wl12xx: Modify requested number of memory blocks

 drivers/net/wireless/wl12xx/boot.h    |    2 +-
 drivers/net/wireless/wl12xx/debugfs.c |    2 +-
 drivers/net/wireless/wl12xx/io.h      |    1 +
 drivers/net/wireless/wl12xx/main.c    |  157 ++++++++++++++++++++------------
 drivers/net/wireless/wl12xx/ps.c      |    6 +-
 drivers/net/wireless/wl12xx/ps.h      |    2 +-
 drivers/net/wireless/wl12xx/rx.c      |   11 ++-
 drivers/net/wireless/wl12xx/sdio.c    |   26 ++----
 drivers/net/wireless/wl12xx/spi.c     |   19 ++---
 drivers/net/wireless/wl12xx/tx.c      |   15 +++-
 drivers/net/wireless/wl12xx/wl12xx.h  |   12 ++-
 11 files changed, 147 insertions(+), 106 deletions(-)

