Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:44617 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab0FYWnI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 18:43:08 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/8] iwlwifi updates for 2.6.36
Date: Fri, 25 Jun 2010 15:42:53 -0700
Message-Id: <1277505781-25268-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A variety of changes are included in this series. With the recent station
management changes the rate is not allocated correctly for broadcast
station if user happens to switch from 2.4 to 5 GHz. Fix this. We also
include a fix for the case when the user switches the rfkill state while
system hibernates. A recent patch introduced an error message with it is
learned that antennas are disconnected ... we since have seen this message
under various circumstances and reduce the severity here until our
understanding of the behavior is complete. We add some configuration
capabilities to driver to deal with requirements of various hardwares.
There is a potential issue at the moment where a move to RTS/CTS protection
can cause problems, this is reworked to set RTS/CTS mode when the
aggregation becomes operational ... which it when it is really needed.

Please note that I merged wireless-2.6 into wireless-next-2.6 since there
is a fix in wireless-2.6 ("iwlwifi: set TX_CMD_FLAG_PROT_REQUIRE_MSK
in tx_flag") that should be considered in a name change patch included in
this series.

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Daniel Halperin (1):
  iwlwifi: update LQ for bcast station on channel change

Johannes Berg (1):
  iwlwifi: read rfkill during resume

Reinette Chatre (1):
  iwlagn: reduce severity of disconnected antennas warning

Wey-Yi Guy (5):
  iwlwifi: name change from signal protection flag
  iwlwifi: enable DC calibration based on config parameter
  iwlwifi: add a mechanism to disable plcp error checking
  iwlwifi: turn on RTS/CTS after aggregation become operational
  iwlwifi: add disable rf calibration support for 6000g2a and 6000g2b

 drivers/net/wireless/iwlwifi/iwl-1000.c      |    3 +
 drivers/net/wireless/iwlwifi/iwl-3945.c      |    5 +
 drivers/net/wireless/iwlwifi/iwl-4965.c      |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c      |    7 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c      |  160 ++++++--------------------
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c    |   17 +--
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c    |    6 +
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   28 +++++-
 drivers/net/wireless/iwlwifi/iwl-commands.h  |   30 ++++--
 drivers/net/wireless/iwlwifi/iwl-core.c      |   15 +++
 drivers/net/wireless/iwlwifi/iwl-core.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c    |    3 +
 drivers/net/wireless/iwlwifi/iwl-scan.c      |    9 ++
 drivers/net/wireless/iwlwifi/iwl-sta.c       |   30 +++++
 drivers/net/wireless/iwlwifi/iwl-sta.h       |    1 +
 19 files changed, 179 insertions(+), 155 deletions(-)

