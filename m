Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44287 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab2BQS5G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 13:57:06 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	stable@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3.3] iwlwifi: fix key removal
Date: Fri, 17 Feb 2012 09:47:14 -0800
Message-Id: <1329500834-5433-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_195713_638459_6043AC54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When trying to remove a key, we always send key
flags just setting the key type, not including
the multicast flag and the key ID. As a result,
whenever any key was removed, the unicast key 0
would be removed, causing a complete connection
loss after the second rekey (the first doesn't
cause a key removal). Fix the key removal code
to include the key ID and multicast flag, thus
removing the correct key.

Cc: stable@vger.kernel.org
Reported-by: Alexander Schnaidt <alex.schnaidt@googlemail.com>
Tested-by: Alexander Schnaidt <alex.schnaidt@googlemail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch will be also available from wireless branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 7353826..e483cfa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -1187,6 +1187,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	unsigned long flags;
 	struct iwl_addsta_cmd sta_cmd;
 	u8 sta_id = iwlagn_key_sta_id(priv, ctx->vif, sta);
+	__le16 key_flags;
 
 	/* if station isn't there, neither is the key */
 	if (sta_id == IWL_INVALID_STATION)
@@ -1212,7 +1213,14 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 		IWL_ERR(priv, "offset %d not used in uCode key table.\n",
 			keyconf->hw_key_idx);
 
-	sta_cmd.key.key_flags = STA_KEY_FLG_NO_ENC | STA_KEY_FLG_INVALID;
+	key_flags = cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
+	key_flags |= STA_KEY_FLG_MAP_KEY_MSK | STA_KEY_FLG_NO_ENC |
+		     STA_KEY_FLG_INVALID;
+
+	if (!(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		key_flags |= STA_KEY_MULTICAST_MSK;
+
+	sta_cmd.key.key_flags = key_flags;
 	sta_cmd.key.key_offset = WEP_INVALID_OFFSET;
 	sta_cmd.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	sta_cmd.mode = STA_CONTROL_MODIFY_MSK;
-- 
1.7.0.4

