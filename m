Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1413 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179Ab0HRQSf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:18:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/16] iwlwifi: cleanup iwl_set_rxon_channel()
Date: Wed, 18 Aug 2010 09:22:42 -0700
Message-Id: <1282148571-9258-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

Update outdated comments of iwl_set_rxon_channel() to reflect the
current signature. Also remove the unnecessary validation of the
channel. Those channel info are constructed in iwlwifi driver
and mac80211 will never modify the content of the struct. Also
everytime before this function is called the channel info has
been validated already (as a paranoid check).

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index fc78690..fe28272 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -904,26 +904,19 @@ u8 iwl_get_single_channel_number(struct iwl_priv *priv,
 EXPORT_SYMBOL(iwl_get_single_channel_number);
 
 /**
- * iwl_set_rxon_channel - Set the phymode and channel values in staging RXON
- * @phymode: MODE_IEEE80211A sets to 5.2GHz; all else set to 2.4GHz
- * @channel: Any channel valid for the requested phymode
+ * iwl_set_rxon_channel - Set the band and channel values in staging RXON
+ * @ch: requested channel as a pointer to struct ieee80211_channel
 
- * In addition to setting the staging RXON, priv->phymode is also set.
+ * In addition to setting the staging RXON, priv->band is also set.
  *
  * NOTE:  Does not commit to the hardware; it sets appropriate bit fields
- * in the staging RXON flag structure based on the phymode
+ * in the staging RXON flag structure based on the ch->band
  */
 int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch)
 {
 	enum ieee80211_band band = ch->band;
 	u16 channel = ch->hw_value;
 
-	if (!iwl_get_channel_info(priv, band, channel)) {
-		IWL_DEBUG_INFO(priv, "Could not set channel to %d [%d]\n",
-			       channel, band);
-		return -EINVAL;
-	}
-
 	if ((le16_to_cpu(priv->staging_rxon.channel) == channel) &&
 	    (priv->band == band))
 		return 0;
-- 
1.7.0.4

