Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21300 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757412AbZCZRIn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 13:08:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/3] iwlwifi: remove STATUS_ALIVE checking from rf_kill
Date: Thu, 26 Mar 2009 10:14:09 -0700
Message-Id: <1238087650-26993-3-git-send-email-reinette.chatre@intel.com> (sfid-20090326_180848_474402_415390F1)
In-Reply-To: <1238087650-26993-2-git-send-email-reinette.chatre@intel.com>
References: <1238087650-26993-1-git-send-email-reinette.chatre@intel.com>
 <1238087650-26993-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Remove STATUS_ALIVE checking when HW RF KILL disabled, the bit get
clear in __iwl_down() function; the additional checking will fail and
cause RF can not be turn back on.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index e1b5472..7560d6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2056,8 +2056,7 @@ void iwl_bg_rf_kill(struct work_struct *work)
 		IWL_DEBUG_RF_KILL(priv,
 			  "HW and/or SW RF Kill no longer active, restarting "
 			  "device\n");
-		if (!test_bit(STATUS_EXIT_PENDING, &priv->status) &&
-		    test_bit(STATUS_ALIVE, &priv->status))
+		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
 			queue_work(priv->workqueue, &priv->restart);
 	} else {
 		/* make sure mac80211 stop sending Tx frame */
-- 
1.5.6.3

