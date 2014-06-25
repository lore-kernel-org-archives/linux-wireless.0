Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56755 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbaFYUPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:13 -0400
Received: by mail-wi0-f173.google.com with SMTP id cc10so8613119wib.12
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:15:12 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/17] staging: vt6656: mac80211 conversion: add key functions
Date: Wed, 25 Jun 2014 21:14:24 +0100
Message-Id: <1403727278-6666-4-git-send-email-tvboxspy@gmail.com> (sfid-20140625_221657_006342_3290F54B)
In-Reply-To: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create vnt_key_init_table to replace KeyvInitTable.

Create vnt_set_keymode to handle key setting operations with five different
modes VNT_KEY_DEFAULTKEY, VNT_KEY_GROUP_ADDRESS, VNT_KEY_ALLGROUP, VNT_KEY_GROUP
and VNT_KEY_PAIRWISE. VNT_KEY_ONFLY and VNT_KEY_ONFLY_ALL are for when
key latching in driver is not required.

Create vnt_set_keys to handle mac80211 key cipher modes, four modes are
supported WLAN_CIPHER_SUITE_WEP40, WLAN_CIPHER_SUITE_WEP104, WLAN_CIPHER_SUITE_TKIP
and WLAN_CIPHER_SUITE_CCMP.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h |   1 +
 drivers/staging/vt6656/key.c    | 143 ++++++++++++++++++++++++++++++++++++++++
 drivers/staging/vt6656/key.h    |  13 ++++
 3 files changed, 157 insertions(+)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 23fc5e2..112e0b0 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -631,6 +631,7 @@ struct vnt_private {
 
 	u32 uKeyLength;
 	u8 abyKey[WLAN_WEP232_KEYLEN];
+	unsigned long key_entry_inuse;
 
 	/* for AP mode */
 	u32 uAssocCount;
diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index 33e3e5a..3513066 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -728,3 +728,146 @@ int KeybSetAllGroupKey(struct vnt_private *pDevice, PSKeyManagement pTable,
     }
     return (true);
 }
+
+int vnt_key_init_table(struct vnt_private *priv)
+{
+	int ret;
+	u8 i;
+	u8 data[MAX_KEY_TABLE];
+
+	for (i = 0; i < MAX_KEY_TABLE; i++)
+		data[i] = i;
+
+	ret = vnt_control_out(priv, MESSAGE_TYPE_CLRKEYENTRY,
+			0, 0, ARRAY_SIZE(data), data);
+
+	return ret;
+}
+
+static int vnt_set_keymode(struct ieee80211_hw *hw, u8 *mac_addr,
+	struct ieee80211_key_conf *key, u32 key_type, u32 mode,
+	bool onfly_latch)
+{
+	struct vnt_private *priv = hw->priv;
+	u8 broadcast[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	u16 key_mode = 0;
+	u32 entry = 0;
+	u8 *bssid;
+	u8 key_inx = key->keyidx;
+	u8 i;
+
+	if (mac_addr)
+		bssid = mac_addr;
+	else
+		bssid = &broadcast[0];
+
+	if (key_type != VNT_KEY_DEFAULTKEY) {
+		for (i = 0; i < (MAX_KEY_TABLE - 1); i++) {
+			if (!test_bit(i, &priv->key_entry_inuse)) {
+				set_bit(i, &priv->key_entry_inuse);
+
+				key->hw_key_idx = i;
+				entry = key->hw_key_idx;
+				break;
+			}
+		}
+	}
+
+	switch (key_type) {
+		/* fallthrough */
+	case VNT_KEY_DEFAULTKEY:
+		/* default key last entry */
+		entry = MAX_KEY_TABLE - 1;
+		key->hw_key_idx = entry;
+	case VNT_KEY_ALLGROUP:
+		key_mode |= VNT_KEY_ALLGROUP;
+		if (onfly_latch)
+			key_mode |= VNT_KEY_ONFLY_ALL;
+	case VNT_KEY_GROUP_ADDRESS:
+		key_mode |= mode;
+	case VNT_KEY_GROUP:
+		key_mode |= (mode << 4);
+		key_mode |= VNT_KEY_GROUP;
+		break;
+	case  VNT_KEY_PAIRWISE:
+		key_mode |= mode;
+		key_inx = 4;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (onfly_latch)
+		key_mode |= VNT_KEY_ONFLY;
+
+	if (mode == KEY_CTL_WEP) {
+		if (key->keylen == WLAN_KEY_LEN_WEP40)
+			key->key[15] &= 0x7f;
+		if (key->keylen == WLAN_KEY_LEN_WEP104)
+			key->key[15] |= 0x80;
+	}
+
+	vnt_mac_set_keyentry(priv, key_mode, entry, key_inx, bssid, key->key);
+
+	return 0;
+}
+
+int vnt_set_keys(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+	struct ieee80211_vif *vif, struct ieee80211_key_conf *key)
+{
+	struct ieee80211_bss_conf *conf = &vif->bss_conf;
+	struct vnt_private *priv = hw->priv;
+	u8 *mac_addr = NULL;
+	u8 key_dec_mode = 0;
+	int ret = 0, u;
+
+	if (sta)
+		mac_addr = &sta->addr[0];
+
+	switch (key->cipher) {
+	case 0:
+		for (u = 0 ; u < MAX_KEY_TABLE; u++)
+			vnt_mac_disable_keyentry(priv, u);
+		return ret;
+
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		for (u = 0; u < MAX_KEY_TABLE; u++)
+			vnt_mac_disable_keyentry(priv, u);
+
+		vnt_set_keymode(hw, mac_addr, key, VNT_KEY_DEFAULTKEY,
+			KEY_CTL_WEP, true);
+
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+
+		return ret;
+	case WLAN_CIPHER_SUITE_TKIP:
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+
+		key_dec_mode = KEY_CTL_TKIP;
+
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		if (priv->byLocalID <= MAC_REVISION_A1)
+			return -EINVAL;
+
+		key_dec_mode = KEY_CTL_CCMP;
+
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+	}
+
+
+	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE) {
+		vnt_set_keymode(hw, mac_addr, key, VNT_KEY_PAIRWISE,
+					key_dec_mode, true);
+	} else {
+		vnt_set_keymode(hw, mac_addr, key, VNT_KEY_DEFAULTKEY,
+						key_dec_mode, true);
+
+		vnt_set_keymode(hw, (u8 *)conf->bssid, key,
+			VNT_KEY_GROUP_ADDRESS, key_dec_mode, true);
+	}
+
+	return 0;
+}
diff --git a/drivers/staging/vt6656/key.h b/drivers/staging/vt6656/key.h
index 23e188d..7b8c960 100644
--- a/drivers/staging/vt6656/key.h
+++ b/drivers/staging/vt6656/key.h
@@ -51,6 +51,14 @@
 #define KEY_CTL_CCMP        0x03
 #define KEY_CTL_INVALID     0xFF
 
+#define VNT_KEY_DEFAULTKEY	0x1
+#define VNT_KEY_GROUP_ADDRESS	0x2
+#define VNT_KEY_ALLGROUP	0x4
+#define VNT_KEY_GROUP		0x40
+#define VNT_KEY_PAIRWISE	0x00
+#define VNT_KEY_ONFLY		0x8000
+#define VNT_KEY_ONFLY_ALL	0x4000
+
 typedef struct tagSKeyItem
 {
     bool        bKeyValid;
@@ -109,4 +117,9 @@ int KeybSetAllGroupKey(struct vnt_private *, PSKeyManagement pTable,
 	u32 dwKeyIndex, u32 uKeyLength, u64 *KeyRSC, u8 *pbyKey,
 	u8 byKeyDecMode);
 
+int vnt_key_init_table(struct vnt_private *);
+
+int vnt_set_keys(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+	struct ieee80211_vif *vif, struct ieee80211_key_conf *key);
+
 #endif /* __KEY_H__ */
-- 
1.9.1

