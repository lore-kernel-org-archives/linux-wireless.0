Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:64003 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549Ab2ECV2m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 17:28:42 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/6] iwlwifi: include rssi as part of decision making for reduce txpower
Date: Thu,  3 May 2012 14:22:01 -0700
Message-Id: <1336080126-22606-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120503_232850_657431_E293B7F1)
In-Reply-To: <1336080126-22606-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1336080126-22606-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In bt coex, consider the average rssi as part of decision making process

Change-Id: I8d11d7f177a6875e2a9d08f7539d42253226fd7a
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Reviewed-on: http://git-mwg.jer.intel.com/gerrit/1945
Tested-by: Jenkins
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 01dc442..9d88565 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <net/mac80211.h>
 
 #include "iwl-dev.h"
 #include "iwl-io.h"
@@ -593,9 +594,18 @@ static bool iwlagn_fill_txpower_mode(struct iwl_priv *priv,
 				struct iwl_bt_uart_msg *uart_msg)
 {
 	bool need_update = false;
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+	int ave_rssi;
 
+	ave_rssi = ieee80211_ave_rssi(ctx->vif);
+	if (!ave_rssi) {
+		/* no rssi data, no changes to reduce tx power */
+		IWL_DEBUG_COEX(priv, "no rssi data available\n");
+		return need_update;
+	}
 	if (!priv->reduced_txpower &&
 	    !iwl_is_associated(priv, IWL_RXON_CTX_PAN) &&
+	    (ave_rssi > BT_ENABLE_REDUCED_TXPOWER_THRESHOLD) &&
 	    (uart_msg->frame3 & (BT_UART_MSG_FRAME3ACL_MSK |
 	    BT_UART_MSG_FRAME3OBEX_MSK)) &&
 	    !(uart_msg->frame3 & (BT_UART_MSG_FRAME3SCOESCO_MSK |
@@ -606,6 +616,7 @@ static bool iwlagn_fill_txpower_mode(struct iwl_priv *priv,
 		need_update = true;
 	} else if (priv->reduced_txpower &&
 		   (iwl_is_associated(priv, IWL_RXON_CTX_PAN) ||
+		   (ave_rssi < BT_DISABLE_REDUCED_TXPOWER_THRESHOLD) ||
 		   (uart_msg->frame3 & (BT_UART_MSG_FRAME3SCOESCO_MSK |
 		   BT_UART_MSG_FRAME3SNIFF_MSK | BT_UART_MSG_FRAME3A2DP_MSK)) ||
 		   !(uart_msg->frame3 & (BT_UART_MSG_FRAME3ACL_MSK |
-- 
1.7.0.4

