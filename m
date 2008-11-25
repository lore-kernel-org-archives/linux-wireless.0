Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:35899 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbYKYLJm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 06:09:42 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	reinette.chatre@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] iwlwifi: clean key table in iwl_clear_stations_table function
Date: Tue, 25 Nov 2008 13:09:39 +0200
Message-Id: <1227611379-20650-1-git-send-email-tomas.winkler@intel.com> (sfid-20081125_120945_898597_097FAABB)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch cleans uCode key table bit map iwl_clear_stations_table
since all stations are cleared also the key table must be.

Since the keys are not removed properly on suspend by mac80211
this may result in exhausting key table on resume leading
to memory corruption during removal

This patch also fixes a memory corruption problem reported in
http://marc.info/?l=linux-wireless&m=122641417231586&w=2 and tracked in
http://bugzilla.kernel.org/show_bug.cgi?id=12040.

When the key is removed a second time the offset is set to 255 - this
index is not valid for the ucode_key_table and corrupts the eeprom pointer
(which is 255 bits from ucode_key_table).

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Reported-by: Carlos R. Mafra <crmafra2@gmail.com>
Reported-by: Lukas Hejtmanek <xhejtman@ics.muni.cz>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 0222ef8..2553d4d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -488,6 +488,8 @@ void iwl_clear_stations_table(struct iwl_priv *priv)
 
 	priv->num_stations = 0;
 	memset(priv->stations, 0, sizeof(priv->stations));
+	/* clean ucode key table bit map */
+	priv->ucode_key_table = 0;
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
@@ -501,7 +503,7 @@ static int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 		if (!test_and_set_bit(i, &priv->ucode_key_table))
 			return i;
 
-	return -1;
+	return WEP_INVALID_OFFSET;
 }
 
 int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
@@ -645,6 +647,8 @@ static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
 				 iwl_get_free_ucode_key_index(priv);
 	/* else, we are overriding an existing key => no need to allocated room
 	 * in uCode. */
+	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
+		"no space for new kew");
 
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
@@ -663,6 +667,7 @@ static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 {
 	unsigned long flags;
 	__le16 key_flags = 0;
+	int ret;
 
 	key_flags |= (STA_KEY_FLG_CCMP | STA_KEY_FLG_MAP_KEY_MSK);
 	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
@@ -690,14 +695,18 @@ static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 	/* else, we are overriding an existing key => no need to allocated room
 	 * in uCode. */
 
+	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
+		"no space for new kew");
+
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
+	ret = iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	IWL_DEBUG_INFO("hwcrypto: modify ucode station key info\n");
-	return iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+	return ret;
 }
 
 static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
@@ -722,6 +731,9 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 	/* else, we are overriding an existing key => no need to allocated room
 	 * in uCode. */
 
+	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
+		"no space for new kew");
+
 	/* This copy is actually not needed: we get the key with each TX */
 	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
 
@@ -736,10 +748,10 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 			struct ieee80211_key_conf *keyconf,
 			const u8 *addr, u32 iv32, u16 *phase1key)
 {
-	u8 sta_id = IWL_INVALID_STATION;
 	unsigned long flags;
-	__le16 key_flags = 0;
 	int i;
+	__le16 key_flags = 0;
+	u8 sta_id;
 	DECLARE_MAC_BUF(mac);
 
 	sta_id = iwl_find_station(priv, addr);
@@ -765,7 +777,7 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
-	priv->stations[sta_id].sta.key.tkip_rx_tsc_byte2 = (u8) iv32;
+	priv->stations[sta_id].sta.key.tkip_rx_tsc_byte2 = (u8)iv32;
 
 	for (i = 0; i < 5; i++)
 		priv->stations[sta_id].sta.key.tkip_rx_ttak[i] =
@@ -809,6 +821,13 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 		return 0;
 	}
 
+	if (priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET) {
+		IWL_WARNING("Removing wrong key %d 0x%x\n",
+			    keyconf->keyidx, key_flags);
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
+		return 0;
+	}
+
 	if (!test_and_clear_bit(priv->stations[sta_id].sta.key.key_offset,
 		&priv->ucode_key_table))
 		IWL_ERROR("index %d not used in uCode key table.\n",
-- 
1.5.4.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

