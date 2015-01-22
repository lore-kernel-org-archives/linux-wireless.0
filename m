Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbbAVUe3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:29 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/38] iwlwifi: mvm: rs: use STBC regardless of power save mode
Date: Thu, 22 Jan 2015 22:33:18 +0200
Message-Id: <1421958809-3371-27-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214445_944372_E13E150D)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Tx STBC was used only when in CAM mode or if powersave is disabled.
Effectively this meant we never used STBC as these modes aren't
used on most platforms by default. Change that.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index dd2f966..997a383 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1802,20 +1802,12 @@ out:
 static bool rs_stbc_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			  struct iwl_lq_sta *lq_sta)
 {
-	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
-	struct ieee80211_vif *vif = mvmsta->vif;
-	bool sta_ps_disabled = (vif->type == NL80211_IFTYPE_STATION &&
-				!vif->bss_conf.ps);
-
 	/* Our chip supports Tx STBC and the peer is an HT/VHT STA which
 	 * supports STBC of at least 1*SS
 	 */
 	if (!lq_sta->stbc)
 		return false;
 
-	if (!mvm->ps_disabled && !sta_ps_disabled)
-		return false;
-
 	if (!iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta))
 		return false;
 
-- 
1.9.1

