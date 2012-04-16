Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57140 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495Ab2DPWB0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:26 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/16] update for 3.5: iwlwifi 2012-04-16
Date: Mon, 16 Apr 2012 14:56:54 -0700
Message-Id: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120417_000249_736654_FB42B96A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another batch of the cleanup and refactor work to prepare our up-coming
new architecture. Still more to come, but we are almost there.

Amit Beka (1):
  iwlwifi: added HBUS_TARG_TEST_REG

David Spinadel (4):
  iwlwifi: set size of ucode section
  iwlwifi: remove double verification of ucode sections
  iwlwifi: phy db channel to tx power channel group
  iwlwifi: expose static methods for MVM use

Don Fry (3):
  iwlwifi: complete STATUS_READY refactoring
  iwlwifi: move HCMD_ACTIVE to trans
  iwlwifi: move status definitions from iwl-shared

Dor Shaish (1):
  iwlwifi: Disabling calibrations variable

Emmanuel Grumbach (1):
  iwlwifi: remove uneeded include from iwl-pci.c

Johannes Berg (6):
  iwlwifi: remove no_sleep_autoadjust
  iwlwifi: remove uCode alternatives mechanism
  iwlwifi: remove antenna from mod params struct
  iwlwifi: remove iwl_tx_queue declaration
  iwlwifi: optimize struct iwl_cmd_meta layout
  iwlwifi: remove get_cmd_string

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-agn-calib.c      |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |  175 ++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |   28 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   63 +++-----
 drivers/net/wireless/iwlwifi/iwl-agn.h            |  109 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c           |    4 +
 drivers/net/wireless/iwlwifi/iwl-csr.h            |    3 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |   39 ++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   13 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c            |   70 +--------
 drivers/net/wireless/iwlwifi/iwl-fw-file.h        |   15 +--
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |  100 ++++++------
 drivers/net/wireless/iwlwifi/iwl-op-mode.h        |    7 +
 drivers/net/wireless/iwlwifi/iwl-pci.c            |    2 -
 drivers/net/wireless/iwlwifi/iwl-phy-db.c         |   20 ++-
 drivers/net/wireless/iwlwifi/iwl-phy-db.h         |    6 +
 drivers/net/wireless/iwlwifi/iwl-power.c          |   62 +-------
 drivers/net/wireless/iwlwifi/iwl-shared.h         |   37 -----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |   21 +++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |   19 +--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   54 ++++---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   16 ++-
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    3 +
 drivers/net/wireless/iwlwifi/iwl-ucode.c          |    2 +-
 25 files changed, 451 insertions(+), 427 deletions(-)

