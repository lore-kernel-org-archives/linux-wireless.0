Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54054 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212Ab1EFS2m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 14:28:42 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/7] update for 2.6.40
Date: Fri,  6 May 2011 11:04:33 -0700
Message-Id: <1304705080-29349-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110506_202846_804615_2028A9A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add the feature to support the test mode operation through
the generic netlink channel NL80211_CMD_TESTMODE
We also continue the cleanup work for iwlagn

Cindy H. Kao (1):
  iwlwifi: support the svtool messages interactions through nl80211
    test mode

Johannes Berg (6):
  iwlagn: remove get_hcmd_size indirection
  iwlagn: remove frame pre-allocation
  iwlagn: remove unused variable
  iwlagn: dont update bytecount table for command queue
  iwlagn: remove bytecount indirection
  iwlagn: check DMA mapping errors

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.gi

 drivers/net/wireless/iwlwifi/Kconfig         |   10 +
 drivers/net/wireless/iwlwifi/Makefile        |    1 +
 drivers/net/wireless/iwlwifi/iwl-1000.c      |    2 -
 drivers/net/wireless/iwlwifi/iwl-2000.c      |    2 -
 drivers/net/wireless/iwlwifi/iwl-5000.c      |    4 -
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    4 -
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c  |    7 -
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |  105 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |  143 ++------
 drivers/net/wireless/iwlwifi/iwl-agn.h       |   22 +-
 drivers/net/wireless/iwlwifi/iwl-core.h      |    6 -
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   15 +-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c   |  469 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-testmode.h  |  151 +++++++++
 drivers/net/wireless/iwlwifi/iwl-tx.c        |   22 +-
 16 files changed, 747 insertions(+), 218 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-sv-open.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-testmode.h

