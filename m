Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42127 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756826AbcIMVu6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 17:50:58 -0400
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Guy Mishol <guym@ti.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 0/5] Fix wlcore config firwmare annoyances
Date: Tue, 13 Sep 2016 14:50:38 -0700
Message-Id: <20160913215043.29454-1-tony@atomide.com> (sfid-20160913_235101_919809_7424825C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Here are some patches to fix the firmware loading for wl12xx/wl18xx
when the same rootfs is used on multiple WLAN chip variants.

Regards,

Tony

Tony Lindgren (5):
  wlcore: Prepare family to fix nvs file handling
  wlcore: sdio: Populate config firmware data
  wlcore: sdio: Populate config firmware data
  wlcore: Fix config firmware loading issues
  wlcore: wl18xx: Use chip specific configuration firmware

 drivers/net/wireless/ti/wl18xx/main.c     | 19 ++++----
 drivers/net/wireless/ti/wlcore/boot.c     | 15 ++++--
 drivers/net/wireless/ti/wlcore/main.c     | 34 +++++++++-----
 drivers/net/wireless/ti/wlcore/sdio.c     | 76 +++++++++++++++++++------------
 drivers/net/wireless/ti/wlcore/spi.c      | 48 +++++++++----------
 drivers/net/wireless/ti/wlcore/wlcore_i.h | 12 ++---
 6 files changed, 122 insertions(+), 82 deletions(-)

-- 
2.9.3
