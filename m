Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:52625 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab0I2Pxe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 11:53:34 -0400
Subject: pull request: wl1xx 2010-09-29
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 18:53:19 +0300
Message-ID: <1285775599.9024.5.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

The wl12xx tree is ready for pulling.  There are lots of changes, as you
already know, mostly bugfixes and other stability improvements that were
still pending in our internal tree.

This is my first pull request to you, so please let me know if there are
any problems with it.

The following changes since commit 1728943d83e9fd919e454332fe344944123b3c3a:
  John W. Linville (1):
        Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git wireless-next

Juuso Oikarinen (22):
      wl1271: Implement CMD_SET_STA_STATE to indicate connection completion to FW
      wl1271: Add trigger to net_device oper_state to change BT coex priority
      wl1271: Fix scan race condition
      wl1271: Change supported channel order for a more optimal scan
      wl1271: Remove outdated FIXME's
      wl1271: Move setting of wake-up conditions to ps.c from cmd.c
      wl1271: Remove acx_fw_version function
      wl1271: Release interrupt *after* releasing the driver context
      wl1271: Remove function cmd_read_memory
      wl1271: Enable/disable 11a support based on INI configuration
      wl1271: Reduce rate used for last PSM entry attempt
      wl1271: Enable 11a support always, prevent scanning for unsupporting chips
      wl1271: Fix tid-configuration of TX frames
      wl1271: Fix AC/TID default configuration
      wl1271: Move scan complete invocation into work function
      wl1271: Fix work cancelling when shutting down the driver
      wl1271: Separate interface removal to another function
      wl1271: Add hardware recovery mechanism
      wl1271: Add handling for failing hardware scan command
      wl1271: Optimize scan duration
      wl1271: Increase connection reliability
      wl1271: Add support for hardware GEM cipher

Luciano Coelho (4):
      wl1271: remove deprecated ACX definition
      wl1271: remove useless 11a check when scanning
      wl1271: fix forced passive scan
      MAINTAINERS: Update git url for the wl1271 driver

ext Ohad Ben-Cohen (1):
      wl12xx: fix non-wl12xx build scenarios

 MAINTAINERS                                   |    2 +-
 drivers/net/wireless/wl12xx/wl1271.h          |   24 +-
 drivers/net/wireless/wl12xx/wl1271_acx.c      |   34 ---
 drivers/net/wireless/wl12xx/wl1271_acx.h      |   31 ---
 drivers/net/wireless/wl12xx/wl1271_boot.c     |   39 ++-
 drivers/net/wireless/wl12xx/wl1271_cmd.c      |   89 +++----
 drivers/net/wireless/wl12xx/wl1271_cmd.h      |   49 +---
 drivers/net/wireless/wl12xx/wl1271_conf.h     |   57 ++++-
 drivers/net/wireless/wl12xx/wl1271_event.c    |   15 +-
 drivers/net/wireless/wl12xx/wl1271_init.c     |   35 ++--
 drivers/net/wireless/wl12xx/wl1271_main.c     |  358 ++++++++++++++++---------
 drivers/net/wireless/wl12xx/wl1271_ps.c       |   20 ++-
 drivers/net/wireless/wl12xx/wl1271_ps.h       |    2 +-
 drivers/net/wireless/wl12xx/wl1271_scan.c     |   79 +++++-
 drivers/net/wireless/wl12xx/wl1271_scan.h     |    6 +-
 drivers/net/wireless/wl12xx/wl1271_sdio.c     |    3 +-
 drivers/net/wireless/wl12xx/wl1271_spi.c      |    3 +-
 drivers/net/wireless/wl12xx/wl1271_testmode.c |   14 +-
 drivers/net/wireless/wl12xx/wl1271_tx.c       |    6 +-
 drivers/net/wireless/wl12xx/wl1271_tx.h       |   17 --
 include/linux/wl12xx.h                        |   13 +
 21 files changed, 500 insertions(+), 396 deletions(-)


-- 
Cheers,
Luca.

