Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61438 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbYKGR6T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 12:58:19 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/13] iwl3945 : Simplify iwl3945_send_beacon_cmd
Date: Fri,  7 Nov 2008 09:58:44 -0800
Message-Id: <1226080726-24860-12-git-send-email-reinette.chatre@intel.com> (sfid-20081107_190902_491725_EE103FE0)
In-Reply-To: <1226080726-24860-11-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-3-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-4-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-5-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-6-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-7-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-8-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-9-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-10-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-11-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>

Moved rate_msk calculation to iwl3945_rate_get_lowest_plcp.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 51f1c81..dec9e04 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1420,9 +1420,16 @@ unsigned int iwl3945_fill_beacon_frame(struct iwl3945_priv *priv,
 	return priv->ibss_beacon->len;
 }
 
-static u8 iwl3945_rate_get_lowest_plcp(int rate_mask)
+static u8 iwl3945_rate_get_lowest_plcp(struct iwl3945_priv *priv)
 {
 	u8 i;
+	int rate_mask;
+
+	/* Set rate mask*/
+	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)
+		rate_mask = priv->active_rate_basic & 0xF;
+	else
+		rate_mask = priv->active_rate_basic & 0xFF0;
 
 	for (i = IWL_RATE_1M_INDEX; i != IWL_RATE_INVALID;
 	     i = iwl3945_rates[i].next_ieee) {
@@ -1430,7 +1437,11 @@ static u8 iwl3945_rate_get_lowest_plcp(int rate_mask)
 			return iwl3945_rates[i].plcp;
 	}
 
-	return IWL_RATE_INVALID;
+	/* No valid rate was found. Assign the lowest one */
+	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)
+		return IWL_RATE_1M_PLCP;
+	else
+		return IWL_RATE_6M_PLCP;
 }
 
 static int iwl3945_send_beacon_cmd(struct iwl3945_priv *priv)
@@ -1448,16 +1459,7 @@ static int iwl3945_send_beacon_cmd(struct iwl3945_priv *priv)
 		return -ENOMEM;
 	}
 
-	if (!(priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)) {
-		rate = iwl3945_rate_get_lowest_plcp(priv->active_rate_basic &
-						0xFF0);
-		if (rate == IWL_INVALID_RATE)
-			rate = IWL_RATE_6M_PLCP;
-	} else {
-		rate = iwl3945_rate_get_lowest_plcp(priv->active_rate_basic & 0xF);
-		if (rate == IWL_INVALID_RATE)
-			rate = IWL_RATE_1M_PLCP;
-	}
+	rate = iwl3945_rate_get_lowest_plcp(priv);
 
 	frame_size = iwl3945_hw_get_beacon_cmd(priv, frame, rate);
 
-- 
1.5.4.3

