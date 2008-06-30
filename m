Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19551 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756968AbYF3J1K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:10 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Assaf Krauss <assaf.krauss@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 14/33] iwlwifi: fix IBSS association flow
Date: Mon, 30 Jun 2008 17:23:14 +0800
Message-Id: <1214817813-17639-15-git-send-email-yi.zhu@intel.com> (sfid-20080630_113815_014788_76D949F4)
In-Reply-To: <1214817813-17639-14-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-11-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-12-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-13-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-14-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes regression caused by
'iwlwifi: send ADD_STA before RXON with assoc bit' patch.
RXON associated wasn't IBSS flow.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index bb3e61c..144b1da 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -344,16 +344,19 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 
 	/* If we have set the ASSOC_MSK and we are in BSS mode then
 	 * add the IWL_AP_ID to the station rate table */
-	if (new_assoc && (priv->iw_mode == IEEE80211_IF_TYPE_STA)) {
-		if (iwl_rxon_add_station(priv, priv->active_rxon.bssid_addr, 1)
-		    == IWL_INVALID_STATION) {
-			IWL_ERROR("Error adding AP address for transmit.\n");
-			return -EIO;
+	if (new_assoc) {
+		if (priv->iw_mode == IEEE80211_IF_TYPE_STA) {
+			ret = iwl_rxon_add_station(priv,
+					   priv->active_rxon.bssid_addr, 1);
+			if (ret == IWL_INVALID_STATION) {
+				IWL_ERROR("Error adding AP address for TX.\n");
+				return -EIO;
+			}
+			priv->assoc_station_added = 1;
+			if (priv->default_wep_key &&
+			    iwl_send_static_wepkey_cmd(priv, 0))
+				IWL_ERROR("Could not send WEP static key.\n");
 		}
-		priv->assoc_station_added = 1;
-		if (priv->default_wep_key &&
-		    iwl_send_static_wepkey_cmd(priv, 0))
-			IWL_ERROR("Could not send WEP static key.\n");
 
 		/* Apply the new configuration
 		 * RXON assoc doesn't clear the station table in uCode,
-- 
1.5.3.6

