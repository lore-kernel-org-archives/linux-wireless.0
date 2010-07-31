Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15724 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198Ab0GaQyq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 12:54:46 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/8] iwlwifi update for 2.6.36
Date: Sat, 31 Jul 2010 08:34:04 -0700
Message-Id: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We move "Thermal throttling" related functions out of power management
into it own file.
We also reduce the warning level for "BA scd_flow not match" to
avoid flood the syslog when condition detected.
We also track IBSS manager status with uCode beacon notification.

Johannes Berg (2):
  iwlwifi: fix compile warning
  iwlwifi: track IBSS manager status

Wey-Yi Guy (6):
  iwlwifi: make iwl_hw_detect static to _agn
  iwlagn: log pci revision id
  iwlwifi: separate thermal throttling function
  iwlwifi: make iwl_set_hw_params static to _agn
  iwlwifi: BA scd_flow not match condition detected
  iwlagn: fix typo in ucode_bt_stats_read debugfs

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/Makefile          |    1 +
 drivers/net/wireless/iwlwifi/iwl-1000.c        |    5 +
 drivers/net/wireless/iwlwifi/iwl-5000.c        |   10 +
 drivers/net/wireless/iwlwifi/iwl-6000.c        |    5 +
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c      |  697 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-tt.h      |  129 +++++
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c      |    9 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   77 +++-
 drivers/net/wireless/iwlwifi/iwl-commands.h    |    5 +
 drivers/net/wireless/iwlwifi/iwl-core.c        |   83 +---
 drivers/net/wireless/iwlwifi/iwl-core.h        |   13 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h         |    4 +
 drivers/net/wireless/iwlwifi/iwl-power.c       |  640 +---------------------
 drivers/net/wireless/iwlwifi/iwl-power.h       |   93 ----
 drivers/net/wireless/iwlwifi/iwl-tx.c          |    9 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c    |    5 +-
 18 files changed, 979 insertions(+), 810 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-tt.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-tt.h

