Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36990 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab1CANPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 08:15:06 -0500
Received: by wwb22 with SMTP id 22so4420741wwb.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 05:15:05 -0800 (PST)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH v2 0/7] wl12xx: Optimizing throughput and CPU usage
Date: Tue,  1 Mar 2011 15:14:37 +0200
Message-Id: <1298985284-6048-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patches tweak the driver in multiple places to achieve maximal
throughput and minimal CPU usage.

Throughput improved significantly with these patches, up to 50% increase in
some cases.

Changes since v1:
- Keep using the existing PG version mask & introduce an end-of-transaction
  quirk
- Make sure the deferred queues don't get too large
- Prevent a theoretical endless loop in the interrupt handler
- Flush the network stack work before cancelling it

Ido Yariv (7):
  wl12xx: Reorder data handling in irq_work
  wl12xx: Do end-of-transactions transfers only if needed
  wl12xx: Change claiming of the SDIO bus
  wl12xx: Switch to a threaded interrupt handler
  wl12xx: Switch to level trigger interrupts
  wl12xx: Avoid redundant TX work
  wl12xx: Modify requested number of memory blocks

 drivers/net/wireless/wl12xx/boot.c    |    3 +
 drivers/net/wireless/wl12xx/boot.h    |    5 +
 drivers/net/wireless/wl12xx/debugfs.c |    2 +-
 drivers/net/wireless/wl12xx/io.h      |    1 +
 drivers/net/wireless/wl12xx/main.c    |  170 ++++++++++++++++++++++-----------
 drivers/net/wireless/wl12xx/ps.c      |    6 +-
 drivers/net/wireless/wl12xx/ps.h      |    2 +-
 drivers/net/wireless/wl12xx/rx.c      |   11 ++-
 drivers/net/wireless/wl12xx/sdio.c    |   26 +----
 drivers/net/wireless/wl12xx/spi.c     |   19 ++---
 drivers/net/wireless/wl12xx/tx.c      |   15 ++-
 drivers/net/wireless/wl12xx/wl12xx.h  |   22 ++++-
 12 files changed, 178 insertions(+), 104 deletions(-)

