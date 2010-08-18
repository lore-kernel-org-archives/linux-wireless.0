Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:30390 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab0HRRp7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 13:45:59 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/2] iwlwifi fix for stable kernel 2.6.35
Date: Wed, 18 Aug 2010 10:50:17 -0700
Message-Id: <1282153819-27781-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When tx queue stuck, iwlwifi driver should detect and reload the firmware;
different devices has different timing requirement, change the timeout
value for 5000 series devices to avoid un-necessary firmware reload which
can cause device become unstable.

This fixes:
http://article.gmane.org/gmane.linux.kernel.wireless.general/53552

Those patches already available in wireless-2.6

Wey-Yi Guy (2):
  iwlwifi: long monitor timer
  iwlwifi: use long monitor timer to avoid un-necessary reload

this patch is also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-1000.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-3945.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c |   14 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-6000.c |   14 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    3 ++-
 6 files changed, 21 insertions(+), 20 deletions(-)

