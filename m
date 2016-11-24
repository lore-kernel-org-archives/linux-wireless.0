Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34276 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935654AbcKXBYb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 20:24:31 -0500
Received: by mail-pg0-f67.google.com with SMTP id e9so2198407pgc.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2016 17:24:31 -0800 (PST)
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Wed, 23 Nov 2016 17:24:24 -0800
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Zhaoyang Liu <liuzy@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 0/7] Fix -Wunused-but-set-variable in mwifiex/
Message-ID: <cover.1479950323.git.kirtika@google.com> (sfid-20161124_022502_384717_B06E95E8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset is part of the effort led by Arnd Bergmann to clean up
warnings in the kernel. This and following patchsets will focus on
"-Wunused-but-set-variable" as it among the noisier ones. These were
found compiling with W=1.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kirtika Ruchandani <kirtika@google.com>

---
Changes in v2:
- Reapplied patches on top of wireless-drivers-next.
- Patch 5/7 ("mwifiex: Remove unused 'pm_flag' variable") had to be 
  redone slightly. The others applied cleanly with 'patch -p1'.

Kirtika Ruchandani (7):
  mwifiex: Removed unused mwifiex_private* 'priv' variable
  mwifiex: Remove unused  'chan_num' variable
  mwifiex: Remove unused 'sta_ptr' variable
  mwifiex: Remove unused 'adapter'variable
  mwifiex: Remove unused 'pm_flag' variable
  mwifiex: Removed unused 'pkt_type' variable
  mwifiex: Remove unused 'bcd_usb' variable

 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 2 --
 drivers/net/wireless/marvell/mwifiex/main.c     | 3 ---
 drivers/net/wireless/marvell/mwifiex/scan.c     | 8 +++-----
 drivers/net/wireless/marvell/mwifiex/sdio.c     | 5 -----
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c  | 2 --
 drivers/net/wireless/marvell/mwifiex/usb.c      | 3 +--
 6 files changed, 4 insertions(+), 19 deletions(-)

-- 
2.8.0.rc3.226.g39d4020
