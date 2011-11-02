Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3976 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1KBVqC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 17:46:02 -0400
Date: Wed, 2 Nov 2011 23:45:55 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath6kl: Fix key configuration to copy at most seq_len
 from seq
Message-ID: <20111102214555.GA31245@jouni.qca.qualcomm.com> (sfid-20111102_224607_308032_0E5CE647)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no guarantee on the caller using 8-octet buffer for
key->seq, so better follow the key->seq_len parameter on figuring
out how many octets to copy.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 +++++---
 drivers/net/wireless/ath/ath6kl/main.c     |    5 +++--
 drivers/net/wireless/ath/ath6kl/wmi.c      |    7 ++++---
 drivers/net/wireless/ath/ath6kl/wmi.h      |    3 ++-
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 6aff8be..3b9511a 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -500,7 +500,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 				      vif->prwise_crypto,
 				      GROUP_USAGE | TX_USAGE,
 				      key->key_len,
-				      NULL,
+				      NULL, 0,
 				      key->key, KEY_OP_INIT_VAL, NULL,
 				      NO_SYNC_WMIFLAG);
 	}
@@ -1014,7 +1014,8 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	status = ath6kl_wmi_addkey_cmd(ar->wmi, vif->fw_vif_idx,
 				       vif->def_txkey_index,
 				       key_type, key_usage, key->key_len,
-				       key->seq, key->key, KEY_OP_INIT_VAL,
+				       key->seq, key->seq_len, key->key,
+				       KEY_OP_INIT_VAL,
 				       (u8 *) mac_addr, SYNC_BOTH_WMIFLAG);
 
 	if (status)
@@ -1134,7 +1135,8 @@ static int ath6kl_cfg80211_set_default_key(struct wiphy *wiphy,
 	status = ath6kl_wmi_addkey_cmd(ar->wmi, vif->fw_vif_idx,
 				       vif->def_txkey_index,
 				       key_type, key_usage,
-				       key->key_len, key->seq, key->key,
+				       key->key_len, key->seq, key->seq_len,
+				       key->key,
 				       KEY_OP_INIT_VAL, NULL,
 				       SYNC_BOTH_WMIFLAG);
 	if (status)
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index f9410e4..a800837 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -442,7 +442,7 @@ static void ath6kl_install_static_wep_keys(struct ath6kl_vif *vif)
 					      WEP_CRYPT,
 					      keyusage,
 					      vif->wep_key_list[index].key_len,
-					      NULL,
+					      NULL, 0,
 					      vif->wep_key_list[index].key,
 					      KEY_OP_INIT_VAL, NULL,
 					      NO_SYNC_WMIFLAG);
@@ -477,7 +477,8 @@ void ath6kl_connect_ap_mode_bss(struct ath6kl_vif *vif, u16 channel)
 		memset(key_rsc, 0, sizeof(key_rsc));
 		res = ath6kl_wmi_addkey_cmd(
 			ar->wmi, vif->fw_vif_idx, ik->key_index, ik->key_type,
-			GROUP_USAGE, ik->key_len, key_rsc, ik->key,
+			GROUP_USAGE, ik->key_len, key_rsc, ATH6KL_KEY_SEQ_LEN,
+			ik->key,
 			KEY_OP_INIT_VAL, NULL, SYNC_BOTH_WMIFLAG);
 		if (res) {
 			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "Delayed "
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index ece67a5..612326d 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2000,7 +2000,8 @@ int ath6kl_wmi_disctimeout_cmd(struct wmi *wmi, u8 if_idx, u8 timeout)
 int ath6kl_wmi_addkey_cmd(struct wmi *wmi, u8 if_idx, u8 key_index,
 			  enum crypto_type key_type,
 			  u8 key_usage, u8 key_len,
-			  u8 *key_rsc, u8 *key_material,
+			  u8 *key_rsc, unsigned int key_rsc_len,
+			  u8 *key_material,
 			  u8 key_op_ctrl, u8 *mac_addr,
 			  enum wmi_sync_flag sync_flag)
 {
@@ -2013,7 +2014,7 @@ int ath6kl_wmi_addkey_cmd(struct wmi *wmi, u8 if_idx, u8 key_index,
 		   key_index, key_type, key_usage, key_len, key_op_ctrl);
 
 	if ((key_index > WMI_MAX_KEY_INDEX) || (key_len > WMI_MAX_KEY_LEN) ||
-	    (key_material == NULL))
+	    (key_material == NULL) || key_rsc_len > 8)
 		return -EINVAL;
 
 	if ((WEP_CRYPT != key_type) && (NULL == key_rsc))
@@ -2031,7 +2032,7 @@ int ath6kl_wmi_addkey_cmd(struct wmi *wmi, u8 if_idx, u8 key_index,
 	memcpy(cmd->key, key_material, key_len);
 
 	if (key_rsc != NULL)
-		memcpy(cmd->key_rsc, key_rsc, sizeof(cmd->key_rsc));
+		memcpy(cmd->key_rsc, key_rsc, key_rsc_len);
 
 	cmd->key_op_ctrl = key_op_ctrl;
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index c626c1e..1d458f0 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2253,7 +2253,8 @@ int ath6kl_wmi_get_stats_cmd(struct wmi *wmi, u8 if_idx);
 int ath6kl_wmi_addkey_cmd(struct wmi *wmi, u8 if_idx, u8 key_index,
 			  enum crypto_type key_type,
 			  u8 key_usage, u8 key_len,
-			  u8 *key_rsc, u8 *key_material,
+			  u8 *key_rsc, unsigned int key_rsc_len,
+			  u8 *key_material,
 			  u8 key_op_ctrl, u8 *mac_addr,
 			  enum wmi_sync_flag sync_flag);
 int ath6kl_wmi_add_krk_cmd(struct wmi *wmi, u8 if_idx, u8 *krk);
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
