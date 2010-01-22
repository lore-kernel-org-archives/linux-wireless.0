Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57076 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940Ab0AVWXC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:23:02 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 00/17] iwlwifi updates for 2.6.34
Date: Fri, 22 Jan 2010 14:22:41 -0800
Message-Id: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A variety of changes are included here. Some recent patches exposed a
problem with station initialization in the driver and resulted in
throughput aggregation, this is now fixed. When using an application like
NetworkManager that scans while associated the driver always rejected the
second scan request since it was made to close to the first. This resulted
in A band not being scanned while associated.

We include quite a few cleanups and code reorganization. 

Two new features are:
- if driver detects a large number of PLCP errors it will trigger a radio
reset to trigger a retune
- we introduce a new module parameter that can be used to disable bluetooth
coexistence, this is required on certain platforms that have bluetooth
systems that do not cooperate well. On these systems disabling bluetooth
coexistence is needed to get working wireless.

We also include some enabling code needed for new 6000 series hardware.

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Daniel Halperin (1):
  iwlwifi: fix throughput degradation in aggregation mode

Henry Zhangh (1):
  iwlwifi: Fix A band scanning when associated

Johannes Berg (5):
  iwlwifi: is no longer experimental
  iwlwifi: reorder device setup
  iwlwifi: clean up debugfs code
  iwlwifi: fix sparse warnings
  iwlwifi: check endianness annotations by default

Abhijeet Kolekar (1):
  iwlwifi: enable DC calibration

Reinette Chatre (3):
  iwlwifi: cleanup station adding code
  iwlwifi: make broadcast station addition generic
  iwlwifi: cleanup spectrum measurement command support

Trieu 'Andrew' Nguyen (1):
  iwlwifi: Tune radio to prevent unexpected behavior

Wey-Yi Guy (5):
  iwlwifi: configure missed beacon threshold
  iwlwifi: add function to reset/tune radio if needed
  iwlwifi: Logic to control how frequent radio should be reset if
    needed
  iwlwifi: bit field description for BT Config command
  iwlwifi: module parameter to enable/disable bt co-exist

 drivers/net/wireless/iwlwifi/Kconfig        |   14 +-
 drivers/net/wireless/iwlwifi/Makefile       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    3 +
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    9 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    9 +
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   23 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   45 ++--
 drivers/net/wireless/iwlwifi/iwl-commands.h |   43 +++-
 drivers/net/wireless/iwlwifi/iwl-core.c     |   53 ++++-
 drivers/net/wireless/iwlwifi/iwl-core.h     |   17 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h    |   61 +-----
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |  341 +++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   22 ++-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   77 ++++++-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |  190 +++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-spectrum.c |  198 ----------------
 drivers/net/wireless/iwlwifi/iwl-sta.c      |  148 ++++++++----
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   28 +--
 20 files changed, 721 insertions(+), 566 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-spectrum.c

