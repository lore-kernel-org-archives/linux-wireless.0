Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50845 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab1DHPuK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 11:50:10 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/16] update for 2.6.40
Date: Fri,  8 Apr 2011 08:30:20 -0700
Message-Id: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have more _agn clean up work after driver split
We also fix a frame rejection bug in radar channel 

Garen Tamrazian (1):
  iwlagn: fix radar frame rejection

Johannes Berg (3):
  iwlwifi: fix bugs in change_interface
  iwlagn: clean up & autodetect statistics
  iwlagn: downgrade warning on unknown TLV

Wey-Yi Guy (11):
  iwlagn: remove un-necessary function pointer
  iwlagn: PAPD read for 2000 series devices
  iwlagn: no 3945 define needed
  iwlagn: remove unused 3945 define
  iwlagn: cleanup to remove the reference for 3945
  iwlagn: remove more reference to legacy devices
  iwlagn: remove un-needed configuration
  iwlagn: more cleanup to remove unused reference
  iwlagn: all _agn devices support power save mode
  iwlagn: tx power calib always done in firmware
  iwlagn: sensitivity and chain noise done by driver

Jay Sternberg (1):
  iwlwifi: remove extranious macro from firmware define

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-1000.c        |   13 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c        |   25 +--
 drivers/net/wireless/iwlwifi/iwl-5000.c        |   18 +--
 drivers/net/wireless/iwlwifi/iwl-6000.c        |   30 +--
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c   |   43 +---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |  134 ++++-------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |   39 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c    |   13 +
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c   |    3 +
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   24 +--
 drivers/net/wireless/iwlwifi/iwl-agn.h         |    3 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h    |   64 -----
 drivers/net/wireless/iwlwifi/iwl-core.c        |   47 ++--
 drivers/net/wireless/iwlwifi/iwl-core.h        |   28 +--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |   50 ++---
 drivers/net/wireless/iwlwifi/iwl-dev.h         |   44 +++--
 drivers/net/wireless/iwlwifi/iwl-fh.h          |   38 ++--
 drivers/net/wireless/iwlwifi/iwl-helpers.h     |   13 +
 drivers/net/wireless/iwlwifi/iwl-led.c         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-power.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h        |   16 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c          |  319 +++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-tx.c          |    1 -
 25 files changed, 409 insertions(+), 569 deletions(-)

