Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31379 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab0LBQ5w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 11:57:52 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/5] update for 2.6.38
Date: Thu,  2 Dec 2010 08:51:19 -0800
Message-Id: <1291308684-3279-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We enable PCI L1 state after uCode load to improve device power
consumption
We also fix the error when sending rxon command to uCode while the
device is on the way to shutdown

Grumbach, Emmanuel (1):
  iwlagn: Enable PCI L1 ACTIVE state after uCode has been loaded

Wey-Yi Guy (4):
  iwlagn: fix race condition when reprogram sta
  iwlagn: remove structure name reference to gen2
  iwlwifi: check for STATUS_EXIT_PENDING when send RXON command
  iwlagn: name change for bt_ch_announce module parameter

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-3945.c      |    3 +
 drivers/net/wireless/iwlwifi/iwl-6000.c      |   20 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |    3 +
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    4 ++
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   70 +++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-agn.h       |   20 ++++----
 drivers/net/wireless/iwlwifi/iwl-sta.c       |   13 +++++
 7 files changed, 79 insertions(+), 54 deletions(-)

