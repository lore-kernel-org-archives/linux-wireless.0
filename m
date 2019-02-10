Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D554C282C2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE6362145D
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:12:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="GkyFBPnr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfBJVMN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 16:12:13 -0500
Received: from 19.mo1.mail-out.ovh.net ([178.32.97.206]:53865 "EHLO
        19.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfBJVMN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 16:12:13 -0500
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Feb 2019 16:12:07 EST
Received: from player788.ha.ovh.net (unknown [10.109.160.217])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id ED257151001
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2019 22:06:48 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player788.ha.ovh.net (Postfix) with ESMTPSA id 82CB028A59EB;
        Sun, 10 Feb 2019 21:06:47 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1549832804;
        bh=Bi6wKFZvDqP5lEnl0JbuPMspQBjCBU2LQVzWifytkSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=GkyFBPnr/jA4/aYVFmkUxhv9bQrL/gYJxG00mBfbsiS5efCoD/MGJZqz2kj6tFuaB
         4JQqRC2Rsuglr5etAeYXAghXqsqS/BKK+lZYY/UYK7mozFzLtZv9jToC0QO9cg6XkZ
         J93Ebmsz8IadCN5Wld3Y/PVUht1d8m0xUVOiEGgM=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [RFC PATCH v3 04/12] mac80211: Compatibility Extended Key ID support
Date:   Sun, 10 Feb 2019 22:06:12 +0100
Message-Id: <20190210210620.31181-5-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190210210620.31181-1-alexander@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10549682127409388743
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrleehgdekhecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Allow drivers to support Extended Key ID when they are not able to
handle two unicast keys per station for Rx by falling back to software
decryption when replacing keys.

Rx HW decryption activation is delayed till we either get the first MPDU
encrypted with the new key or for max 10s.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---

Most drivers with the exception of ath10k should be able to support this
mode even without firmware updates from the vendors. (ath10k seems to be
a no-go without some firmware update, but that's not for discussion
here.)
Biggest downside are - besides the added complexity - potential severe
CPU peaks. (Imagine an rebooted AP with hundred of clients using
it with rekeying enabled and a weak CPU.) 

Also noteworthy is, that using HW Rx decryption here at all is kind of
breaking the standard: As soon as one Rx key is offloaded to the
hardware we are/may no longer be able to decrypt packets with the "other"
valid keyid. (The hardware may have tried to decrypt it with the wrong
key and then hands over the decryption failure instead of the original
data.) So this will only work correctly as long as the remote sta is
switching to the new keyid at a time within 10s and not mixing old and
new keyids for a while. If that assumption breaks, mac80211 will not be
able to decrypt mangled packets.
That said it seems unlikely that this could be much more than some
retransmits and I get perfect looking rekeys in my test setup with max a
few dozen packets decrypted in software.

 include/net/mac80211.h  | 46 ++++++++++++++++++++++++++++
 net/mac80211/debugfs.c  |  1 +
 net/mac80211/key.c      | 67 +++++++++++++++++++++++++++++++++++++++--
 net/mac80211/key.h      |  4 +++
 net/mac80211/main.c     |  3 +-
 net/mac80211/rx.c       |  7 +++++
 net/mac80211/sta_info.c |  3 ++
 net/mac80211/sta_info.h |  2 ++
 8 files changed, 129 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e16bc7623dc0..eafad5eb8953 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1814,12 +1814,16 @@ struct ieee80211_cipher_scheme {
  * @EXT_SET_KEY: a new key must be set but is only valid for decryption
  * @EXT_KEY_RX_TX: a key installed with @EXT_SET_KEY is becoming the
  *	designated Rx/Tx key for the station
+ * @EXT_DISABLE_KEY_RX: installed key must switch to to software decryption
+ *	while not altering Tx encryption. Command only required when driver
+ *	is using EXT_KEY_ID_COMPAT for Extended Key ID support.
  */
 enum set_key_cmd {
 	SET_KEY,
 	DISABLE_KEY,
 	EXT_SET_KEY,
 	EXT_KEY_RX_TX,
+	EXT_DISABLE_KEY_RX,
 };
 
 /**
@@ -2231,6 +2235,10 @@ struct ieee80211_txq {
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
@@ -2281,6 +2289,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_STA_MMPDU_TXQ,
 	IEEE80211_HW_TX_STATUS_NO_AMPDU_LEN,
 	IEEE80211_HW_EXT_KEY_ID_NATIVE,
+	IEEE80211_HW_EXT_KEY_ID_COMPAT,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
@@ -2641,6 +2650,43 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
    Mac80211 will not queue any new frames for a deleted key to the driver.
  */
 
+/**
+ * DOC: Extended Key ID support
+ *
+ * Mac80211 can support "Extended Key ID" from IEEE 802.11-2016, allowing to
+ * rekey the in-use unicast key with ideally zero impact for ongoing
+ * transmissions.
+ *
+ * There are two options for a driver to support Extended Key ID:
+ * 1) Native:
+ *    The "Native" Extended Key ID mode is using the key commands
+ *    %EXT_SET_KEY, %EXT_KEY_RX_TX and %DISABLE_KEY.
+ *    Drivers/cards fully compatible can set @IEEE80211_HW_EXT_KEY_ID_NATIVE,
+ *    allowing mac80211 to install two unicast keys per station to the driver.
+ *    Mac80211 will then inform the driver via %EXT_SET_KEY when a key must be
+ *    added for Rx decryption and again with %EXT_KEY_RX_TX when the driver has
+ *    to switch Tx to a new key. When the driver returns any other code than 0
+ *    for those two commands the key install is aborted and reported as failed.
+ *
+ * 2) Compatibility
+ *    This mode is for Drivers and cards which are not able to handle two
+ *    unicast key for a station on Rx, but are fine with it for Tx and can
+ *    pass trough the still encrypted MPDUs to mac80211.
+ *    The "Compatibility" Extended Key ID mode is using the key commands
+ *    %EXT_SET_KEY, %EXT_KEY_RX_TX, %EXT_DISABLE_KEY_RX and %DISABLE_KEY.
+ *    A driver setting @IEEE80211_HW_EXT_KEY_ID_COMPAT must
+ *    - implement %EXT_DISABLE_KEY_RX to switch a running key to Rx software
+ *      decryption without changing Tx handling for the key.
+ *    - Add a new key for Tx when called with %EXT_SET_KEY for the same station
+ *      with another keyid (to have a key ready allowing Tx)
+ *    - Optionally activate Rx decryption when called with %EXT_KEY_RX_TX
+ *    Only the command %EXT_KEY_RX_TX is allowed to return a value not 0, any
+ *    other command failing will abort the key install.
+ *
+ * Additionally any driver/card setting @IEEE80211_HW_EXT_KEY_ID_NATIVE or
+ * @IEEE80211_HW_EXT_KEY_ID_COMPAT must allow keyid 0 and 1 to for unicast keys.
+ */
+
 /**
  * DOC: Powersave support
  *
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 334a9883894f..01849b093287 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -220,6 +220,7 @@ static const char *hw_flag_names[] = {
 	FLAG(STA_MMPDU_TXQ),
 	FLAG(TX_STATUS_NO_AMPDU_LEN),
 	FLAG(EXT_KEY_ID_NATIVE),
+	FLAG(EXT_KEY_ID_COMPAT),
 #undef FLAG
 };
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index d91503de1e1d..7f673887ec50 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -184,10 +184,32 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		}
 	}
 
-	if (rx_only)
+	if (rx_only) {
+		/* EXT_KEY_ID_COMPAT drivers may scramble the payload when
+		 * using the wrong HW key for decryption. Therefore only use SW
+		 * decryption for the critical window.
+		 */
+		if (sta && pairwise && !ext_native && !local->wowlan &&
+		    sta->ptk_idx != key->conf.keyidx) {
+			struct ieee80211_key *old;
+
+			old = key_mtx_dereference(local,
+						  sta->ptk[sta->ptk_idx]);
+			if (old) {
+				if (drv_set_key(local, EXT_DISABLE_KEY_RX,
+						sdata, &sta->sta, &old->conf))
+					return -EINVAL;
+			}
+		}
+
+		/* Install the key to hardware. EXT_KEY_ID_NATIVE drivers can
+		 * use it for decryption but EXT_KEY_ID_COMPAT drivers must
+		 * prepare it as a not yet used Tx only key.
+		 */
 		cmd = EXT_SET_KEY;
-	else
+	} else {
 		cmd = SET_KEY;
+	}
 
 	ret = drv_set_key(local, cmd, sdata,
 			  sta ? &sta->sta : NULL, &key->conf);
@@ -282,6 +304,7 @@ int ieee80211_key_activate_tx(struct ieee80211_key *key)
 	struct sta_info *sta = key->sta;
 	struct ieee80211_local *local = key->local;
 	struct ieee80211_key *old;
+	bool ext_native = ieee80211_hw_check(&local->hw, EXT_KEY_ID_NATIVE);
 	int ret;
 
 	assert_key_lock(local);
@@ -294,7 +317,7 @@ int ieee80211_key_activate_tx(struct ieee80211_key *key)
 			       IEEE80211_KEY_FLAG_RESERVE_TAILROOM))
 		increment_tailroom_need_count(sdata);
 
-	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
+	if (ext_native && key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 		ret = drv_set_key(local, EXT_KEY_RX_TX, sdata,
 				  &sta->sta, &key->conf);
 		if (ret) {
@@ -309,6 +332,13 @@ int ieee80211_key_activate_tx(struct ieee80211_key *key)
 	sta->ptk_idx = key->conf.keyidx;
 	ieee80211_check_fast_xmit(sta);
 
+	if (!ext_native && key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
+		key->flags |= KEY_FLAG_RX_SW_CRYPTO;
+		/* Activate Rx crypto offload after max 10s when idle */
+		ieee80211_queue_delayed_work(&local->hw, &sta->ext_key_compat_wk,
+					     round_jiffies_relative(HZ * 10));
+	}
+
 	if (old) {
 		old->flags |= KEY_FLAG_RX_ONLY;
 
@@ -1109,6 +1139,37 @@ void ieee80211_free_sta_keys(struct ieee80211_local *local,
 	mutex_unlock(&local->key_mtx);
 }
 
+/* EXT_KEY_ID_COMPAT support can't install PTK keys to the card/driver for
+ * hardware decryption as long as the remote sta may use both keyids. Those
+ * cards are not aware that the keyid must be checked and try to decrypt the
+ * payload with the wrong key, which would effectively scrambling it. This
+ * worker is therefore used to activate Rx hardware decryption when we assume
+ * there will be only packets for the new key.
+ */
+void ext_key_compat_rx_offload_work(struct work_struct *wk)
+{
+	struct sta_info *sta;
+	struct ieee80211_local *local;
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_key *key;
+
+	sta = container_of(wk, struct sta_info, ext_key_compat_wk.work);
+	local = sta->local;
+	sdata = sta->sdata;
+
+	mutex_lock(&local->key_mtx);
+	key = key_mtx_dereference(local, sta->ptk[sta->ptk_idx]);
+
+	if (key->flags & KEY_FLAG_RX_SW_CRYPTO)
+		key->flags &= ~KEY_FLAG_RX_SW_CRYPTO;
+
+	if (drv_set_key(local, EXT_KEY_RX_TX, sdata, &sta->sta, &key->conf)) {
+		sdata_info(sdata, "Could not switch Rx to HW crypto (%d, %pM)\n",
+			   key->conf.keyidx, sta->sta.addr);
+	}
+	mutex_unlock(&local->key_mtx);
+}
+
 void ieee80211_delayed_tailroom_dec(struct work_struct *wk)
 {
 	struct ieee80211_sub_if_data *sdata;
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 1a3da999e0c4..d74c8c36491a 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -32,12 +32,15 @@ struct sta_info;
  * @KEY_FLAG_TAINTED: Key is tainted and packets should be dropped.
  * @KEY_FLAG_CIPHER_SCHEME: This key is for a hardware cipher scheme
  * @KEY_FLAG_RX_ONLY: Pairwise key only allowed to be used on Rx.
+ * @KEY_FLAG_RX_SW_CRYPTO: This key is using Rx SW decryption to work around HW
+ *	limitations. Flag can only set when using EXT_KEY_COMPAT for max 10s.
  */
 enum ieee80211_internal_key_flags {
 	KEY_FLAG_UPLOADED_TO_HARDWARE	= BIT(0),
 	KEY_FLAG_TAINTED		= BIT(1),
 	KEY_FLAG_CIPHER_SCHEME		= BIT(2),
 	KEY_FLAG_RX_ONLY		= BIT(3),
+	KEY_FLAG_RX_SW_CRYPTO		= BIT(4),
 };
 
 enum ieee80211_internal_tkip_state {
@@ -167,5 +170,6 @@ void ieee80211_reset_crypto_tx_tailroom(struct ieee80211_sub_if_data *sdata);
 	rcu_dereference_protected(ref, lockdep_is_held(&((local)->key_mtx)))
 
 void ieee80211_delayed_tailroom_dec(struct work_struct *wk);
+void ext_key_compat_rx_offload_work(struct work_struct *wk);
 
 #endif /* IEEE80211_KEY_H */
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index ea34544985f3..dbabfa58c4c9 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1052,7 +1052,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	}
 
 	/* mac80211 supports Extended Key ID when driver does */
-	if (ieee80211_hw_check(&local->hw, EXT_KEY_ID_NATIVE))
+	if (ieee80211_hw_check(&local->hw, EXT_KEY_ID_COMPAT) ||
+	    ieee80211_hw_check(&local->hw, EXT_KEY_ID_NATIVE))
 		wiphy_ext_feature_set(local->hw.wiphy,
 				      NL80211_EXT_FEATURE_EXT_KEY_ID);
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ce786311baf4..95c13f4c7e4a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2015,6 +2015,13 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		if (unlikely(rx->key->flags & KEY_FLAG_TAINTED))
 			return RX_DROP_MONITOR;
 
+		if (unlikely(rx->key->flags & KEY_FLAG_RX_SW_CRYPTO)) {
+			rx->key->flags &= ~KEY_FLAG_RX_SW_CRYPTO;
+			cancel_delayed_work(&rx->sta->ext_key_compat_wk);
+			ieee80211_queue_delayed_work(&rx->local->hw,
+						     &rx->sta->ext_key_compat_wk, 0);
+		}
+
 		/* TODO: add threshold stuff again */
 	} else {
 		return RX_DROP_MONITOR;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 09c69955c6e3..a20e05439173 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -132,6 +132,7 @@ static void __cleanup_single_sta(struct sta_info *sta)
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_sta_cleanup(sta);
 
+	cancel_delayed_work_sync(&sta->ext_key_compat_wk);
 	cancel_work_sync(&sta->drv_deliver_wk);
 
 	/*
@@ -326,6 +327,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	spin_lock_init(&sta->ps_lock);
 	INIT_WORK(&sta->drv_deliver_wk, sta_deliver_ps_frames);
 	INIT_WORK(&sta->ampdu_mlme.work, ieee80211_ba_session_work);
+	INIT_DELAYED_WORK(&sta->ext_key_compat_wk,
+			  ext_key_compat_rx_offload_work);
 	mutex_init(&sta->ampdu_mlme.mtx);
 #ifdef CONFIG_MAC80211_MESH
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 304a7ea24757..1fd1a349a875 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -450,6 +450,7 @@ struct ieee80211_sta_rx_stats {
  * @sdata: virtual interface this station belongs to
  * @ptk: peer keys negotiated with this station, if any
  * @ptk_idx: peer key index to use for transmissions
+ * @ext_key_compat_wk: supports PTK key installs when using EXT_KEY_ID_COMPAT
  * @gtk: group keys negotiated with this station, if any
  * @rate_ctrl: rate control algorithm reference
  * @rate_ctrl_lock: spinlock used to protect rate control data
@@ -530,6 +531,7 @@ struct sta_info {
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
 	struct ieee80211_key __rcu *ptk[NUM_DEFAULT_KEYS];
+	struct delayed_work ext_key_compat_wk;
 	u8 ptk_idx;
 	struct rate_control_ref *rate_ctrl;
 	void *rate_ctrl_priv;
-- 
2.20.1

