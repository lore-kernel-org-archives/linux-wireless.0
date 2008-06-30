Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41503 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbYF3J0g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:26:36 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 06/33] iwlwifi: send ADD_STA before RXON with assoc bit
Date: Mon, 30 Jun 2008 17:23:06 +0800
Message-Id: <1214817813-17639-7-git-send-email-yi.zhu@intel.com> (sfid-20080630_112639_744359_5AC5F87A)
In-Reply-To: <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch fixes a bug in association flow. As soon as RXON with assoc bit
is sent, uCode expects to have an entry in its station table that describe
the AP. Receiving a beacon from an HT AP before sending ADD_STA results a
uCode error. This patch sends first the ADD_STA (bcast and bssid) and only
then RXON with assoc bit set

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   79 ++++++++++++++++-----------
 1 files changed, 46 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index a2dffe4..0a279d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -241,16 +241,18 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 	/* cast away the const for active_rxon in this function */
 	struct iwl_rxon_cmd *active_rxon = (void *)&priv->active_rxon;
 	DECLARE_MAC_BUF(mac);
-	int rc = 0;
+	int ret;
+	bool new_assoc =
+		!!(priv->staging_rxon.filter_flags & RXON_FILTER_ASSOC_MSK);
 
 	if (!iwl_is_alive(priv))
-		return -1;
+		return -EBUSY;
 
 	/* always get timestamp with Rx frame */
 	priv->staging_rxon.flags |= RXON_FLG_TSF2HOST_MSK;
 
-	rc = iwl4965_check_rxon_cmd(&priv->staging_rxon);
-	if (rc) {
+	ret = iwl4965_check_rxon_cmd(&priv->staging_rxon);
+	if (ret) {
 		IWL_ERROR("Invalid RXON configuration.  Not committing.\n");
 		return -EINVAL;
 	}
@@ -259,15 +261,13 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 	 * iwl4965_rxon_assoc_cmd which is used to reconfigure filter
 	 * and other flags for the current radio configuration. */
 	if (!iwl4965_full_rxon_required(priv)) {
-		rc = iwl_send_rxon_assoc(priv);
-		if (rc) {
-			IWL_ERROR("Error setting RXON_ASSOC "
-				  "configuration (%d).\n", rc);
-			return rc;
+		ret = iwl_send_rxon_assoc(priv);
+		if (ret) {
+			IWL_ERROR("Error setting RXON_ASSOC (%d)\n", ret);
+			return ret;
 		}
 
 		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
-
 		return 0;
 	}
 
@@ -278,22 +278,20 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 	 * an RXON_ASSOC and the new config wants the associated mask enabled,
 	 * we must clear the associated from the active configuration
 	 * before we apply the new config */
-	if (iwl_is_associated(priv) &&
-	    (priv->staging_rxon.filter_flags & RXON_FILTER_ASSOC_MSK)) {
+	if (iwl_is_associated(priv) && new_assoc) {
 		IWL_DEBUG_INFO("Toggling associated bit on current RXON\n");
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
-		rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
+		ret = iwl_send_cmd_pdu(priv, REPLY_RXON,
 				      sizeof(struct iwl_rxon_cmd),
 				      &priv->active_rxon);
 
 		/* If the mask clearing failed then we set
 		 * active_rxon back to what it was previously */
-		if (rc) {
+		if (ret) {
 			active_rxon->filter_flags |= RXON_FILTER_ASSOC_MSK;
-			IWL_ERROR("Error clearing ASSOC_MSK on current "
-				  "configuration (%d).\n", rc);
-			return rc;
+			IWL_ERROR("Error clearing ASSOC_MSK (%d)\n", ret);
+			return ret;
 		}
 	}
 
@@ -301,18 +299,25 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 		       "* with%s RXON_FILTER_ASSOC_MSK\n"
 		       "* channel = %d\n"
 		       "* bssid = %s\n",
-		       ((priv->staging_rxon.filter_flags &
-			 RXON_FILTER_ASSOC_MSK) ? "" : "out"),
+		       (new_assoc ? "" : "out"),
 		       le16_to_cpu(priv->staging_rxon.channel),
 		       print_mac(mac, priv->staging_rxon.bssid_addr));
 
 	iwl4965_set_rxon_hwcrypto(priv, !priv->hw_params.sw_crypto);
-	/* Apply the new configuration */
-	rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
+
+	/* Apply the new configuration
+	 * RXON unassoc clears the station table in uCode, send it before
+	 * we add the bcast station. If assoc bit is set, we will send RXON
+	 * after having added the bcast and bssid station.
+	 */
+	if (!new_assoc) {
+		ret = iwl_send_cmd_pdu(priv, REPLY_RXON,
 			      sizeof(struct iwl_rxon_cmd), &priv->staging_rxon);
-	if (rc) {
-		IWL_ERROR("Error setting new configuration (%d).\n", rc);
-		return rc;
+		if (ret) {
+			IWL_ERROR("Error setting new RXON (%d)\n", ret);
+			return ret;
+		}
+		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
 	}
 
 	iwlcore_clear_stations_table(priv);
@@ -322,27 +327,24 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 
 	iwl_init_sensitivity(priv);
 
-	memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
-
 	/* If we issue a new RXON command which required a tune then we must
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
-	rc = iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
-	if (rc) {
-		IWL_ERROR("Error sending TX power (%d).\n", rc);
-		return rc;
+	ret = iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
+	if (ret) {
+		IWL_ERROR("Error sending TX power (%d)\n", ret);
+		return ret;
 	}
 
 	/* Add the broadcast address so we can send broadcast frames */
 	if (iwl_rxon_add_station(priv, iwl_bcast_addr, 0) ==
-	    IWL_INVALID_STATION) {
+						IWL_INVALID_STATION) {
 		IWL_ERROR("Error adding BROADCAST address for transmit.\n");
 		return -EIO;
 	}
 
 	/* If we have set the ASSOC_MSK and we are in BSS mode then
 	 * add the IWL_AP_ID to the station rate table */
-	if (iwl_is_associated(priv) &&
-	    (priv->iw_mode == IEEE80211_IF_TYPE_STA)) {
+	if (new_assoc && (priv->iw_mode == IEEE80211_IF_TYPE_STA)) {
 		if (iwl_rxon_add_station(priv, priv->active_rxon.bssid_addr, 1)
 		    == IWL_INVALID_STATION) {
 			IWL_ERROR("Error adding AP address for transmit.\n");
@@ -352,6 +354,17 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 		if (priv->default_wep_key &&
 		    iwl_send_static_wepkey_cmd(priv, 0))
 			IWL_ERROR("Could not send WEP static key.\n");
+
+		/* Apply the new configuration
+		 * RXON assoc doesn't clear the station table in uCode,
+		 */
+		ret = iwl_send_cmd_pdu(priv, REPLY_RXON,
+			      sizeof(struct iwl_rxon_cmd), &priv->staging_rxon);
+		if (ret) {
+			IWL_ERROR("Error setting new RXON (%d)\n", ret);
+			return ret;
+		}
+		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
 	}
 
 	return 0;
-- 
1.5.3.6

