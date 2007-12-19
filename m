Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40673 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbXLSPsQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 10:48:16 -0500
Message-Id: <20071219010340.310330000@sipsolutions.net> (sfid-20071219_154824_823699_E332D984)
References: <20071219010328.762470000@sipsolutions.net>
Date: Wed, 19 Dec 2007 02:03:31 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 3/9] mac80211: support getting key sequence counters via
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

--- everything.orig/net/mac80211/cfg.c	2007-12-19 00:50:16.293022569 +0100
+++ everything/net/mac80211/cfg.c	2007-12-19 00:50:17.133022895 +0100
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
--- everything.orig/include/net/mac80211.h	2007-12-19 00:50:13.963022840 +0100
+++ everything/include/net/mac80211.h	2007-12-19 00:50:17.133022895 +0100
@@ -661,9 +661,6 @@ struct ieee80211_key_conf {
 	u8 key[0];
 };
 
-#define IEEE80211_SEQ_COUNTER_RX	0
-#define IEEE80211_SEQ_COUNTER_TX	1
-
 /**
  * enum set_key_cmd - key command
  *
@@ -1014,9 +1011,9 @@ enum ieee80211_erp_change_flags {
  *
  * @get_stats: return low-level statistics
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
@@ -1092,9 +1089,8 @@ struct ieee80211_ops {
 	int (*hw_scan)(struct ieee80211_hw *hw, u8 *ssid, size_t len);
 	int (*get_stats)(struct ieee80211_hw *hw,
 			 struct ieee80211_low_level_stats *stats);
-	int (*get_sequence_counter)(struct ieee80211_hw *hw,
-				    u8* addr, u8 keyidx, u8 txrx,
-				    u32* iv32, u16* iv16);
+	void (*get_tkip_seq)(struct ieee80211_hw *hw, u8 hw_key_idx,
+			     u32 *iv32, u16 *iv16);
 	int (*set_rts_threshold)(struct ieee80211_hw *hw, u32 value);
 	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
 	int (*set_retry_limit)(struct ieee80211_hw *hw,

-- 

