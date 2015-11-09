Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36941 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbbKIWCq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 17:02:46 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/4] mac80211: add ieee80211_hw_clear()
Date: Mon,  9 Nov 2015 23:02:34 +0100
Message-Id: <1447106557-17684-2-git-send-email-johannes@sipsolutions.net> (sfid-20151109_230254_521415_54AC5484)
In-Reply-To: <1447106557-17684-1-git-send-email-johannes@sipsolutions.net>
References: <1447106557-17684-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are a few hardware flags that *are* valid to change, at least
under certain circumstances. Since drivers are doing that, add an
inline to make it easier to do correctly. They still need to take
care of locking themselves.

While at it, remove the pointless return in ieee80211_hw_set().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/adm8211.c              | 2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c | 2 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 2 +-
 include/net/mac80211.h                      | 9 ++++++++-
 4 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 15f057ed41ad..bdfd60f39078 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1375,7 +1375,7 @@ static void adm8211_configure_filter(struct ieee80211_hw *dev,
 	if (priv->nar & ADM8211_NAR_PR)
 		ieee80211_hw_set(dev, RX_INCLUDES_FCS);
 	else
-		__clear_bit(IEEE80211_HW_RX_INCLUDES_FCS, dev->flags);
+		ieee80211_hw_clear(dev, RX_INCLUDES_FCS);
 
 	if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
 		adm8211_set_bssid(dev, bcast);
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index b3ad34e8bf5a..d4918a5f7bd7 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1356,7 +1356,7 @@ static int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
 	if (vif->type == NL80211_IFTYPE_MONITOR)
 		ieee80211_hw_set(priv->hw, RX_INCLUDES_FCS);
 	else
-		__clear_bit(IEEE80211_HW_RX_INCLUDES_FCS, priv->hw->flags);
+		ieee80211_hw_clear(priv->hw, RX_INCLUDES_FCS);
 
 	err = iwl_setup_interface(priv, ctx);
 	if (!err || reset)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index ad7ad720d2e7..ca944d3f7401 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1289,7 +1289,7 @@ int iwl_mvm_mac_ctxt_remove(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	mvmvif->uploaded = false;
 
 	if (vif->type == NL80211_IFTYPE_MONITOR)
-		__clear_bit(IEEE80211_HW_RX_INCLUDES_FCS, mvm->hw->flags);
+		ieee80211_hw_clear(mvm->hw, RX_INCLUDES_FCS);
 
 	return 0;
 }
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 82045fca388b..47274d829115 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2081,10 +2081,17 @@ static inline bool _ieee80211_hw_check(struct ieee80211_hw *hw,
 static inline void _ieee80211_hw_set(struct ieee80211_hw *hw,
 				     enum ieee80211_hw_flags flg)
 {
-	return __set_bit(flg, hw->flags);
+	__set_bit(flg, hw->flags);
 }
 #define ieee80211_hw_set(hw, flg)	_ieee80211_hw_set(hw, IEEE80211_HW_##flg)
 
+static inline void _ieee80211_hw_clear(struct ieee80211_hw *hw,
+				       enum ieee80211_hw_flags flg)
+{
+	__clear_bit(flg, hw->flags);
+}
+#define ieee80211_hw_clear(hw, flg)	_ieee80211_hw_clear(hw, IEEE80211_HW_##flg)
+
 /**
  * struct ieee80211_scan_request - hw scan request
  *
-- 
2.6.2

