Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61394 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbYGKD5H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 23:57:07 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 12/14] iwlwifi: send TXPOWER command after a new RXON command
Date: Fri, 11 Jul 2008 11:53:40 +0800
Message-Id: <1215748422-12672-13-git-send-email-yi.zhu@intel.com> (sfid-20080711_055709_896648_8EDF84F4)
In-Reply-To: <1215748422-12672-12-git-send-email-yi.zhu@intel.com>
References: <1215748422-12672-1-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-2-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-3-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-4-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-5-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-6-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-7-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-8-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-9-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-10-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-11-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-12-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes the problem that TXPOWER command is not sent
after we issue a new RXON command which requires a tune. Otherwise
we won't be able to Tx any frames.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index bc9aa8d..b2fae7c 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -328,16 +328,6 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 	if (!priv->error_recovering)
 		priv->start_calib = 0;
 
-	iwl_init_sensitivity(priv);
-
-	/* If we issue a new RXON command which required a tune then we must
-	 * send a new TXPOWER command or we won't be able to Tx any frames */
-	ret = iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
-	if (ret) {
-		IWL_ERROR("Error sending TX power (%d)\n", ret);
-		return ret;
-	}
-
 	/* Add the broadcast address so we can send broadcast frames */
 	if (iwl_rxon_add_station(priv, iwl_bcast_addr, 0) ==
 						IWL_INVALID_STATION) {
@@ -373,6 +363,16 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
 	}
 
+	iwl_init_sensitivity(priv);
+
+	/* If we issue a new RXON command which required a tune then we must
+	 * send a new TXPOWER command or we won't be able to Tx any frames */
+	ret = iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
+	if (ret) {
+		IWL_ERROR("Error sending TX power (%d)\n", ret);
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
1.5.3.6

