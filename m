Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51993 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab0HRQdq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:33:46 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/2] iwlagn: do not check for AP mode for WEP keys
Date: Wed, 18 Aug 2010 09:35:21 -0700
Message-Id: <1282149322-17928-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282149322-17928-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282149322-17928-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Even when we configure WEP keys in AP mode
ones without a station pointer are default
keys, so don't check for AP mode here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 10d7b9b..2d309d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3386,7 +3386,7 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	 * in 1X mode.
 	 * In legacy wep mode, we use another host command to the uCode.
 	 */
-	if (key->alg == ALG_WEP && !sta && vif->type != NL80211_IFTYPE_AP) {
+	if (key->alg == ALG_WEP && !sta) {
 		if (cmd == SET_KEY)
 			is_default_wep_key = !priv->key_mapping_key;
 		else
-- 
1.7.0.4

