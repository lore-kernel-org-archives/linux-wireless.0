Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42094 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752102AbeEOQNY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 12:13:24 -0400
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 0/2] Runtime PM support for wlcore
Date: Tue, 15 May 2018 09:13:13 -0700
Message-Id: <20180515161315.1997-1-tony@atomide.com> (sfid-20180515_181330_097117_F653100E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Here are two patches to add runtime PM support for wlcore. I've
only lightly tested this so far, so some more testing sure would be
appreciated.I have no idea about the test mode for example.

You also want patch "[PATCH] wlcore: sdio: Fix flakey SDIO
runtime PM handling" that I posted earlier today as otherwise
you will get bogus errors.

Regards,

Tony


Tony Lindgren (2):
  wlcore: Make sure PM calls are paired
  wlcore: Add support runtime PM

 drivers/net/wireless/ti/wl18xx/debugfs.c    |  26 +-
 drivers/net/wireless/ti/wlcore/debugfs.c    |  79 ++--
 drivers/net/wireless/ti/wlcore/main.c       | 405 ++++++++++++++------
 drivers/net/wireless/ti/wlcore/ps.c         | 146 -------
 drivers/net/wireless/ti/wlcore/ps.h         |   3 -
 drivers/net/wireless/ti/wlcore/scan.c       |   9 +-
 drivers/net/wireless/ti/wlcore/sysfs.c      |  10 +-
 drivers/net/wireless/ti/wlcore/testmode.c   |  17 +-
 drivers/net/wireless/ti/wlcore/tx.c         |   9 +-
 drivers/net/wireless/ti/wlcore/vendor_cmd.c |  26 +-
 drivers/net/wireless/ti/wlcore/wlcore.h     |   1 -
 drivers/net/wireless/ti/wlcore/wlcore_i.h   |   1 -
 12 files changed, 405 insertions(+), 327 deletions(-)

-- 
2.17.0
