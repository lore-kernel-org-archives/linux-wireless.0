Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:64101 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759516Ab0GBSod (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 14:44:33 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/8] iwlwifi update for 2.6.36
Date: Fri,  2 Jul 2010 11:45:32 -0700
Message-Id: <1278096340-2546-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add support for tx fifo flush command
We also add new supporting sensitivity information for upcoming devices
"fw_restart" module parameter was broken by earlier firmware restart
patch; here we re-enable this module parameter.

Wey-Yi Guy (8):
  iwlwifi: fix fw_restart module parameter
  iwlwifi: add debug print for parsing firmware TLV
  iwlwifi: tx fifo queue flush command
  iwlwifi: add mac80211 flush callback support
  iwlwifi: add support for device tx flush request
  iwlwifi: debugfs file for txfifo command testing
  iwlwifi: generic parameter define for _agn device
  iwlwifi: adding enhance sensitivity table entries

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-1000.c      |    6 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c      |   12 ++-
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |  133 ++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |   82 +++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |  165 ++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    3 +
 drivers/net/wireless/iwlwifi/iwl-commands.h  |   85 +++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.c      |   31 ++++--
 drivers/net/wireless/iwlwifi/iwl-core.h      |    5 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |   29 +++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    4 +
 drivers/net/wireless/iwlwifi/iwl-hcmd.c      |    1 +
 drivers/net/wireless/iwlwifi/iwl-rx.c        |    4 +-
 14 files changed, 477 insertions(+), 89 deletions(-)

