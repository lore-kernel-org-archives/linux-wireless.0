Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22398 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030203Ab2CEUiM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:38:12 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 30/33] iwlwifi: move uCode deallocation to drv
Date: Mon,  5 Mar 2012 11:24:48 -0800
Message-Id: <1330975491-19680-31-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120305_213822_125890_A3458F7B)
In-Reply-To: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This shouldn't be in the op_mode, as it
will later be switchable at runtime.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-drv.c |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6dd4fae..c3b5946 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1385,8 +1385,6 @@ static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 	/*This will stop the queues, move the device to low power state */
 	iwl_trans_stop_device(trans(priv));
 
-	iwl_dealloc_ucode(nic(priv));
-
 	iwl_eeprom_free(priv->shrd);
 
 	/*netif_stop_queue(dev); */
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 76fc440..590f576 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -99,5 +99,7 @@ void iwl_drv_stop(struct iwl_shared *shrd)
 	if (shrd->nic->op_mode)
 		iwl_op_mode_stop(shrd->nic->op_mode);
 
+	iwl_dealloc_ucode(shrd->nic);
+
 	kfree(shrd->nic);
 }
-- 
1.7.0.4

