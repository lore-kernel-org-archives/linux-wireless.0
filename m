Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:42498 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab1CQAGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 20:06:16 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 08/11] mwifiex: remove some redundant WEP key handling
Date: Wed, 16 Mar 2011 17:09:31 -0700
Message-Id: <1300320574-10793-9-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
References: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

1) mwifiex_sec_ioctl_get_key() is unused
2) is_current_wep_key flag is unused after 1) is removed

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/ioctl.h     |    1 -
 drivers/net/wireless/mwifiex/sta_ioctl.c |  103 ++++--------------------------
 2 files changed, 13 insertions(+), 91 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index f4227dd..158664b 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -296,7 +296,6 @@ enum {
 struct mwifiex_ds_encrypt_key {
 	u32 key_disable;
 	u32 key_index;
-	u32 is_current_wep_key;
 	u32 key_len;
 	u8 key_material[MWIFIEX_MAX_KEY_LENGTH];
 	u8 mac_addr[ETH_ALEN];
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 3ca5705..bda00dd 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1744,10 +1744,7 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 	if (priv->wep_key_curr_index >= NUM_WEP_KEYS)
 		priv->wep_key_curr_index = 0;
 	wep_key = &priv->wep_key[priv->wep_key_curr_index];
-	if (encrypt_key->is_current_wep_key)
-		index = priv->wep_key_curr_index;
-	else
-		index = encrypt_key->key_index;
+	index = encrypt_key->key_index;
 	if (encrypt_key->key_disable) {
 		priv->sec_info.wep_status = MWIFIEX_802_11_WEP_DISABLED;
 	} else if (!encrypt_key->key_len) {
@@ -1878,73 +1875,6 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 }
 
 /*
- * IOCTL request handler to get network key.
- *
- * This function works with both WEP and WPA keys.
- */
-static int mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
-			  struct mwifiex_wait_queue *wait,
-			  struct mwifiex_ds_encrypt_key *encrypt_key)
-{
-	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
-	int index;
-
-	if (priv->wep_key_curr_index >= NUM_WEP_KEYS)
-		priv->wep_key_curr_index = 0;
-
-	if ((priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED)
-	    || (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_KEY_ABSENT)
-	    || priv->sec_info.wpa_enabled || priv->sec_info.wpa2_enabled)
-		encrypt_key->key_disable = false;
-	else
-		encrypt_key->key_disable = true;
-
-	if (encrypt_key->is_current_wep_key) {
-		if ((priv->wep_key[priv->wep_key_curr_index].key_length) &&
-		    (priv->sec_info.wep_status ==
-		     MWIFIEX_802_11_WEP_ENABLED)) {
-			index = priv->wep_key_curr_index;
-			encrypt_key->key_index =
-				priv->wep_key[index].key_index;
-			memcpy(encrypt_key->key_material,
-			       priv->wep_key[index].key_material,
-			       priv->wep_key[index].key_length);
-			encrypt_key->key_len =
-				priv->wep_key[index].key_length;
-		} else if (priv->sec_info.wpa_enabled
-			   || priv->sec_info.wpa2_enabled) {
-			/* Return WPA enabled */
-			encrypt_key->key_disable = false;
-			memcpy(encrypt_key->key_material,
-			       priv->aes_key.key_param_set.key,
-			       le16_to_cpu(
-			       priv->aes_key.key_param_set.key_len));
-			encrypt_key->key_len = le16_to_cpu(
-				priv->aes_key.key_param_set.key_len);
-		} else {
-			encrypt_key->key_disable = true;
-		}
-	} else {
-		index = encrypt_key->key_index;
-		if (priv->wep_key[index].key_length) {
-			encrypt_key->key_index = priv->wep_key[index].key_index;
-			memcpy(encrypt_key->key_material,
-			       priv->wep_key[index].key_material,
-			       priv->wep_key[index].key_length);
-			encrypt_key->key_len = priv->wep_key[index].key_length;
-		} else if (priv->sec_info.wpa_enabled
-			   || priv->sec_info.wpa2_enabled) {
-			/* Return WPA enabled */
-			encrypt_key->key_disable = false;
-		} else {
-			encrypt_key->key_disable = true;
-		}
-	}
-
-	return 0;
-}
-
-/*
  * IOCTL request handler to set/get network keys.
  *
  * This is a generic key handling function which supports WEP, WPA
@@ -1953,25 +1883,20 @@ static int mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
 static int
 mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *priv,
 			      struct mwifiex_wait_queue *wait,
-			      struct mwifiex_ds_encrypt_key *encrypt_key,
-			      u16 action)
+			      struct mwifiex_ds_encrypt_key *encrypt_key)
 {
 	int status = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
-	if (action == HostCmd_ACT_GEN_SET) {
-		if (encrypt_key->is_wapi_key)
-			status = mwifiex_sec_ioctl_set_wapi_key(adapter,
-							wait, encrypt_key);
-		else if (encrypt_key->key_len > WLAN_KEY_LEN_WEP104)
-			status = mwifiex_sec_ioctl_set_wpa_key(adapter,
-							wait, encrypt_key);
-		else
-			status = mwifiex_sec_ioctl_set_wep_key(adapter,
-							wait, encrypt_key);
-	} else {
-		status = mwifiex_sec_ioctl_get_key(adapter, wait, encrypt_key);
-	}
+	if (encrypt_key->is_wapi_key)
+		status = mwifiex_sec_ioctl_set_wapi_key(adapter, wait,
+							encrypt_key);
+	else if (encrypt_key->key_len > WLAN_KEY_LEN_WEP104)
+		status = mwifiex_sec_ioctl_set_wpa_key(adapter, wait,
+						       encrypt_key);
+	else
+		status = mwifiex_sec_ioctl_set_wep_key(adapter, wait,
+						       encrypt_key);
 	return status;
 }
 
@@ -2375,8 +2300,7 @@ mwifiex_set_encode(struct mwifiex_private *priv, u32 cipher, const u8 *key,
 		if (cipher == WLAN_CIPHER_SUITE_WEP40
 		    || cipher == WLAN_CIPHER_SUITE_WEP104) {
 			status = mwifiex_sec_ioctl_encrypt_key(priv, wait,
-							&encrypt_key,
-							HostCmd_ACT_GEN_SET);
+							       &encrypt_key);
 			if (mwifiex_request_ioctl(priv, wait, status,
 						  MWIFIEX_IOCTL_WAIT)) {
 				ret = -EFAULT;
@@ -2388,8 +2312,7 @@ mwifiex_set_encode(struct mwifiex_private *priv, u32 cipher, const u8 *key,
 		encrypt_key.key_disable = true;
 	}
 
-	status = mwifiex_sec_ioctl_encrypt_key(priv, wait, &encrypt_key,
-						       HostCmd_ACT_GEN_SET);
+	status = mwifiex_sec_ioctl_encrypt_key(priv, wait, &encrypt_key);
 
 	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT))
 		ret = -EFAULT;
-- 
1.7.0.2

