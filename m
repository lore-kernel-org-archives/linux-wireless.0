Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19515 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757075Ab0D3XAe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 19:00:34 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/8] iwlwifi updates for 2.6.35
Date: Fri, 30 Apr 2010 16:00:17 -0700
Message-Id: <1272668425-3753-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this series we include the return of the disabling of a PCI timeout
register that was removed during some code iterations. The ucode
statistics (tx, rx, and general) is now also available to 3945. The
incorrect usage of some AMPDU variables is fixed, so too is the incorrect
setting of access class in some circumstances. We also include a few code
cleanups to make code more flexible when dealing with multiple devices and
removing unused code and comments.

To make this submission easier I again merged wireless-2.6 into
wireless-next-2.6 since the patch we submit from there (wireless-2.6)
touches code that has been moved as well as modified. Please let me know if
me doing this does not (or does) work for you.

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Abhijeet Kolekar (2):
  iwlwifi: reset pci retry timeout
  iwl3945: add ucode statistics

Daniel Halperin (1):
  iwlwifi: set AMPDU status variables correctly

Shanyu Zhao (1):
  iwlwifi: set correct AC to swq_id for aggregation

Wey-Yi Guy (4):
  iwlwifi: remove get_stats callback function
  iwlwifi: remove outdated comments
  iwlwifi: set hw parameters based on device type
  iwlwifi: greenfield support only true for 11n devices

 drivers/net/wireless/iwlwifi/Makefile           |    1 +
 drivers/net/wireless/iwlwifi/iwl-1000.c         |    1 -
 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c |  500 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.h |   60 +++
 drivers/net/wireless/iwlwifi/iwl-3945.c         |   72 ++++-
 drivers/net/wireless/iwlwifi/iwl-3945.h         |    2 +
 drivers/net/wireless/iwlwifi/iwl-5000.c         |   73 +++-
 drivers/net/wireless/iwlwifi/iwl-6000.c         |   73 +++-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c       |   10 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c       |   16 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c          |   13 -
 drivers/net/wireless/iwlwifi/iwl-core.c         |   10 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c      |   18 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h          |    5 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c     |    2 +-
 15 files changed, 773 insertions(+), 83 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.h

