Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932554Ab0EMVuR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:50:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 00/17] iwlwifi updates for 2.6.35
Date: Thu, 13 May 2010 14:49:42 -0700
Message-Id: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series includes a lot of driver cleanup. Driver is made more robust to
be able to deal with firmware that miss some information. Duplicate code
scattered in driver is moved to a function. Structures and code specific to
some devices are moved to be only accessible to these devices. We include
better station debug information and make it possible to compile driver
with debugfs support without needing debug support.

We also include some fixes which include the usage of the correct mac80211
variables and fixing of station locking.

We continue the recognition and enabling of some new iwlwifi devices.

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Johannes Berg (9):
  iwlwifi: introduce iwl_sta_id_or_broadcast
  iwlwifi: don't crash on firmware file missing info
  iwl3945: remove sequence number assignment
  iwlwifi: move iwl_free_tfds_in_queue to iwlagn
  iwlwifi: improve station debugfs
  iwlwifi: remove IWL_MULTICAST_ID
  iwlagn: use firmware event/error log information
  iwlwifi: split debug and debugfs options
  iwlwifi: use proper short slot/preamble settings

Reinette Chatre (1):
  iwlwifi: fix and add missing sta_lock usage

Shanyu Zhao (2):
  iwlwifi: enable remaining 6000 Gen2 devices
  iwlwifi: add new PCI IDs for 6000g2 devices

Wey-Yi Guy (5):
  iwlwifi: move _agn statistics related structure
  iwlwifi: separate statistics flag function for agn & 3945
  iwlwifi: code cleanup for _agn devices
  iwlwifi: modify out-dated comments
  iwlwifi: move ucode related function to iwl-agn-ucode.c

 drivers/net/wireless/iwlwifi/Kconfig            |    6 +-
 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c |   28 ++-
 drivers/net/wireless/iwlwifi/iwl-3945.c         |   15 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c         |    9 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c         |  286 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c  |   91 +++++---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c      |   23 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c       |   46 +++-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c    |  123 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c          |  196 ++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-agn.h          |   34 +++
 drivers/net/wireless/iwlwifi/iwl-commands.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.c         |  131 +----------
 drivers/net/wireless/iwlwifi/iwl-core.h         |    3 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c      |   81 ++-----
 drivers/net/wireless/iwlwifi/iwl-dev.h          |   58 ++---
 drivers/net/wireless/iwlwifi/iwl-helpers.h      |    5 +
 drivers/net/wireless/iwlwifi/iwl-rx.c           |   63 +++---
 drivers/net/wireless/iwlwifi/iwl-sta.c          |   72 +++---
 drivers/net/wireless/iwlwifi/iwl-sta.h          |   29 +++
 drivers/net/wireless/iwlwifi/iwl-tx.c           |   15 --
 drivers/net/wireless/iwlwifi/iwl3945-base.c     |   53 +----
 24 files changed, 916 insertions(+), 458 deletions(-)

