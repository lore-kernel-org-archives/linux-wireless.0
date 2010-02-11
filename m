Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24445 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756798Ab0BKSmO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 13:42:14 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 00/12] iwlwifi updates for 2.6.34
Date: Thu, 11 Feb 2010 10:41:53 -0800
Message-Id: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Included is a fix to a scan race introduced by the new internal scanning
code. We also now reset the card during the probe to support users of
kdump. Memory allocation is not done as often with GFP_ATOMIC to improve
success rate. Included are some fixes to help aggregation queues recover
after firmware reload as well as recovery after TX stalls. A new interface
is added to force reset of firmware.

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Abhijeet Kolekar (1):
  iwlwifi: cleanup return values

Reinette Chatre (2):
  iwlwifi: fix scan race
  iwlwifi: reset card during probe

Stanislaw Gruszka (1):
  iwlwifi: use dma_alloc_coherent

Trieu 'Andrew' Nguyen (2):
  iwlwifi: Adjusting PLCP error threshold for 1000 NIC
  iwlwifi: Monitor and recover the aggregation TX flow failure

Wey-Yi Guy (6):
  iwlwifi: clear all tx queues when firmware ready
  iwlwifi: multiple force reset mode
  iwlwifi: add debug function to reset/reload radio/firmware
  iwlwifi: check for aggregation frame and queue
  iwlwifi: remove unused op-code in PHY Calibration command
  iwlwifi: clear all the stop_queue flag after load firmware

 drivers/net/wireless/iwlwifi/iwl-1000.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    8 +--
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    7 ++
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    7 ++
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |   15 +++++-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   22 +++++++-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 -
 drivers/net/wireless/iwlwifi/iwl-core.c     |   56 ++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-core.h     |    8 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   28 +++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   13 ++++-
 drivers/net/wireless/iwlwifi/iwl-helpers.h  |    7 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   80 ++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   37 ++++--------
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   62 ++++++++++----------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   39 ++++++-------
 16 files changed, 273 insertions(+), 124 deletions(-)

