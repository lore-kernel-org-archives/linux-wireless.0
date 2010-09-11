Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492Ab0IKQGo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 12:06:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/10] iwlwifi: implement beacon interval change
Date: Sat, 11 Sep 2010 09:08:32 -0700
Message-Id: <1284221318-28281-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the beacon interval needs to be changed,
all we need to do is send updated timing to
the device.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 87a2e40..a763103 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1797,9 +1797,8 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 		priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
 	}
 
-	if (changes & BSS_CHANGED_BEACON_INT) {
-		/* TODO: in AP mode, do something to make this take effect */
-	}
+	if (changes & BSS_CHANGED_BEACON_INT && vif->type == NL80211_IFTYPE_AP)
+		iwl_send_rxon_timing(priv, ctx);
 
 	if (changes & BSS_CHANGED_BSSID) {
 		IWL_DEBUG_MAC80211(priv, "BSSID %pM\n", bss_conf->bssid);
-- 
1.7.0.4

