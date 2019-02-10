Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D71EC282C2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:42:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4641F213F2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:42:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="GZvIqo6g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfBJVmU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 16:42:20 -0500
Received: from 10.mo5.mail-out.ovh.net ([46.105.52.148]:38705 "EHLO
        10.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfBJVmU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 16:42:20 -0500
X-Greylist: delayed 2126 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Feb 2019 16:42:13 EST
Received: from player692.ha.ovh.net (unknown [10.109.143.225])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id 4CC26219B1D
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2019 22:06:46 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player692.ha.ovh.net (Postfix) with ESMTPSA id 1EDC428F0FB3;
        Sun, 10 Feb 2019 21:06:45 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1549832804;
        bh=EI3lt3qUEVnSOBeCvhv5l+YzSHHDG22UEr0hsL0MYhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=GZvIqo6gdwrYwjPRH7n/5y7hrhxTOvopLpQ6X8AXmUSCAIcAGj0Uzl+vbXhfjs3rS
         VHC0PYFKk1mmV7eeDb8cosKsNfmO0h+6SISd+n97Pl4sa3YEKgtX7NpLO+I8S0tkkZ
         TKlbQ4n7X9EDv7zr2ZnJG44zv0Pzp9iZnxIF3aGE=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [RFC PATCH v3 03/12] mac80211: IEEE 802.11 Extended Key ID support
Date:   Sun, 10 Feb 2019 22:06:11 +0100
Message-Id: <20190210210620.31181-4-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190210210620.31181-1-alexander@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10549119177668500679
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrledvgdduvddvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenuc
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add support for Extended Key ID as defined in IEEE 802.11-2016.

 - Implement the nl80211 API for Extended Key ID
 - Extend mac80211 API to allow drivers to support Extended Key ID
 - Add handling for Rx-only keys (including tailroom_need_count)
 - Select the decryption key based on the MPDU keyid
 - Enforce cipher does not change when replacing a key.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
 include/net/mac80211.h     |  19 ++++-
 net/mac80211/cfg.c         |  38 ++++++++++
 net/mac80211/debugfs.c     |   1 +
 net/mac80211/ieee80211_i.h |   2 +-
 net/mac80211/key.c         | 138 +++++++++++++++++++++++++++++--------
 net/mac80211/key.h         |   4 ++
 net/mac80211/main.c        |   5 ++
 net/mac80211/rx.c          |  74 ++++++++++----------
 net/mac80211/sta_info.c    |   9 +++
 net/mac80211/sta_info.h    |   2 +-
 net/mac80211/tx.c          |  13 +---
 11 files changed, 227 insertions(+), 78 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index de866a7253c9..e16bc7623dc0 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1804,13 +1804,22 @@ struct ieee80211_cipher_scheme {
  * enum set_key_cmd - key command
  *
  * Used with the set_key() callback in &struct ieee80211_ops, this
- * indicates whether a key is being removed or added.
+ * indicates which action has to be performed with the key.
  *
- * @SET_KEY: a key is set
+ * @SET_KEY: a key is set and valid for Rx and Tx immediately
  * @DISABLE_KEY: a key must be disabled
+ *
+ * Additional commands for drivers supporting Extended Key ID:
+ *
+ * @EXT_SET_KEY: a new key must be set but is only valid for decryption
+ * @EXT_KEY_RX_TX: a key installed with @EXT_SET_KEY is becoming the
+ *	designated Rx/Tx key for the station
  */
 enum set_key_cmd {
-	SET_KEY, DISABLE_KEY,
+	SET_KEY,
+	DISABLE_KEY,
+	EXT_SET_KEY,
+	EXT_KEY_RX_TX,
 };
 
 /**
@@ -2219,6 +2228,9 @@ struct ieee80211_txq {
  * @IEEE80211_HW_TX_STATUS_NO_AMPDU_LEN: Driver does not report accurate A-MPDU
  *	length in tx status information
  *
+ * @IEEE80211_HW_EXT_KEY_ID_NATIVE: Driver and hardware are supporting Extended
+ *	Key ID and can handle two unicast keys per station for Rx and Tx.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2268,6 +2280,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_VHT_EXT_NSS_BW,
 	IEEE80211_HW_STA_MMPDU_TXQ,
 	IEEE80211_HW_TX_STATUS_NO_AMPDU_LEN,
+	IEEE80211_HW_EXT_KEY_ID_NATIVE,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d65aa019ce85..a032da64eed2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -351,6 +351,38 @@ static int ieee80211_set_noack_map(struct wiphy *wiphy,
 	return 0;
 }
 
+static int ieee80211_set_tx_key(struct ieee80211_sub_if_data *sdata,
+				const u8 *mac_addr, u8 key_idx)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_key *key;
+	struct sta_info *sta;
+	int ret;
+
+	if (!wiphy_ext_feature_isset(local->hw.wiphy,
+				     NL80211_EXT_FEATURE_EXT_KEY_ID))
+		return -EINVAL;
+
+	sta = sta_info_get_bss(sdata, mac_addr);
+
+	if (!sta)
+		return -EINVAL;
+
+	if (sta->ptk_idx == key_idx)
+		return 0;
+
+	mutex_lock(&local->key_mtx);
+	key = key_mtx_dereference(local, sta->ptk[key_idx]);
+
+	if (key && key->flags & KEY_FLAG_RX_ONLY)
+		ret = ieee80211_key_activate_tx(key);
+	else
+		ret = -EINVAL;
+
+	mutex_unlock(&local->key_mtx);
+	return ret;
+}
+
 static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 			     u8 key_idx, bool pairwise, const u8 *mac_addr,
 			     struct key_params *params)
@@ -365,6 +397,9 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	if (!ieee80211_sdata_running(sdata))
 		return -ENETDOWN;
 
+	if (pairwise && params->install_mode == NL80211_KEY_SWITCH_TX)
+		return ieee80211_set_tx_key(sdata, mac_addr, key_idx);
+
 	/* reject WEP and TKIP keys if WEP failed to initialize */
 	switch (params->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
@@ -396,6 +431,9 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	if (pairwise)
 		key->conf.flags |= IEEE80211_KEY_FLAG_PAIRWISE;
 
+	if (params->install_mode == NL80211_KEY_RX_ONLY)
+		key->flags |= KEY_FLAG_RX_ONLY;
+
 	mutex_lock(&local->sta_mtx);
 
 	if (mac_addr) {
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 343ad0a915e4..334a9883894f 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -219,6 +219,7 @@ static const char *hw_flag_names[] = {
 	FLAG(SUPPORTS_VHT_EXT_NSS_BW),
 	FLAG(STA_MMPDU_TXQ),
 	FLAG(TX_STATUS_NO_AMPDU_LEN),
+	FLAG(EXT_KEY_ID_NATIVE),
 #undef FLAG
 };
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 056b16bce3b0..cbc35a31adc5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1263,7 +1263,7 @@ struct ieee80211_local {
 
 	/*
 	 * Key mutex, protects sdata's key_list and sta_info's
-	 * key pointers (write access, they're RCU.)
+	 * key pointers and @ptk_idx (write access, they're RCU.)
 	 */
 	struct mutex key_mtx;
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index b9f2bfc00263..d91503de1e1d 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -127,8 +127,13 @@ static void decrease_tailroom_need_count(struct ieee80211_sub_if_data *sdata,
 static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 {
 	struct ieee80211_sub_if_data *sdata = key->sdata;
+	struct ieee80211_local *local = key->local;
 	struct sta_info *sta;
+	bool rx_only = key->flags & KEY_FLAG_RX_ONLY;
+	bool pairwise = key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE;
+	bool ext_native = ieee80211_hw_check(&local->hw, EXT_KEY_ID_NATIVE);
 	int ret = -EOPNOTSUPP;
+	int cmd;
 
 	might_sleep();
 
@@ -150,10 +155,10 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		return -EINVAL;
 	}
 
-	if (!key->local->ops->set_key)
+	if (!local->ops->set_key)
 		goto out_unsupported;
 
-	assert_key_lock(key->local);
+	assert_key_lock(local);
 
 	sta = key->sta;
 
@@ -161,8 +166,8 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	 * If this is a per-STA GTK, check if it
 	 * is supported; if not, return.
 	 */
-	if (sta && !(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE) &&
-	    !ieee80211_hw_check(&key->local->hw, SUPPORTS_PER_STA_GTK))
+	if (sta && !pairwise &&
+	    !ieee80211_hw_check(&local->hw, SUPPORTS_PER_STA_GTK))
 		goto out_unsupported;
 
 	if (sta && !sta->uploaded)
@@ -173,19 +178,25 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		 * The driver doesn't know anything about VLAN interfaces.
 		 * Hence, don't send GTKs for VLAN interfaces to the driver.
 		 */
-		if (!(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+		if (!pairwise) {
 			ret = 1;
 			goto out_unsupported;
 		}
 	}
 
-	ret = drv_set_key(key->local, SET_KEY, sdata,
+	if (rx_only)
+		cmd = EXT_SET_KEY;
+	else
+		cmd = SET_KEY;
+
+	ret = drv_set_key(local, cmd, sdata,
 			  sta ? &sta->sta : NULL, &key->conf);
 
 	if (!ret) {
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-		if (!(key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
+		if (!(rx_only ||
+		      key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
 					 IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
 					 IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
 			decrease_tailroom_need_count(sdata, 1);
@@ -221,7 +232,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		/* all of these we can do in software - if driver can */
 		if (ret == 1)
 			return 0;
-		if (ieee80211_hw_check(&key->local->hw, SW_CRYPTO_CONTROL))
+		if (ieee80211_hw_check(&local->hw, SW_CRYPTO_CONTROL))
 			return -EINVAL;
 		return 0;
 	default:
@@ -248,7 +259,8 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	sta = key->sta;
 	sdata = key->sdata;
 
-	if (!(key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
+	if (!(key->flags & KEY_FLAG_RX_ONLY ||
+	      key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
 				 IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
 				 IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
 		increment_tailroom_need_count(sdata);
@@ -264,9 +276,55 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 			  sta ? sta->sta.addr : bcast_addr, ret);
 }
 
+int ieee80211_key_activate_tx(struct ieee80211_key *key)
+{
+	struct ieee80211_sub_if_data *sdata = key->sdata;
+	struct sta_info *sta = key->sta;
+	struct ieee80211_local *local = key->local;
+	struct ieee80211_key *old;
+	int ret;
+
+	assert_key_lock(local);
+
+	key->flags &= ~KEY_FLAG_RX_ONLY;
+
+	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) ||
+	    key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
+			       IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
+			       IEEE80211_KEY_FLAG_RESERVE_TAILROOM))
+		increment_tailroom_need_count(sdata);
+
+	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
+		ret = drv_set_key(local, EXT_KEY_RX_TX, sdata,
+				  &sta->sta, &key->conf);
+		if (ret) {
+			sdata_err(sdata,
+				  "failed to activate key for Tx (%d, %pM)\n",
+				  key->conf.keyidx, sta->sta.addr);
+			return ret;
+		}
+	}
+
+	old = key_mtx_dereference(local, sta->ptk[sta->ptk_idx]);
+	sta->ptk_idx = key->conf.keyidx;
+	ieee80211_check_fast_xmit(sta);
+
+	if (old) {
+		old->flags |= KEY_FLAG_RX_ONLY;
+
+		if (!(old->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) ||
+		    old->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
+				       IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
+				       IEEE80211_KEY_FLAG_RESERVE_TAILROOM))
+			decrease_tailroom_need_count(sdata, 1);
+	}
+
+	return 0;
+}
+
 static int ieee80211_hw_key_replace(struct ieee80211_key *old_key,
 				    struct ieee80211_key *new_key,
-				    bool ptk0rekey)
+				    bool pairwise)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_local *local;
@@ -283,16 +341,17 @@ static int ieee80211_hw_key_replace(struct ieee80211_key *old_key,
 	assert_key_lock(old_key->local);
 	sta = old_key->sta;
 
-	/* PTK only using key ID 0 needs special handling on rekey */
-	if (new_key && sta && ptk0rekey) {
+	/* Unicast rekey without Extended Key ID needs special handling */
+	if (new_key && pairwise && sta &&
+	    rcu_access_pointer(sta->ptk[sta->ptk_idx]) == old_key) {
 		local = old_key->local;
 		sdata = old_key->sdata;
 
-		/* Stop TX till we are on the new key */
+		/* Stop Tx till we are on the new key */
 		old_key->flags |= KEY_FLAG_TAINTED;
 		ieee80211_clear_fast_xmit(sta);
 
-		/* Aggregation sessions during rekey are complicated due to the
+		/* Aggregation sessions during rekey are complicated by the
 		 * reorder buffer and retransmits. Side step that by blocking
 		 * aggregation during rekey and tear down running sessions.
 		 */
@@ -400,10 +459,6 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 
 	if (old) {
 		idx = old->conf.keyidx;
-		/* TODO: proper implement and test "Extended Key ID for
-		 * Individually Addressed Frames" from IEEE 802.11-2016.
-		 * Till then always assume only key ID 0 is used for
-		 * pairwise keys.*/
 		ret = ieee80211_hw_key_replace(old, new, pairwise);
 	} else {
 		/* new must be provided in case old is not */
@@ -420,15 +475,19 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	if (sta) {
 		if (pairwise) {
 			rcu_assign_pointer(sta->ptk[idx], new);
-			sta->ptk_idx = idx;
-			if (new) {
+			if (new && !(new->flags & KEY_FLAG_RX_ONLY)) {
+				sta->ptk_idx = idx;
 				clear_sta_flag(sta, WLAN_STA_BLOCK_BA);
 				ieee80211_check_fast_xmit(sta);
 			}
 		} else {
 			rcu_assign_pointer(sta->gtk[idx], new);
 		}
-		if (new)
+		/* Only needed when transition from no key -> key.
+		 * Still triggers unnecessary when using Extended Key ID
+		 * and installing the second key ID the first time.
+		 */
+		if (new && !old)
 			ieee80211_check_fast_rx(sta);
 	} else {
 		defunikey = old &&
@@ -664,6 +723,9 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key,
 
 		ieee80211_debugfs_key_remove(key);
 
+		if (key->flags & KEY_FLAG_RX_ONLY)
+			return;
+
 		if (delay_tailroom) {
 			/* see ieee80211_delayed_tailroom_dec */
 			sdata->crypto_tx_tailroom_pending_dec++;
@@ -744,16 +806,33 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	 * can cause warnings to appear.
 	 */
 	bool delay_tailroom = sdata->vif.type == NL80211_IFTYPE_STATION;
-	int ret;
+	bool rx_only = key->flags & KEY_FLAG_RX_ONLY;
+	int ret = -EOPNOTSUPP;
 
 	mutex_lock(&sdata->local->key_mtx);
 
-	if (sta && pairwise)
+	if (sta && pairwise) {
+		struct ieee80211_key *alt_key;
+
 		old_key = key_mtx_dereference(sdata->local, sta->ptk[idx]);
-	else if (sta)
+		alt_key = key_mtx_dereference(sdata->local, sta->ptk[idx ^ 1]);
+
+		/* Don't allow pairwise keys to change cipher on rekey */
+		if (key &&
+		    ((alt_key && alt_key->conf.cipher != key->conf.cipher) ||
+		     (old_key && old_key->conf.cipher != key->conf.cipher)))
+			goto out;
+	} else if (sta) {
 		old_key = key_mtx_dereference(sdata->local, sta->gtk[idx]);
-	else
+	} else {
 		old_key = key_mtx_dereference(sdata->local, sdata->keys[idx]);
+	}
+
+	/* Don't allow non-pairwise keys to change cipher on rekey */
+	if (!pairwise) {
+		if (key && old_key && old_key->conf.cipher != key->conf.cipher)
+			goto out;
+	}
 
 	/*
 	 * Silently accept key re-installation without really installing the
@@ -769,7 +848,8 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	key->sdata = sdata;
 	key->sta = sta;
 
-	increment_tailroom_need_count(sdata);
+	if (!rx_only)
+		increment_tailroom_need_count(sdata);
 
 	ret = ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
 
@@ -823,7 +903,8 @@ void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
 	}
 
 	list_for_each_entry(key, &sdata->key_list, list) {
-		increment_tailroom_need_count(sdata);
+		if (!(key->flags & KEY_FLAG_RX_ONLY))
+			increment_tailroom_need_count(sdata);
 		ieee80211_key_enable_hw_accel(key);
 	}
 
@@ -1193,7 +1274,8 @@ void ieee80211_remove_key(struct ieee80211_key_conf *keyconf)
 	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-		if (!(key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
+		if (!(key->flags & KEY_FLAG_RX_ONLY ||
+		      key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
 					 IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
 					 IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
 			increment_tailroom_need_count(key->sdata);
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index ebdb80b85dc3..1a3da999e0c4 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -18,6 +18,7 @@
 
 #define NUM_DEFAULT_KEYS 4
 #define NUM_DEFAULT_MGMT_KEYS 2
+#define INVALID_PTK_KEYIDX 2 /* Existing key slot never used by PTK keys */
 
 struct ieee80211_local;
 struct ieee80211_sub_if_data;
@@ -30,11 +31,13 @@ struct sta_info;
  *	in the hardware for TX crypto hardware acceleration.
  * @KEY_FLAG_TAINTED: Key is tainted and packets should be dropped.
  * @KEY_FLAG_CIPHER_SCHEME: This key is for a hardware cipher scheme
+ * @KEY_FLAG_RX_ONLY: Pairwise key only allowed to be used on Rx.
  */
 enum ieee80211_internal_key_flags {
 	KEY_FLAG_UPLOADED_TO_HARDWARE	= BIT(0),
 	KEY_FLAG_TAINTED		= BIT(1),
 	KEY_FLAG_CIPHER_SCHEME		= BIT(2),
+	KEY_FLAG_RX_ONLY		= BIT(3),
 };
 
 enum ieee80211_internal_tkip_state {
@@ -146,6 +149,7 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 int ieee80211_key_link(struct ieee80211_key *key,
 		       struct ieee80211_sub_if_data *sdata,
 		       struct sta_info *sta);
+int ieee80211_key_activate_tx(struct ieee80211_key *key);
 void ieee80211_key_free(struct ieee80211_key *key, bool delay_tailroom);
 void ieee80211_key_free_unused(struct ieee80211_key *key);
 void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 71005b6dfcd1..ea34544985f3 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1051,6 +1051,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		}
 	}
 
+	/* mac80211 supports Extended Key ID when driver does */
+	if (ieee80211_hw_check(&local->hw, EXT_KEY_ID_NATIVE))
+		wiphy_ext_feature_set(local->hw.wiphy,
+				      NL80211_EXT_FEATURE_EXT_KEY_ID);
+
 	/*
 	 * Calculate scan IE length -- we need this to alloc
 	 * memory and to subtract from the driver limit. It
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bb4d71efb6fb..ce786311baf4 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -988,23 +988,43 @@ static int ieee80211_get_mmie_keyidx(struct sk_buff *skb)
 	return -1;
 }
 
-static int ieee80211_get_cs_keyid(const struct ieee80211_cipher_scheme *cs,
-				  struct sk_buff *skb)
+static int ieee80211_get_keyid(struct sk_buff *skb,
+			       const struct ieee80211_cipher_scheme *cs)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	__le16 fc;
 	int hdrlen;
+	int minlen;
+	u8 key_idx_off;
+	u8 key_idx_shift;
 	u8 keyid;
 
 	fc = hdr->frame_control;
 	hdrlen = ieee80211_hdrlen(fc);
 
-	if (skb->len < hdrlen + cs->hdr_len)
+	if (cs) {
+		minlen = hdrlen + cs->hdr_len;
+		key_idx_off = hdrlen + cs->key_idx_off;
+		key_idx_shift = cs->key_idx_shift;
+	} else {
+		/* WEP, TKIP, CCMP and GCMP have the key id at the same place */
+		minlen = hdrlen + IEEE80211_WEP_IV_LEN;
+		key_idx_off = hdrlen + 3;
+		key_idx_shift = 6;
+	}
+
+	if (unlikely(skb->len < minlen))
 		return -EINVAL;
 
-	skb_copy_bits(skb, hdrlen + cs->key_idx_off, &keyid, 1);
-	keyid &= cs->key_idx_mask;
-	keyid >>= cs->key_idx_shift;
+	skb_copy_bits(skb, key_idx_off, &keyid, 1);
+
+	if (cs)
+		keyid &= cs->key_idx_mask;
+	keyid >>= key_idx_shift;
+
+	/* cs could use more than the usual two bits for the keyid */
+	if (unlikely(keyid > NUM_DEFAULT_KEYS))
+		return -EINVAL;
 
 	return keyid;
 }
@@ -1835,9 +1855,9 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	int keyidx;
-	int hdrlen;
 	ieee80211_rx_result result = RX_DROP_UNUSABLE;
 	struct ieee80211_key *sta_ptk = NULL;
+	struct ieee80211_key *ptk_idx = NULL;
 	int mmie_keyidx = -1;
 	__le16 fc;
 	const struct ieee80211_cipher_scheme *cs = NULL;
@@ -1875,21 +1895,24 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 
 	if (rx->sta) {
 		int keyid = rx->sta->ptk_idx;
+		sta_ptk = rcu_dereference(rx->sta->ptk[keyid]);
 
-		if (ieee80211_has_protected(fc) && rx->sta->cipher_scheme) {
+		if (ieee80211_has_protected(fc)) {
 			cs = rx->sta->cipher_scheme;
-			keyid = ieee80211_get_cs_keyid(cs, rx->skb);
+			keyid = ieee80211_get_keyid(rx->skb, cs);
+
 			if (unlikely(keyid < 0))
 				return RX_DROP_UNUSABLE;
+
+			ptk_idx = rcu_dereference(rx->sta->ptk[keyid]);
 		}
-		sta_ptk = rcu_dereference(rx->sta->ptk[keyid]);
 	}
 
 	if (!ieee80211_has_protected(fc))
 		mmie_keyidx = ieee80211_get_mmie_keyidx(rx->skb);
 
 	if (!is_multicast_ether_addr(hdr->addr1) && sta_ptk) {
-		rx->key = sta_ptk;
+		rx->key = ptk_idx ? ptk_idx : sta_ptk;
 		if ((status->flag & RX_FLAG_DECRYPTED) &&
 		    (status->flag & RX_FLAG_IV_STRIPPED))
 			return RX_CONTINUE;
@@ -1949,8 +1972,6 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		}
 		return RX_CONTINUE;
 	} else {
-		u8 keyid;
-
 		/*
 		 * The device doesn't give us the IV so we won't be
 		 * able to look up the key. That's ok though, we
@@ -1964,23 +1985,10 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		    (status->flag & RX_FLAG_IV_STRIPPED))
 			return RX_CONTINUE;
 
-		hdrlen = ieee80211_hdrlen(fc);
-
-		if (cs) {
-			keyidx = ieee80211_get_cs_keyid(cs, rx->skb);
+		keyidx = ieee80211_get_keyid(rx->skb, cs);
 
-			if (unlikely(keyidx < 0))
-				return RX_DROP_UNUSABLE;
-		} else {
-			if (rx->skb->len < 8 + hdrlen)
-				return RX_DROP_UNUSABLE; /* TODO: count this? */
-			/*
-			 * no need to call ieee80211_wep_get_keyidx,
-			 * it verifies a bunch of things we've done already
-			 */
-			skb_copy_bits(rx->skb, hdrlen + 3, &keyid, 1);
-			keyidx = keyid >> 6;
-		}
+		if (unlikely(keyidx < 0))
+			return RX_DROP_UNUSABLE;
 
 		/* check per-station GTK first, if multicast packet */
 		if (is_multicast_ether_addr(hdr->addr1) && rx->sta)
@@ -4020,12 +4028,8 @@ void ieee80211_check_fast_rx(struct sta_info *sta)
 		case WLAN_CIPHER_SUITE_GCMP_256:
 			break;
 		default:
-			/* we also don't want to deal with WEP or cipher scheme
-			 * since those require looking up the key idx in the
-			 * frame, rather than assuming the PTK is used
-			 * (we need to revisit this once we implement the real
-			 * PTK index, which is now valid in the spec, but we
-			 * haven't implemented that part yet)
+			/* We also don't want to deal with
+			 * WEP or cipher scheme.
 			 */
 			goto clear_rcu;
 		}
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 11f058987a54..09c69955c6e3 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -347,6 +347,15 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	sta->sta.max_rx_aggregation_subframes =
 		local->hw.max_rx_aggregation_subframes;
 
+	/* Extended Key ID can install keys for keyid 0 and 1 as Rx only.
+	 * Tx starts uses a key as soon as a key is installed in the slot
+	 * ptk_idx references to. To avoid using the initial Rx key prematurely
+	 * for Tx we initialize ptk_idx to a value never used, making sure the
+	 * referenced key is always NULL till ptk_idx is set to a valid value.
+	 */
+	BUILD_BUG_ON(ARRAY_SIZE(sta->ptk) <= INVALID_PTK_KEYIDX);
+	sta->ptk_idx = INVALID_PTK_KEYIDX;
+
 	sta->local = local;
 	sta->sdata = sdata;
 	sta->rx_stats.last_rx = jiffies;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 71f7e4973329..304a7ea24757 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -449,7 +449,7 @@ struct ieee80211_sta_rx_stats {
  * @local: pointer to the global information
  * @sdata: virtual interface this station belongs to
  * @ptk: peer keys negotiated with this station, if any
- * @ptk_idx: last installed peer key index
+ * @ptk_idx: peer key index to use for transmissions
  * @gtk: group keys negotiated with this station, if any
  * @rate_ctrl: rate control algorithm reference
  * @rate_ctrl_lock: spinlock used to protect rate control data
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8a49a74c0a37..111bd6c490a6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3000,23 +3000,15 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 		switch (build.key->conf.cipher) {
 		case WLAN_CIPHER_SUITE_CCMP:
 		case WLAN_CIPHER_SUITE_CCMP_256:
-			/* add fixed key ID */
-			if (gen_iv) {
-				(build.hdr + build.hdr_len)[3] =
-					0x20 | (build.key->conf.keyidx << 6);
+			if (gen_iv)
 				build.pn_offs = build.hdr_len;
-			}
 			if (gen_iv || iv_spc)
 				build.hdr_len += IEEE80211_CCMP_HDR_LEN;
 			break;
 		case WLAN_CIPHER_SUITE_GCMP:
 		case WLAN_CIPHER_SUITE_GCMP_256:
-			/* add fixed key ID */
-			if (gen_iv) {
-				(build.hdr + build.hdr_len)[3] =
-					0x20 | (build.key->conf.keyidx << 6);
+			if (gen_iv)
 				build.pn_offs = build.hdr_len;
-			}
 			if (gen_iv || iv_spc)
 				build.hdr_len += IEEE80211_GCMP_HDR_LEN;
 			break;
@@ -3383,6 +3375,7 @@ static void ieee80211_xmit_fast_finish(struct ieee80211_sub_if_data *sdata,
 			pn = atomic64_inc_return(&key->conf.tx_pn);
 			crypto_hdr[0] = pn;
 			crypto_hdr[1] = pn >> 8;
+			crypto_hdr[3] = 0x20 | (key->conf.keyidx << 6);
 			crypto_hdr[4] = pn >> 16;
 			crypto_hdr[5] = pn >> 24;
 			crypto_hdr[6] = pn >> 32;
-- 
2.20.1

