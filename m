Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7260 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761875AbZLJWhV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 17:37:21 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/7] iwlwifi updates 12/10/2009
Date: Thu, 10 Dec 2009 14:37:20 -0800
Message-Id: <1260484647-5114-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series includes three fixes targeting 2.6.33:
- "iwlwifi: power up all devices for EEPROM read" fixes a issue where
devices are unable to be initialized on certain platforms due to too
aggressive power savings.
- "iwlwifi: allocated rx page accounting cleanup" fixes some accounting
issues in the recent paged RX work
- "iwlwifi: fix syslog message for event log dump size" fixes the problem
where the entire debug log was not printed when requested by user

In this series we also include support for the new mac80211 spatial
multiplexing support. This patch is dependent on the mac80211 patches
introducing this work ("cfg80211: add SM PS hooks" and "mac80211: enable
spatial multiplexing powersave").

We also include some debugging patches. The status and control registers
are now also dumped when device error occurs. We also introduce continuous
uCode event log capability where the uCode events can be monitored as they
occur.

Johannes Berg (1):
  iwlwifi: use new mac80211 SMPS

Reinette Chatre (1):
  iwlwifi: power up all devices for EEPROM read

Wey-Yi Guy (4):
  iwlwifi: fix syslog message for event log dump size
  iwlwifi: log CT_CARD_DISABLED flag
  iwlwifi: dump "Control and Status Register" when detect uCode HW/SW
    error
  iwlwifi: add continuous uCode event log capability

Zhu Yi (1):
  iwlwifi: allocated rx page accounting cleanup

 drivers/net/wireless/iwlwifi/iwl-1000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  149 +++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |  126 ++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-core.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h      |    8 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    2 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   81 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   41 ++++++++
 drivers/net/wireless/iwlwifi/iwl-devtrace.c |    2 +
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |   44 ++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |   14 +--
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    8 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    8 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   12 +--
 21 files changed, 436 insertions(+), 86 deletions(-)

