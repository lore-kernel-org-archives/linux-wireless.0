Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6480 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746Ab0DIUJh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 16:09:37 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/12] iwlwifi: remove wrong key use check
Date: Fri,  9 Apr 2010 13:09:20 -0700
Message-Id: <1270843769-30017-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
References: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Default WEP keys and regular keys are not allocated
from the same space in the firmware, so we shouldn't
use the same bits to indicate in use.

For default WEP keys, however, mac80211 won't allow
using the same key index twice, so the check is not
necessary at all -- add/remove are perfectly nested
due to those checks.

Other keys are allocated in the device in a global
array that only has a certain number of slots, so
for that we need to keep the allocation bitmap; but
the 802.11 key index isn't relevant there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index be3d222..a43493f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -822,10 +822,6 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 	IWL_DEBUG_WEP(priv, "Removing default WEP key: idx=%d\n",
 		      keyconf->keyidx);
 
-	if (!test_and_clear_bit(keyconf->keyidx, &priv->ucode_key_table))
-		IWL_ERR(priv, "index %d not used in uCode key table.\n",
-			  keyconf->keyidx);
-
 	memset(&priv->wep_keys[keyconf->keyidx], 0, sizeof(priv->wep_keys[0]));
 	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_WEP(priv, "Not sending REPLY_WEPKEY command due to RFKILL.\n");
@@ -857,10 +853,6 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 	keyconf->hw_key_idx = HW_KEY_DEFAULT;
 	priv->stations[IWL_AP_ID].keyinfo.alg = ALG_WEP;
 
-	if (test_and_set_bit(keyconf->keyidx, &priv->ucode_key_table))
-		IWL_ERR(priv, "index %d already used in uCode key table.\n",
-			  keyconf->keyidx);
-
 	priv->wep_keys[keyconf->keyidx].key_size = keyconf->keylen;
 	memcpy(&priv->wep_keys[keyconf->keyidx].key, &keyconf->key,
 							keyconf->keylen);
-- 
1.6.3.3

