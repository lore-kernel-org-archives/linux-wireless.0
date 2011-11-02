Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63234 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1KBVrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 17:47:53 -0400
Date: Wed, 2 Nov 2011 23:46:47 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Do not hide ath6kl_wmi_addkey_cmd() error values
Message-ID: <20111102214647.GA31265@jouni.qca.qualcomm.com> (sfid-20111102_224756_498719_981083D9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of converting any error to EIO, just return the real error
value to upper layers.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   37 ++++++++++------------------
 1 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 3b9511a..04d24d4 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -908,7 +908,6 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	struct ath6kl_key *key = NULL;
 	u8 key_usage;
 	u8 key_type;
-	int status = 0;
 
 	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
@@ -1011,17 +1010,12 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		return 0;
 	}
 
-	status = ath6kl_wmi_addkey_cmd(ar->wmi, vif->fw_vif_idx,
-				       vif->def_txkey_index,
-				       key_type, key_usage, key->key_len,
-				       key->seq, key->seq_len, key->key,
-				       KEY_OP_INIT_VAL,
-				       (u8 *) mac_addr, SYNC_BOTH_WMIFLAG);
-
-	if (status)
-		return -EIO;
-
-	return 0;
+	return ath6kl_wmi_addkey_cmd(ar->wmi, vif->fw_vif_idx,
+				     vif->def_txkey_index,
+				     key_type, key_usage, key->key_len,
+				     key->seq, key->seq_len, key->key,
+				     KEY_OP_INIT_VAL,
+				     (u8 *) mac_addr, SYNC_BOTH_WMIFLAG);
 }
 
 static int ath6kl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
@@ -1097,7 +1091,6 @@ static int ath6kl_cfg80211_set_default_key(struct wiphy *wiphy,
 	struct ath6kl *ar = (struct ath6kl *)ath6kl_priv(ndev);
 	struct ath6kl_vif *vif = netdev_priv(ndev);
 	struct ath6kl_key *key = NULL;
-	int status = 0;
 	u8 key_usage;
 	enum crypto_type key_type = NONE_CRYPT;
 
@@ -1132,17 +1125,13 @@ static int ath6kl_cfg80211_set_default_key(struct wiphy *wiphy,
 	if (vif->next_mode == AP_NETWORK && !test_bit(CONNECTED, &vif->flags))
 		return 0; /* Delay until AP mode has been started */
 
-	status = ath6kl_wmi_addkey_cmd(ar->wmi, vif->fw_vif_idx,
-				       vif->def_txkey_index,
-				       key_type, key_usage,
-				       key->key_len, key->seq, key->seq_len,
-				       key->key,
-				       KEY_OP_INIT_VAL, NULL,
-				       SYNC_BOTH_WMIFLAG);
-	if (status)
-		return -EIO;
-
-	return 0;
+	return ath6kl_wmi_addkey_cmd(ar->wmi, vif->fw_vif_idx,
+				     vif->def_txkey_index,
+				     key_type, key_usage,
+				     key->key_len, key->seq, key->seq_len,
+				     key->key,
+				     KEY_OP_INIT_VAL, NULL,
+				     SYNC_BOTH_WMIFLAG);
 }
 
 void ath6kl_cfg80211_tkip_micerr_event(struct ath6kl_vif *vif, u8 keyid,
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
