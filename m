Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42261 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbZESUcY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 16:32:24 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2.6.29 stable] iwlwifi: update key flags at time key is set
Date: Tue, 19 May 2009 13:39:04 -0700
Message-Id: <1242765544-30131-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

We need to be symmetrical in what is done when key is set and cleared.
This is important wrt the key flags as they are used during key
clearing and if they are not set when the key is set the key cannot be
cleared completely.

This addresses the many occurences of the WARN found in
iwl_set_tkip_dynamic_key_info() and tracked in
http://www.kerneloops.org/searchweek.php?search=iwl_set_dynamic_key

If calling iwl_set_tkip_dynamic_key_info()/iwl_remove_dynamic_key()
pair a few times in a row will cause that we run out of key space.
This is because the index stored in the key flags is used by
iwl_remove_dynamic_key() to decide if it should remove the key.
Unfortunately the key flags, and hence the key index is currently only
set at the time the key is written to the device (in
iwl_update_tkip_key()) and _not_ in iwl_set_tkip_dynamic_key_info().
Fix this by setting flags in iwl_set_tkip_dynamic_key_info().

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
This is a rebase to 2.6.29 stable of commit
299f5462087f3bc2141e6bc83ba7e2b15d8a07d2 from linux-2.6.

 drivers/net/wireless/iwlwifi/iwl-sta.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 70a8b21..ab621b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -708,6 +708,14 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 {
 	unsigned long flags;
 	int ret = 0;
+	__le16 key_flags = 0;
+
+	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
+	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
+	key_flags &= ~STA_KEY_FLG_INVALID;
+
+	if (sta_id == priv->hw_params.bcast_sta_id)
+		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
@@ -727,6 +735,9 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
 		"no space for new kew");
 
+	priv->stations[sta_id].sta.key.key_flags = key_flags;
+
+
 	/* This copy is acutally not needed: we get the key with each TX */
 	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
 
@@ -743,9 +754,7 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 {
 	u8 sta_id = IWL_INVALID_STATION;
 	unsigned long flags;
-	__le16 key_flags = 0;
 	int i;
-	DECLARE_MAC_BUF(mac);
 
 	sta_id = iwl_find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
@@ -760,16 +769,8 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 		return;
 	}
 
-	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
-	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
-	key_flags &= ~STA_KEY_FLG_INVALID;
-
-	if (sta_id == priv->hw_params.bcast_sta_id)
-		key_flags |= STA_KEY_MULTICAST_MSK;
-
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
-	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.key.tkip_rx_tsc_byte2 = (u8) iv32;
 
 	for (i = 0; i < 5; i++)
-- 
1.5.6.3

