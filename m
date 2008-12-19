Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53494 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbYLSCpp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:45 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 42/43] iwl3945: use iwl_get_hw_mode
Date: Fri, 19 Dec 2008 10:37:42 +0800
Message-Id: <1229654263-21454-43-git-send-email-yi.zhu@intel.com> (sfid-20081219_040901_709082_78950E93)
In-Reply-To: <1229654263-21454-42-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-23-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-24-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-25-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-26-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-27-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-28-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-29-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-30-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-31-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-32-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-33-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-34-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-35-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-36-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-37-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-38-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-39-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-40-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-41-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-42-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>

Use iwl_get_hw_mode for 3945.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3305fa9..1a2a4f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -94,12 +94,6 @@ struct iwl_mod_params iwl3945_mod_params = {
 	/* the rest are 0 by default */
 };
 
-static const struct ieee80211_supported_band *iwl3945_get_band(
-		struct iwl_priv *priv, enum ieee80211_band band)
-{
-	return priv->hw->wiphy->bands[band];
-}
-
 /*************** DMA-QUEUE-GENERAL-FUNCTIONS  *****
  * DMA services
  *
@@ -2468,7 +2462,7 @@ static void iwl3945_set_rate(struct iwl_priv *priv)
 	struct ieee80211_rate *rate;
 	int i;
 
-	sband = iwl3945_get_band(priv, priv->band);
+	sband = iwl_get_hw_mode(priv, priv->band);
 	if (!sband) {
 		IWL_ERR(priv, "Failed to set rate: unable to get hw mode\n");
 		return;
@@ -4547,7 +4541,7 @@ static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
 	u16 active_dwell = 0;
 	int added, i;
 
-	sband = iwl3945_get_band(priv, band);
+	sband = iwl_get_hw_mode(priv, band);
 	if (!sband)
 		return 0;
 
-- 
1.5.3.6

