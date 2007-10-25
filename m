Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40422 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbXJYNWn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 09:22:43 -0400
Received: from [131.234.198.68]
	by sipsolutions.net with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Il2fW-0000dL-60
	for linux-wireless@vger.kernel.org; Thu, 25 Oct 2007 14:22:39 +0100
Message-Id: <20071025093715.252497000@sipsolutions.net> (sfid-20071025_142253_177100_5B09EFE8)
References: <20071025093618.440937000@sipsolutions.net>
Date: Thu, 25 Oct 2007 11:36:21 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [patch 3/9] mac80211: support getting key sequence counters via
	cfg80211
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements cfg80211's get_key() to allow retrieving the sequence
counter for a TKIP or CCMP key from userspace. It also cleans up and
documents the associated low-level driver interface.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h |   14 ++------
 net/mac80211/cfg.c     |   85 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 89 insertions(+), 10 deletions(-)

--- linux-2.6.orig/net/mac80211/cfg.c	2007-10-24 11:35:49.112690568 +0200
+++ linux-2.6/net/mac80211/cfg.c	2007-10-24 11:35:49.722690568 +0200
@@ -1,7 +1,7 @@
 /*
  * mac80211 configuration hooks for cfg80211
  *
- * Copyright 2006	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2006, 2007	Johannes Berg <johannes@sipsolutions.net>
  *
  * This file is GPLv2 as found in COPYING.
  */
@@ -175,6 +175,88 @@ static int ieee80211_del_key(struct wiph
 	return 0;
 }
 
+static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
+			     u8 key_idx, u8 *mac_addr, void *cookie,
+			     void (*callback)(void *cookie,
+					      struct key_params *params))
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sta_info *sta = NULL;
+	u8 seq[6] = {0};
+	struct key_params params;
+	struct ieee80211_key *key;
+	u32 iv32;
+	u16 iv16;
+	int err = -ENOENT;
+
+	if (mac_addr) {
+		sta = sta_info_get(sdata->local, mac_addr);
+		if (!sta)
+			goto out;
+
+		key = sta->key;
+	} else
+		key = sdata->keys[key_idx];
+
+	if (!key)
+		goto out;
+
+	memset(&params, 0, sizeof(params));
+
+	switch (key->conf.alg) {
+	case ALG_TKIP:
+		params.cipher = WLAN_CIPHER_SUITE_TKIP;
+
+		iv32 = key->u.tkip.iv32;
+		iv16 = key->u.tkip.iv16;
+
+		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
+		    sdata->local->ops->get_tkip_seq)
+			sdata->local->ops->get_tkip_seq(
+				local_to_hw(sdata->local),
+				key->conf.hw_key_idx,
+				&iv32, &iv16);
+
+		seq[0] = iv16 & 0xff;
+		seq[1] = (iv16 >> 8) & 0xff;
+		seq[2] = iv32 & 0xff;
+		seq[3] = (iv32 >> 8) & 0xff;
+		seq[4] = (iv32 >> 16) & 0xff;
+		seq[5] = (iv32 >> 24) & 0xff;
+		params.seq = seq;
+		params.seq_len = 6;
+		break;
+	case ALG_CCMP:
+		params.cipher = WLAN_CIPHER_SUITE_CCMP;
+		seq[0] = key->u.ccmp.tx_pn[5];
+		seq[1] = key->u.ccmp.tx_pn[4];
+		seq[2] = key->u.ccmp.tx_pn[3];
+		seq[3] = key->u.ccmp.tx_pn[2];
+		seq[4] = key->u.ccmp.tx_pn[1];
+		seq[5] = key->u.ccmp.tx_pn[0];
+		params.seq = seq;
+		params.seq_len = 6;
+		break;
+	case ALG_WEP:
+		if (key->conf.keylen == 5)
+			params.cipher = WLAN_CIPHER_SUITE_WEP40;
+		else
+			params.cipher = WLAN_CIPHER_SUITE_WEP104;
+		break;
+	}
+
+	params.key = key->conf.key;
+	params.key_len = key->conf.keylen;
+
+	callback(cookie, &params);
+	err = 0;
+
+ out:
+	if (sta)
+		sta_info_put(sta);
+	return err;
+}
+
 static int ieee80211_config_default_key(struct wiphy *wiphy,
 					struct net_device *dev,
 					u8 key_idx)
@@ -193,5 +275,6 @@ struct cfg80211_ops mac80211_config_ops 
 	.change_virtual_intf = ieee80211_change_iface,
 	.add_key = ieee80211_add_key,
 	.del_key = ieee80211_del_key,
+	.get_key = ieee80211_get_key,
 	.set_default_key = ieee80211_config_default_key,
 };
--- linux-2.6.orig/include/net/mac80211.h	2007-10-24 11:32:35.932690568 +0200
+++ linux-2.6/include/net/mac80211.h	2007-10-24 11:35:49.722690568 +0200
@@ -597,9 +597,6 @@ struct ieee80211_key_conf {
 	u8 key[0];
 };
 
-#define IEEE80211_SEQ_COUNTER_RX	0
-#define IEEE80211_SEQ_COUNTER_TX	1
-
 /**
  * enum set_key_cmd - key command
  *
@@ -957,9 +954,9 @@ enum ieee80211_erp_change_flags {
  *	response or association responses this updates the state of privacy_invoked
  *	returns 0 for success or an error number.
  *
- * @get_sequence_counter: For devices that have internal sequence counters this
- *	callback allows mac80211 to access the current value of a counter.
- *	This callback seems not well-defined, tell us if you need it.
+ * @get_tkip_seq: If your device implements TKIP encryption in hardware this
+ *	callback should be provided to read the TKIP transmit IVs (both IV32
+ *	and IV16) for the given key from hardware.
  *
  * @set_rts_threshold: Configuration of RTS threshold (if device needs it)
  *
@@ -1037,9 +1034,8 @@ struct ieee80211_ops {
 			 struct ieee80211_low_level_stats *stats);
 	int (*set_privacy_invoked)(struct ieee80211_hw *hw,
 				   int privacy_invoked);
-	int (*get_sequence_counter)(struct ieee80211_hw *hw,
-				    u8* addr, u8 keyidx, u8 txrx,
-				    u32* iv32, u16* iv16);
+	void (*get_tkip_seq)(struct ieee80211_hw *hw, u8 hw_key_idx,
+			     u32 *iv32, u16 *iv16);
 	int (*set_rts_threshold)(struct ieee80211_hw *hw, u32 value);
 	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
 	int (*set_retry_limit)(struct ieee80211_hw *hw,

-- 

