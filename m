Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37879 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab2ISBrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 21:47:42 -0400
Received: by ieak13 with SMTP id k13so798681iea.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Sep 2012 18:47:41 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, <chaoming_li@realsil.com.cn>
Subject: [PATCH NEXT V2 00/15] Add new driver for RTL8723AE
Date: Tue, 18 Sep 2012 20:47:08 -0500
Message-Id: <1348019243-18016-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120919_034746_545005_58033284)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The previous submission had a problem in the final patch, thus I am resubmitting all patches
with a V2. I am still hoping that this driver can be merged into kernel 3.7. No other
drivers are affected by this one.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: <chaoming_li@realsil.com.cn>

Larry Finger (15):
  rtlwifi: rtl8723ae: Add new driver - Part 1
  rtlwifi: rtl8723ae: Add new driver - Part 2
  rtlwifi: rtl8723ae: Add new driver - Part 3
  rtlwifi: rtl8723ae: Add new driver - Part 4
  rtlwifi: rtl8723ae: Add new driver - Part 5
  rtlwifi: rtl8723ae: Add new driver - Part 6
  rtlwifi: rtl8723ae: Add new driver - Part 7
  rtlwifi: rtl8723ae: Add new driver - Part 8
  rtlwifi: rtl8723ae: Add new driver - Part 9
  rtlwifi: rtl8723ae: Add new driver - Part 10
  rtlwifi: rtl8723ae: Add new driver - Part 11
  rtlwifi: rtl8723ae: Add new driver - Part 12
  rtlwifi: rtl8723ae: Add new driver - Part 13
  rtlwifi: Modify files for addition of rtl8723ae
  rtlwifi: rtl8192ce: rtl8192cu: rtl8192se: rtl81723ae: Turn on
    building of the new driver

 drivers/net/wireless/rtlwifi/Kconfig               |   11 +
 drivers/net/wireless/rtlwifi/Makefile              |    4 +-
 drivers/net/wireless/rtlwifi/base.c                |   24 +
 drivers/net/wireless/rtlwifi/base.h                |    2 +
 drivers/net/wireless/rtlwifi/debug.h               |    2 +
 drivers/net/wireless/rtlwifi/pci.c                 |   20 +-
 drivers/net/wireless/rtlwifi/pci.h                 |    2 +
 drivers/net/wireless/rtlwifi/rc.c                  |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        |   10 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |   10 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c        |    6 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/Makefile    |   22 +
 drivers/net/wireless/rtlwifi/rtl8723ae/btc.h       |   40 +
 drivers/net/wireless/rtlwifi/rtl8723ae/def.h       |  290 +++
 drivers/net/wireless/rtlwifi/rtl8723ae/dm.c        |  952 ++++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/dm.h        |  173 ++
 drivers/net/wireless/rtlwifi/rtl8723ae/fw.c        |  757 ++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/fw.h        |   98 +
 .../wireless/rtlwifi/rtl8723ae/hal_bt_coexist.c    |  553 +++++
 .../wireless/rtlwifi/rtl8723ae/hal_bt_coexist.h    |  160 ++
 drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c   | 1805 ++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.h   |  160 ++
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c        | 2498 ++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.h        |   69 +
 drivers/net/wireless/rtlwifi/rtl8723ae/led.c       |  157 ++
 drivers/net/wireless/rtlwifi/rtl8723ae/led.h       |   39 +
 drivers/net/wireless/rtlwifi/rtl8723ae/phy.c       | 2157 +++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/phy.h       |  228 ++
 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.c    |  111 +
 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.h    |  311 +++
 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseqcmd.c |  137 ++
 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseqcmd.h |   99 +
 drivers/net/wireless/rtlwifi/rtl8723ae/reg.h       | 2125 +++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/rf.c        |  515 ++++
 drivers/net/wireless/rtlwifi/rtl8723ae/rf.h        |   44 +
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c        |  391 +++
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.h        |   37 +
 drivers/net/wireless/rtlwifi/rtl8723ae/table.c     |  738 ++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/table.h     |   50 +
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c       |  823 +++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.h       |  725 ++++++
 drivers/net/wireless/rtlwifi/stats.c               |  273 +++
 drivers/net/wireless/rtlwifi/stats.h               |   46 +
 drivers/net/wireless/rtlwifi/wifi.h                |  112 +-
 44 files changed, 16762 insertions(+), 27 deletions(-)
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/Makefile
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/btc.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/def.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/dm.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/dm.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/fw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/fw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/hal_bt_coexist.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/hal_bt_coexist.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/hw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/led.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/led.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/phy.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/phy.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseqcmd.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseqcmd.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/reg.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/rf.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/rf.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/sw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/table.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/table.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/trx.h
 create mode 100644 drivers/net/wireless/rtlwifi/stats.c
 create mode 100644 drivers/net/wireless/rtlwifi/stats.h

-- 
1.7.10.4

