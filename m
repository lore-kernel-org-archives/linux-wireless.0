Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38374 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146Ab1CaIHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 04:07:18 -0400
Received: by fxm17 with SMTP id 17so1636292fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2011 01:07:17 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH 0/5] wl12xx: Cleanups & fixes
Date: Thu, 31 Mar 2011 10:06:56 +0200
Message-Id: <1301558821-17787-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patches mostly clean up code, but also fix a few minor bugs.

The first four patches fix a few issues in the recently added 128x support.
The last patch fixes a regression in the driver, preventing it from working
properly on platforms which do not support level triggered interrupts.

Ido Yariv (5):
  wl12xx: Clean up and fix the 128x boot sequence
  wl12xx: Clean up the block size alignment code
  wl12xx: Clean up the dummy packet mechanism
  wl12xx: Simplify TX blocks accounting
  wl12xx: Handle platforms without level trigger interrupts

 drivers/net/wireless/wl12xx/acx.c    |    2 -
 drivers/net/wireless/wl12xx/boot.c   |  235 +++++++++++++++++-----------------
 drivers/net/wireless/wl12xx/boot.h   |    1 +
 drivers/net/wireless/wl12xx/init.c   |    2 +-
 drivers/net/wireless/wl12xx/io.c     |    3 +-
 drivers/net/wireless/wl12xx/main.c   |  140 +++++++++++++--------
 drivers/net/wireless/wl12xx/sdio.c   |   21 ++--
 drivers/net/wireless/wl12xx/spi.c    |    9 +-
 drivers/net/wireless/wl12xx/tx.c     |   70 +++++++----
 drivers/net/wireless/wl12xx/tx.h     |   11 ++-
 drivers/net/wireless/wl12xx/wl12xx.h |   23 ++-
 include/linux/wl12xx.h               |   14 ++-
 12 files changed, 305 insertions(+), 226 deletions(-)

