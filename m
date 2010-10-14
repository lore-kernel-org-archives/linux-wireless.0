Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:8111 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab0JNSES (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 14:04:18 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/9] update for 2.6.37
Date: Thu, 14 Oct 2010 11:02:41 -0700
Message-Id: <1287079370-20587-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do more code cleanup to prepare for P2P support
We also do more cleanup to prepare separate the legacy and advance devices

Johannes Berg (6):
  iwlwifi: allow probe-after-rx on 2.4 GHz
  iwlwifi: rename ibss_beacon variable
  iwlwifi: clean up some beacon handling
  iwlwifi: rewrite RXON checks
  iwlwifi: blink LED in IBSS mode
  iwlagn: check beacon frame size

Wey-Yi Guy (3):
  iwlagn: need longer tx queue stuck timer for coex devices
  iwlagn: 6050 ops should be used;
  iwlwifi: move agn only eeprom functions to separate file

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/Makefile         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c       |   40 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |  454 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c    |   40 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c        |   39 +--
 drivers/net/wireless/iwlwifi/iwl-agn.h        |    6 +
 drivers/net/wireless/iwlwifi/iwl-core.c       |  130 ++++----
 drivers/net/wireless/iwlwifi/iwl-dev.h        |    4 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c     |  374 +--------------------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h     |    7 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c   |   42 ++--
 11 files changed, 632 insertions(+), 506 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c

