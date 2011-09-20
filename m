Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:1940 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab1ITXX2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 19:23:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/8] update for 3.2
Date: Tue, 20 Sep 2011 15:37:19 -0700
Message-Id: <1316558247-10018-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110921_012334_962107_BCFF4E54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add support and bugs fix for P2P functions
We also do more code clean up works to remove duplicated and simplify the codes

Amit Beka (1):
  iwlagn: remove duplicate list init

Emmanuel Grumbach (4):
  iwlagn: remove the callback in host commands
  iwlagn: simplify the iwl_device_cmd layout
  iwlagn: remove uneeded declaration
  iwlagn: pending frames musn't be incremented if agg is on

Johannes Berg (3):
  iwlagn: move scan code to scan file
  iwlagn: remove common station priv
  iwlagn: split remain-on-channel

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

Because the file system problem, all the patches are not push into 
git.kernel.org yet. I will push as soon as the file system issue addressed

 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |  435 +-----------------
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |   16 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |   21 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   14 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h            |   19 +-
 drivers/net/wireless/iwlwifi/iwl-core.h           |    6 -
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   15 +-
 drivers/net/wireless/iwlwifi/iwl-led.c            |    1 -
 drivers/net/wireless/iwlwifi/iwl-rx.c             |   95 +++--
 drivers/net/wireless/iwlwifi/iwl-scan.c           |  517 +++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    5 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c            |   37 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h            |    5 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |   14 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |   17 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   54 +--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    8 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   17 +-
 19 files changed, 662 insertions(+), 642 deletions(-)

