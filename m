Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57549 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab0L2Xcu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 18:32:50 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so4753430eye.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Dec 2010 15:32:50 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v4 15/18] wl1271: AP mode - encryption support
Date: Thu, 30 Dec 2010 01:32:10 +0200
Message-Id: <1293665533-7599-16-git-send-email-arik@wizery.com>
In-Reply-To: <1293665533-7599-1-git-send-email-arik@wizery.com>
References: <1293665533-7599-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Encryption key configuration is different for AP/STA modes.

AP encryption keys are recorded when the BSS is not started. On BSS
start they are propagated to the AP (in wl1271_ap_init_hwenc).

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.h    |    1 -
 drivers/net/wireless/wl12xx/main.c   |  220 ++++++++++++++++++++++++++++------
 drivers/net/wireless/wl12xx/tx.c     |   30 ++++-
 drivers/net/wireless/wl12xx/wl12xx.h |   16 +++
 4 files changed, 223 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index c9909e0..7512814 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -291,7 +291,6 @@ struct wl1271_cmd_ps_params {
 
 /* HW encryption keys */
 #define NUM_ACCESS_CATEGORIES_COPY 4
-#define MAX_KEY_SIZE 32
 
 enum wl1271_cmd_key_action {
 	KEY_ADD_OR_REPLACE = 1,
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 8b897e3..4ca46b2 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -296,6 +296,7 @@ static struct conf_drv_settings default_conf = {
 };
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl);
+static void wl1271_free_ap_keys(struct wl1271 *wl);
 
 
 static void wl1271_device_release(struct device *dev)
@@ -1193,6 +1194,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 	wl->flags = 0;
 	wl->vif = NULL;
 	wl->filters = 0;
+	wl1271_free_ap_keys(wl);
 	memset(wl->ap_hlid_map, 0, sizeof(wl->ap_hlid_map));
 
 	for (i = 0; i < NUM_TX_QUEUES; i++)
@@ -1627,38 +1629,192 @@ out:
 	kfree(fp);
 }
 
+static int wl1271_record_ap_key(struct wl1271 *wl, u8 id, u8 key_type,
+			u8 key_size, const u8 *key, u8 hlid, u32 tx_seq_32,
+			u16 tx_seq_16)
+{
+	struct wl1271_ap_key *ap_key;
+	int i;
+
+	wl1271_debug(DEBUG_CRYPT, "record ap key id %d", (int)id);
+
+	if (key_size > MAX_KEY_SIZE)
+		return -EINVAL;
+
+	/*
+	 * Find next free entry in ap_keys. Also check we are not replacing
+	 * an existing key.
+	 */
+	for (i = 0; i < MAX_NUM_KEYS; i++) {
+		if (wl->recorded_ap_keys[i] == NULL)
+			break;
+
+		if (wl->recorded_ap_keys[i]->id == id) {
+			wl1271_warning("trying to record key replacement");
+			return -EINVAL;
+		}
+	}
+
+	if (i == MAX_NUM_KEYS)
+		return -EBUSY;
+
+	ap_key = kzalloc(sizeof(*ap_key), GFP_KERNEL);
+	if (!ap_key)
+		return -ENOMEM;
+
+	ap_key->id = id;
+	ap_key->key_type = key_type;
+	ap_key->key_size = key_size;
+	memcpy(ap_key->key, key, key_size);
+	ap_key->hlid = hlid;
+	ap_key->tx_seq_32 = tx_seq_32;
+	ap_key->tx_seq_16 = tx_seq_16;
+
+	wl->recorded_ap_keys[i] = ap_key;
+	return 0;
+}
+
+static void wl1271_free_ap_keys(struct wl1271 *wl)
+{
+	int i;
+
+	for (i = 0; i < MAX_NUM_KEYS; i++) {
+		kfree(wl->recorded_ap_keys[i]);
+		wl->recorded_ap_keys[i] = NULL;
+	}
+}
+
+static int wl1271_ap_init_hwenc(struct wl1271 *wl)
+{
+	int i, ret = 0;
+	struct wl1271_ap_key *key;
+	bool wep_key_added = false;
+
+	for (i = 0; i < MAX_NUM_KEYS; i++) {
+		if (wl->recorded_ap_keys[i] == NULL)
+			break;
+
+		key = wl->recorded_ap_keys[i];
+		ret = wl1271_cmd_set_ap_key(wl, KEY_ADD_OR_REPLACE,
+					    key->id, key->key_type,
+					    key->key_size, key->key,
+					    key->hlid, key->tx_seq_32,
+					    key->tx_seq_16);
+		if (ret < 0)
+			goto out;
+
+		if (key->key_type == KEY_WEP)
+			wep_key_added = true;
+	}
+
+	if (wep_key_added) {
+		ret = wl1271_cmd_set_ap_default_wep_key(wl, wl->default_key);
+		if (ret < 0)
+			goto out;
+	}
+
+out:
+	wl1271_free_ap_keys(wl);
+	return ret;
+}
+
+static int wl1271_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
+		       u8 key_size, const u8 *key, u32 tx_seq_32,
+		       u16 tx_seq_16, struct ieee80211_sta *sta)
+{
+	int ret;
+	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
+
+	if (is_ap) {
+		struct wl1271_station *wl_sta;
+		u8 hlid;
+
+		if (sta) {
+			wl_sta = (struct wl1271_station *)sta->drv_priv;
+			hlid = wl_sta->hlid;
+		} else {
+			hlid = WL1271_AP_BROADCAST_HLID;
+		}
+
+		if (!test_bit(WL1271_FLAG_AP_STARTED, &wl->flags)) {
+			/*
+			 * We do not support removing keys after AP shutdown.
+			 * Pretend we do to make mac80211 happy.
+			 */
+			if (action != KEY_ADD_OR_REPLACE)
+				return 0;
+
+			ret = wl1271_record_ap_key(wl, id,
+					     key_type, key_size,
+					     key, hlid, tx_seq_32,
+					     tx_seq_16);
+		} else {
+			ret = wl1271_cmd_set_ap_key(wl, action,
+					     id, key_type, key_size,
+					     key, hlid, tx_seq_32,
+					     tx_seq_16);
+		}
+
+		if (ret < 0)
+			return ret;
+	} else {
+		const u8 *addr;
+		static const u8 bcast_addr[ETH_ALEN] = {
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+		};
+
+		addr = sta ? sta->addr : bcast_addr;
+
+		if (is_zero_ether_addr(addr)) {
+			/* We dont support TX only encryption */
+			return -EOPNOTSUPP;
+		}
+
+		/* The wl1271 does not allow to remove unicast keys - they
+		   will be cleared automatically on next CMD_JOIN. Ignore the
+		   request silently, as we dont want the mac80211 to emit
+		   an error message. */
+		if (action == KEY_REMOVE && !is_broadcast_ether_addr(addr))
+			return 0;
+
+		ret = wl1271_cmd_set_sta_key(wl, action,
+					     id, key_type, key_size,
+					     key, addr, tx_seq_32,
+					     tx_seq_16);
+		if (ret < 0)
+			return ret;
+
+		/* the default WEP key needs to be configured at least once */
+		if (key_type == KEY_WEP) {
+			ret = wl1271_cmd_set_sta_default_wep_key(wl,
+							wl->default_key);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
 static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			     struct ieee80211_vif *vif,
 			     struct ieee80211_sta *sta,
 			     struct ieee80211_key_conf *key_conf)
 {
 	struct wl1271 *wl = hw->priv;
-	const u8 *addr;
 	int ret;
 	u32 tx_seq_32 = 0;
 	u16 tx_seq_16 = 0;
 	u8 key_type;
 
-	static const u8 bcast_addr[ETH_ALEN] =
-		{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
-
 	wl1271_debug(DEBUG_MAC80211, "mac80211 set key");
 
-	addr = sta ? sta->addr : bcast_addr;
-
-	wl1271_debug(DEBUG_CRYPT, "CMD: 0x%x", cmd);
-	wl1271_dump(DEBUG_CRYPT, "ADDR: ", addr, ETH_ALEN);
+	wl1271_debug(DEBUG_CRYPT, "CMD: 0x%x sta: %p", cmd, sta);
 	wl1271_debug(DEBUG_CRYPT, "Key: algo:0x%x, id:%d, len:%d flags 0x%x",
 		     key_conf->cipher, key_conf->keyidx,
 		     key_conf->keylen, key_conf->flags);
 	wl1271_dump(DEBUG_CRYPT, "KEY: ", key_conf->key, key_conf->keylen);
 
-	if (is_zero_ether_addr(addr)) {
-		/* We dont support TX only encryption */
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
-
 	mutex_lock(&wl->mutex);
 
 	if (unlikely(wl->state == WL1271_STATE_OFF)) {
@@ -1705,36 +1861,21 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	switch (cmd) {
 	case SET_KEY:
-		ret = wl1271_cmd_set_sta_key(wl, KEY_ADD_OR_REPLACE,
-					 key_conf->keyidx, key_type,
-					 key_conf->keylen, key_conf->key,
-					 addr, tx_seq_32, tx_seq_16);
+		ret = wl1271_set_key(wl, KEY_ADD_OR_REPLACE,
+				 key_conf->keyidx, key_type,
+				 key_conf->keylen, key_conf->key,
+				 tx_seq_32, tx_seq_16, sta);
 		if (ret < 0) {
 			wl1271_error("Could not add or replace key");
 			goto out_sleep;
 		}
-
-		/* the default WEP key needs to be configured at least once */
-		if (key_type == KEY_WEP) {
-			ret = wl1271_cmd_set_sta_default_wep_key(wl,
-							     wl->default_key);
-			if (ret < 0)
-				goto out_sleep;
-		}
 		break;
 
 	case DISABLE_KEY:
-		/* The wl1271 does not allow to remove unicast keys - they
-		   will be cleared automatically on next CMD_JOIN. Ignore the
-		   request silently, as we dont want the mac80211 to emit
-		   an error message. */
-		if (!is_broadcast_ether_addr(addr))
-			break;
-
-		ret = wl1271_cmd_set_sta_key(wl, KEY_REMOVE,
-					 key_conf->keyidx, key_type,
-					 key_conf->keylen, key_conf->key,
-					 addr, 0, 0);
+		ret = wl1271_set_key(wl, KEY_REMOVE,
+				     key_conf->keyidx, key_type,
+				     key_conf->keylen, key_conf->key,
+				     0, 0, sta);
 		if (ret < 0) {
 			wl1271_error("Could not remove key");
 			goto out_sleep;
@@ -1753,7 +1894,6 @@ out_sleep:
 out_unlock:
 	mutex_unlock(&wl->mutex);
 
-out:
 	return ret;
 }
 
@@ -2019,6 +2159,10 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 
 				set_bit(WL1271_FLAG_AP_STARTED, &wl->flags);
 				wl1271_debug(DEBUG_AP, "started AP");
+
+				ret = wl1271_ap_init_hwenc(wl);
+				if (ret < 0)
+					goto out;
 			}
 		} else {
 			if (test_bit(WL1271_FLAG_AP_STARTED, &wl->flags)) {
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 3245c24..2347f25 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -31,6 +31,23 @@
 #include "ps.h"
 #include "tx.h"
 
+static int wl1271_set_default_wep_key(struct wl1271 *wl, u8 id)
+{
+	int ret;
+	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
+
+	if (is_ap)
+		ret = wl1271_cmd_set_ap_default_wep_key(wl, id);
+	else
+		ret = wl1271_cmd_set_sta_default_wep_key(wl, id);
+
+	if (ret < 0)
+		return ret;
+
+	wl1271_debug(DEBUG_CRYPT, "default wep key idx: %d", (int)id);
+	return 0;
+}
+
 static int wl1271_alloc_tx_id(struct wl1271 *wl, struct sk_buff *skb)
 {
 	int id;
@@ -190,7 +207,6 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 	struct ieee80211_tx_info *info;
 	u32 extra = 0;
 	int ret = 0;
-	u8 idx;
 	u32 total_len;
 
 	if (!skb)
@@ -203,11 +219,15 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 		extra = WL1271_TKIP_IV_SPACE;
 
 	if (info->control.hw_key) {
-		idx = info->control.hw_key->hw_key_idx;
+		bool is_wep;
+		u8 idx = info->control.hw_key->hw_key_idx;
+		u32 cipher = info->control.hw_key->cipher;
+
+		is_wep = (cipher == WLAN_CIPHER_SUITE_WEP40) ||
+			 (cipher == WLAN_CIPHER_SUITE_WEP104);
 
-		/* FIXME: do we have to do this if we're not using WEP? */
-		if (unlikely(wl->default_key != idx)) {
-			ret = wl1271_cmd_set_sta_default_wep_key(wl, idx);
+		if (unlikely(is_wep && wl->default_key != idx)) {
+			ret = wl1271_set_default_wep_key(wl, idx);
 			if (ret < 0)
 				return ret;
 			wl->default_key = idx;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 3bd03af..98532fc 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -253,6 +253,19 @@ struct wl1271_if_operations {
 	void (*disable_irq)(struct wl1271 *wl);
 };
 
+#define MAX_NUM_KEYS 14
+#define MAX_KEY_SIZE 32
+
+struct wl1271_ap_key {
+	u8 id;
+	u8 key_type;
+	u8 key_size;
+	u8 key[MAX_KEY_SIZE];
+	u8 hlid;
+	u32 tx_seq_32;
+	u16 tx_seq_16;
+};
+
 struct wl1271 {
 	struct platform_device *plat_dev;
 	struct ieee80211_hw *hw;
@@ -438,6 +451,9 @@ struct wl1271 {
 
 	/* map for HLIDs of associated stations - when operating in AP mode */
 	unsigned long ap_hlid_map[BITS_TO_LONGS(AP_MAX_STATIONS)];
+
+	/* recoreded keys for AP-mode - set here before AP startup */
+	struct wl1271_ap_key *recorded_ap_keys[MAX_NUM_KEYS];
 };
 
 struct wl1271_station {
-- 
1.7.1

