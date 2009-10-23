Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24332 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbZJWUmd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:33 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 00/18] iwlwifi updates 10/23/2009
Date: Fri, 23 Oct 2009 13:42:18 -0700
Message-Id: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series includes the cleanup patch promised after feedback on "iwlwifi:
rework for static power save" from previous series.

Ben M Cahill (2):
  iwlwifi: consolidate apm_init() functions
  iwlwifi: make sure device is reset when unloading driver

Jay Sternberg (1):
  iwlwifi: add missing commands to syslog messages

Reinette Chatre (1):
  iwlwifi: remove duplicate defines

Wey-Yi Guy (12):
  iwlwifi: fix gain computation for 5000 series and up
  iwlwifi: separate led function from statistic notification
  iwlwifi: update bt co-exit configuration parameter
  iwlwifi: specify the valid tx/rx chain in device config structure
  iwlwifi: increase max tfd payload size
  iwlwifi: choose thermal throttle method based on device config
  iwlwifi: issue ct_kill host command based on device config
  iwlwifi: add channel switch support to 5000 series and up
  iwlwifi: remove unused parameters
  iwlwifi: remove duplicated define
  iwlwifi: update lowest API version support for 6x00 & 6x50 series
  iwlwifi: minor comments changes for wimax co-exist command

Zhu Yi (2):
  iwlwifi: fix use after free bug for paged rx
  iwlwifi: reuse page for notification packets

 drivers/net/wireless/iwlwifi/iwl-1000.c     |   12 ++-
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    6 -
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   79 +++-----------
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    8 --
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   78 +++-----------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |  120 ++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   98 +++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   49 ++++++---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   16 +++-
 drivers/net/wireless/iwlwifi/iwl-core.c     |  150 ++++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-core.h     |   13 ++-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   18 ++--
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-power.c    |   12 +--
 drivers/net/wireless/iwlwifi/iwl-power.h    |    2 -
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   24 +++--
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    9 +--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   54 +++++++---
 18 files changed, 446 insertions(+), 304 deletions(-)

