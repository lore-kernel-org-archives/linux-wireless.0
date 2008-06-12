Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12449 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbYFLBtu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:50 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 16/29] iwlwifi: Fix mode changes (ad-hoc <--> managed)
Date: Thu, 12 Jun 2008 09:47:06 +0800
Message-Id: <1213235239-2954-17-git-send-email-yi.zhu@intel.com> (sfid-20080612_041915_578085_C14EFECD)
In-Reply-To: <1213235239-2954-16-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-9-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-11-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-12-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-13-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-14-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-15-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-16-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

This fix allows to move between modes (ad-hoc to managed, and vice versa).
Since mode changes can only be done while driver is down, check for ibss
support can only be made when the channel is set (afte the driver goes up).

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 4570fd1..8e7860d 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1176,22 +1176,11 @@ static void iwl4965_connection_init_rx_config(struct iwl_priv *priv)
 
 static int iwl4965_set_mode(struct iwl_priv *priv, int mode)
 {
-	if (mode == IEEE80211_IF_TYPE_IBSS) {
-		const struct iwl_channel_info *ch_info;
-
-		ch_info = iwl_get_channel_info(priv,
-			priv->band,
-			le16_to_cpu(priv->staging_rxon.channel));
-
-		if (!ch_info || !is_channel_ibss(ch_info)) {
-			IWL_ERROR("channel %d not IBSS channel\n",
-				  le16_to_cpu(priv->staging_rxon.channel));
-			return -EINVAL;
-		}
-	}
-
 	priv->iw_mode = mode;
 
+	/* init channel/phymode to values given at driver init */
+	iwl_set_rxon_channel(priv, IEEE80211_BAND_2GHZ, 6);
+
 	iwl4965_connection_init_rx_config(priv);
 	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 
@@ -3892,6 +3881,14 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 		goto out;
 	}
 
+	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS &&
+	    !is_channel_ibss(ch_info)) {
+		IWL_ERROR("channel %d in band %d not IBSS channel\n",
+			conf->channel->hw_value, conf->channel->band);
+		ret = -EINVAL;
+		goto out;
+	}
+
 	spin_lock_irqsave(&priv->lock, flags);
 
 	/* if we are switching from ht to 2.4 clear flags
-- 
1.5.3.6

