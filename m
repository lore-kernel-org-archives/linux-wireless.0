Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52885 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759613Ab2EPUyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:54:37 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/9] iwlwifi: properly handle device_set_wakeup_enable
Date: Wed, 16 May 2012 22:54:25 +0200
Message-Id: <1337201670-21604-5-git-send-email-johannes@sipsolutions.net> (sfid-20120516_225458_573046_5D2B2F99)
In-Reply-To: <1337201670-21604-1-git-send-email-johannes@sipsolutions.net>
References: <1337201670-21604-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is intended to be set whenever wakeup will be
needed upon suspend, not only when suspending, so
use the new callbacks to set it then.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index ab2f4d7..ff66200 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -417,8 +417,6 @@ int iwlagn_mac_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	if (ret)
 		goto error;
 
-	device_set_wakeup_enable(priv->trans->dev, true);
-
 	iwl_trans_wowlan_suspend(priv->trans);
 
 	goto out;
@@ -485,8 +483,6 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 
 	priv->wowlan = false;
 
-	device_set_wakeup_enable(priv->trans->dev, false);
-
 	iwlagn_prepare_restart(priv);
 
 	memset((void *)&ctx->active, 0, sizeof(ctx->active));
@@ -501,6 +497,12 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	return 1;
 }
 
+static void iwlagn_mac_set_wakeup(struct ieee80211_hw *hw, bool enabled)
+{
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
+
+	device_set_wakeup_enable(priv->trans->dev, enabled);
+}
 #endif
 
 void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
@@ -1581,6 +1583,7 @@ struct ieee80211_ops iwlagn_hw_ops = {
 #ifdef CONFIG_PM_SLEEP
 	.suspend = iwlagn_mac_suspend,
 	.resume = iwlagn_mac_resume,
+	.set_wakeup = iwlagn_mac_set_wakeup,
 #endif
 	.add_interface = iwlagn_mac_add_interface,
 	.remove_interface = iwlagn_mac_remove_interface,
-- 
1.7.10

