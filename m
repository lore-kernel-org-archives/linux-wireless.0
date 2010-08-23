Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24115 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab0HWOxb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/26] iwlagn: disable gen2b BT coexistence in IBSS
Date: Mon, 23 Aug 2010 07:57:00 -0700
Message-Id: <1282575437-23270-10-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

IBSS doesn't allow for coexistence, so it
should be disabled.

Additionally, disable reacting to the BT
profile notification when in IBSS mode,
it likely won't be sent by the device to
start with though.

Also, in IBSS mode, BT coexistence isn't as fully-featured
and we must use a single antenna only. So instead of
peppering the code with new checks, simply pretend
we are in high BT traffic load, which has the needed
effect of disabling antenna B use.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   34 +++++++++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-core.c |   21 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    2 +-
 3 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f049ebc..5141944 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -217,7 +217,14 @@ static void iwl6000g2b_send_bt_config(struct iwl_priv *priv)
 	BUILD_BUG_ON(sizeof(iwl6000g2b_def_3w_lookup) !=
 			sizeof(bt_cmd.bt3_lookup_table));
 
-	if (!bt_coex_active) {
+	/*
+	 * Configure BT coex mode to "no coexistence" when the
+	 * user disabled BT coexistence, we have no interface
+	 * (might be in monitor mode), or the interface is in
+	 * IBSS mode (no proper uCode support for coex then).
+	 */
+	if (!bt_coex_active || !priv->vif ||
+	    priv->iw_mode == NL80211_IFTYPE_ADHOC) {
 		bt_cmd.flags = 0;
 	} else {
 		bt_cmd.flags = IWL6000G2B_BT_FLAG_CHANNEL_INHIBITION |
@@ -426,18 +433,23 @@ static void iwl6000g2b_bt_coex_profile_notif(struct iwl_priv *priv,
 			coex->uart_msg[3], coex->uart_msg[4], coex->uart_msg[5],
 			coex->uart_msg[6], coex->uart_msg[7]);
 
-	if (coex->bt_traffic_load != priv->bt_traffic_load) {
-		priv->bt_traffic_load = coex->bt_traffic_load;
+	priv->notif_bt_traffic_load = coex->bt_traffic_load;
 
-		queue_work(priv->workqueue, &priv->bt_traffic_change_work);
-	}
+	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
+		if (coex->bt_traffic_load != priv->bt_traffic_load) {
+			priv->bt_traffic_load = coex->bt_traffic_load;
 
-	/* FIXME: add defines for this check */
-	priv->bt_sco_active = coex->uart_msg[3] & 1;
-	if (priv->bt_sco_active)
-		sco_cmd.flags |= IWL6000G2B_BT_SCO_ACTIVE;
-	iwl_send_cmd_pdu_async(priv, REPLY_BT_COEX_SCO,
-			       sizeof(sco_cmd), &sco_cmd, NULL);
+			queue_work(priv->workqueue,
+				   &priv->bt_traffic_change_work);
+		}
+
+		/* FIXME: add defines for this check */
+		priv->bt_sco_active = coex->uart_msg[3] & 1;
+		if (priv->bt_sco_active)
+			sco_cmd.flags |= IWL6000G2B_BT_SCO_ACTIVE;
+		iwl_send_cmd_pdu_async(priv, REPLY_BT_COEX_SCO,
+				       sizeof(sco_cmd), &sco_cmd, NULL);
+	}
 }
 
 void iwl6000g2b_rx_handler_setup(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4beddad..1921307 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1872,6 +1872,16 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	if (err)
 		goto out_err;
 
+	if (priv->cfg->advanced_bt_coexist &&
+	    vif->type == NL80211_IFTYPE_ADHOC) {
+		/*
+		 * pretend to have high BT traffic as long as we
+		 * are operating in IBSS mode, as this will cause
+		 * the rate scaling etc. to behave as intended.
+		 */
+		priv->bt_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_HIGH;
+	}
+
 	goto out;
 
  out_err:
@@ -1909,6 +1919,17 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 		}
 		memset(priv->bssid, 0, ETH_ALEN);
 	}
+
+	/*
+	 * When removing the IBSS interface, overwrite the
+	 * BT traffic load with the stored one from the last
+	 * notification, if any. If this is a device that
+	 * doesn't implement this, this has no effect since
+	 * both values are the same and zero.
+	 */
+	if (vif->type == NL80211_IFTYPE_ADHOC)
+		priv->bt_traffic_load = priv->notif_bt_traffic_load;
+
 	mutex_unlock(&priv->mutex);
 
 	if (scan_completed)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 5d327b4..815ba0a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1362,7 +1362,7 @@ struct iwl_priv {
 #endif
 	};
 
-	u8 bt_traffic_load;
+	u8 bt_traffic_load, notif_bt_traffic_load;
 	bool bt_sco_active;
 	struct work_struct bt_traffic_change_work;
 
-- 
1.7.0.4

