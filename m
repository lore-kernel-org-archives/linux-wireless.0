Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55973 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab2CDUnM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:12 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 091/101] iwlwifi: log stop / wake queues
Date: Sun,  4 Mar 2012 11:29:45 -0800
Message-Id: <1330889395-533-92-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214412_008631_328F6FFE)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

There were a few missing occurences when we get PASSIVE_NO_RX
notification.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    2 ++
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 1d67e6c..1cd4831 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1088,6 +1088,8 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			    ctx->vif->type == NL80211_IFTYPE_STATION) {
 				/* block and stop all queues */
 				priv->passive_no_rx = true;
+				IWL_DEBUG_TX_QUEUES(priv, "stop all queues: "
+						    "passive channel");
 				ieee80211_stop_queues(priv->hw);
 
 				IWL_DEBUG_TX_REPLY(priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7927e3e..6ed2f78 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1450,8 +1450,12 @@ void iwlagn_lift_passive_no_rx(struct iwl_priv *priv)
 		return;
 
 	for (ac = IEEE80211_AC_VO; ac < IEEE80211_NUM_ACS; ac++) {
-		if (!test_bit(ac, &priv->transport_queue_stop))
+		if (!test_bit(ac, &priv->transport_queue_stop)) {
+			IWL_DEBUG_TX_QUEUES(priv, "Wake queue %d");
 			ieee80211_wake_queue(priv->hw, ac);
+		} else {
+			IWL_DEBUG_TX_QUEUES(priv, "Don't wake queue %d");
+		}
 	}
 
 	priv->passive_no_rx = false;
-- 
1.7.0.4

