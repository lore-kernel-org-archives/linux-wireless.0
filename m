Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48290 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752166AbdLALvC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 06:51:02 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  1 Dec 2017 13:50:52 +0200
Message-Id: <20171201115053.29608-3-luca@coelho.fi> (sfid-20171201_125106_106666_D839C633)
In-Reply-To: <20171201115053.29608-1-luca@coelho.fi>
References: <20171201115053.29608-1-luca@coelho.fi>
Subject: [PATCH 2/3] mac80211: Add MIC space only for TX key option
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Add a key flag to indicates that the device only needs
MIC space and not a real MIC.
In such cases, keep the MIC zeroed for ease of debug.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h |  6 +++++-
 net/mac80211/key.c     | 12 +++++++++---
 net/mac80211/tx.c      |  4 +++-
 net/mac80211/wpa.c     | 16 ++++++++++++----
 4 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ed73f79fe6ad..a6b0765e290d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1552,6 +1552,9 @@ struct wireless_dev *ieee80211_vif_to_wdev(struct ieee80211_vif *vif);
  * @IEEE80211_KEY_FLAG_RESERVE_TAILROOM: This flag should be set by the
  *	driver for a key to indicate that sufficient tailroom must always
  *	be reserved for ICV or MIC, even when HW encryption is enabled.
+ * @IEEE80211_KEY_FLAG_PUT_MIC_SPACE: This flag should be set by the driver for
+ *	a TKIP key if it only requires MIC space. Do not set together with
+ *	@IEEE80211_KEY_FLAG_GENERATE_MMIC on the same key.
  */
 enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_GENERATE_IV_MGMT	= BIT(0),
@@ -1562,6 +1565,7 @@ enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_PUT_IV_SPACE		= BIT(5),
 	IEEE80211_KEY_FLAG_RX_MGMT		= BIT(6),
 	IEEE80211_KEY_FLAG_RESERVE_TAILROOM	= BIT(7),
+	IEEE80211_KEY_FLAG_PUT_MIC_SPACE	= BIT(8),
 };
 
 /**
@@ -1593,8 +1597,8 @@ struct ieee80211_key_conf {
 	u8 icv_len;
 	u8 iv_len;
 	u8 hw_key_idx;
-	u8 flags;
 	s8 keyidx;
+	u16 flags;
 	u8 keylen;
 	u8 key[0];
 };
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index a98fc2b5e0dc..0302d3ec19c1 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -177,13 +177,17 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	if (!ret) {
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+		if (!((key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
+					   IEEE80211_KEY_FLAG_PUT_MIC_SPACE)) ||
 		      (key->conf.flags & IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
 			decrease_tailroom_need_count(sdata, 1);
 
 		WARN_ON((key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
 			(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV));
 
+		WARN_ON((key->conf.flags & IEEE80211_KEY_FLAG_PUT_MIC_SPACE) &&
+			(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC));
+
 		return 0;
 	}
 
@@ -236,7 +240,8 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	sta = key->sta;
 	sdata = key->sdata;
 
-	if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+	if (!((key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
+				   IEEE80211_KEY_FLAG_PUT_MIC_SPACE)) ||
 	      (key->conf.flags & IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
 		increment_tailroom_need_count(sdata);
 
@@ -1058,7 +1063,8 @@ void ieee80211_remove_key(struct ieee80211_key_conf *keyconf)
 	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+		if (!((key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
+					   IEEE80211_KEY_FLAG_PUT_MIC_SPACE)) ||
 		      (key->conf.flags & IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
 			increment_tailroom_need_count(key->sdata);
 	}
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7b8154474b9e..16bc1dacf1b3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2922,7 +2922,9 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 
 		gen_iv = build.key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV;
 		iv_spc = build.key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE;
-		mmic = build.key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC;
+		mmic = build.key->conf.flags &
+			(IEEE80211_KEY_FLAG_GENERATE_MMIC |
+			 IEEE80211_KEY_FLAG_PUT_MIC_SPACE);
 
 		/* don't handle software crypto */
 		if (!(build.key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index b58722d9de37..785056cb76f6 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -1,7 +1,7 @@
 /*
  * Copyright 2002-2004, Instant802 Networks, Inc.
  * Copyright 2008, Jouni Malinen <j@w1.fi>
- * Copyright (C) 2016 Intel Deutschland GmbH
+ * Copyright (C) 2016-2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -59,8 +59,9 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 	if (info->control.hw_key &&
 	    (info->flags & IEEE80211_TX_CTL_DONTFRAG ||
 	     ieee80211_hw_check(&tx->local->hw, SUPPORTS_TX_FRAG)) &&
-	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC)) {
-		/* hwaccel - with no need for SW-generated MMIC */
+	    !(tx->key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
+				     IEEE80211_KEY_FLAG_PUT_MIC_SPACE))) {
+		/* hwaccel - with no need for SW-generated MMIC or MIC space */
 		return TX_CONTINUE;
 	}
 
@@ -75,8 +76,15 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 		 skb_tailroom(skb), tail))
 		return TX_DROP;
 
-	key = &tx->key->conf.key[NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY];
 	mic = skb_put(skb, MICHAEL_MIC_LEN);
+
+	if (tx->key->conf.flags & IEEE80211_KEY_FLAG_PUT_MIC_SPACE) {
+		/* Zeroed MIC can help with debug */
+		memset(mic, 0, MICHAEL_MIC_LEN);
+		return TX_CONTINUE;
+	}
+
+	key = &tx->key->conf.key[NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY];
 	michael_mic(key, hdr, data, data_len, mic);
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_TKIP_MIC_FAILURE))
 		mic[0]++;
-- 
2.15.0
