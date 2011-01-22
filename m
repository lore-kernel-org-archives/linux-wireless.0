Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47747 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab1AVASU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 19:18:20 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/14] update for 2.6.39
Date: Fri, 21 Jan 2011 16:06:35 -0800
Message-Id: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add 2000 series device support
We also fix a issue for 1000 series device to support idle power save
We add initial implementation on P2P supports

Jay Sternberg (1):
  iwlwifi: correct debugfs data dumped from sram

Johannes Berg (3):
  iwlwifi: implement remain-on-channel
  iwlwifi: replace minimum slot time constant
  iwlwifi: initial P2P support

Meenakshi Venkataraman (1):
  iwlagn: Enable idle powersave mode in 1000 series

Wey-Yi Guy (9):
  iwlwifi: use mac80211 throughput trigger
  iwlagn: remove reference to gen2a and gen2b
  iwlagn: add 2000 series EEPROM version
  iwlagn: 2000 series devices support
  iwlagn: add 2000 series pci id
  iwlagn: add 2000 series to Kconfig
  iwlagn: remove Gen2 from Kconfig
  iwlwifi: remove g2 from csr hw rev
  iwlwifi: add hw rev for 2000 series devices

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/Kconfig        |   26 ++-
 drivers/net/wireless/iwlwifi/Makefile       |    1 +
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-2000.c     |  556 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |   27 --
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   52 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |   18 +-
 drivers/net/wireless/iwlwifi/iwl-agn-led.c  |   14 +-
 drivers/net/wireless/iwlwifi/iwl-agn-led.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   19 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    9 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  151 +++++++-
 drivers/net/wireless/iwlwifi/iwl-agn.h      |   11 +
 drivers/net/wireless/iwlwifi/iwl-commands.h |    5 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |    7 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |   14 -
 drivers/net/wireless/iwlwifi/iwl-csr.h      |   14 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |  106 +++---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   24 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |   26 +-
 drivers/net/wireless/iwlwifi/iwl-led.c      |  201 ++++------
 drivers/net/wireless/iwlwifi/iwl-led.h      |   16 +-
 drivers/net/wireless/iwlwifi/iwl-legacy.c   |    4 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 +-
 24 files changed, 998 insertions(+), 313 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-2000.c

