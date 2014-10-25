Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:39871 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaJYTsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:48:45 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so3181735wgh.16
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:48:44 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/31] staging: vt6655: mac80211 conversion: add new key functions
Date: Sat, 25 Oct 2014 09:20:12 +0100
Message-Id: <1414225241-5480-3-git-send-email-tvboxspy@gmail.com> (sfid-20141025_214848_929553_EF2FEAE0)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vnt_key_init_table to initialize the table

vnt_set_keys to set the keys

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h |   1 +
 drivers/staging/vt6655/key.c    | 136 ++++++++++++++++++++++++++++++++++++++++
 drivers/staging/vt6655/key.h    |  17 +++++
 3 files changed, 154 insertions(+)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 33b4215..5717fa5 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -331,6 +331,7 @@ struct vnt_private {
 	/* mac80211 */
 	struct ieee80211_hw *hw;
 	struct ieee80211_vif *vif;
+	unsigned long key_entry_inuse;
 // netdev
 	struct net_device *dev;
 
diff --git a/drivers/staging/vt6655/key.c b/drivers/staging/vt6655/key.c
index 02caffb..b2fa812 100644
--- a/drivers/staging/vt6655/key.c
+++ b/drivers/staging/vt6655/key.c
@@ -790,3 +790,139 @@ bool KeybSetAllGroupKey(
 	}
 	return true;
 }
+
+int vnt_key_init_table(struct vnt_private *priv)
+{
+	u32 i;
+
+	for (i = 0; i < MAX_KEY_TABLE; i++)
+		MACvDisableKeyEntry(priv->PortOffset, i);
+
+	return 0;
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
+	/* fallthrough */
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
+	MACvSetKeyEntry(priv->PortOffset, key_mode, entry, key_inx,
+			bssid, (u32 *)key->key, priv->byLocalID);
+
+	return 0;
+}
+
+int vnt_set_keys(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+		 struct ieee80211_vif *vif, struct ieee80211_key_conf *key)
+{
+	struct ieee80211_bss_conf *conf = &vif->bss_conf;
+	struct vnt_private *priv = hw->priv;
+	u8 *mac_addr = NULL;
+	u8 key_dec_mode = 0;
+	int ret = 0;
+	u32 u;
+
+	if (sta)
+		mac_addr = &sta->addr[0];
+
+	switch (key->cipher) {
+	case 0:
+		for (u = 0 ; u < MAX_KEY_TABLE; u++)
+			MACvDisableKeyEntry(priv->PortOffset, u);
+		return ret;
+
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		for (u = 0; u < MAX_KEY_TABLE; u++)
+			MACvDisableKeyEntry(priv->PortOffset, u);
+
+		vnt_set_keymode(hw, mac_addr,
+				key, VNT_KEY_DEFAULTKEY, KEY_CTL_WEP, true);
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
+		key_dec_mode = KEY_CTL_CCMP;
+
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+	}
+
+	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE) {
+		vnt_set_keymode(hw, mac_addr,
+				key, VNT_KEY_PAIRWISE, key_dec_mode, true);
+	} else {
+		vnt_set_keymode(hw, mac_addr,
+				key, VNT_KEY_DEFAULTKEY, key_dec_mode, true);
+
+		vnt_set_keymode(hw, (u8 *)conf->bssid,
+				key, VNT_KEY_GROUP_ADDRESS, key_dec_mode, true);
+	}
+
+	return 0;
+}
diff --git a/drivers/staging/vt6655/key.h b/drivers/staging/vt6655/key.h
index 44efe18..d70ffd6 100644
--- a/drivers/staging/vt6655/key.h
+++ b/drivers/staging/vt6655/key.h
@@ -30,6 +30,8 @@
 #ifndef __KEY_H__
 #define __KEY_H__
 
+#include <net/mac80211.h>
+
 #include "ttype.h"
 #include "tether.h"
 #include "80211mgr.h"
@@ -53,6 +55,14 @@
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
 typedef struct tagSKeyItem {
 	bool bKeyValid;
 	unsigned long uKeyLength;
@@ -173,4 +183,11 @@ bool KeybSetAllGroupKey(
 	unsigned char byLocalID
 );
 
+struct vnt_private;
+
+int vnt_key_init_table(struct vnt_private *);
+
+int vnt_set_keys(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+		 struct ieee80211_vif *vif, struct ieee80211_key_conf *key);
+
 #endif // __KEY_H__
-- 
1.9.1

