Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29327 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab1BUUAO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 15:00:14 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/4] update for 2.6.39
Date: Mon, 21 Feb 2011 11:45:32 -0800
Message-Id: <1298317536-5071-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We split legacy(3945/4965) from iwlwifi into separated directory(iwlegacy)
We also fix few firmware related problems

Wey-Yi Guy (3):
  iwlwifi: Limit number of firmware reload
  iwlwifi: Loading correct uCode again when fail to load
  iwlwifi: enable 2-wire bt coex support for non-combo device

Meenakshi Venkataraman (1):
  iwlwifi: split the drivers for agn and legacy devices 3945/4965

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/Kconfig                     |    1 +
 drivers/net/wireless/Makefile                    |    3 +-
 drivers/net/wireless/iwlegacy/Kconfig            |  116 +
 drivers/net/wireless/iwlegacy/Makefile           |   25 +
 drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c |  523 +++
 drivers/net/wireless/iwlegacy/iwl-3945-debugfs.h |   60 +
 drivers/net/wireless/iwlegacy/iwl-3945-fh.h      |  187 +
 drivers/net/wireless/iwlegacy/iwl-3945-hw.h      |  293 ++
 drivers/net/wireless/iwlegacy/iwl-3945-led.c     |   64 +
 drivers/net/wireless/iwlegacy/iwl-3945-led.h     |   32 +
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c      |  994 +++++
 drivers/net/wireless/iwlegacy/iwl-3945.c         | 2744 ++++++++++++++
 drivers/net/wireless/iwlegacy/iwl-3945.h         |  308 ++
 drivers/net/wireless/iwlegacy/iwl-4965-calib.c   |  967 +++++
 drivers/net/wireless/iwlegacy/iwl-4965-calib.h   |   75 +
 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c |  774 ++++
 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.h |   59 +
 drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c  |  154 +
 drivers/net/wireless/iwlegacy/iwl-4965-hw.h      |  814 ++++
 drivers/net/wireless/iwlegacy/iwl-4965-led.c     |   74 +
 drivers/net/wireless/iwlegacy/iwl-4965-led.h     |   33 +
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c     | 1260 +++++++
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c      | 2870 ++++++++++++++
 drivers/net/wireless/iwlegacy/iwl-4965-rx.c      |  291 ++
 drivers/net/wireless/iwlegacy/iwl-4965-sta.c     |  720 ++++
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c      | 1359 +++++++
 drivers/net/wireless/iwlegacy/iwl-4965-ucode.c   |  166 +
 drivers/net/wireless/iwlegacy/iwl-4965.c         | 2188 +++++++++++
 drivers/net/wireless/iwlegacy/iwl-4965.h         |  282 ++
 drivers/net/wireless/iwlegacy/iwl-commands.h     | 3405 +++++++++++++++++
 drivers/net/wireless/iwlegacy/iwl-core.c         | 2668 +++++++++++++
 drivers/net/wireless/iwlegacy/iwl-core.h         |  646 ++++
 drivers/net/wireless/iwlegacy/iwl-csr.h          |  422 +++
 drivers/net/wireless/iwlegacy/iwl-debug.h        |  198 +
 drivers/net/wireless/iwlegacy/iwl-debugfs.c      | 1467 ++++++++
 drivers/net/wireless/iwlegacy/iwl-dev.h          | 1426 +++++++
 drivers/net/wireless/iwlegacy/iwl-devtrace.c     |   45 +
 drivers/net/wireless/iwlegacy/iwl-devtrace.h     |  270 ++
 drivers/net/wireless/iwlegacy/iwl-eeprom.c       |  561 +++
 drivers/net/wireless/iwlegacy/iwl-eeprom.h       |  344 ++
 drivers/net/wireless/iwlegacy/iwl-fh.h           |  513 +++
 drivers/net/wireless/iwlegacy/iwl-hcmd.c         |  271 ++
 drivers/net/wireless/iwlegacy/iwl-helpers.h      |  181 +
 drivers/net/wireless/iwlegacy/iwl-io.h           |  545 +++
 drivers/net/wireless/iwlegacy/iwl-led.c          |  188 +
 drivers/net/wireless/iwlegacy/iwl-led.h          |   56 +
 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h    |  456 +++
 drivers/net/wireless/iwlegacy/iwl-power.c        |  165 +
 drivers/net/wireless/iwlegacy/iwl-power.h        |   55 +
 drivers/net/wireless/iwlegacy/iwl-prph.h         |  523 +++
 drivers/net/wireless/iwlegacy/iwl-rx.c           |  302 ++
 drivers/net/wireless/iwlegacy/iwl-scan.c         |  625 ++++
 drivers/net/wireless/iwlegacy/iwl-spectrum.h     |   92 +
 drivers/net/wireless/iwlegacy/iwl-sta.c          |  816 ++++
 drivers/net/wireless/iwlegacy/iwl-sta.h          |  148 +
 drivers/net/wireless/iwlegacy/iwl-tx.c           |  637 ++++
 drivers/net/wireless/iwlegacy/iwl3945-base.c     | 4294 +++++++++++++++++++++
 drivers/net/wireless/iwlegacy/iwl4965-base.c     | 3633 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/Kconfig             |  124 +-
 drivers/net/wireless/iwlwifi/Makefile            |   39 +-
 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c  |  522 ---
 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.h  |   60 -
 drivers/net/wireless/iwlwifi/iwl-3945-fh.h       |  188 -
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h       |  294 --
 drivers/net/wireless/iwlwifi/iwl-3945-led.c      |   64 -
 drivers/net/wireless/iwlwifi/iwl-3945-led.h      |   32 -
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c       |  995 -----
 drivers/net/wireless/iwlwifi/iwl-3945.c          | 2819 --------------
 drivers/net/wireless/iwlwifi/iwl-3945.h          |  308 --
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h       |  792 ----
 drivers/net/wireless/iwlwifi/iwl-4965.c          | 2666 -------------
 drivers/net/wireless/iwlwifi/iwl-agn.c           |   35 +-
 drivers/net/wireless/iwlwifi/iwl-core.c          |   76 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |    2 -
 drivers/net/wireless/iwlwifi/iwl-dev.h           |   13 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c        |    8 -
 drivers/net/wireless/iwlwifi/iwl-hcmd.c          |    5 -
 drivers/net/wireless/iwlwifi/iwl-led.c           |    2 -
 drivers/net/wireless/iwlwifi/iwl-legacy.c        |  657 ----
 drivers/net/wireless/iwlwifi/iwl-legacy.h        |   79 -
 drivers/net/wireless/iwlwifi/iwl-power.c         |    3 -
 drivers/net/wireless/iwlwifi/iwl-rx.c            |    6 -
 drivers/net/wireless/iwlwifi/iwl-scan.c          |   10 -
 drivers/net/wireless/iwlwifi/iwl-sta.c           |   11 -
 drivers/net/wireless/iwlwifi/iwl-tx.c            |    7 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c      | 4334 ----------------------
 86 files changed, 42490 insertions(+), 14049 deletions(-)
 create mode 100644 drivers/net/wireless/iwlegacy/Kconfig
 create mode 100644 drivers/net/wireless/iwlegacy/Makefile
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-debugfs.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-fh.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-hw.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-led.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-led.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-rs.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-3945.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-3945.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-calib.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-calib.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-hw.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-led.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-led.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-lib.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-rs.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-rx.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-sta.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-tx.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-commands.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-core.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-core.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-csr.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-debug.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-debugfs.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-dev.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-devtrace.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-devtrace.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-eeprom.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-eeprom.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-fh.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-hcmd.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-helpers.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-io.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-led.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-led.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-power.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-power.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-prph.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-rx.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-scan.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-spectrum.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-sta.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-sta.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-tx.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl3945-base.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl4965-base.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-fh.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-hw.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-led.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-led.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-rs.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-4965-hw.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-4965.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-legacy.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-legacy.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl3945-base.c

