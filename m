Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:38730 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843Ab0LOPAw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 10:00:52 -0500
Subject: pull request: wl12xx 2010-12-15
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 17:02:48 +0200
Message-ID: <1292425368.32385.14.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This pull-request contains some improvements and bug fixes for the wl12xx driver.

Please pull or let me know if there's any problem.  This tree is based
on wireless-next/master.

Don't know if there is still time to include these patches for 2.6.38,
since it's kind of late already, but I didn't see any email from you
saying "stop now!" either. ;)

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

Luciano Coelho (3):
      wl12xx: disable 11a channels when regulatory changes if 11a is not supported
      wl12xx: fix illegal memset if debugfs is not enabled
      wl12xx: disable 11a channels when wl->enable_11a is known

Roger Quadros (2):
      wl1271: Add wl1271_load_firmware() and export some functions
      wl1271_sdio_test: Add module for sdio RX/TX testing

 drivers/net/wireless/wl12xx/Kconfig            |    8 +
 drivers/net/wireless/wl12xx/Makefile           |    2 +
 drivers/net/wireless/wl12xx/acx.c              |    4 +-
 drivers/net/wireless/wl12xx/acx.h              |    9 +-
 drivers/net/wireless/wl12xx/boot.c             |   17 +-
 drivers/net/wireless/wl12xx/boot.h             |    1 +
 drivers/net/wireless/wl12xx/cmd.c              |   69 ++++
 drivers/net/wireless/wl12xx/cmd.h              |    4 +
 drivers/net/wireless/wl12xx/debugfs.c          |  192 ++-------
 drivers/net/wireless/wl12xx/init.c             |   13 +-
 drivers/net/wireless/wl12xx/io.c               |    1 +
 drivers/net/wireless/wl12xx/main.c             |  119 ++++--
 drivers/net/wireless/wl12xx/scan.c             |    4 +
 drivers/net/wireless/wl12xx/tx.c               |   60 +++-
 drivers/net/wireless/wl12xx/wl1271_sdio_test.c |  510 ++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl12xx.h           |  129 +------
 drivers/net/wireless/wl12xx/wl12xx_80211.h     |   17 +-
 17 files changed, 835 insertions(+), 324 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_sdio_test.c


-- 
Cheers,
Luca.


