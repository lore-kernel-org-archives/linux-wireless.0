Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26702 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435Ab1IFRPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 13:15:06 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/10] update for 3.2
Date: Tue,  6 Sep 2011 09:31:15 -0700
Message-Id: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110906_191511_686443_4027503F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We fix compilation cause by recent changes when debug flags is unset
We also re-enable the 11n support for "_d" sku
More clean up work after the transport layer split.

Emmanuel Grumbach (6):
  iwlagn: merge iwl_pci_down and iwl_pci_remove
  iwlagn: remove priv dereferences from the transport layer
  iwlagn: clean up of transport layer
  iwlagn: move traffic_log back to upper layer
  iwlagn: iwl-trans.c can't dereference iwl_priv any more
  iwlagn: fix compilation when debug flags is unset

Wey-Yi Guy (4):
  iwlagn: only perform necessary calibration at init time
  iwlagn: disply queue read/write pointer when stuck
  iwlagn: enable 11n support for "_d" sku
  iwlagn: remove lines from the wrong place

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

Because the file system problem, all the patches are not push into 
git.kernel.org yet. I will push as soon as the file system issue addressed

 drivers/net/wireless/iwlwifi/iwl-2000.c           |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.h         |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   10 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h            |    2 -
 drivers/net/wireless/iwlwifi/iwl-commands.h       |    7 +-
 drivers/net/wireless/iwlwifi/iwl-core.c           |   17 +-
 drivers/net/wireless/iwlwifi/iwl-core.h           |   22 --
 drivers/net/wireless/iwlwifi/iwl-csr.h            |   18 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |   85 +++++
 drivers/net/wireless/iwlwifi/iwl-dev.h            |  202 +----------
 drivers/net/wireless/iwlwifi/iwl-helpers.h        |   23 --
 drivers/net/wireless/iwlwifi/iwl-pci.c            |   18 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c             |   83 +++++-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |   52 +++
 drivers/net/wireless/iwlwifi/iwl-sta.c            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c        |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |  110 ++++++-
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  |   45 +--
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |  128 ++------
 drivers/net/wireless/iwlwifi/iwl-trans.c          |  402 ++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   66 ++++-
 25 files changed, 636 insertions(+), 674 deletions(-)

