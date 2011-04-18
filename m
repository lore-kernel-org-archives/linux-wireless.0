Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32823 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab1DRRFg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 13:05:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/10] update for 2.6.40
Date: Mon, 18 Apr 2011 09:44:07 -0700
Message-Id: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We fix the huge xommands synchronous problem especially for beacon
We continue clean up the _agn driver after split

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Johannes Berg (3):
  iwlagn: remove most BUG_ON instances
  iwlagn: verify that huge commands are synchronous
  iwlagn: use huge command for beacon

Wey-Yi Guy (7):
  iwlagn: use direct call for led functions
  iwlagn: always support uCode trace
  iwlagn: temperature should be measure for all _agn devices
  iwlagn: no 5.2GHz/HT40 support for bgn devices
  iwlagn: remove un-necessary ieee80211_ops
  iwlagn: remove legacy ops
  iwlagn: remove led_ops

 drivers/net/wireless/iwlwifi/Makefile      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c    |   11 +----
 drivers/net/wireless/iwlwifi/iwl-2000.c    |   18 +-------
 drivers/net/wireless/iwlwifi/iwl-5000.c    |   16 ------
 drivers/net/wireless/iwlwifi/iwl-6000.c    |   22 --------
 drivers/net/wireless/iwlwifi/iwl-agn-led.c |   73 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-agn-led.h |   33 -------------
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   42 ++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-core.c    |   24 ---------
 drivers/net/wireless/iwlwifi/iwl-core.h    |   28 -----------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    3 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c  |    6 --
 drivers/net/wireless/iwlwifi/iwl-eeprom.h  |    1 -
 drivers/net/wireless/iwlwifi/iwl-hcmd.c    |   12 +++--
 drivers/net/wireless/iwlwifi/iwl-led.c     |   26 ++++++++++-
 drivers/net/wireless/iwlwifi/iwl-led.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-power.c   |   13 ++---
 drivers/net/wireless/iwlwifi/iwl-sta.c     |    9 ++-
 drivers/net/wireless/iwlwifi/iwl-tx.c      |   38 ++++++++++-----
 19 files changed, 113 insertions(+), 265 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-led.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-led.h

