Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54745 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab2KIUHj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:07:39 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/13] iwlwifi: don't call stop_device twice
Date: Fri,  9 Nov 2012 21:08:01 +0100
Message-Id: <1352491692-28994-3-git-send-email-johannes@sipsolutions.net> (sfid-20121109_210743_586969_F59342ED)
In-Reply-To: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
References: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we unregister from mac80211 it will down the device anyway.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 2b50d11..4547f36 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1507,10 +1507,6 @@ static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 
 	iwl_tt_exit(priv);
 
-	/*This will stop the queues, move the device to low power state */
-	priv->ucode_loaded = false;
-	iwl_trans_stop_device(priv->trans);
-
 	kfree(priv->eeprom_blob);
 	iwl_free_eeprom_data(priv->eeprom_data);
 
-- 
1.8.0

