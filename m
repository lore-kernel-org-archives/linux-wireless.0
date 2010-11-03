Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44763 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab0KCWN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 18:13:56 -0400
Received: by eye27 with SMTP id 27so668478eye.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 15:13:55 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@adurom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 0/3] wl1251 SDIO patches
Date: Thu,  4 Nov 2010 00:13:46 +0200
Message-Id: <1288822429-24541-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches add runtime PM support for wl1251, similar to how
it's done for wl1271. This allows powering down the card properly
when the driver is loaded but not started.

Last patch switches to cleaner method for passing platform_data.
Most of this code is based on Ohad Ben-Cohen's wl1271 work.

Grazvydas Ignotas (3):
  wl1251: add power callback to wl1251_if_operations
  wl1251: add runtime PM support for SDIO
  wl1251: use wl12xx_platform_data to pass data

 arch/arm/mach-omap2/board-omap3pandora.c |   32 +++-------
 drivers/net/wireless/wl1251/main.c       |   15 +++--
 drivers/net/wireless/wl1251/sdio.c       |   99 +++++++++++++++++++-----------
 drivers/net/wireless/wl1251/spi.c        |    9 +++
 drivers/net/wireless/wl1251/wl1251.h     |    1 +
 drivers/net/wireless/wl12xx/Kconfig      |    2 +-
 6 files changed, 93 insertions(+), 65 deletions(-)

