Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:43389 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921Ab1GERbm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 13:31:42 -0400
Received: by bwf12 with SMTP id 12so6384067bwf.36
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 10:31:39 -0700 (PDT)
Subject: pull request: wl12xx 2011-07-05
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jul 2011 20:31:35 +0300
Message-ID: <1309887095.1514.497.camel@cumari> (sfid-20110705_193146_589426_203475B5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the first batch of patches for 3.1.  I'll probably still send
one more later this week.  This took a little longer to be sent than I
was planning at first, but we had some problems with booting and testing
3.0, so I had to hold it back.

These are mainly bugfixes, a few new firmware features support and other
general clean-ups. 

Please pull or let me know if there's any problem.  This tree is based
on wireless-next/master.

Thanks!


The following changes since commit 9a4ba833a2d0016cf836827e136f0c219834bd41:

  rtlwifi: potential forever loop in rtl92de_hw_init() (2011-06-29 15:11:07 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linville

Eliad Peller (12):
      wl12xx: add support for rx streaming
      wl12xx: add automatic rx streaming triggers
      wl12xx: add rx_streaming debugfs entry
      wl12xx: remove unused crc7 references
      wl12xx: fix erroneous commit (cb5ae0)
      wl12xx: don't check wow param on suspend/resume
      wl12xx: clear wl->wow_enabled on resume
      wl12xx: enable/disable beacon filtering on ap suspend/resume
      wl12xx_sdio: enable wowlan only if enable_irq_wake() succeeded
      wl12xx: check the vif's operstate after join
      wl12xx: use _ni version of ieee80211_tx_status
      wl12xx: use freezable workqueue for netstack_work

Felipe Balbi (5):
      net: wl12xx: sdio: id_tables should be __devinitconst
      net: wl12xx: remove some unnecessary prints
      net: wl12xx: care for optional operations
      net: wl12xx: remove the nops
      net: wl12xx: remove unnecessary prints

Ido Yariv (3):
      wl12xx: Check for FW quirks as soon as the FW boots
      wl12xx: Avoid recovery while one is already in progress
      wl12xx: Support routing FW logs to the host

Luciano Coelho (1):
      wl12xx: split channel array per band in sched_scan

Ohad Ben-Cohen (1):
      wl12xx: don't bail if mmc isn't MMC_CAP_POWER_OFF_CARD

Shahar Levi (2):
      wl12xx: Enable beacon early termination in 2.4GHz band only
      wl12xx: Add Support for Low Power DRPw (LPD) Mode

 drivers/net/wireless/wl12xx/Kconfig    |    2 +-
 drivers/net/wireless/wl12xx/acx.c      |   49 +++-
 drivers/net/wireless/wl12xx/acx.h      |   16 +
 drivers/net/wireless/wl12xx/boot.c     |   33 ++
 drivers/net/wireless/wl12xx/cmd.c      |   94 +++++-
 drivers/net/wireless/wl12xx/cmd.h      |   62 ++++
 drivers/net/wireless/wl12xx/conf.h     |   55 +++
 drivers/net/wireless/wl12xx/debugfs.c  |  138 ++++++++-
 drivers/net/wireless/wl12xx/event.c    |   36 ++-
 drivers/net/wireless/wl12xx/ini.h      |    3 +
 drivers/net/wireless/wl12xx/init.c     |   19 +
 drivers/net/wireless/wl12xx/io.c       |    7 +-
 drivers/net/wireless/wl12xx/io.h       |   14 +
 drivers/net/wireless/wl12xx/main.c     |  590 ++++++++++++++++++++++++++------
 drivers/net/wireless/wl12xx/ps.c       |   12 +-
 drivers/net/wireless/wl12xx/rx.c       |   39 ++-
 drivers/net/wireless/wl12xx/rx.h       |   12 +
 drivers/net/wireless/wl12xx/scan.c     |   63 ++--
 drivers/net/wireless/wl12xx/scan.h     |   17 +-
 drivers/net/wireless/wl12xx/sdio.c     |   71 ++---
 drivers/net/wireless/wl12xx/spi.c      |   15 +-
 drivers/net/wireless/wl12xx/testmode.c |    2 +-
 drivers/net/wireless/wl12xx/tx.c       |   33 ++-
 drivers/net/wireless/wl12xx/wl12xx.h   |   38 ++-
 24 files changed, 1176 insertions(+), 244 deletions(-)

-- 
Cheers,
Luca.

