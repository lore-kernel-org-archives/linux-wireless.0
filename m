Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39589 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab1BFRz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 12:55:58 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/2] iwlwifi: fix compiling error with different configuration
Date: Sun,  6 Feb 2011 09:42:53 -0800
Message-Id: <1297014173-28964-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1297014173-28964-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1297014173-28964-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When .config has different configuration, it might fail to compile
iwlwifi. fix it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a5daf64..096f8ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3771,7 +3771,7 @@ static void iwlagn_disable_roc(struct iwl_priv *priv)
 
 	priv->_agn.hw_roc_channel = NULL;
 
-	iwlagn_commit_rxon(priv, ctx);
+	iwlcore_commit_rxon(priv, ctx);
 
 	ctx->is_active = false;
 }
@@ -3787,6 +3787,7 @@ static void iwlagn_bg_roc_done(struct work_struct *work)
 	mutex_unlock(&priv->mutex);
 }
 
+#ifdef CONFIG_IWL5000
 static int iwl_mac_remain_on_channel(struct ieee80211_hw *hw,
 				     struct ieee80211_channel *channel,
 				     enum nl80211_channel_type channel_type,
@@ -3814,7 +3815,7 @@ static int iwl_mac_remain_on_channel(struct ieee80211_hw *hw,
 	priv->_agn.hw_roc_channel = channel;
 	priv->_agn.hw_roc_chantype = channel_type;
 	priv->_agn.hw_roc_duration = DIV_ROUND_UP(duration * 1000, 1024);
-	iwlagn_commit_rxon(priv, &priv->contexts[IWL_RXON_CTX_PAN]);
+	iwlcore_commit_rxon(priv, &priv->contexts[IWL_RXON_CTX_PAN]);
 	queue_delayed_work(priv->workqueue, &priv->_agn.hw_roc_work,
 			   msecs_to_jiffies(duration + 20));
 
@@ -3842,6 +3843,7 @@ static int iwl_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 
 	return 0;
 }
+#endif
 
 /*****************************************************************************
  *
-- 
1.7.0.4

