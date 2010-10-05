Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:53026 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab0JEQBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 12:01:39 -0400
Subject: pull-request: wl12xx 2010-10-05 (replaces 2010-09.29)
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 19:01:13 +0300
Message-ID: <1286294473.31817.3.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

As we agreed on IRC, here's my new pull request for wl12xx.  It replaces
(or rather is a superset of) the previous request I sent last week.

Please let me know if you find any problems.

The following changes since commit 1728943d83e9fd919e454332fe344944123b3c3a:
  John W. Linville (1):
        Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git wireless-next

Ido Yariv (3):
      wl1271: Handle large SPI transfers
      wl1271: Support firmware RX packet aggregation
      wl1271: Support firmware TX packet aggregation

Juuso Oikarinen (25):
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
      wl1271: Move work-init calls to hw allocation
      wl1271: Indicate disconnection on hardware failure
      wl1271: Add extended radio parameter initialization

Luciano Coelho (5):
      wl1271: remove deprecated ACX definition
      wl1271: remove useless 11a check when scanning
      wl1271: fix forced passive scan
      MAINTAINERS: Update git url for the wl1271 driver
      wl1271: remove deprecated __attribute__ ((packed))

Ohad Ben-Cohen (1):
      wl12xx: fix non-wl12xx build scenarios

ext Anand Gadiyar (1):
      omap: zoom2/3: fix build caused by wl1271 support

 MAINTAINERS                                   |    2 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c  |    2 +-
 drivers/net/wireless/wl12xx/wl1271.h          |   29 +-
 drivers/net/wireless/wl12xx/wl1271_acx.c      |   34 ---
 drivers/net/wireless/wl12xx/wl1271_acx.h      |   31 --
 drivers/net/wireless/wl12xx/wl1271_boot.c     |   39 ++-
 drivers/net/wireless/wl12xx/wl1271_cmd.c      |  122 +++++----
 drivers/net/wireless/wl12xx/wl1271_cmd.h      |   73 ++---
 drivers/net/wireless/wl12xx/wl1271_conf.h     |   78 +++++-
 drivers/net/wireless/wl12xx/wl1271_event.c    |   15 +-
 drivers/net/wireless/wl12xx/wl1271_init.c     |   39 ++--
 drivers/net/wireless/wl12xx/wl1271_main.c     |  393 ++++++++++++++++---------
 drivers/net/wireless/wl12xx/wl1271_ps.c       |   20 +-
 drivers/net/wireless/wl12xx/wl1271_ps.h       |    2 +-
 drivers/net/wireless/wl12xx/wl1271_rx.c       |   63 +++-
 drivers/net/wireless/wl12xx/wl1271_scan.c     |   79 ++++-
 drivers/net/wireless/wl12xx/wl1271_scan.h     |    6 +-
 drivers/net/wireless/wl12xx/wl1271_sdio.c     |    3 +-
 drivers/net/wireless/wl12xx/wl1271_spi.c      |  143 ++++++----
 drivers/net/wireless/wl12xx/wl1271_testmode.c |   14 +-
 drivers/net/wireless/wl12xx/wl1271_tx.c       |  105 +++----
 drivers/net/wireless/wl12xx/wl1271_tx.h       |   17 -
 include/linux/wl12xx.h                        |   13 +
 23 files changed, 784 insertions(+), 538 deletions(-)


-- 
Cheers,
Luca.

