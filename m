Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab1INI6r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 04:58:47 -0400
Date: Wed, 14 Sep 2011 10:59:16 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linville@tuxdriver.com
Cc: Greg Dietsche <gregory.dietsche@cuw.edu>,
	linux-wireless@vger.kernel.org
Subject: pull request: iwlegacy 2011-09-14
Message-ID: <20110914085900.GA2717@redhat.com> (sfid-20110914_105853_372214_459A8ACE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Please pull iwlegacy cleanup changes done by Greg and me, intended
for 3.2. These request include huge patches with file renaming and
automatic code processing done by sed and indent. Work of changing
iwlegacy driver into something that I could consider maintainable
is not done yet, but these massive changes bring closer into that.
Hopefully with having clean, maintainable code I will be able to
fix some nasty, not easy reproducible bugs, we still have in the
iwlegacy driver.

Thanks.

The following changes since commit d82cdad64a0127611724c61849a8487d69fb76ef:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next (2011-08-30 16:34:33 -0400)

are available in the git repository at:

  git://github.com/dietsche/linux.git wireless-next-iwlegacy-stanislaw-greg

Greg Dietsche (9):
      iwlegacy: change IL_WARN to D_HT in il4965_tx_agg_start
      iwlegacy: change IL_ERR to D_HT in iwl4965_rs_tl_turn_on_agg_for_tid
      iwlegacy: 4965: remove vif null check in request_scan
      iwlegacy: 4965-rs: remove null check on sta in il4965_rs_tx_status
      iwlegacy: 4965-rs: remove unnecessary null check for sta and lq_sta
      iwlegacy: 4965-rs: il4965_rs_alloc_sta: remove lq_sta local var
      iwlegacy: 4965-rs: don't return rate from il4965_rs_update_rate_tbl
      iwlegacy: 4965-rs: cleanup il4965_rs_sta_dbgfs_rate_scale_data_read
      iwlegacy: debugfs_ops should depend on CONFIG_IWLEGACY_DEBUGFS

Stanislaw Gruszka (65):
      iwlegacy: remove tracing
      iwlegacy: rename iwl to il
      iwlegacy: rename priv to il
      iwlegacy: rename iwlegacy to il
      iwlegacy: remove DEBUG_IO
      iwlegacy: remove DEBUG_LIMIT
      iwlegacy: rename IL_DEBUG_ to D_
      iwlegacy: remove il argument from IWL_ERR/INFO/WARN/CRIT
      iwlegacy: remove IL_CRIT
      iwlegacy: rename il_{read,write}32 to _il_{rd,wr}
      iwlegacy: mark poll bit as unlocked function
      iwlegacy: mark il_{grab,release}_nic_access as unlocked
      iwlegacy: remove _il_{read,write}_direct32
      iwlegacy: rename i/o direct methods
      iwlegacy: rename il_{read,write}_prph
      iwlegacy: remove not needed parentheses
      iwlegacy: rename remaining IWLs to ILs
      iwlegacy: s/iwl_rx_packet/iwl_rx_pkt/
      iwlegacy: partial rxon context cleanup
      iwlegacy: s/il_rx_mem_buffer/il_rx_buf/
      iwlegacy: s/statistics/stats/
      iwlegacy: s/window/win/
      iwlegacy: s/IL_RATE/RATE/
      iwlegacy: s/INDEX/IDX/
      iwlegacy: s/index/idx/
      iwlegacy: s/TABLE/TBL/
      iwlegacy: remove for_each_context
      iwlegacy: rename base 4965 and 3945 file names
      iwlegacy: merge iwl-4965-led.c into 4965.c
      iwlegacy: merge iwl-3945-led.c into 3945.c
      iwlegacy: merge iwl-4965-eeprom.c into 4965.c
      iwlegacy: merge iwl-4965-ucode.c into 4965.c
      iwlegacy: merge iwl-4965-sta.c into 4965-mac.c
      iwlegacy: merge iwl-4965-{tx,rx}.c into 4965-mac.c
      iwlegacy: merge iwl-4965-lib.c into 4965-mac.c
      iwlegacy: rename iwl-4965-{rs,calib,debugfs}.c to 4965-{rs,calib,debug}.c
      iwlegacy: rename iwl-3945-{rs,debugfs}.c to 3945-{rs,debug}.c
      iwlegacy: move iwl-4965-{,hw,debugfs,calib}.h to 4965.h
      iwlegacy: move iwl-3945-{,hw,fh,debugfs}.h to 3945.h
      iwlegacy: s/STATUS_/S_/
      iwlegacy: s/STATISTICS/STATS/
      iwlegacy: rename REPLY_ to N_ or C_
      iwlegacy: s/rx_handler/handler/
      iwlegacy: s/rx_reply/hdl/
      iwlegacy: rename other handlers
      iwlegacy: rename iwl-core.c to common.c
      iwlegacy: merge common .c files and rename module name
      iwlegacy: rename iwl-commands.h to commands.h
      iwlegacy: remove il_ieee80211_get_hw_conf
      iwlegacy: move IL_MASK
      iwlegacy: rename iwl-csr.h to csr.h
      iwlegacy: rename iwl-core.h to common.h
      iwlegacy: merge common header files
      iwlegacy: remove iwl-helpers.h
      iwlegacy: merge iwl-legacy-rs.h into common.h
      iwlegacy: merge iwl-power.h into common.h
      iwlegacy: merge iwl-{eeprom,led}.h into common.h
      iwlegacy: rename iwl-prph.h to prph.h
      iwlegacy: use FH39_ prefix in 3945 code
      iwlegacy: use FH49_ prefix in 4965 code
      iwlegacy: merge iwl-fh.h into 4965.h
      iwlegacy: rename iwl-debug.c to debug.c
      iwlegacy: merge iwl-debug.h into common.h
      iwlegacy: indentions and whitespaces
      iwlegacy: checkpatch.pl fixes

 drivers/net/wireless/Makefile                      |    2 +-
 drivers/net/wireless/iwlegacy/3945-debug.c         |  505 ++
 drivers/net/wireless/iwlegacy/3945-mac.c           | 3978 ++++++++++++
 drivers/net/wireless/iwlegacy/3945-rs.c            |  995 +++
 drivers/net/wireless/iwlegacy/3945.c               | 2751 ++++++++
 drivers/net/wireless/iwlegacy/3945.h               |  626 ++
 .../iwlegacy/{iwl-4965-calib.c => 4965-calib.c}    |  613 +-
 drivers/net/wireless/iwlegacy/4965-debug.c         |  746 +++
 drivers/net/wireless/iwlegacy/4965-mac.c           | 6536 ++++++++++++++++++++
 drivers/net/wireless/iwlegacy/4965-rs.c            | 2860 +++++++++
 drivers/net/wireless/iwlegacy/4965.c               | 2423 ++++++++
 drivers/net/wireless/iwlegacy/4965.h               | 1309 ++++
 drivers/net/wireless/iwlegacy/Kconfig              |   43 +-
 drivers/net/wireless/iwlegacy/Makefile             |   22 +-
 .../iwlegacy/{iwl-commands.h => commands.h}        | 1134 ++--
 drivers/net/wireless/iwlegacy/common.c             | 5704 +++++++++++++++++
 drivers/net/wireless/iwlegacy/common.h             | 3424 ++++++++++
 drivers/net/wireless/iwlegacy/{iwl-csr.h => csr.h} |   93 +-
 drivers/net/wireless/iwlegacy/debug.c              | 1410 +++++
 drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c   |  523 --
 drivers/net/wireless/iwlegacy/iwl-3945-debugfs.h   |   60 -
 drivers/net/wireless/iwlegacy/iwl-3945-fh.h        |  187 -
 drivers/net/wireless/iwlegacy/iwl-3945-hw.h        |  291 -
 drivers/net/wireless/iwlegacy/iwl-3945-led.c       |   63 -
 drivers/net/wireless/iwlegacy/iwl-3945-led.h       |   32 -
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c        |  996 ---
 drivers/net/wireless/iwlegacy/iwl-3945.c           | 2741 --------
 drivers/net/wireless/iwlegacy/iwl-3945.h           |  308 -
 drivers/net/wireless/iwlegacy/iwl-4965-calib.h     |   75 -
 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c   |  774 ---
 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.h   |   59 -
 drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c    |  154 -
 drivers/net/wireless/iwlegacy/iwl-4965-hw.h        |  811 ---
 drivers/net/wireless/iwlegacy/iwl-4965-led.c       |   73 -
 drivers/net/wireless/iwlegacy/iwl-4965-led.h       |   33 -
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c       | 1194 ----
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c        | 2871 ---------
 drivers/net/wireless/iwlegacy/iwl-4965-rx.c        |  215 -
 drivers/net/wireless/iwlegacy/iwl-4965-sta.c       |  721 ---
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c        | 1378 -----
 drivers/net/wireless/iwlegacy/iwl-4965-ucode.c     |  166 -
 drivers/net/wireless/iwlegacy/iwl-4965.c           | 2183 -------
 drivers/net/wireless/iwlegacy/iwl-4965.h           |  282 -
 drivers/net/wireless/iwlegacy/iwl-core.c           | 2659 --------
 drivers/net/wireless/iwlegacy/iwl-core.h           |  634 --
 drivers/net/wireless/iwlegacy/iwl-debug.h          |  198 -
 drivers/net/wireless/iwlegacy/iwl-debugfs.c        | 1313 ----
 drivers/net/wireless/iwlegacy/iwl-dev.h            | 1364 ----
 drivers/net/wireless/iwlegacy/iwl-devtrace.c       |   42 -
 drivers/net/wireless/iwlegacy/iwl-devtrace.h       |  210 -
 drivers/net/wireless/iwlegacy/iwl-eeprom.c         |  553 --
 drivers/net/wireless/iwlegacy/iwl-eeprom.h         |  344 -
 drivers/net/wireless/iwlegacy/iwl-fh.h             |  513 --
 drivers/net/wireless/iwlegacy/iwl-hcmd.c           |  271 -
 drivers/net/wireless/iwlegacy/iwl-helpers.h        |  196 -
 drivers/net/wireless/iwlegacy/iwl-io.h             |  545 --
 drivers/net/wireless/iwlegacy/iwl-led.c            |  205 -
 drivers/net/wireless/iwlegacy/iwl-led.h            |   56 -
 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h      |  456 --
 drivers/net/wireless/iwlegacy/iwl-power.c          |  165 -
 drivers/net/wireless/iwlegacy/iwl-power.h          |   55 -
 drivers/net/wireless/iwlegacy/iwl-rx.c             |  281 -
 drivers/net/wireless/iwlegacy/iwl-scan.c           |  549 --
 drivers/net/wireless/iwlegacy/iwl-spectrum.h       |    4 +-
 drivers/net/wireless/iwlegacy/iwl-sta.c            |  816 ---
 drivers/net/wireless/iwlegacy/iwl-sta.h            |  148 -
 drivers/net/wireless/iwlegacy/iwl-tx.c             |  656 --
 drivers/net/wireless/iwlegacy/iwl3945-base.c       | 4016 ------------
 drivers/net/wireless/iwlegacy/iwl4965-base.c       | 3281 ----------
 .../net/wireless/iwlegacy/{iwl-prph.h => prph.h}   |  133 +-
 70 files changed, 34254 insertions(+), 36773 deletions(-)
 create mode 100644 drivers/net/wireless/iwlegacy/3945-debug.c
 create mode 100644 drivers/net/wireless/iwlegacy/3945-mac.c
 create mode 100644 drivers/net/wireless/iwlegacy/3945-rs.c
 create mode 100644 drivers/net/wireless/iwlegacy/3945.c
 create mode 100644 drivers/net/wireless/iwlegacy/3945.h
 rename drivers/net/wireless/iwlegacy/{iwl-4965-calib.c => 4965-calib.c} (55%)
 create mode 100644 drivers/net/wireless/iwlegacy/4965-debug.c
 create mode 100644 drivers/net/wireless/iwlegacy/4965-mac.c
 create mode 100644 drivers/net/wireless/iwlegacy/4965-rs.c
 create mode 100644 drivers/net/wireless/iwlegacy/4965.c
 create mode 100644 drivers/net/wireless/iwlegacy/4965.h
 rename drivers/net/wireless/iwlegacy/{iwl-commands.h => commands.h} (79%)
 create mode 100644 drivers/net/wireless/iwlegacy/common.c
 create mode 100644 drivers/net/wireless/iwlegacy/common.h
 rename drivers/net/wireless/iwlegacy/{iwl-csr.h => csr.h} (84%)
 create mode 100644 drivers/net/wireless/iwlegacy/debug.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-debugfs.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-fh.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-hw.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-led.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-led.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-rs.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-calib.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-hw.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-led.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-led.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-lib.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-rs.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-rx.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-sta.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-tx.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-core.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-core.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-debug.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-debugfs.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-dev.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-devtrace.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-devtrace.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-eeprom.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-eeprom.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-fh.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-hcmd.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-helpers.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-io.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-led.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-led.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-power.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-power.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-rx.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-scan.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-sta.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-sta.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-tx.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl3945-base.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl4965-base.c
 rename drivers/net/wireless/iwlegacy/{iwl-prph.h => prph.h} (83%)
