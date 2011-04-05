Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4582 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368Ab1DERB1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/25] update for 2.6.40
Date: Tue,  5 Apr 2011 09:41:47 -0700
Message-Id: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We continue the _agn clean up work after driver split

Johannes Berg (21):
  iwlagn: remove unused variable
  iwlagn: clean up some 3945/4965 remnants
  iwlagn: make mac80211 handlers static
  iwlagn: clean up ucode loading
  iwlagn: remove pointless return variables
  iwlagn: simplify ucode check code
  iwlagn: verify specific ucode
  iwlagn: remove bootstrap code
  iwlagn: centralize and fix ucode restart
  iwlagn: remove ucode_data_backup
  iwlagn: add feature flags
  iwlagn: fix ucode verify message
  iwlagn: clean up alive handling
  iwlagn: init cmd_queue earlier
  iwlagn: remove BSM clock setting
  iwlagn: remove hw_wa_rev
  iwlagn: remove hw_rev
  iwlagn: remove rev_id
  iwlagn: remove rxb page bookkeeping
  iwlagn: remove ISR ops
  iwlagn: move IO functions out of line

Wey-Yi Guy (4):
  iwlagn: remove more 3945/4965 related defines
  iwlagn: return send calibration result
  iwlagn: change Copyright to 2011
  iwlagn: check more error return code


 drivers/net/wireless/iwlwifi/Makefile          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c        |   14 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c        |   15 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c        |   25 +-
 drivers/net/wireless/iwlwifi/iwl-6000-hw.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c        |   26 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |   52 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c  |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-led.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-led.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c      |   11 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h      |   30 +--
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c   |  122 ++---
 drivers/net/wireless/iwlwifi/iwl-agn.c         |  225 ++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.h         |   36 +--
 drivers/net/wireless/iwlwifi/iwl-commands.h    |  643 +-----------------------
 drivers/net/wireless/iwlwifi/iwl-core.c        |  114 ++---
 drivers/net/wireless/iwlwifi/iwl-core.h        |   30 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |    9 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h         |  271 +++-------
 drivers/net/wireless/iwlwifi/iwl-devtrace.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c      |   48 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h      |  191 +-------
 drivers/net/wireless/iwlwifi/iwl-fh.h          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c        |    4 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.c          |  274 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-io.h          |  491 +-----------------
 drivers/net/wireless/iwlwifi/iwl-led.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h        |  342 +-------------
 drivers/net/wireless/iwlwifi/iwl-rx.c          |   13 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c         |    3 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c          |    6 +-
 55 files changed, 700 insertions(+), 2380 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-io.c

