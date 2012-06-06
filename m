Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab2FFNXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:09 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 29/29] iwlwifi: remove extern opmode ops declarations
Date: Wed,  6 Jun 2012 15:22:10 +0200
Message-Id: <1338988930-11561-29-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152326_868089_FC82B901)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to declare the opmode ops
as extern since they're now dynamically
registered.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c    |    4 +++-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h |    5 -----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index ec0b77b..1c2d023 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -81,6 +81,8 @@ MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 
+static const struct iwl_op_mode_ops iwl_dvm_ops;
+
 void iwl_update_chain_flags(struct iwl_priv *priv)
 {
 	struct iwl_rxon_context *ctx;
@@ -2163,7 +2165,7 @@ static void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 	wiphy_rfkill_set_hw_state(priv->hw->wiphy, state);
 }
 
-const struct iwl_op_mode_ops iwl_dvm_ops = {
+static const struct iwl_op_mode_ops iwl_dvm_ops = {
 	.start = iwl_op_mode_dvm_start,
 	.stop = iwl_op_mode_dvm_stop,
 	.rx = iwl_rx_dispatch,
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index cec133c..cd9ef11 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -221,9 +221,4 @@ static inline void iwl_op_mode_wimax_active(struct iwl_op_mode *op_mode)
 	op_mode->ops->wimax_active(op_mode);
 }
 
-/*****************************************************
-* Op mode layers implementations
-******************************************************/
-extern const struct iwl_op_mode_ops iwl_dvm_ops;
-
 #endif /* __iwl_op_mode_h__ */
-- 
1.7.10

