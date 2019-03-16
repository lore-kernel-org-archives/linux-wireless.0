Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34159C10F03
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1614218D4
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:42:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="k1KZ0VfM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfCPUm1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 16:42:27 -0400
Received: from 3.mo177.mail-out.ovh.net ([46.105.36.172]:44565 "EHLO
        3.mo177.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbfCPUm1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 16:42:27 -0400
Received: from player770.ha.ovh.net (unknown [10.109.143.249])
        by mo177.mail-out.ovh.net (Postfix) with ESMTP id 6B3DCE4E21
        for <linux-wireless@vger.kernel.org>; Sat, 16 Mar 2019 21:42:23 +0100 (CET)
Received: from awhome.eu (p4FF91B93.dip0.t-ipconnect.de [79.249.27.147])
        (Authenticated sender: postmaster@awhome.eu)
        by player770.ha.ovh.net (Postfix) with ESMTPSA id 176AC3BF8024;
        Sat, 16 Mar 2019 20:42:22 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1552768941;
        bh=K6drBFFx3/0EzZQwGdHncaZWhJ4EYYdNLk7mFx8AWdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=k1KZ0VfMw5JGWFWMOEqqpAe5xDQSSiMZ7poQjBaEezLOexNIy++A8EEhyEr6TWOE3
         dgjUzJrWY85igeZEe/0PRYjrjOsz6OTLToalnyZ76fWkD5/esZyQOLa64w2m9d/eIb
         W3iDonf3cOK8XqsqjqztjshKl3fP4K/FLL4ueT+w=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH 2/5] mac80211: IEEE 802.11 Extended Key ID support
Date:   Sat, 16 Mar 2019 21:42:05 +0100
Message-Id: <20190316204208.16497-3-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190316204208.16497-1-alexander@wetzel-home.de>
References: <20190316204208.16497-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6894729555619093703
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrheejgddugeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenuc
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add support for Extended Key ID as defined in IEEE 802.11-2016.

 - Implement the nl80211 API for Extended Key ID
 - Extend mac80211 API to allow drivers to support Extended Key ID
 - Allow unicast Tx usage to be supressed (IEEE80211_KEY_FLAG_NO_AUTO_TX)
 - Select the decryption key based on the MPDU keyid
 - Enforce existing assumptions in the code that rekeys don't change the
   cipher

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---

Bugs fixed compared to last RFC patch:
 - Off by one: ieee80211_get_keyid() no longer accepts invalid keyID 4
   

 include/net/mac80211.h     |  6 ++++
 net/mac80211/cfg.c         | 36 +++++++++++++++++++
 net/mac80211/debugfs.c     |  1 +
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/key.c         | 63 ++++++++++++++++++++++++--------
 net/mac80211/key.h         |  2 ++
 net/mac80211/main.c        | 21 +++++++++++
 net/mac80211/rx.c          | 74 ++++++++++++++++++++------------------
 net/mac80211/sta_info.c    |  9 +++++
 net/mac80211/tx.c          | 13 ++-----
 10 files changed, 167 insertions(+), 60 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ac2ed8ec662b..c10abca55fde 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1697,6 +1697,7 @@ struct wireless_dev *ieee80211_vif_to_wdev(struct ieee80211_vif *vif);
  * @IEEE80211_KEY_FLAG_PUT_MIC_SPACE: This flag should be set by the driver for
  *	a TKIP key if it only requires MIC space. Do not set together with
  *	@IEEE80211_KEY_FLAG_GENERATE_MMIC on the same key.
+ * @IEEE80211_KEY_FLAG_NO_AUTO_TX: Key needs explicit Tx activation.
  */
 enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_GENERATE_IV_MGMT	= BIT(0),
@@ -1708,6 +1709,7 @@ enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_RX_MGMT		= BIT(6),
 	IEEE80211_KEY_FLAG_RESERVE_TAILROOM	= BIT(7),
 	IEEE80211_KEY_FLAG_PUT_MIC_SPACE	= BIT(8),
+	IEEE80211_KEY_FLAG_NO_AUTO_TX		= BIT(9),
 };
 
 /**
@@ -2243,6 +2245,9 @@ struct ieee80211_txq {
  * @IEEE80211_HW_SUPPORTS_ONLY_HE_MULTI_BSSID: Hardware supports multi BSSID
  *	only for HE APs. Applies if @IEEE80211_HW_SUPPORTS_MULTI_BSSID is set.
  *
+ * @IEEE80211_HW_EXT_KEY_ID_NATIVE: Driver and hardware are supporting Extended
+ *	Key ID and can handle two unicast keys per station for Rx and Tx.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2294,6 +2299,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TX_STATUS_NO_AMPDU_LEN,
 	IEEE80211_HW_SUPPORTS_MULTI_BSSID,
 	IEEE80211_HW_SUPPORTS_ONLY_HE_MULTI_BSSID,
+	IEEE80211_HW_EXT_KEY_ID_NATIVE,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 09dd1c2860fc..14bbb7e8ad0e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -351,6 +351,36 @@ static int ieee80211_set_noack_map(struct wiphy *wiphy,
 	return 0;
 }
 
+static int ieee80211_set_tx(struct ieee80211_sub_if_data *sdata,
+			    const u8 *mac_addr, u8 key_idx)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_key *key;
+	struct sta_info *sta;
+	int ret = -EINVAL;
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
+	if (key && key->conf.flags & IEEE80211_KEY_FLAG_NO_AUTO_TX)
+		ret = ieee80211_set_tx_key(key);
+
+	mutex_unlock(&local->key_mtx);
+	return ret;
+}
+
 static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 			     u8 key_idx, bool pairwise, const u8 *mac_addr,
 			     struct key_params *params)
@@ -365,6 +395,9 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	if (!ieee80211_sdata_running(sdata))
 		return -ENETDOWN;
 
+	if (pairwise && params->mode == NL80211_KEY_SET_TX)
+		return ieee80211_set_tx(sdata, mac_addr, key_idx);
+
 	/* reject WEP and TKIP keys if WEP failed to initialize */
 	switch (params->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
@@ -396,6 +429,9 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	if (pairwise)
 		key->conf.flags |= IEEE80211_KEY_FLAG_PAIRWISE;
 
+	if (params->mode == NL80211_KEY_NO_TX)
+		key->conf.flags |= IEEE80211_KEY_FLAG_NO_AUTO_TX;
+
 	mutex_lock(&local->sta_mtx);
 
 	if (mac_addr) {
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 2d43bc127043..aa6f23e1a457 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -221,6 +221,7 @@ static const char *hw_flag_names[] = {
 	FLAG(TX_STATUS_NO_AMPDU_LEN),
 	FLAG(SUPPORTS_MULTI_BSSID),
 	FLAG(SUPPORTS_ONLY_HE_MULTI_BSSID),
+	FLAG(EXT_KEY_ID_NATIVE),
 #undef FLAG
 };
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e170f986d226..e5d95d2233e3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1269,7 +1269,7 @@ struct ieee80211_local {
 
 	/*
 	 * Key mutex, protects sdata's key_list and sta_info's
-	 * key pointers (write access, they're RCU.)
+	 * key pointers and ptk_idx (write access, they're RCU.)
 	 */
 	struct mutex key_mtx;
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index b9f2bfc00263..20bf9db7a388 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -264,9 +264,24 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 			  sta ? sta->sta.addr : bcast_addr, ret);
 }
 
+int ieee80211_set_tx_key(struct ieee80211_key *key)
+{
+	struct sta_info *sta = key->sta;
+	struct ieee80211_local *local = key->local;
+	struct ieee80211_key *old;
+
+	assert_key_lock(local);
+
+	old = key_mtx_dereference(local, sta->ptk[sta->ptk_idx]);
+	sta->ptk_idx = key->conf.keyidx;
+	ieee80211_check_fast_xmit(sta);
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
@@ -283,8 +298,9 @@ static int ieee80211_hw_key_replace(struct ieee80211_key *old_key,
 	assert_key_lock(old_key->local);
 	sta = old_key->sta;
 
-	/* PTK only using key ID 0 needs special handling on rekey */
-	if (new_key && sta && ptk0rekey) {
+	/* Unicast rekey without Extended Key ID needs special handling */
+	if (new_key && sta && pairwise &&
+	    rcu_access_pointer(sta->ptk[sta->ptk_idx]) == old_key) {
 		local = old_key->local;
 		sdata = old_key->sdata;
 
@@ -400,10 +416,6 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 
 	if (old) {
 		idx = old->conf.keyidx;
-		/* TODO: proper implement and test "Extended Key ID for
-		 * Individually Addressed Frames" from IEEE 802.11-2016.
-		 * Till then always assume only key ID 0 is used for
-		 * pairwise keys.*/
 		ret = ieee80211_hw_key_replace(old, new, pairwise);
 	} else {
 		/* new must be provided in case old is not */
@@ -420,15 +432,20 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	if (sta) {
 		if (pairwise) {
 			rcu_assign_pointer(sta->ptk[idx], new);
-			sta->ptk_idx = idx;
-			if (new) {
+			if (new &&
+			    !(new->conf.flags & IEEE80211_KEY_FLAG_NO_AUTO_TX)) {
+				sta->ptk_idx = idx;
 				clear_sta_flag(sta, WLAN_STA_BLOCK_BA);
 				ieee80211_check_fast_xmit(sta);
 			}
 		} else {
 			rcu_assign_pointer(sta->gtk[idx], new);
 		}
-		if (new)
+		/* Only needed for transition from no key -> key.
+		 * Still triggers unnecessary when using Extended Key ID
+		 * and installing the second key ID the first time.
+		 */
+		if (new && !old)
 			ieee80211_check_fast_rx(sta);
 	} else {
 		defunikey = old &&
@@ -744,16 +761,34 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	 * can cause warnings to appear.
 	 */
 	bool delay_tailroom = sdata->vif.type == NL80211_IFTYPE_STATION;
-	int ret;
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
+		/* The rekey code assumes that the old and new key are using
+		 * the same cipher. Enforce the assumption for pairwise keys.
+		 */
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
+	/* Non-pairwise keys must also not switch the cipher on rekey */
+	if (!pairwise) {
+		if (key && old_key && old_key->conf.cipher != key->conf.cipher)
+			goto out;
+	}
 
 	/*
 	 * Silently accept key re-installation without really installing the
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index ebdb80b85dc3..f06fbd03d235 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -18,6 +18,7 @@
 
 #define NUM_DEFAULT_KEYS 4
 #define NUM_DEFAULT_MGMT_KEYS 2
+#define INVALID_PTK_KEYIDX 2 /* Keyidx always pointing to a NULL key for PTK */
 
 struct ieee80211_local;
 struct ieee80211_sub_if_data;
@@ -146,6 +147,7 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 int ieee80211_key_link(struct ieee80211_key *key,
 		       struct ieee80211_sub_if_data *sdata,
 		       struct sta_info *sta);
+int ieee80211_set_tx_key(struct ieee80211_key *key);
 void ieee80211_key_free(struct ieee80211_key *key, bool delay_tailroom);
 void ieee80211_key_free_unused(struct ieee80211_key *key);
 void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 800e67615e2a..c212615f1bdc 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -35,6 +35,11 @@
 #include "led.h"
 #include "debugfs.h"
 
+static int ieee80211_extended_key_id = 1; /* Driver setting */
+module_param(ieee80211_extended_key_id, int, 0444);
+MODULE_PARM_DESC(ieee80211_extended_key_id,
+		 "IEEE 802.11 Extended Key ID support. 0: Force off 1: Driver setting 2: Force on. (default: 1)");
+
 void ieee80211_configure_filter(struct ieee80211_local *local)
 {
 	u64 mc;
@@ -1051,6 +1056,22 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		}
 	}
 
+	switch (ieee80211_extended_key_id) {
+	case 2:
+		/* Force on */
+		ieee80211_hw_set(&local->hw, EXT_KEY_ID_NATIVE);
+		/* fall trough */
+	case 1:
+		if (ieee80211_hw_check(&local->hw, EXT_KEY_ID_NATIVE))
+			wiphy_ext_feature_set(local->hw.wiphy,
+					      NL80211_EXT_FEATURE_EXT_KEY_ID);
+		wiphy_info(hw->wiphy, "Extended Key ID support enabled.\n");
+		break;
+	default:
+		/* Force off */
+		wiphy_info(hw->wiphy, "Extended Key ID not supported.\n");
+	}
+
 	/*
 	 * Calculate scan IE length -- we need this to alloc
 	 * memory and to subtract from the driver limit. It
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7f8d93401ce0..4a03c18b39a8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1005,23 +1005,43 @@ static int ieee80211_get_mmie_keyidx(struct sk_buff *skb)
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
+		/* WEP, TKIP, CCMP and GCMP */
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
+	if (unlikely(keyid >= NUM_DEFAULT_KEYS))
+		return -EINVAL;
 
 	return keyid;
 }
@@ -1852,9 +1872,9 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
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
@@ -1892,21 +1912,24 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 
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
@@ -1966,8 +1989,6 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		}
 		return RX_CONTINUE;
 	} else {
-		u8 keyid;
-
 		/*
 		 * The device doesn't give us the IV so we won't be
 		 * able to look up the key. That's ok though, we
@@ -1981,23 +2002,10 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
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
@@ -4042,12 +4050,8 @@ void ieee80211_check_fast_rx(struct sta_info *sta)
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
index 11f058987a54..7c61f6aee873 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -347,6 +347,15 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	sta->sta.max_rx_aggregation_subframes =
 		local->hw.max_rx_aggregation_subframes;
 
+	/* Extended Key ID needs to install keys for keyid 0 and 1 Rx-only.
+	 * The Tx path starts to use a key as soon as the key slot ptk_idx
+	 * references to is not NULL. To not use the initial Rx-only key
+	 * prematurely for Tx initialize ptk_idx to an impossible PTK keyid
+	 * which always will refer to a NULL key.
+	 */
+	BUILD_BUG_ON(ARRAY_SIZE(sta->ptk) <= INVALID_PTK_KEYIDX);
+	sta->ptk_idx = INVALID_PTK_KEYIDX;
+
 	sta->local = local;
 	sta->sdata = sdata;
 	sta->rx_stats.last_rx = jiffies;
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
2.21.0

