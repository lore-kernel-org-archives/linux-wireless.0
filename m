Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59070 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab1AEAbw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 19:31:52 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/5] iwlagn: properly wait for PAN disable
Date: Tue,  4 Jan 2011 16:22:01 -0800
Message-Id: <1294186923-4582-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1294186923-4582-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1294186923-4582-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Previously I hacked this with an msleep(300)
which was fine since we never had longer PAN
time slots, but now that we will have them I
need to fix that. Use the new notification
wait support to properly wait for the WIPAN
deactivation complete signal from the ucode.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   15 ++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    1 +
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 6d140bd..99e9650 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -52,10 +52,14 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 			      struct iwl_rxon_context *ctx,
 			      struct iwl_rxon_cmd *send)
 {
+	struct iwl_notification_wait disable_wait;
 	__le32 old_filter = send->filter_flags;
 	u8 old_dev_type = send->dev_type;
 	int ret;
 
+	iwlagn_init_notification_wait(priv, &disable_wait, NULL,
+				      REPLY_WIPAN_DEACTIVATION_COMPLETE);
+
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	send->dev_type = RXON_DEV_TYPE_P2P;
 	ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd, sizeof(*send), send);
@@ -63,11 +67,16 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 	send->filter_flags = old_filter;
 	send->dev_type = old_dev_type;
 
-	if (ret)
+	if (ret) {
 		IWL_ERR(priv, "Error disabling PAN (%d)\n", ret);
+		iwlagn_remove_notification(priv, &disable_wait);
+	} else {
+		signed long wait_res;
 
-	/* FIXME: WAIT FOR PAN DISABLE */
-	msleep(300);
+		wait_res = iwlagn_wait_notification(priv, &disable_wait, HZ);
+		if (wait_res == 0)
+			IWL_ERR(priv, "Timed out waiting for PAN disable\n");
+	}
 
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index f893d4a..abe2479 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -189,6 +189,7 @@ enum {
 	REPLY_WIPAN_WEPKEY = 0xb8,	/* use REPLY_WEPKEY structure */
 	REPLY_WIPAN_P2P_CHANNEL_SWITCH = 0xb9,
 	REPLY_WIPAN_NOA_NOTIFICATION = 0xbc,
+	REPLY_WIPAN_DEACTIVATION_COMPLETE = 0xbd,
 
 	REPLY_MAX = 0xff
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index c373b53..e4b953d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -108,6 +108,7 @@ const char *get_cmd_string(u8 cmd)
 		IWL_CMD(REPLY_WIPAN_WEPKEY);
 		IWL_CMD(REPLY_WIPAN_P2P_CHANNEL_SWITCH);
 		IWL_CMD(REPLY_WIPAN_NOA_NOTIFICATION);
+		IWL_CMD(REPLY_WIPAN_DEACTIVATION_COMPLETE);
 	default:
 		return "UNKNOWN";
 
-- 
1.7.0.4

