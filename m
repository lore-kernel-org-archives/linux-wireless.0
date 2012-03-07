Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51937 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759724Ab2CGTGi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:06:38 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 25/35] iwlwifi: log stop / wake queues
Date: Wed,  7 Mar 2012 09:52:34 -0800
Message-Id: <1331142764-5750-26-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120307_200648_563052_05ACFE8A)
In-Reply-To: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
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

