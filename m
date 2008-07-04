Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:7643 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbYGDRon (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 13:44:43 -0400
Received: by yw-out-2324.google.com with SMTP id 9so567449ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2008 10:44:42 -0700 (PDT)
From: Milan Plzik <milan.plzik@gmail.com>
Subject: [PATCH 6/7] Adds support for WEP operation with 1.103.x firmware.
To: linux-wireless@vger.kernel.org
Date: Fri, 04 Jul 2008 19:44:37 +0200
Message-ID: <20080704174436.4996.36495.stgit@localhost> (sfid-20080704_194446_305491_78CEFCDB)
In-Reply-To: <20080704174350.4996.72931.stgit@localhost>
References: <20080704174350.4996.72931.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Signed-off-by: Milan Plzik <milan.plzik@gmail.com>
---

 drivers/net/wireless/at76_usb.c |  214 ++++++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/at76_usb.h |   47 ++++++++-
 2 files changed, 256 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 612c714..5b6fa5c 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1069,6 +1069,45 @@ exit:
 	kfree(m);
 }
 
+static void at76_dump_mib_mac_encryption(struct at76_priv *priv)
+{
+	int i;
+	int ret;
+	/*int key_len;*/
+	struct mib_mac_encryption *m = kmalloc(sizeof(struct mib_mac_encryption), GFP_KERNEL);
+
+	if (!m)
+		return;
+
+	ret = at76_get_mib(priv->udev, MIB_MAC_ENCRYPTION, m,
+			   sizeof(struct mib_mac_encryption));
+	if (ret < 0) {
+		printk(KERN_ERR "%s: at76_get_mib (MAC_ENCRYPTION) failed: %d\n",
+		       wiphy_name(priv->hw->wiphy), ret);
+		goto exit;
+	}
+
+	at76_dbg(DBG_MIB, "%s: MIB MAC_ENCRYPTION: tkip_bssid %s priv_invoked %u " 
+		 "ciph_key_id %u grp_key_id %u excl_unencr %u "
+		 "ckip_key_perm %u wep_icv_err %u wep_excluded %u", 
+		 wiphy_name(priv->hw->wiphy), mac2str(m->tkip_bssid),
+		 m->privacy_invoked, m->cipher_default_key_id,
+		 m->cipher_default_group_key_id, m->exclude_unencrypted,
+		 m->ckip_key_permutation,
+		 le32_to_cpu(m->wep_icv_error_count),
+		 le32_to_cpu(m->wep_excluded_count));
+
+	/*key_len = (m->encryption_level == 1) ?
+	    WEP_SMALL_KEY_LEN : WEP_LARGE_KEY_LEN;*/
+
+	for (i = 0; i < CIPHER_KEYS; i++)
+		at76_dbg(DBG_MIB, "%s: MIB MAC_ENCRYPTION: key %d: %s",
+			 wiphy_name(priv->hw->wiphy), i,
+			 hex2str(m->cipher_default_keyvalue[i], CIPHER_KEY_LEN));
+exit:
+	kfree(m);
+}
+
 static void at76_dump_mib_mac_mgmt(struct at76_priv *priv)
 {
 	int ret;
@@ -1601,7 +1640,6 @@ static void at76_rx_tasklet(unsigned long param)
 		 wiphy_name(priv->hw->wiphy), buf->rx_rate, buf->rssi,
 		 buf->noise_level, buf->link_quality);
 
-
 	skb_trim(priv->rx_skb, le16_to_cpu(buf->wlength) + AT76_RX_HDRLEN);
 	at76_dbg_dump(DBG_RX_DATA, &priv->rx_skb->data[AT76_RX_HDRLEN],
 		      priv->rx_skb->len, "RX: len=%d", (int)(priv->rx_skb->len - AT76_RX_HDRLEN));
@@ -1760,7 +1798,18 @@ static int at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	tx_buffer->padding = padding;
 	tx_buffer->wlength = cpu_to_le16(skb->len);
 	tx_buffer->tx_rate = ieee80211_get_tx_rate(hw, info)->hw_value;
-	memset(tx_buffer->reserved, 0, sizeof(tx_buffer->reserved));
+	if (FIRMWARE_IS_WPA(priv->fw_version) && !(control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT)) {
+		tx_buffer->key_id = (control->key_idx);
+		tx_buffer->cipher_type = priv->keys[control->key_idx].cipher;
+		tx_buffer->cipher_length = priv->keys[control->key_idx].keylen;
+		tx_buffer->reserved = 0;
+	} else {
+		tx_buffer->key_id = 0;
+		tx_buffer->cipher_type = 0;
+		tx_buffer->cipher_length = 0;
+		tx_buffer->reserved = 0;
+	};
+	/* memset(tx_buffer->reserved, 0, sizeof(tx_buffer->reserved)); */
 	memcpy(tx_buffer->packet, skb->data, skb->len);
 
 	at76_dbg(DBG_TX_DATA, "%s tx: wlen 0x%x pad 0x%x rate %d hdr",
@@ -1823,7 +1872,8 @@ static void at76_mac80211_stop(struct ieee80211_hw *hw)
 	if (!priv->device_unplugged) {
 		/* We are called by "ifconfig ethX down", not because the
 		 * device is not available anymore. */
-		at76_set_radio(priv, 0);
+		if (at76_set_radio(priv, 0) == 1)
+			at76_wait_completion(priv, CMD_RADIO_ON);
 
 		/* We unlink rx_urb because at76_open() re-submits it.
 		 * If unplugged, at76_delete_device() takes care of it. */
@@ -2061,7 +2111,7 @@ static void at76_configure_filter(struct ieee80211_hw *hw,
 	queue_work(hw->workqueue, &priv->work_set_promisc);
 }
 
-static int at76_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+static int at76_set_key_oldfw(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			const u8 *local_address, const u8 *address,
 			struct ieee80211_key_conf *key)
 {
@@ -2109,6 +2159,151 @@ static int at76_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return 0;
 }
 
+static int at76_set_key_newfw(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+			const u8 *local_address, const u8 *address,
+			struct ieee80211_key_conf *key) 
+{
+	struct at76_priv *priv = hw->priv;
+	int ret = -EOPNOTSUPP;
+
+	at76_dbg(DBG_MAC80211, "%s(): cmd %d key->alg %d key->keyidx %d "
+		 "key->keylen %d",
+		 __func__, cmd, key->alg, key->keyidx, key->keylen);
+
+	mutex_lock(&priv->mtx);
+
+	priv->mib_buf.type = MIB_MAC_ENCRYPTION;
+
+	if (cmd == DISABLE_KEY) {
+		priv->mib_buf.size = CIPHER_KEY_LEN;
+		priv->mib_buf.index = offsetof(struct mib_mac_encryption, 
+				cipher_default_keyvalue[key->keyidx]);
+		memset(priv->mib_buf.data.data, 0, CIPHER_KEY_LEN);
+		if (at76_set_mib(priv, &priv->mib_buf) != CMD_STATUS_COMPLETE)
+			ret = -EOPNOTSUPP; /* -EIO would be probably better */
+		else {
+			ret = 0;
+			priv->keys[key->keyidx].cipher = CIPHER_NONE;
+			priv->keys[key->keyidx].keylen = 0;
+		};
+		if (priv->default_group_key == key->keyidx)
+			priv->default_group_key = 0xff;
+
+		if (priv->default_pairwise_key == key->keyidx)
+			priv->default_pairwise_key = 0xff;
+		/* If default pairwise key is removed, fall back to 
+		 * group key? */
+		goto exit;
+	};
+	
+	if (cmd == SET_KEY) {
+		/* store key into MIB */
+		priv->mib_buf.size = CIPHER_KEY_LEN;
+		priv->mib_buf.index = offsetof(struct mib_mac_encryption, 
+				cipher_default_keyvalue[key->keyidx]);
+		memset(priv->mib_buf.data.data, 0, CIPHER_KEY_LEN);
+		memcpy(priv->mib_buf.data.data, key->key, key->keylen);
+		
+		switch (key->alg) {
+			case ALG_WEP:
+				if (key->keylen == 5) {
+					priv->keys[key->keyidx].cipher = 
+						CIPHER_WEP64;
+					priv->keys[key->keyidx].keylen = 8;
+				} else if (key->keylen == 13) {
+					priv->keys[key->keyidx].cipher = 
+						CIPHER_WEP128;
+					/* Firmware needs this */
+					priv->keys[key->keyidx].keylen = 8;
+				} else {
+					ret = -EOPNOTSUPP;
+					goto exit;
+				};
+				break;
+			default:
+				ret = -EOPNOTSUPP;
+				goto exit;
+
+		};
+
+		priv->mib_buf.data.data[38] = priv->keys[key->keyidx].cipher;
+		priv->mib_buf.data.data[39] = 1; /* Taken from atmelwlandriver, 
+						    not documented */
+		
+		if (is_valid_ether_addr(address))
+			/* Pairwise key */
+			priv->mib_buf.data.data[39] |= (KEY_PAIRWISE | KEY_TX);
+		else if (is_broadcast_ether_addr(address)) 
+			/* Group key */
+			priv->mib_buf.data.data[39] |= (KEY_TX);
+		else	/* Key used only for transmission ??? */
+			priv->mib_buf.data.data[39] |= (KEY_TX);
+
+		if (at76_set_mib(priv, &priv->mib_buf) != 
+				CMD_STATUS_COMPLETE) {
+			ret = -EOPNOTSUPP; /* -EIO would be probably better */
+			goto exit;
+		};
+		key->hw_key_idx = key->keyidx;
+
+		/* Set up default keys */
+		if (is_broadcast_ether_addr(address))
+			priv->default_group_key = key->keyidx;
+		if (is_valid_ether_addr(address))
+			priv->default_pairwise_key = key->keyidx;
+
+		/* Set up encryption MIBs */
+
+		/* first block of settings */
+		priv->mib_buf.size = 3;
+		priv->mib_buf.index = offsetof(struct mib_mac_encryption, 
+				privacy_invoked); 
+		priv->mib_buf.data.data[0] = 1;	/* privacy_invoked */
+		priv->mib_buf.data.data[1] = priv->default_pairwise_key;
+		priv->mib_buf.data.data[2] = priv->default_group_key;
+
+		if ((ret = at76_set_mib(priv, &priv->mib_buf)) != 
+				CMD_STATUS_COMPLETE)
+			goto exit;
+
+		/* second block of settings */
+		priv->mib_buf.size = 3;
+		priv->mib_buf.index = offsetof(struct mib_mac_encryption, 
+				exclude_unencrypted); 
+		priv->mib_buf.data.data[0] = 1;	/* exclude_unencrypted */
+		priv->mib_buf.data.data[1] = 0;	/* wep_encryption_type */
+		priv->mib_buf.data.data[2] = 0;	/* ckip_key_permutation */
+
+		if ((ret = at76_set_mib(priv, &priv->mib_buf)) != 
+				CMD_STATUS_COMPLETE)
+			goto exit;
+		ret = 0;
+	};
+exit:
+	at76_dump_mib_mac_encryption(priv);
+	mutex_unlock(&priv->mtx);
+	return ret;
+}
+
+static int at76_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+			const u8 *local_address, const u8 *address,
+			struct ieee80211_key_conf *key)
+{
+	struct at76_priv *priv = hw->priv;
+
+	// int i;
+
+	at76_dbg(DBG_MAC80211, "%s(): cmd %d key->alg %d key->keyidx %d "
+		 "key->keylen %d",
+		 __func__, cmd, key->alg, key->keyidx, key->keylen);
+	
+	if (FIRMWARE_IS_WPA(priv->fw_version))
+		return at76_set_key_newfw(hw, cmd, local_address, address, key);
+	else
+		return at76_set_key_oldfw(hw, cmd, local_address, address, key);
+
+}
+
 static const struct ieee80211_ops at76_ops = {
 	.tx = at76_mac80211_tx,
 	.add_interface = at76_add_interface,
@@ -2285,6 +2480,8 @@ static int at76_init_new_device(struct at76_priv *priv,
 	priv->scan_min_time = DEF_SCAN_MIN_TIME;
 	priv->scan_max_time = DEF_SCAN_MAX_TIME;
 	priv->scan_mode = SCAN_TYPE_ACTIVE;
+	priv->default_pairwise_key = 0xff;
+	priv->default_group_key = 0xff;
 
 	/* mac80211 initialisation */
 	priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &at76_supported_band;
@@ -2317,6 +2514,15 @@ static int at76_init_new_device(struct at76_priv *priv,
 	printk(KERN_INFO "%s: regulatory domain 0x%02x: %s\n",
 	       wiphy_name(priv->hw->wiphy),
 	       priv->regulatory_domain, priv->domain->name);
+	printk(KERN_INFO "%s: WPA support: ", wiphy_name(priv->hw->wiphy));
+	if (!FIRMWARE_IS_WPA(priv->fw_version))
+		printk("none\n");
+	else {
+		if (!at76_is_505a(priv->board_type))
+			printk("TKIP\n");
+		else
+			printk("TKIP, AES/CCMP\n");
+	};
 
 exit:
 	return ret;
diff --git a/drivers/net/wireless/at76_usb.h b/drivers/net/wireless/at76_usb.h
index 1ec5ccf..8bb352f 100644
--- a/drivers/net/wireless/at76_usb.h
+++ b/drivers/net/wireless/at76_usb.h
@@ -65,6 +65,7 @@ enum board_type {
 #define MIB_MAC			0x03
 #define MIB_MAC_MGMT		0x05
 #define MIB_MAC_WEP		0x06
+#define MIB_MAC_ENCRYPTION	0x06
 #define MIB_PHY			0x07
 #define MIB_FW_VERSION		0x08
 #define MIB_MDOMAIN		0x09
@@ -89,6 +90,26 @@ enum board_type {
 #define AT76_PM_ON		2
 #define AT76_PM_SMART		3
 
+/* cipher values for encryption keys */
+#define CIPHER_NONE		0	/* this value is only guessed */
+#define CIPHER_WEP64		1
+#define CIPHER_TKIP		2
+#define CIPHER_CCMP		3
+#define CIPHER_CCX		4	/* for consistency sake only */
+#define CIPHER_WEP128		5
+
+/* bit flags key types for encryption keys */
+#define KEY_PAIRWISE		2
+#define KEY_TX			4
+
+#define CIPHER_KEYS		(4)
+#define CIPHER_KEY_LEN		(40)
+
+struct key_config {
+	u8 cipher;
+	u8 keylen;
+};
+
 struct hwcfg_r505 {
 	u8 cr39_values[14];
 	u8 reserved1[14];
@@ -132,6 +153,8 @@ union at76_hwcfg {
 #define WEP_LARGE_KEY_LEN	(104 / 8)
 #define WEP_KEYS		(4)
 
+
+
 struct at76_card_config {
 	u8 exclude_unencrypted;
 	u8 promiscuous_mode;
@@ -180,7 +203,10 @@ struct at76_tx_buffer {
 	__le16 wlength;
 	u8 tx_rate;
 	u8 padding;
-	u8 reserved[4];
+	u8 key_id;
+	u8 cipher_type;
+	u8 cipher_length;
+	u8 reserved;
 	u8 packet[IEEE80211_MAX_FRAG_THRESHOLD];
 } __attribute__((packed));
 
@@ -228,6 +254,7 @@ struct set_mib_buffer {
 		u8 byte;
 		__le16 word;
 		u8 addr[ETH_ALEN];
+		u8 data[256];	/* we need more space for mib_mac_encryption */
 	} data;
 } __attribute__((packed));
 
@@ -305,6 +332,20 @@ struct mib_mac_wep {
 	u8 encryption_level;	/* 1 for 40bit, 2 for 104bit encryption */
 } __attribute__((packed));
 
+struct mib_mac_encryption {
+	u8 cipher_default_keyvalue[CIPHER_KEYS][CIPHER_KEY_LEN];
+	u8 tkip_bssid[6];
+	u8 privacy_invoked;
+	u8 cipher_default_key_id;
+	u8 cipher_default_group_key_id;
+	u8 exclude_unencrypted;
+	u8 wep_encryption_type;
+	u8 ckip_key_permutation;	/* bool */
+	__le32 wep_icv_error_count;
+	__le32 wep_excluded_count;
+	u8 key_rsc[CIPHER_KEYS][8];
+} __attribute__((packed));
+
 struct mib_phy {
 	__le32 ed_threshold;
 
@@ -442,6 +483,10 @@ struct at76_priv {
 
 	struct ieee80211_hw *hw;
 	int mac80211_registered;
+
+	struct key_config keys[4];	/* installed key types */
+	u8 default_pairwise_key;
+	u8 default_group_key;
 };
 
 #define AT76_SUPPORTED_FILTERS FIF_PROMISC_IN_BSS

