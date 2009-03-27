Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16674 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbZC0TkA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 15:40:00 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] iwlwifi: change check triggering device restart after rfkill change
Date: Fri, 27 Mar 2009 12:45:30 -0700
Message-Id: <1238183130-31461-1-git-send-email-reinette.chatre@intel.com> (sfid-20090327_204005_642167_EB1A658A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The STATUS_ALIVE value cannot be used because it is cleared when
interface is brought down and will not be set if rfkill is enabled when
interface is started again. The interface can thus not be brought up if
rfkill was enabled before stopping the interface and disabled after
starting the interface.

Change the test to use priv->is_open instead, this will be set when
interface is started whether rfkill is enabled or not.

Thanks to Helmut Schaa for the suggested fix.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
CC: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 18ef713..970c4fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2058,7 +2058,7 @@ void iwl_bg_rf_kill(struct work_struct *work)
 			  "HW and/or SW RF Kill no longer active, restarting "
 			  "device\n");
 		if (!test_bit(STATUS_EXIT_PENDING, &priv->status) &&
-		    test_bit(STATUS_ALIVE, &priv->status))
+		    priv->is_open)
 			queue_work(priv->workqueue, &priv->restart);
 	} else {
 		/* make sure mac80211 stop sending Tx frame */
-- 
1.5.6.3

