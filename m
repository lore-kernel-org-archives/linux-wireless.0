Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17408 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907AbYDCXFt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 19:05:49 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/5] iwlwifi: ensure led registration complete as part of initialization
Date: Thu,  3 Apr 2008 16:05:23 -0700
Message-Id: <1207263924-25385-5-git-send-email-reinette.chatre@intel.com> (sfid-20080404_000607_409957_A8BBC6E6)
In-Reply-To: <1207263924-25385-4-git-send-email-reinette.chatre@intel.com>
References: <1207263924-25385-1-git-send-email-reinette.chatre@intel.com>
 <1207263924-25385-2-git-send-email-reinette.chatre@intel.com>
 <1207263924-25385-3-git-send-email-reinette.chatre@intel.com>
 <1207263924-25385-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the workqueue is notified the LED code may be accessed. Ensure
that LED registration completes completely as part of initialization
before anything waiting on this is notified.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 51480a4..d4daa04 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5874,12 +5874,12 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 
 	iwl3945_reg_txpower_periodic(priv);
 
+	iwl3945_led_register(priv);
+
 	IWL_DEBUG_INFO("ALIVE processing complete.\n");
 	set_bit(STATUS_READY, &priv->status);
 	wake_up_interruptible(&priv->wait_command_queue);
 
-	iwl3945_led_register(priv);
-
 	if (priv->error_recovering)
 		iwl3945_error_recovery(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 5dfc414..4517e4c 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5701,12 +5701,12 @@ static void iwl4965_alive_start(struct iwl_priv *priv)
 
 	iwl4965_rf_kill_ct_config(priv);
 
+	iwl_leds_register(priv);
+
 	IWL_DEBUG_INFO("ALIVE processing complete.\n");
 	set_bit(STATUS_READY, &priv->status);
 	wake_up_interruptible(&priv->wait_command_queue);
 
-	iwl_leds_register(priv);
-
 	if (priv->error_recovering)
 		iwl4965_error_recovery(priv);
 
-- 
1.5.3.4

