Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6480 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789Ab0DIUJk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 16:09:40 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/12] iwlagn: simplify WEP key check
Date: Fri,  9 Apr 2010 13:09:21 -0700
Message-Id: <1270843769-30017-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
References: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Simplify the WEP group key check by checking the
sta pointer instead of the sta_id we calculate
with it; also clean up the comment formatting.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8a3b0ed..3526d5e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2901,12 +2901,13 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	mutex_lock(&priv->mutex);
 	iwl_scan_cancel_timeout(priv, 100);
 
-	/* If we are getting WEP group key and we didn't receive any key mapping
+	/*
+	 * If we are getting WEP group key and we didn't receive any key mapping
 	 * so far, we are in legacy wep mode (group key only), otherwise we are
 	 * in 1X mode.
-	 * In legacy wep mode, we use another host command to the uCode */
-	if (key->alg == ALG_WEP && sta_id == priv->hw_params.bcast_sta_id &&
-		priv->iw_mode != NL80211_IFTYPE_AP) {
+	 * In legacy wep mode, we use another host command to the uCode.
+	 */
+	if (key->alg == ALG_WEP && !sta && vif->type != NL80211_IFTYPE_AP) {
 		if (cmd == SET_KEY)
 			is_default_wep_key = !priv->key_mapping_key;
 		else
-- 
1.6.3.3

