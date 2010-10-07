Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59924 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab0JGXIr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:47 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/22] update for 2.6.37
Date: Thu,  7 Oct 2010 16:07:39 -0700
Message-Id: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add temperature offset calibration support for 6000g2 series devices.
We also did a lot of cleanup to separate agn and legacy devices.

Johannes Berg (19):
  iwlagn: rename iwl_commit_rxon
  iwlwifi: introduce post_scan hook
  iwl3945: use iwl3945_commit_rxon
  iwlwifi: move chain settings to agn
  iwlwifi: rename iwl_mac_beacon_update
  iwlwifi: remove verify_signature eeprom operation
  iwlwifi: move agn specific station code there
  iwlwifi: move tx fail code to agn
  iwlwifi: remove spurious exports
  iwlwifi: remove agn rates info there
  iwlwifi: move iwl_toggle_rx_ant to agn
  iwlwifi: move iwl_dump_csr to agn
  iwlwifi: move iwl_dump_fh to agn
  iwlwifi: remove set_ct_kill operation
  iwlwifi: remove set_pwr_src operation
  iwlwifi: remove apm_ops.stop
  iwlwifi: clean up declarations
  iwlwifi: remove iwl_check_bits
  iwlwifi: fix dual-mode scanning

Shanyu Zhao (2):
  iwlagn: fix default calibration table size
  iwlagn: add temperature offset calib for 6000g2

Wey-Yi Guy (1):
  iwlagn: no version check for experimental uCode

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/Makefile        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c      |    7 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c      |   75 ++-
 drivers/net/wireless/iwlwifi/iwl-3945.h      |    9 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c      |   27 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c      |   14 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c      |   22 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h |   86 +++
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c  |    9 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |  332 ++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c    |   69 +++
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h    |   10 -
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c   |  716 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c    |    5 -
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   40 ++
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   28 +
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   57 +--
 drivers/net/wireless/iwlwifi/iwl-agn.h       |   65 +++
 drivers/net/wireless/iwlwifi/iwl-calib.h     |   82 ---
 drivers/net/wireless/iwlwifi/iwl-commands.h  |   13 +-
 drivers/net/wireless/iwlwifi/iwl-core.c      |  401 +--------------
 drivers/net/wireless/iwlwifi/iwl-core.h      |   49 +--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   12 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c    |    7 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h    |    1 -
 drivers/net/wireless/iwlwifi/iwl-helpers.h   |    5 -
 drivers/net/wireless/iwlwifi/iwl-rx.c        |    1 -
 drivers/net/wireless/iwlwifi/iwl-scan.c      |   12 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c       |  725 +-------------------------
 drivers/net/wireless/iwlwifi/iwl-sta.h       |   35 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c        |   38 --
 drivers/net/wireless/iwlwifi/iwl3945-base.c  |   55 ++-
 35 files changed, 1554 insertions(+), 1460 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-calib.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-sta.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-calib.h

