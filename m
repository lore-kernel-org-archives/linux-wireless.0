Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42581 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752512AbcIQQGk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 12:06:40 -0400
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCHv2 0/5] Fix wlcore config firwmare annoyances
Date: Sat, 17 Sep 2016 09:06:28 -0700
Message-Id: <20160917160633.8767-1-tony@atomide.com> (sfid-20160917_180644_288303_D8FE41D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Here are some patches to fix the firmware loading for wl12xx/wl18xx
when the same rootfs is used on multiple WLAN chip variants.

Changes since v1:

- Fix copy paste typo for the SPI related changes as noted by
  Kalle Valo

- Fix uninitialized ret variable warning as noted by Kalle Valo

Regards,

Tony

Tony Lindgren (5):
  wlcore: Prepare family to fix nvs file handling
  wlcore: sdio: Populate config firmware data
  wlcore: spi: Populate config firmware data
  wlcore: Fix config firmware loading issues
  wlcore: wl18xx: Use chip specific configuration firmware

 drivers/net/wireless/ti/wl18xx/main.c     | 19 ++++----
 drivers/net/wireless/ti/wlcore/boot.c     | 15 ++++--
 drivers/net/wireless/ti/wlcore/main.c     | 36 ++++++++++-----
 drivers/net/wireless/ti/wlcore/sdio.c     | 76 +++++++++++++++++++------------
 drivers/net/wireless/ti/wlcore/spi.c      | 48 +++++++++----------
 drivers/net/wireless/ti/wlcore/wlcore_i.h | 12 ++---
 6 files changed, 123 insertions(+), 83 deletions(-)

-- 
2.9.3
