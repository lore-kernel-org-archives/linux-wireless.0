Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15768 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758079Ab1BKUUi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 15:20:38 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/2] iwlagn: donot process bt update when bt coex disable
Date: Fri, 11 Feb 2011 12:07:00 -0800
Message-Id: <1297454821-14904-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1297454821-14904-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1297454821-14904-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If bt coex is disabled, do not process any bt related information
from uCode even received.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 3aa4864..325ff5c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1832,7 +1832,7 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 	 * IBSS mode (no proper uCode support for coex then).
 	 */
 	if (!bt_coex_active || priv->iw_mode == NL80211_IFTYPE_ADHOC) {
-		bt_cmd.flags = 0;
+		bt_cmd.flags = IWLAGN_BT_FLAG_COEX_MODE_DISABLED;
 	} else {
 		bt_cmd.flags = IWLAGN_BT_FLAG_COEX_MODE_3W <<
 					IWLAGN_BT_FLAG_COEX_MODE_SHIFT;
@@ -1869,6 +1869,11 @@ static void iwlagn_bt_traffic_change_work(struct work_struct *work)
 	struct iwl_rxon_context *ctx;
 	int smps_request = -1;
 
+	if (priv->bt_enable_flag == IWLAGN_BT_FLAG_COEX_MODE_DISABLED) {
+		/* bt coex disabled */
+		return;
+	}
+
 	/*
 	 * Note: bt_traffic_load can be overridden by scan complete and
 	 * coex profile notifications. Ignore that since only bad consequence
@@ -2022,6 +2027,11 @@ void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 	struct iwl_bt_coex_profile_notif *coex = &pkt->u.bt_coex_profile_notif;
 	struct iwl_bt_uart_msg *uart_msg = &coex->last_bt_uart_msg;
 
+	if (priv->bt_enable_flag == IWLAGN_BT_FLAG_COEX_MODE_DISABLED) {
+		/* bt coex disabled */
+		return;
+	}
+
 	IWL_DEBUG_NOTIF(priv, "BT Coex notification:\n");
 	IWL_DEBUG_NOTIF(priv, "    status: %d\n", coex->bt_status);
 	IWL_DEBUG_NOTIF(priv, "    traffic load: %d\n", coex->bt_traffic_load);
-- 
1.7.0.4

