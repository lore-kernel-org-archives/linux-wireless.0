Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16661 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbYCSTiE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:04 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Rick Farrington <rickdic@hotmail.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/2] iwlwifi: mac start synchronization issue
Date: Tue, 18 Mar 2008 14:57:49 -0700
Message-Id: <1205877470-11525-1-git-send-email-reinette.chatre@intel.com> (sfid-20080319_193942_547304_3F96E078)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rick Farrington <rickdic@hotmail.com>

This patch fixes a synchronization problem on the 4965 and 3945 with the
mac start callback routine.  The problem is that this function exits BEFORE the
'xxx_alive_start' has completed.  This can lead to a problem if a
subsequent MAC callback attempts to issue a firmware command.

Signed-off-by: Rick Farrington <rickdic@hotmail.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 093b863..7b6517f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5844,11 +5844,11 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 
 	/* At this point, the NIC is initialized and operational */
 	priv->notif_missed_beacons = 0;
-	set_bit(STATUS_READY, &priv->status);
 
 	iwl3945_reg_txpower_periodic(priv);
 
 	IWL_DEBUG_INFO("ALIVE processing complete.\n");
+	set_bit(STATUS_READY, &priv->status);
 	wake_up_interruptible(&priv->wait_command_queue);
 
 	if (priv->error_recovering)
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 64595ac..97db4eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5938,11 +5938,11 @@ static void iwl4965_alive_start(struct iwl_priv *priv)
 
 	/* At this point, the NIC is initialized and operational */
 	priv->notif_missed_beacons = 0;
-	set_bit(STATUS_READY, &priv->status);
 
 	iwl4965_rf_kill_ct_config(priv);
 
 	IWL_DEBUG_INFO("ALIVE processing complete.\n");
+	set_bit(STATUS_READY, &priv->status);
 	wake_up_interruptible(&priv->wait_command_queue);
 
 	if (priv->error_recovering)
-- 
1.5.3.4

