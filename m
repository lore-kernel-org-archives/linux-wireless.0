Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13138 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757251Ab1LBRqR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 12:46:17 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	stable@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/16] iwlagn: fix HW crypto for TX-only keys
Date: Fri,  2 Dec 2011 08:48:30 -0800
Message-Id: <1322844520-21149-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111202_184623_946604_9D81AC82)
In-Reply-To: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Group keys in IBSS or AP mode are not programmed
into the device since we give the key to it with
every TX packet. However, we do need mac80211 to
create the MMIC & PN in all cases. Move the code
around to set the key flags all the time. We set
them even when the key is removed again but that
is obviously harmless.

Cc: stable@vger.kernel.org
Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |    5 -----
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   11 +++++++++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 901fd94..626ed70 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -1250,9 +1250,6 @@ int iwl_set_dynamic_key(struct iwl_priv *priv,
 
 	switch (keyconf->cipher) {
 	case WLAN_CIPHER_SUITE_TKIP:
-		keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-		keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-
 		if (sta)
 			addr = sta->addr;
 		else /* station mode case only */
@@ -1265,8 +1262,6 @@ int iwl_set_dynamic_key(struct iwl_priv *priv,
 					  seq.tkip.iv32, p1k, CMD_SYNC);
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
-		keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-		/* fall through */
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
 		ret = iwlagn_send_sta_key(priv, keyconf, sta_id,
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index ec31482..bafd525 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -521,6 +521,17 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return -EOPNOTSUPP;
 	}
 
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_TKIP:
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+		/* fall through */
+	case WLAN_CIPHER_SUITE_CCMP:
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+		break;
+	default:
+		break;
+	}
+
 	/*
 	 * We could program these keys into the hardware as well, but we
 	 * don't expect much multicast traffic in IBSS and having keys
-- 
1.7.0.4

