Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41899 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab1CYObg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 10:31:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/12]  update for 2.6.40
Date: Fri, 25 Mar 2011 07:14:04 -0700
Message-Id: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do more clean up works in iwlagn for driver split
We also make new rate scale changes to improve HT performance

Daniel Halperin (4):
  iwlwifi: limit number of attempts for highest HT rate
  iwlwifi: cleanup and bugfix tx aggregation code
  iwlwifi: add RATE_MCS_RATE_MSK
  iwlwifi: set default aggregation frame limit to 63

Johannes Berg (2):
  iwlagn: clean up TX aggregation code
  iwlagn: fix aggregation queue scheduler setup

Wey-Yi Guy (6):
  iwlegacy: MAINTAINERS
  iwlagn: use 6030 configuration for 6035 series
  iwlwifi: remove legacy isr tasklet
  iwlagn: remove 3945 only station code
  iwlagn: remove reference to 3945 and 4965
  iwlagn: remove deprecated module parameters

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 MAINTAINERS                                 |   10 +
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    2 -
 drivers/net/wireless/iwlwifi/iwl-2000.c     |   33 ----
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    4 -
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   20 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c  |    2 -
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |   18 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |  140 ++++++--------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  266 ++------------------------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    9 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |   10 -
 drivers/net/wireless/iwlwifi/iwl-csr.h      |   39 +---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    2 -
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    6 -
 17 files changed, 136 insertions(+), 433 deletions(-)

