Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:56426 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737Ab3AWOld (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 09:41:33 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id r0NEfWTL004219
	for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 08:41:32 -0600
Received: from DLEE74.ent.ti.com (dlee74.ent.ti.com [157.170.170.8])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id r0NEfWKL025733
	for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 08:41:32 -0600
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>
Subject: [PATCH 0/5] ti wlan drivers: clean-up platform_data stuff (part 1)
Date: Wed, 23 Jan 2013 16:40:33 +0200
Message-ID: <1358952038-5982-1-git-send-email-coelho@ti.com> (sfid-20130123_154136_278638_B19CB7CB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

These are my initial patches where I started cleaning up the platform
data stuff so we can start moving to using DT more easily later.

There is still a lot more to clean up before making all this DT
friendly, so I'll send a few more patchsets soon.  I'm sending this
already because I don't want to pile up too many patches.  Maybe in
small batches I have a chance of getting some review. :P

--
Cheers,
Luca.

Luciano Coelho (5):
  wlcore: remove unused set_power method
  wlcore: remove if_ops from platform_data
  wlcore: use wl12xx_platform_data pointer from wlcore_pdev_data
  wlcore: use PLATFORM_DEVID_AUTO for plat dev creation to avoid
    conflicts
  wlcore: move wl12xx_platform_data up and make it truly optional

 drivers/net/wireless/ti/Kconfig                    |    9 ++++++
 drivers/net/wireless/ti/Makefile                   |    3 ++
 ...12xx_platform_data.c => wilink_platform_data.c} |    0
 drivers/net/wireless/ti/wlcore/Kconfig             |    5 ---
 drivers/net/wireless/ti/wlcore/Makefile            |    3 --
 drivers/net/wireless/ti/wlcore/main.c              |    6 ++--
 drivers/net/wireless/ti/wlcore/sdio.c              |   33 +++++++++++++-------
 drivers/net/wireless/ti/wlcore/spi.c               |   28 ++++++++++++-----
 drivers/net/wireless/ti/wlcore/wlcore.h            |    1 -
 drivers/net/wireless/ti/wlcore/wlcore_i.h          |    5 +++
 include/linux/wl12xx.h                             |   16 +++++++---
 11 files changed, 72 insertions(+), 37 deletions(-)
 rename drivers/net/wireless/ti/{wlcore/wl12xx_platform_data.c => wilink_platform_data.c} (100%)

-- 
1.7.10.4

