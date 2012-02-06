Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34898 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab2BFKoO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 05:44:14 -0500
Received: by wics10 with SMTP id s10so4057049wic.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 02:44:13 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/4] wl12xx: support multiple vifs
Date: Mon,  6 Feb 2012 12:47:53 +0200
Message-Id: <1328525277-25334-1-git-send-email-eliad@wizery.com> (sfid-20120206_114417_722134_D6348972)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to lack of space, wl12xx uses separate firmwares for PLT,
single-role and multi-role (some advanced fw features are
disabled in the multi-role fw, so we use the single-role fw
when only a single vif is configured).

Add support for loading the different firmwares, and initiate
a recovery when a single<->multi transition is needed.

Eliad Peller (4):
  wl12xx: Use a dedicated fw for PLT
  wl12xx: dynamically change fw according to number of active roles
  wl12xx: enter forced-psm on fw change
  wl12xx: delete wl->vif (and allow multiple vifs)

 drivers/net/wireless/wl12xx/debugfs.c |    2 +-
 drivers/net/wireless/wl12xx/main.c    |  184 +++++++++++++++++++++++++++------
 drivers/net/wireless/wl12xx/rx.c      |    2 +-
 drivers/net/wireless/wl12xx/sdio.c    |    8 +-
 drivers/net/wireless/wl12xx/spi.c     |    8 +-
 drivers/net/wireless/wl12xx/wl12xx.h  |   24 ++++-
 6 files changed, 186 insertions(+), 42 deletions(-)

-- 
1.7.6.401.g6a319

