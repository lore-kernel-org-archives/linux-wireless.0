Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38203 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796Ab1LBRQy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 12:16:54 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/3] iwlwifi fix for 3.2
Date: Fri,  2 Dec 2011 08:19:16 -0800
Message-Id: <1322842759-567-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111202_181657_522484_2F2F063F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We fix the HW crypto in iwlwifi
We make sure HT40 is configure correctly to avoid firmware crash
We also disable watchdog timer by default for legacy devices


Johannes Berg (1):
  iwlagn: fix HW crypto for TX-only keys

Wey-Yi Guy (2):
  iwlwifi: do not re-configure HT40 after associated
  iwlwifi: change the default behavior of watchdog timer

these patches are also available from wireless branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-1000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   36 +++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |    5 ---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   34 ++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |   22 ++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl-shared.h   |    4 +-
 9 files changed, 65 insertions(+), 42 deletions(-)

