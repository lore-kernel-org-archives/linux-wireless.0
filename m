Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:54541 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab0LPItv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 03:49:51 -0500
Subject: pull request: wl12xx 2010-12-16
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 10:51:51 +0200
Message-ID: <1292489511.11205.3.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This pull-request contains some improvements and bug fixes for the
wl12xx driver.  It's the same thing I sent yesterday, but with one extra
patch that fixes a compilation breakage.

Please pull or let me know if there's any problem.  This tree is based
on wireless-next/master.

Thanks!

The following changes since commit 412b31334b831a8c2909afaca017c5a236ac2dd0:
  Wolfgang Kufner (1):
        rt2x00: Fix firmware loading regression on x86_64.

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git wl12xx-next

Eliad Peller (4):
      wl1271: use debugfs_remove_recursive
      wl1271: move wl12xx debugfs directory to under wiphy's debugfs
      wl12xx: add auto-arp support
      wl12xx: allow runtime changing of debug_level

Guy Eilam (1):
      wl1271: fixed problem with WPS IEs in probe requests

Juuso Oikarinen (4):
      wl12xx: Fix kernel crash related to hw recovery and interface shutdown
      wl1271: Fix setting of the hardware connection monitoring probe-req template
      wl12xx: Remove 11j channels from the supported channels list.
      wl12xx: Change TX queue to be per AC

Luciano Coelho (4):
      wl12xx: disable 11a channels when regulatory changes if 11a is not supported
      wl12xx: fix illegal memset if debugfs is not enabled
      wl12xx: disable 11a channels when wl->enable_11a is known
      wl12xx_sdio_test: rename files to match current style

Roger Quadros (2):
      wl1271: Add wl1271_load_firmware() and export some functions
      wl1271_sdio_test: Add module for sdio RX/TX testing

 drivers/net/wireless/wl12xx/Kconfig        |   10 +
 drivers/net/wireless/wl12xx/Makefile       |    3 +
 drivers/net/wireless/wl12xx/acx.c          |    4 +-
 drivers/net/wireless/wl12xx/acx.h          |    9 +-
 drivers/net/wireless/wl12xx/boot.c         |   17 +-
 drivers/net/wireless/wl12xx/boot.h         |    1 +
 drivers/net/wireless/wl12xx/cmd.c          |   69 ++++
 drivers/net/wireless/wl12xx/cmd.h          |    4 +
 drivers/net/wireless/wl12xx/debugfs.c      |  192 +++--------
 drivers/net/wireless/wl12xx/init.c         |   13 +-
 drivers/net/wireless/wl12xx/io.c           |    1 +
 drivers/net/wireless/wl12xx/main.c         |  119 +++++--
 drivers/net/wireless/wl12xx/scan.c         |    4 +
 drivers/net/wireless/wl12xx/sdio_test.c    |  520 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/tx.c           |   60 +++-
 drivers/net/wireless/wl12xx/wl12xx.h       |  129 +------
 drivers/net/wireless/wl12xx/wl12xx_80211.h |   17 +-
 17 files changed, 848 insertions(+), 324 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/sdio_test.c


-- 
Cheers,
Luca.


