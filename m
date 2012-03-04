Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20116 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170Ab2CDUnK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:10 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 072/101] iwlwifi: remove unused argument from iwlagn_suspend
Date: Sun,  4 Mar 2012 11:29:26 -0800
Message-Id: <1330889395-533-73-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214529_735259_0E7CD6DE)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's not much point in passing priv and
hw pointers since they can be derived from
each other, and the function doesn't use
the hw pointer anyway. Remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    3 +--
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    3 +--
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index b2ee1f9..6d8a857 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1120,8 +1120,7 @@ int iwlagn_send_patterns(struct iwl_priv *priv,
 	return err;
 }
 
-int iwlagn_suspend(struct iwl_priv *priv,
-		struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
+int iwlagn_suspend(struct iwl_priv *priv, struct cfg80211_wowlan *wowlan)
 {
 	struct iwlagn_wowlan_wakeup_filter_cmd wakeup_filter_cmd;
 	struct iwl_rxon_cmd rxon;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 8384c05..82930ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -141,8 +141,7 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv);
 #ifdef CONFIG_PM_SLEEP
 int iwlagn_send_patterns(struct iwl_priv *priv,
 			 struct cfg80211_wowlan *wowlan);
-int iwlagn_suspend(struct iwl_priv *priv,
-		   struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan);
+int iwlagn_suspend(struct iwl_priv *priv, struct cfg80211_wowlan *wowlan);
 #endif
 
 /* rx */
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index d2c1d71..bdcbbd0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -405,7 +405,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	ret = iwlagn_suspend(priv, hw, wowlan);
+	ret = iwlagn_suspend(priv, wowlan);
 	if (ret)
 		goto error;
 
-- 
1.7.0.4

