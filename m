Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:49975 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaCDWyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 17:54:22 -0500
Received: by mail-ob0-f175.google.com with SMTP id uy5so229389obc.6
        for <linux-wireless@vger.kernel.org>; Tue, 04 Mar 2014 14:54:21 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/9] rtlwifi: Some cleanups
Date: Tue,  4 Mar 2014 16:53:46 -0600
Message-Id: <1393973635-24799-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140304_235426_988040_8E02B7F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches consist of modifications needed to replace the staging version
of r8821ae with a newer version that uses the regular version of rtlwifi.
In addition, there are fixes that prevent the drivers from disabling IRQs
for too long a time.

Finally, there are two patches that actually make the changes in the staging
directory. The process of sending these through wireless has been discussed
with Greg Kroah-Hartman.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry Finger (9):
  rtlwifi: rtl8192ce: rtl8192cu: rtl8192de: rtl8192se: rtl8723ae:
    rtl8723be: rtl8188eu: Modify for new API
  rtlwifi: Move common routines to core
  rtlwifi: rtl8723be: rtl8723com: Remove unused allow_all_destaddr
    functions
  rtlwifi: rtl8192cu: Fix too long disable of IRQs
  rtlwifi: rtl8192se: Fix too long disable of IRQs
  rtlwifi: rtl8188ee: Fix too long disable of IRQs
  rtlwifi: rtl8723ae: Fix too long disable of IRQs
  staging: r8821ae: Replace driver with new version
  staging: r8821ae: Remove remainder of files from old driver

 .../net/wireless/rtlwifi/btcoexist/halbt_precomp.h |   12 -
 .../net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c  |    2 +-
 drivers/net/wireless/rtlwifi/core.c                |   60 +
 drivers/net/wireless/rtlwifi/core.h                |    4 +
 drivers/net/wireless/rtlwifi/pci.c                 |   64 +-
 drivers/net/wireless/rtlwifi/pci.h                 |   10 +
 drivers/net/wireless/rtlwifi/ps.c                  |  100 +
 drivers/net/wireless/rtlwifi/ps.h                  |   60 +
 drivers/net/wireless/rtlwifi/rtl8188ee/Makefile    |    1 -
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c        |   39 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/phy.c       |   61 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.h    |    1 -
 drivers/net/wireless/rtlwifi/rtl8188ee/reg.h       |   16 -
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c       |    8 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.h       |    8 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c       |   71 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h       |   16 -
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c       |    5 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h       |    7 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |   15 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c       |   71 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c        |   50 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c        |   10 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c       |  429 +-
 drivers/net/wireless/rtlwifi/rtl8192de/reg.h       |   14 -
 drivers/net/wireless/rtlwifi/rtl8192de/rf.c        |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c       |    5 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.h       |    7 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c        |   27 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c       |   87 +-
 drivers/net/wireless/rtlwifi/rtl8192se/reg.h       |   12 -
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |    5 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.h       |    8 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/Makefile    |    1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c        |   19 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/phy.c       |   48 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.h    |    1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/reg.h       |   16 -
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c       |    5 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.h       |    7 +-
 drivers/net/wireless/rtlwifi/rtl8723be/Makefile    |    1 -
 drivers/net/wireless/rtlwifi/rtl8723be/hw.c        |   15 +-
 drivers/net/wireless/rtlwifi/rtl8723be/phy.c       |   29 +-
 drivers/net/wireless/rtlwifi/rtl8723be/pwrseq.h    |    1 -
 drivers/net/wireless/rtlwifi/rtl8723be/reg.h       |   16 -
 drivers/net/wireless/rtlwifi/rtl8723be/sw.c        |    1 -
 drivers/net/wireless/rtlwifi/rtl8723be/trx.c       |    5 +-
 drivers/net/wireless/rtlwifi/rtl8723be/trx.h       |    7 +-
 .../net/wireless/rtlwifi/rtl8723com/fw_common.c    |    2 +-
 drivers/net/wireless/rtlwifi/usb.c                 |    2 +-
 drivers/net/wireless/rtlwifi/wifi.h                |  217 +-
 drivers/staging/rtl8821ae/Kconfig                  |    2 +-
 drivers/staging/rtl8821ae/Makefile                 |   48 +-
 drivers/staging/rtl8821ae/btc.h                    |   82 +
 .../staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.c  | 3976 --------------
 .../staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.h  |  205 -
 .../staging/rtl8821ae/btcoexist/habtc8723a1ant.c   | 1614 ------
 .../staging/rtl8821ae/btcoexist/habtc8723a1ant.h   |  176 -
 .../staging/rtl8821ae/btcoexist/halbt_precomp.h    |   99 -
 .../staging/rtl8821ae/btcoexist/halbtc8192e1ant.c  | 3891 --------------
 .../staging/rtl8821ae/btcoexist/halbtc8192e1ant.h  |  226 -
 .../staging/rtl8821ae/btcoexist/halbtc8192e2ant.c  | 4242 ---------------
 .../staging/rtl8821ae/btcoexist/halbtc8192e2ant.h  |  162 -
 .../staging/rtl8821ae/btcoexist/halbtc8723a2ant.c  | 3780 -------------
 .../staging/rtl8821ae/btcoexist/halbtc8723a2ant.h  |  179 -
 .../staging/rtl8821ae/btcoexist/halbtc8723b1ant.c  | 4104 ---------------
 .../staging/rtl8821ae/btcoexist/halbtc8723b1ant.h  |  175 -
 .../staging/rtl8821ae/btcoexist/halbtc8723b2ant.c  | 4185 ---------------
 .../staging/rtl8821ae/btcoexist/halbtc8723b2ant.h  |  145 -
 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c | 1181 -----
 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h |  549 --
 drivers/staging/rtl8821ae/btcoexist/rtl_btc.c      |  236 -
 drivers/staging/rtl8821ae/btcoexist/rtl_btc.h      |   66 -
 drivers/staging/rtl8821ae/def.h                    |  442 ++
 drivers/staging/rtl8821ae/dm.c                     | 3115 +++++++++++
 drivers/staging/rtl8821ae/dm.h                     |  367 ++
 drivers/staging/rtl8821ae/fw.c                     | 1311 +++++
 drivers/staging/rtl8821ae/fw.h                     |  307 ++
 drivers/staging/rtl8821ae/hal_bt_coexist.c         |  492 ++
 drivers/staging/rtl8821ae/hal_bt_coexist.h         |  155 +
 drivers/staging/rtl8821ae/hal_btc.c                | 1669 ++++++
 drivers/staging/rtl8821ae/hal_btc.h                |  157 +
 drivers/staging/rtl8821ae/hw.c                     | 3089 +++++++++++
 drivers/staging/rtl8821ae/hw.h                     |   73 +
 drivers/staging/rtl8821ae/led.c                    |  231 +
 drivers/staging/rtl8821ae/led.h                    |   37 +
 drivers/staging/rtl8821ae/phy.c                    | 5005 ++++++++++++++++++
 drivers/staging/rtl8821ae/phy.h                    |  254 +
 drivers/staging/rtl8821ae/pwrseq.c                 |  181 +
 drivers/staging/rtl8821ae/pwrseq.h                 |  691 +++
 drivers/staging/rtl8821ae/reg.h                    | 2433 +++++++++
 drivers/staging/rtl8821ae/rf.c                     |  448 ++
 drivers/staging/rtl8821ae/rf.h                     |   43 +
 drivers/staging/rtl8821ae/rtl8821ae/btc.h          |   87 -
 drivers/staging/rtl8821ae/rtl8821ae/def.h          |  442 --
 drivers/staging/rtl8821ae/rtl8821ae/dm.c           | 3045 -----------
 drivers/staging/rtl8821ae/rtl8821ae/dm.h           |  426 --
 drivers/staging/rtl8821ae/rtl8821ae/fw.c           | 1349 -----
 drivers/staging/rtl8821ae/rtl8821ae/fw.h           |  321 --
 .../staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c   |  519 --
 .../staging/rtl8821ae/rtl8821ae/hal_bt_coexist.h   |  169 -
 drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c      | 2069 --------
 drivers/staging/rtl8821ae/rtl8821ae/hal_btc.h      |  160 -
 drivers/staging/rtl8821ae/rtl8821ae/hw.c           | 3346 ------------
 drivers/staging/rtl8821ae/rtl8821ae/hw.h           |   75 -
 drivers/staging/rtl8821ae/rtl8821ae/led.c          |  239 -
 drivers/staging/rtl8821ae/rtl8821ae/led.h          |   40 -
 drivers/staging/rtl8821ae/rtl8821ae/phy.c          | 5525 --------------------
 drivers/staging/rtl8821ae/rtl8821ae/phy.h          |  258 -
 drivers/staging/rtl8821ae/rtl8821ae/pwrseq.c       |  199 -
 drivers/staging/rtl8821ae/rtl8821ae/pwrseq.h       |  413 --
 drivers/staging/rtl8821ae/rtl8821ae/pwrseqcmd.c    |  140 -
 drivers/staging/rtl8821ae/rtl8821ae/pwrseqcmd.h    |   71 -
 drivers/staging/rtl8821ae/rtl8821ae/reg.h          | 2427 ---------
 drivers/staging/rtl8821ae/rtl8821ae/rf.c           |  464 --
 drivers/staging/rtl8821ae/rtl8821ae/rf.h           |   46 -
 drivers/staging/rtl8821ae/rtl8821ae/sw.c           |  499 --
 drivers/staging/rtl8821ae/rtl8821ae/sw.h           |   39 -
 drivers/staging/rtl8821ae/rtl8821ae/table.c        | 4002 --------------
 drivers/staging/rtl8821ae/rtl8821ae/table.h        |   62 -
 drivers/staging/rtl8821ae/rtl8821ae/trx.c          | 1050 ----
 drivers/staging/rtl8821ae/rtl8821ae/trx.h          |  641 ---
 drivers/staging/rtl8821ae/sw.c                     |  417 ++
 drivers/staging/rtl8821ae/sw.h                     |   34 +
 drivers/staging/rtl8821ae/table.c                  | 3430 ++++++++++++
 drivers/staging/rtl8821ae/table.h                  |   56 +
 drivers/staging/rtl8821ae/trx.c                    |  944 ++++
 drivers/staging/rtl8821ae/trx.h                    |  623 +++
 130 files changed, 26973 insertions(+), 58165 deletions(-)
 create mode 100644 drivers/staging/rtl8821ae/btc.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.c
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/habtc8723a1ant.c
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/habtc8723a1ant.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbt_precomp.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.c
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8723a2ant.c
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8723a2ant.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.c
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.c
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/rtl_btc.c
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/rtl_btc.h
 create mode 100644 drivers/staging/rtl8821ae/def.h
 create mode 100644 drivers/staging/rtl8821ae/dm.c
 create mode 100644 drivers/staging/rtl8821ae/dm.h
 create mode 100644 drivers/staging/rtl8821ae/fw.c
 create mode 100644 drivers/staging/rtl8821ae/fw.h
 create mode 100644 drivers/staging/rtl8821ae/hal_bt_coexist.c
 create mode 100644 drivers/staging/rtl8821ae/hal_bt_coexist.h
 create mode 100644 drivers/staging/rtl8821ae/hal_btc.c
 create mode 100644 drivers/staging/rtl8821ae/hal_btc.h
 create mode 100644 drivers/staging/rtl8821ae/hw.c
 create mode 100644 drivers/staging/rtl8821ae/hw.h
 create mode 100644 drivers/staging/rtl8821ae/led.c
 create mode 100644 drivers/staging/rtl8821ae/led.h
 create mode 100644 drivers/staging/rtl8821ae/phy.c
 create mode 100644 drivers/staging/rtl8821ae/phy.h
 create mode 100644 drivers/staging/rtl8821ae/pwrseq.c
 create mode 100644 drivers/staging/rtl8821ae/pwrseq.h
 create mode 100644 drivers/staging/rtl8821ae/reg.h
 create mode 100644 drivers/staging/rtl8821ae/rf.c
 create mode 100644 drivers/staging/rtl8821ae/rf.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/btc.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/def.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/dm.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/dm.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/fw.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/fw.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/hal_btc.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/hw.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/hw.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/led.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/led.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/phy.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/phy.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/pwrseq.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/pwrseq.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/pwrseqcmd.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/pwrseqcmd.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/reg.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/rf.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/rf.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/sw.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/sw.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/table.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/table.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/trx.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/trx.h
 create mode 100644 drivers/staging/rtl8821ae/sw.c
 create mode 100644 drivers/staging/rtl8821ae/sw.h
 create mode 100644 drivers/staging/rtl8821ae/table.c
 create mode 100644 drivers/staging/rtl8821ae/table.h
 create mode 100644 drivers/staging/rtl8821ae/trx.c
 create mode 100644 drivers/staging/rtl8821ae/trx.h

-- 
1.8.4.5

