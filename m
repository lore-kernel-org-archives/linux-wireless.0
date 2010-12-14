Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:3691 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757492Ab0LNARG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 19:17:06 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/14] update for 2.6.38
Date: Mon, 13 Dec 2010 16:09:18 -0800
Message-Id: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We implement layout-agnostic EEPROM read and remove
the old EEPROM read method.
We also adding EEPROM debug log to help debug EEPROM related issues
Few minor bug fix for new devices

Johannes Berg (4):
  iwlagn: fix debug variable access
  iwlagn: rename enhanced txpower fields
  iwlagn: implement layout-agnostic EEPROM reading
  iwlagn: remove old EEPROM TX power reading

Shanyu Zhao (2):
  iwlwifi: clear dbg_fixed_rate during init
  iwlagn: check ready in iwlagn_bss_info_changed()

Wey-Yi Guy (8):
  iwlagn: change led compensation for 6005 and 6030 devices
  iwlagn: rx antenna diversity
  iwlwifi: add new EEPROM debug log type
  iwlwifi: use IWL_DEBUG_EEPROM for EEPROM related info
  iwlagn: More detail tx power logging
  iwlwifi: do not reload fw if WiMAX own the RF
  iwlwifi: keep track of bt coex enable/disable stage
  iwlagn: code clean up to remove duplicate code

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-1000.c        |   69 +++---
 drivers/net/wireless/iwlwifi/iwl-5000.c        |   88 +++----
 drivers/net/wireless/iwlwifi/iwl-6000.c        |  326 +++++++----------------
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |    3 +
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c  |  332 ++++++-----------------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |    7 +
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c      |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c    |    9 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c      |    9 +-
 drivers/net/wireless/iwlwifi/iwl-core.c        |   17 ++
 drivers/net/wireless/iwlwifi/iwl-core.h        |    4 +
 drivers/net/wireless/iwlwifi/iwl-debug.h       |    2 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |    7 +
 drivers/net/wireless/iwlwifi/iwl-dev.h         |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c      |   25 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h      |   78 ++----
 drivers/net/wireless/iwlwifi/iwl-prph.h        |    2 +-
 17 files changed, 345 insertions(+), 636 deletions(-)

