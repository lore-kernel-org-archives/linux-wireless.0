Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35970 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759135Ab3EWUYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 16:24:36 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: stable@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Arend van Spriel <arend@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.9] iwlwifi: mvm: remove P2P_DEVICE support
Date: Thu, 23 May 2013 22:24:31 +0200
Message-Id: <1369340671-14560-1-git-send-email-johannes@sipsolutions.net> (sfid-20130523_222438_802452_E0D206C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Unfortunately, advertising P2P_DEVICE support was a little
premature, a number of issues came up in testing and have
been fixed for 3.10. Rather than try to backport all the
different fixes, disable P2P_DEVICE support in the drivers
using it. For iwlmvm that implies disabling P2P completely
as it can't support P2P operation w/o P2P Device.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index dd158ec..11dc7df 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -84,15 +84,6 @@ static const struct ieee80211_iface_limit iwl_mvm_limits[] = {
 		.types = BIT(NL80211_IFTYPE_STATION) |
 			BIT(NL80211_IFTYPE_AP),
 	},
-	{
-		.max = 1,
-		.types = BIT(NL80211_IFTYPE_P2P_CLIENT) |
-			BIT(NL80211_IFTYPE_P2P_GO),
-	},
-	{
-		.max = 1,
-		.types = BIT(NL80211_IFTYPE_P2P_DEVICE),
-	},
 };
 
 static const struct ieee80211_iface_combination iwl_mvm_iface_combinations[] = {
@@ -161,10 +152,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	hw->chanctx_data_size = sizeof(struct iwl_mvm_phy_ctxt);
 
 	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_P2P_CLIENT) |
-		BIT(NL80211_IFTYPE_AP) |
-		BIT(NL80211_IFTYPE_P2P_GO) |
-		BIT(NL80211_IFTYPE_P2P_DEVICE);
+		BIT(NL80211_IFTYPE_AP);
 
 	hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
-- 
1.8.0

