Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:31296 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834Ab0KVOxX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 09:53:23 -0500
Subject: pull request: wl12xx 2010-11-22
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 16:53:13 +0200
Message-ID: <1290437593.3322.36.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This pull-request contains patches that change the name of the driver
from wl1271 to wl12xx and a few other improvements and bug fixes.

Please pull or let me know if there's any problem.  This tree is based
on wireless-next/master.

Thanks!

The following changes since commit a76a574ca9ce7c05791cee42f000f2a42c687837:
  Rafał Miłecki (1):
        ssb: drop BCM4328 hack for SPROM revision

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git wl12xx-next

Arik Nemtsov (1):
      wl1271: add support for HW TX fragmentation

Gery Kahn (1):
      wl1271: cleanup unused code of calibration structures

Juuso Oikarinen (3):
      wl1271: Prevent ad-hoc and active scanning on 11a DFS frequencies
      Revert "wl1271: Change supported channel order for a more optimal scan"
      wl12xx: Unset bssid filter, ssid and bssid from firmware on disassoc

Shahar Levi (1):
      wl1271: Change wl12xx Files Names

 drivers/net/wireless/wl12xx/Kconfig                |   52 +++---
 drivers/net/wireless/wl12xx/Makefile               |   17 +-
 .../net/wireless/wl12xx/{wl1271_acx.c => acx.c}    |   12 +-
 .../net/wireless/wl12xx/{wl1271_acx.h => acx.h}    |   10 +-
 .../net/wireless/wl12xx/{wl1271_boot.c => boot.c}  |   10 +-
 .../net/wireless/wl12xx/{wl1271_boot.h => boot.h}  |    2 +-
 .../net/wireless/wl12xx/{wl1271_cmd.c => cmd.c}    |   12 +-
 .../net/wireless/wl12xx/{wl1271_cmd.h => cmd.h}    |   54 +------
 .../net/wireless/wl12xx/{wl1271_conf.h => conf.h}  |    4 +-
 .../wl12xx/{wl1271_debugfs.c => debugfs.c}         |   10 +-
 .../wl12xx/{wl1271_debugfs.h => debugfs.h}         |    6 +-
 .../wireless/wl12xx/{wl1271_event.c => event.c}    |   12 +-
 .../wireless/wl12xx/{wl1271_event.h => event.h}    |    4 +-
 .../net/wireless/wl12xx/{wl1271_ini.h => ini.h}    |    4 +-
 .../net/wireless/wl12xx/{wl1271_init.c => init.c}  |   10 +-
 .../net/wireless/wl12xx/{wl1271_init.h => init.h}  |    6 +-
 drivers/net/wireless/wl12xx/{wl1271_io.c => io.c}  |    4 +-
 drivers/net/wireless/wl12xx/{wl1271_io.h => io.h}  |    6 +-
 .../net/wireless/wl12xx/{wl1271_main.c => main.c}  |  183 +++++++++++++-------
 drivers/net/wireless/wl12xx/{wl1271_ps.c => ps.c}  |    6 +-
 drivers/net/wireless/wl12xx/{wl1271_ps.h => ps.h}  |    8 +-
 .../net/wireless/wl12xx/{wl1271_reg.h => reg.h}    |    0
 drivers/net/wireless/wl12xx/{wl1271_rx.c => rx.c}  |   12 +-
 drivers/net/wireless/wl12xx/{wl1271_rx.h => rx.h}  |    4 +-
 .../net/wireless/wl12xx/{wl1271_scan.c => scan.c}  |    8 +-
 .../net/wireless/wl12xx/{wl1271_scan.h => scan.h}  |    6 +-
 .../net/wireless/wl12xx/{wl1271_sdio.c => sdio.c}  |    4 +-
 .../net/wireless/wl12xx/{wl1271_spi.c => spi.c}    |    6 +-
 .../wl12xx/{wl1271_testmode.c => testmode.c}       |    6 +-
 .../wl12xx/{wl1271_testmode.h => testmode.h}       |    4 +-
 drivers/net/wireless/wl12xx/{wl1271_tx.c => tx.c}  |   12 +-
 drivers/net/wireless/wl12xx/{wl1271_tx.h => tx.h}  |    4 +-
 drivers/net/wireless/wl12xx/{wl1271.h => wl12xx.h} |    8 +-
 33 files changed, 255 insertions(+), 251 deletions(-)
 rename drivers/net/wireless/wl12xx/{wl1271_acx.c => acx.c} (99%)
 rename drivers/net/wireless/wl12xx/{wl1271_acx.h => acx.h} (99%)
 rename drivers/net/wireless/wl12xx/{wl1271_boot.c => boot.c} (99%)
 rename drivers/net/wireless/wl12xx/{wl1271_boot.h => boot.h} (98%)
 rename drivers/net/wireless/wl12xx/{wl1271_cmd.c => cmd.c} (99%)
 rename drivers/net/wireless/wl12xx/{wl1271_cmd.h => cmd.h} (91%)
 rename drivers/net/wireless/wl12xx/{wl1271_conf.h => conf.h} (99%)
 rename drivers/net/wireless/wl12xx/{wl1271_debugfs.c => debugfs.c} (99%)
 rename drivers/net/wireless/wl12xx/{wl1271_debugfs.h => debugfs.h} (93%)
 rename drivers/net/wireless/wl12xx/{wl1271_event.c => event.c} (98%)
 rename drivers/net/wireless/wl12xx/{wl1271_event.h => event.h} (98%)
 rename drivers/net/wireless/wl12xx/{wl1271_ini.h => ini.h} (98%)
 rename drivers/net/wireless/wl12xx/{wl1271_init.c => init.c} (98%)
 rename drivers/net/wireless/wl12xx/{wl1271_init.h => init.h} (93%)
 rename drivers/net/wireless/wl12xx/{wl1271_io.c => io.c} (99%)
 rename drivers/net/wireless/wl12xx/{wl1271_io.h => io.h} (98%)
 rename drivers/net/wireless/wl12xx/{wl1271_main.c => main.c} (97%)
 rename drivers/net/wireless/wl12xx/{wl1271_ps.c => ps.c} (98%)
 rename drivers/net/wireless/wl12xx/{wl1271_ps.h => ps.h} (92%)
 rename drivers/net/wireless/wl12xx/{wl1271_reg.h => reg.h} (100%)
 rename drivers/net/wireless/wl12xx/{wl1271_rx.c => rx.c} (97%)
 rename drivers/net/wireless/wl12xx/{wl1271_rx.h => rx.h} (98%)
 rename drivers/net/wireless/wl12xx/{wl1271_scan.c => scan.c} (98%)
 rename drivers/net/wireless/wl12xx/{wl1271_scan.h => scan.h} (97%)
 rename drivers/net/wireless/wl12xx/{wl1271_sdio.c => sdio.c} (99%)
 rename drivers/net/wireless/wl12xx/{wl1271_spi.c => spi.c} (99%)
 rename drivers/net/wireless/wl12xx/{wl1271_testmode.c => testmode.c} (98%)
 rename drivers/net/wireless/wl12xx/{wl1271_testmode.h => testmode.h} (93%)
 rename drivers/net/wireless/wl12xx/{wl1271_tx.c => tx.c} (98%)
 rename drivers/net/wireless/wl12xx/{wl1271_tx.h => tx.h} (99%)
 rename drivers/net/wireless/wl12xx/{wl1271.h => wl12xx.h} (99%)


-- 
Cheers,
Luca.

