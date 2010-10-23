Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:49685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756926Ab0JWQSI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Oct 2010 12:18:08 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/8]  update for 2.6.38
Date: Sat, 23 Oct 2010 09:15:38 -0700
Message-Id: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We make number of changes to prepare upcoming P2P supports
We also turn on dynamic smps to improve WiFi rx throughput
for WiFi/BT coex case.
We also change the new 130 series devices to using 6000g2b uCode

Johannes Berg (5):
  iwlwifi: make mac80211 ops a device config
  iwlagn: don't resent RXON timing
  iwlagn: new RXON processing for modern devices
  iwlwifi: fix IBSS beaconing
  iwlwifi: implement switching iftype while up

Wey-Yi Guy (3):
  iwlagn: turn dynamic smps on while BT is on
  iwlwifi: add new devices to Kconfig
  iwlagn: use 6000g2b uCode for 130 series devices

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/Kconfig        |    3 +
 drivers/net/wireless/iwlwifi/Makefile       |    3 +
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    5 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   11 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    8 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  318 +++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   10 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   27 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |  587 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  409 ++--------------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |   36 ++
 drivers/net/wireless/iwlwifi/iwl-core.c     |  673 +++++----------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |   37 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-led.c      |    2 +
 drivers/net/wireless/iwlwifi/iwl-legacy.c   |  560 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-legacy.h   |   74 +++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   35 +-
 19 files changed, 1805 insertions(+), 1000 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-legacy.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-legacy.h

