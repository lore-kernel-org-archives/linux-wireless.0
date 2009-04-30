Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17738 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320AbZD3UuR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 16:50:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/1 v2.6.30] iwlwifi: update key flags at time key is set
Date: Thu, 30 Apr 2009 13:56:31 -0700
Message-Id: <1241124991-12492-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1241124991-12492-6-git-send-email-reinette.chatre@intel.com>
References: <1241124991-12492-1-git-send-email-reinette.chatre@intel.com>
 <1241124991-12492-2-git-send-email-reinette.chatre@intel.com>
 <1241124991-12492-3-git-send-email-reinette.chatre@intel.com>
 <1241124991-12492-4-git-send-email-reinette.chatre@intel.com>
 <1241124991-12492-5-git-send-email-reinette.chatre@intel.com>
 <1241124991-12492-6-git-send-email-reinette.chatre@intel.com>
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
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 5798fe4..44ab03a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -719,6 +719,14 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
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
@@ -738,6 +746,9 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
 		"no space for a new key");
 
+	priv->stations[sta_id].sta.key.key_flags = key_flags;
+
+
 	/* This copy is acutally not needed: we get the key with each TX */
 	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
 
@@ -754,9 +765,7 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 {
 	u8 sta_id = IWL_INVALID_STATION;
 	unsigned long flags;
-	__le16 key_flags = 0;
 	int i;
-	DECLARE_MAC_BUF(mac);
 
 	sta_id = iwl_find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
@@ -771,16 +780,8 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
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

