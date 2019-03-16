Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7475C4360F
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87C25218D0
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:42:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="VwyVdrkW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfCPUm2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 16:42:28 -0400
Received: from 9.mo7.mail-out.ovh.net ([46.105.60.248]:52006 "EHLO
        9.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbfCPUm2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 16:42:28 -0400
Received: from player793.ha.ovh.net (unknown [10.109.143.238])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id 661C4102DD5
        for <linux-wireless@vger.kernel.org>; Sat, 16 Mar 2019 21:42:23 +0100 (CET)
Received: from awhome.eu (p4FF91B93.dip0.t-ipconnect.de [79.249.27.147])
        (Authenticated sender: postmaster@awhome.eu)
        by player793.ha.ovh.net (Postfix) with ESMTPSA id 26E0B3D4F1FB;
        Sat, 16 Mar 2019 20:42:22 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1552768941;
        bh=Q7sDAM49amMrz/4tSp92SWSSEkwPalbzuZ2FNxCin9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=VwyVdrkWcm3ByMMDIbRAba+aiybY1zFVQj+ccHGLSgjuHIE+o41r9enFCv3LrLsb4
         LrZLoyle4YZwmdDXPwFtZdTJWs0tD/bFpf63j/yW9Sf7TEleRL23L5mrV50haWVw4g
         1xX4uBTA+8bdhlSP9mvxdQIwc+NXM358vVIHuqcw=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH 3/5] mac80211: Compatibility Extended Key ID support
Date:   Sat, 16 Mar 2019 21:42:06 +0100
Message-Id: <20190316204208.16497-4-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190316204208.16497-1-alexander@wetzel-home.de>
References: <20190316204208.16497-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6894729555110206663
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrheejgddugeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenuc
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Allow drivers to support Extended Key ID when they are not able to
handle two unicast keys per station for Rx by falling back to software
decryption when replacing keys.
Drivers using this mode may drop some MPDUs when Rx acceleration is
enabled too soon again. We rely on retransmits to recover the scrambled
MPDUs, making this better than a classical rekey but worse than NATIVE
Extended Key ID support.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
 include/net/mac80211.h  | 45 +++++++++++++++++++++++++++-
 net/mac80211/debugfs.c  |  1 +
 net/mac80211/key.c      | 65 ++++++++++++++++++++++++++++++++++++-----
 net/mac80211/key.h      |  5 ++++
 net/mac80211/main.c     |  8 +++--
 net/mac80211/rx.c       |  6 ++++
 net/mac80211/sta_info.c |  2 ++
 net/mac80211/sta_info.h |  3 ++
 8 files changed, 124 insertions(+), 11 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c10abca55fde..63bd3d5aa707 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1829,9 +1829,17 @@ struct ieee80211_cipher_scheme {
  *
  * @SET_KEY: a key is set
  * @DISABLE_KEY: a key must be disabled
+ *
+ * Additional driver commands for COMPAT Extended Key ID support:
+ *
+ * @ENABLE_KEY_RX: Rx acceleration can be activated for a key
+ * @DISABLE_KEY_RX: Rx acceleration must be deactivated for a key
  */
 enum set_key_cmd {
-	SET_KEY, DISABLE_KEY,
+	SET_KEY,
+	DISABLE_KEY,
+	ENABLE_KEY_RX,
+	DISABLE_KEY_RX,
 };
 
 /**
@@ -2248,6 +2256,10 @@ struct ieee80211_txq {
  * @IEEE80211_HW_EXT_KEY_ID_NATIVE: Driver and hardware are supporting Extended
  *	Key ID and can handle two unicast keys per station for Rx and Tx.
  *
+ * @IEEE80211_HW_EXT_KEY_ID_COMPAT: Driver and hardware support Extended Key ID
+ *	when mac80211 handles Rx decryption during transition from one keyid to
+ *	the next.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2300,6 +2312,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_MULTI_BSSID,
 	IEEE80211_HW_SUPPORTS_ONLY_HE_MULTI_BSSID,
 	IEEE80211_HW_EXT_KEY_ID_NATIVE,
+	IEEE80211_HW_EXT_KEY_ID_COMPAT,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
@@ -2660,6 +2673,36 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
    Mac80211 will not queue any new frames for a deleted key to the driver.
  */
 
+/**
+ * DOC: Extended Key ID support
+ *
+ * Mac80211 supports "Extended Key ID" from IEEE 802.11-2016, allowing to rekey
+ * the in-use unicast key with no impact for ongoing transmissions.
+ *
+ * There are two ways mac80211 drivers can support Extended Key ID:
+ * 1) Native
+ *    When using "Native" Extended Key ID mode mac80211 can install two unicast
+ *    keys per station to the driver, using the two key IDs "0" and "1".
+ *    Compatible drivers/cards can simply set @IEEE80211_HW_EXT_KEY_ID_NATIVE,
+ *    allowing mac80211 to install two unicast keys per station to the driver
+ *    with %SET_KEY.
+ *
+ * 2) Compatibility
+ *    This mode is for drivers and cards which are not able to handle two
+ *    unicast key for a station for Rx. For drivers setting
+ *    @IEEE80211_HW_EXT_KEY_ID_COMPAT mac80211 will make sure that never more
+ *    than one unicast key is active for Rx in the hardware, falling back to
+ *    software decryption while installing a new unicast key. Divers using this
+ *    mode must implement the additional key commands %ENABLE_KEY_RX and
+ *    %DISABLE_KEY_RX to allow switching Rx crypto offload on and off without
+ *    impact for Tx. Drivers also must not activate Rx crypto offload when
+ *    %SET_KEY is called for a key with @IEEE80211_KEY_FLAG_NO_AUTO_TX set.
+ *    Compatibility mode will only be really lossless when there is a clean cut
+ *    over to the new key and MPDUs using both key IDs are not mixed. It can
+ *    also cause CPU spikes when falling back to software encryption, depending
+ *    on the amount of Rx packets at that time.
+ */
+
 /**
  * DOC: Powersave support
  *
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index aa6f23e1a457..9c4899aaf346 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -222,6 +222,7 @@ static const char *hw_flag_names[] = {
 	FLAG(SUPPORTS_MULTI_BSSID),
 	FLAG(SUPPORTS_ONLY_HE_MULTI_BSSID),
 	FLAG(EXT_KEY_ID_NATIVE),
+	FLAG(EXT_KEY_ID_COMPAT),
 #undef FLAG
 };
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 20bf9db7a388..bd38167916ad 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -127,7 +127,9 @@ static void decrease_tailroom_need_count(struct ieee80211_sub_if_data *sdata,
 static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 {
 	struct ieee80211_sub_if_data *sdata = key->sdata;
+	struct ieee80211_local *local = key->local;
 	struct sta_info *sta;
+	bool pairwise = key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE;
 	int ret = -EOPNOTSUPP;
 
 	might_sleep();
@@ -150,10 +152,10 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		return -EINVAL;
 	}
 
-	if (!key->local->ops->set_key)
+	if (!local->ops->set_key)
 		goto out_unsupported;
 
-	assert_key_lock(key->local);
+	assert_key_lock(local);
 
 	sta = key->sta;
 
@@ -161,8 +163,8 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	 * If this is a per-STA GTK, check if it
 	 * is supported; if not, return.
 	 */
-	if (sta && !(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE) &&
-	    !ieee80211_hw_check(&key->local->hw, SUPPORTS_PER_STA_GTK))
+	if (sta && !pairwise &&
+	    !ieee80211_hw_check(&local->hw, SUPPORTS_PER_STA_GTK))
 		goto out_unsupported;
 
 	if (sta && !sta->uploaded)
@@ -173,13 +175,33 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
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
+	if (key->conf.flags & IEEE80211_KEY_FLAG_NO_AUTO_TX) {
+		/* EXT_KEY_ID_COMPAT drivers may scramble the payload when
+		 * using the wrong HW key for decryption. Therefore only use SW
+		 * decryption for the critical window.
+		 */
+		if (sta && pairwise && !local->wowlan &&
+		    ieee80211_hw_check(&local->hw, EXT_KEY_ID_COMPAT) &&
+		    sta->ptk_idx != key->conf.keyidx) {
+			struct ieee80211_key *old;
+
+			old = key_mtx_dereference(local,
+						  sta->ptk[sta->ptk_idx]);
+			if (old) {
+				if (drv_set_key(local, DISABLE_KEY_RX,
+						sdata, &sta->sta, &old->conf))
+					return -EINVAL;
+			}
+		}
+	}
+
+	ret = drv_set_key(local, SET_KEY, sdata,
 			  sta ? &sta->sta : NULL, &key->conf);
 
 	if (!ret) {
@@ -221,7 +243,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		/* all of these we can do in software - if driver can */
 		if (ret == 1)
 			return 0;
-		if (ieee80211_hw_check(&key->local->hw, SW_CRYPTO_CONTROL))
+		if (ieee80211_hw_check(&local->hw, SW_CRYPTO_CONTROL))
 			return -EINVAL;
 		return 0;
 	default:
@@ -276,6 +298,10 @@ int ieee80211_set_tx_key(struct ieee80211_key *key)
 	sta->ptk_idx = key->conf.keyidx;
 	ieee80211_check_fast_xmit(sta);
 
+	if (ieee80211_hw_check(&local->hw, EXT_KEY_ID_COMPAT) &&
+	    key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
+		key->flags |= KEY_FLAG_DELAYED_RX_ACCEL;
+
 	return 0;
 }
 
@@ -1063,6 +1089,31 @@ void ieee80211_free_sta_keys(struct ieee80211_local *local,
 	mutex_unlock(&local->key_mtx);
 }
 
+/* EXT_KEY_ID_COMPAT support can't install PTK keys to the card/driver for
+ * hardware decryption as long as the remote sta may use both keyids. Those
+ * cards are not aware that the keyid must be checked and try to decrypt the
+ * payload with the wrong key, which would effectively scrambling it. This
+ * worker is therefore used to activate Rx hardware decryption when we assume
+ * the remote sta has switched over to the new key.
+ */
+void delayed_rx_accel_work(struct work_struct *wk)
+{
+	struct sta_info *sta;
+	struct ieee80211_local *local;
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_key *key;
+
+	sta = container_of(wk, struct sta_info, delayed_rx_accel_wk);
+	local = sta->local;
+	sdata = sta->sdata;
+
+	mutex_lock(&local->key_mtx);
+	key = key_mtx_dereference(local, sta->ptk[sta->ptk_idx]);
+	drv_set_key(local, ENABLE_KEY_RX, sdata, &sta->sta, &key->conf);
+
+	mutex_unlock(&local->key_mtx);
+}
+
 void ieee80211_delayed_tailroom_dec(struct work_struct *wk)
 {
 	struct ieee80211_sub_if_data *sdata;
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index f06fbd03d235..21e8618b1d55 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -31,11 +31,15 @@ struct sta_info;
  *	in the hardware for TX crypto hardware acceleration.
  * @KEY_FLAG_TAINTED: Key is tainted and packets should be dropped.
  * @KEY_FLAG_CIPHER_SCHEME: This key is for a hardware cipher scheme
+ * @KEY_FLAG_DELAYED_RX_ACCEL: This key has to use Rx SW decryption till we get
+ *	at least one MPDU from the remote sta encrypted with the key. (Needed
+ *	for COMPAT Extended ID support.)
  */
 enum ieee80211_internal_key_flags {
 	KEY_FLAG_UPLOADED_TO_HARDWARE	= BIT(0),
 	KEY_FLAG_TAINTED		= BIT(1),
 	KEY_FLAG_CIPHER_SCHEME		= BIT(2),
+	KEY_FLAG_DELAYED_RX_ACCEL	= BIT(3),
 };
 
 enum ieee80211_internal_tkip_state {
@@ -165,5 +169,6 @@ void ieee80211_reset_crypto_tx_tailroom(struct ieee80211_sub_if_data *sdata);
 	rcu_dereference_protected(ref, lockdep_is_held(&((local)->key_mtx)))
 
 void ieee80211_delayed_tailroom_dec(struct work_struct *wk);
+void delayed_rx_accel_work(struct work_struct *wk);
 
 #endif /* IEEE80211_KEY_H */
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c212615f1bdc..2ce747d43a81 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1058,11 +1058,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	switch (ieee80211_extended_key_id) {
 	case 2:
-		/* Force on */
-		ieee80211_hw_set(&local->hw, EXT_KEY_ID_NATIVE);
+		/* Force on when driver is not supporting COMPAT mode */
+		if (!ieee80211_hw_check(&local->hw, EXT_KEY_ID_COMPAT))
+			ieee80211_hw_set(&local->hw, EXT_KEY_ID_NATIVE);
 		/* fall trough */
 	case 1:
-		if (ieee80211_hw_check(&local->hw, EXT_KEY_ID_NATIVE))
+		if (ieee80211_hw_check(&local->hw, EXT_KEY_ID_COMPAT) ||
+		    ieee80211_hw_check(&local->hw, EXT_KEY_ID_NATIVE))
 			wiphy_ext_feature_set(local->hw.wiphy,
 					      NL80211_EXT_FEATURE_EXT_KEY_ID);
 		wiphy_info(hw->wiphy, "Extended Key ID support enabled.\n");
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 4a03c18b39a8..e3e4fb1073d6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2032,6 +2032,12 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		if (unlikely(rx->key->flags & KEY_FLAG_TAINTED))
 			return RX_DROP_MONITOR;
 
+		if (unlikely(rx->key->flags & KEY_FLAG_DELAYED_RX_ACCEL)) {
+			rx->key->flags &= ~KEY_FLAG_DELAYED_RX_ACCEL;
+			ieee80211_queue_work(&rx->local->hw,
+					     &rx->sta->delayed_rx_accel_wk);
+		}
+
 		/* TODO: add threshold stuff again */
 	} else {
 		return RX_DROP_MONITOR;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 7c61f6aee873..41ea1d05a946 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -132,6 +132,7 @@ static void __cleanup_single_sta(struct sta_info *sta)
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_sta_cleanup(sta);
 
+	cancel_work_sync(&sta->delayed_rx_accel_wk);
 	cancel_work_sync(&sta->drv_deliver_wk);
 
 	/*
@@ -326,6 +327,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	spin_lock_init(&sta->ps_lock);
 	INIT_WORK(&sta->drv_deliver_wk, sta_deliver_ps_frames);
 	INIT_WORK(&sta->ampdu_mlme.work, ieee80211_ba_session_work);
+	INIT_WORK(&sta->delayed_rx_accel_wk, delayed_rx_accel_work);
 	mutex_init(&sta->ampdu_mlme.mtx);
 #ifdef CONFIG_MAC80211_MESH
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 71f7e4973329..45f7cbfe9698 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -450,6 +450,8 @@ struct ieee80211_sta_rx_stats {
  * @sdata: virtual interface this station belongs to
  * @ptk: peer keys negotiated with this station, if any
  * @ptk_idx: last installed peer key index
+ * @delayed_rx_accel_wk: Used to activate Rx crypto offload only after
+ *	we have	seen one MPDU encrypted with the key.
  * @gtk: group keys negotiated with this station, if any
  * @rate_ctrl: rate control algorithm reference
  * @rate_ctrl_lock: spinlock used to protect rate control data
@@ -530,6 +532,7 @@ struct sta_info {
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
 	struct ieee80211_key __rcu *ptk[NUM_DEFAULT_KEYS];
+	struct work_struct delayed_rx_accel_wk;
 	u8 ptk_idx;
 	struct rate_control_ref *rate_ctrl;
 	void *rate_ctrl_priv;
-- 
2.21.0

