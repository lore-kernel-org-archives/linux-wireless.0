Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27344 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab0HWOx0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:26 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/26] iwlwifi update for 2.6.37
Date: Mon, 23 Aug 2010 07:56:51 -0700
Message-Id: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We enable WiFi/BT coexist support in this patchset.
We also make some minor code cleanup works. 

Johannes Berg (10):
  iwlwifi: add 6000g2b BT coexist API
  iwlagn: implement advance BT config command
  iwlagn: set BT IGNORE for some frames
  iwlwifi: add BT notification support for bt coex
  iwlagn: let bluetooth traffic load impact rate scale
  iwlwifi: reset BT when going down
  iwlagn: disable gen2b BT coexistence in IBSS
  iwlagn: keep BT settings across restart
  iwlwifi: use antenna A only under high BT load
  iwlwifi: disable aggregation queue if stopped early

Wey-Yi Guy (16):
  iwlwifi: update out-of-date comments
  iwlwifi: comments cleanup
  iwlwifi: Relax uCode timeout/error checking for 6000g2b
  iwlwifi: add bt full concurrency support
  iwlagn: wifi/bt coex configuration sequence
  iwlwifi: indicate bt_kill condition when receive tx reply
  iwlwifi: add debugfs to control stuck queue timer
  iwlwifi: add bt_init_traffic_load as configurable parameter
  iwlagn: add bt prio_boost to .cfg
  iwlagn: parsing uart message and take actions
  iwlagn: add additional bt related parameters
  iwlagn: add bt_ch_announce module parameter
  iwlagn: set traffic load based on multiple factors
  iwlagn: generic bt coex functions
  iwlagn: update bt status upon scan complete
  iwlwifi: add bt traffic load debugfs file

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-3945-hw.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000-hw.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c      |  135 ++++++++--
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c  |    8 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |  396 +++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c    |  236 ++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h    |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   56 +++--
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   64 ++++
 drivers/net/wireless/iwlwifi/iwl-agn.c       |  122 ++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    9 +
 drivers/net/wireless/iwlwifi/iwl-commands.h  |  360 +++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-core.c      |   71 ++++-
 drivers/net/wireless/iwlwifi/iwl-core.h      |   10 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |   75 +++++
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   23 ++
 drivers/net/wireless/iwlwifi/iwl-hcmd.c      |    3 +
 drivers/net/wireless/iwlwifi/iwl-scan.c      |   20 ++
 20 files changed, 1496 insertions(+), 106 deletions(-)

