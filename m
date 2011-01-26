Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:53790 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab1AZVFd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 16:05:33 -0500
Subject: pull request: wl12xx 2011-01-26
From: Luciano Coelho <coelho@ti.com>
To: <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 23:05:20 +0200
Message-ID: <1296075920.2302.45.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is my first pull request for 2.6.39.  It contains initial AP
support, initial block-ack support for 11n, a bunch of bug fixes and
other small improvements.

Please pull or let me know if there's any problem.  This tree is based
on wireless-next/master.

Thanks!

The following changes since commit 97d9c3a354f9eb6b8bfe4bf672bdbe9ff76956e6:

  ath5k: ath5k_setup_channels cleanup and whitespace (2011-01-25 16:39:06 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linville

Arik Nemtsov (20):
      wl12xx: Add AP related configuration to conf_drv_settings
      wl12xx: AP mode - AP specific CMD_CONFIGURE sub-commands
      wl12xx: AP mode - add AP specific event
      wl12xx: AP-mode high level commands
      wl12xx: AP mode - workaround for FW bug on station remove
      wl12xx: AP mode - init sequence
      wl12xx: AP specific RX filter configuration
      wl12xx: Add AP related definitions to HOST-FW interface
      wl12xx: Configure AP on BSS info change
      wl12xx: AP mode config in ieee80211_ops.config
      wl12xx: AP mode - change filter config
      wl12xx: AP mode - add STA add/remove ops
      wl12xx: AP mode - changes in TX path
      wl12xx: AP mode - record TX configuration settings
      wl12xx: AP mode - encryption support
      wl12xx: AP mode - fetch appropriate firmware for AP
      wl12xx: Read MAC address from NVS file on HW startup
      wl12xx: Enable AP-mode
      wl12xx: add missing MODULE_FIRMWARE statment for AP-mode FW
      wl12xx: Add channel 14 to list of supported 2ghz channels

Dan Carpenter (1):
      wl12xx: use after free in debug code

Eliad Peller (6):
      wl12xx: remove redundant debugfs_remove_recursive() call
      wl12xx: fix some sparse warnings
      wl12xx: don't join upon disassociation
      wl12xx: fix some endianess bugs
      wl12xx: wrong values are returned in gpio_power_write()
      wl12xx: disable auto-arp

Guy Eilam (1):
      wl12xx: change debug_level module param sysfs permissions

Juuso Oikarinen (2):
      wl12xx: Cleanup PLT mode when module is removed
      wl12xx: Increase scan channel dwell time for passive scans

Levi, Shahar (2):
      wl12xx: BA initiator support
      wl12xx: BA receiver support

Luciano Coelho (4):
      MAINTAINERS: update information for the wl12xx driver
      wl12xx: don't modify the global supported band structures
      wl12xx: lock the RCU when accessing sta via ieee80211_find_sta()
      wl12xx: add hw configuration for max supported AMDPU size

 MAINTAINERS                                |    6 +-
 drivers/net/wireless/wl12xx/acx.c          |  160 ++++-
 drivers/net/wireless/wl12xx/acx.h          |   91 +++-
 drivers/net/wireless/wl12xx/boot.c         |   35 +-
 drivers/net/wireless/wl12xx/cmd.c          |  308 ++++++++-
 drivers/net/wireless/wl12xx/cmd.h          |  147 ++++-
 drivers/net/wireless/wl12xx/conf.h         |   76 ++-
 drivers/net/wireless/wl12xx/debugfs.c      |   49 +-
 drivers/net/wireless/wl12xx/event.c        |    7 +-
 drivers/net/wireless/wl12xx/event.h        |    8 +-
 drivers/net/wireless/wl12xx/init.c         |  387 ++++++++--
 drivers/net/wireless/wl12xx/init.h         |    2 +-
 drivers/net/wireless/wl12xx/main.c         | 1115 +++++++++++++++++++++-------
 drivers/net/wireless/wl12xx/rx.c           |   14 +-
 drivers/net/wireless/wl12xx/rx.h           |   11 +-
 drivers/net/wireless/wl12xx/sdio.c         |    1 +
 drivers/net/wireless/wl12xx/spi.c          |    3 +-
 drivers/net/wireless/wl12xx/tx.c           |  105 +++-
 drivers/net/wireless/wl12xx/tx.h           |   10 +-
 drivers/net/wireless/wl12xx/wl12xx.h       |   88 ++-
 drivers/net/wireless/wl12xx/wl12xx_80211.h |   11 +-
 21 files changed, 2175 insertions(+), 459 deletions(-)

-- 
Cheers,
Luca.

