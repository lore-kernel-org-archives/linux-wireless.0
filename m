Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33561 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab0HNPly (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Aug 2010 11:41:54 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/2] iwlwifi fix for 2.6.35
Date: Sat, 14 Aug 2010 08:45:49 -0700
Message-Id: <1281800751-20784-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When tx queue stuck, iwlwifi driver should detect and reload the firmware;
different devices has different timing requirement, change the timeout
value for 5000 series devices to avoid un-necessary firmware reload which
can cause device become unstable.

This fixes:
http://article.gmane.org/gmane.linux.kernel.wireless.general/53552

Wey-Yi Guy (2):
  iwlwifi: long monitor timer
  iwlwifi: use long monitor timer to avoid un-necessary reload

these patches are also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-1000.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c |   14 ++++++------
 drivers/net/wireless/iwlwifi/iwl-6000.c |   32 +++++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    3 +-
 6 files changed, 30 insertions(+), 29 deletions(-)

