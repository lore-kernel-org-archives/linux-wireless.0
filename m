Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab1JJPQ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:26 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/34] iwlagn: add "echo" test when command queue stuck
Date: Mon, 10 Oct 2011 07:26:49 -0700
Message-Id: <1318256839-31837-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171740_814313_5AC7F000)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When detect command queue stuck, instead of reload the firmware
do the "echo" test to make sure it is really stuck before reload

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   23 ++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 +
 2 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 0725603..59d1968 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1732,10 +1732,31 @@ int iwl_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	return err;
 }
 
+int iwl_cmd_echo_test(struct iwl_priv *priv)
+{
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_ECHO,
+		.flags = CMD_SYNC,
+	};
+
+	return iwl_trans_send_cmd(trans(priv), &cmd);
+}
+
 static inline int iwl_check_stuck_queue(struct iwl_priv *priv, int txq)
 {
 	if (iwl_trans_check_stuck_queue(trans(priv), txq)) {
-		int ret = iwl_force_reset(priv, IWL_FW_RESET, false);
+		int ret;
+		if (txq == priv->shrd->cmd_queue) {
+			/*
+			 * validate command queue still working
+			 * by sending "ECHO" command
+			 */
+			if (!iwl_cmd_echo_test(priv))
+				return 0;
+			else
+				IWL_DEBUG_HC(priv, "echo testing fail\n");
+		}
+		ret = iwl_force_reset(priv, IWL_FW_RESET, false);
 		return (ret == -EAGAIN) ? 0 : 1;
 	}
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index db50b65..080c355 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -266,6 +266,7 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 int iwl_mac_change_interface(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     enum nl80211_iftype newtype, bool newp2p);
+int iwl_cmd_echo_test(struct iwl_priv *priv);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_alloc_traffic_mem(struct iwl_priv *priv);
 void iwl_free_traffic_mem(struct iwl_priv *priv);
-- 
1.7.0.4

