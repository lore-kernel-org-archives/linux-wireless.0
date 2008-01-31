Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48758 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763053AbYAaS2e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 13:28:34 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] iwlwifi: fix merge error (cancel_deferred_work)
Date: Thu, 31 Jan 2008 10:28:33 -0800
Message-Id: <1201804113-1621-1-git-send-email-reinette.chatre@intel.com> (sfid-20080131_182840_166771_CA2406A5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "iwlwifi: cleanup namespace" mistakenly changed to undo a fix
included in "iwlwifi: fix possible priv->mutex deadlock during suspend".

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 --
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 789a9cd..f82aec5 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6163,8 +6163,6 @@ static void __iwl3945_down(struct iwl3945_priv *priv)
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
 
-	iwl3945_cancel_deferred_work(priv);
-
 	/* Wipe out the EXIT_PENDING status bit if we are not actually
 	 * exiting the module */
 	if (!exit_pending)
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 5a13f0c..a4fa6bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6577,8 +6577,6 @@ static void __iwl4965_down(struct iwl4965_priv *priv)
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
 
-	iwl4965_cancel_deferred_work(priv);
-
 	/* Wipe out the EXIT_PENDING status bit if we are not actually
 	 * exiting the module */
 	if (!exit_pending)
-- 
1.5.3.4

