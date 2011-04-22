Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:8682 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462Ab1DVRzM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 13:55:12 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/10] update for 2.6.40
Date: Fri, 22 Apr 2011 10:33:08 -0700
Message-Id: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We refactor the firmware loading/reloading process
We continue the clean up work for _agn after driver split

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Johannes Berg (10):
  iwlagn: simplify error table reading
  iwlagn: clean up some exit code
  iwlagn: refactor down path
  iwlagn: refactor up path
  iwlagn: extend notification wait function
  iwlagn: make iwlagn_wait_notification return error code
  iwlagn: leave notification waits on firmware errors
  iwlagn: implement synchronous firmware load
  iwlagn: combine firmware code/data
  iwlagn: remove hw_ready variable

 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |  101 ++++++-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |   13 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |  245 ++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.c       |  432 ++++++++------------------
 drivers/net/wireless/iwlwifi/iwl-agn.h       |   33 ++-
 drivers/net/wireless/iwlwifi/iwl-commands.h  |  103 ++++---
 drivers/net/wireless/iwlwifi/iwl-core.c      |   15 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |    6 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   28 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h   |   24 --
 drivers/net/wireless/iwlwifi/iwl-io.c        |   18 +-
 drivers/net/wireless/iwlwifi/iwl-io.h        |   10 +
 drivers/net/wireless/iwlwifi/iwl-rx.c        |   50 ---
 13 files changed, 537 insertions(+), 541 deletions(-)

