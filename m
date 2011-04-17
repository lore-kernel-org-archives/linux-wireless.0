Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52409 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab1DQV2S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Apr 2011 17:28:18 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	jouni.malinen@atheros.com
Subject: [PATCH 2/2] ath9k: assign keycache slots to unencrypted stations
Date: Sun, 17 Apr 2011 23:28:10 +0200
Message-Id: <1303075690-53804-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1303075690-53804-1-git-send-email-nbd@openwrt.org>
References: <1303075690-53804-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frame filtering relies on having a valid destination index (keycache slot),
to keep track of the destination. Assigning a keycache slot (configured
to unencrypted, with no key data attached) improves powersave handling in
AP mode with no encryption.
The dummy keycache entry for a station is cleared, when a real key gets
added.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 ++
 drivers/net/wireless/ath/ath9k/main.c  |   22 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/xmit.c  |   10 +++++++---
 drivers/net/wireless/ath/key.c         |    6 +++++-
 4 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a2ddabf..a6b5388 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -256,6 +256,8 @@ struct ath_node {
 #endif
 	struct ath_atx_tid tid[WME_NUM_TID];
 	struct ath_atx_ac ac[WME_NUM_AC];
+	int ps_key;
+
 	u16 maxampdu;
 	u8 mpdudensity;
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 44f4d59..a8d9009 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1736,18 +1736,37 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
 			 struct ieee80211_sta *sta)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_node *an = (struct ath_node *) sta->drv_priv;
+	struct ieee80211_key_conf ps_key = { };
 
 	ath_node_attach(sc, sta);
+	an->ps_key = ath_key_config(common, vif, sta, &ps_key);
 
 	return 0;
 }
 
+static void ath9k_del_ps_key(struct ath_softc *sc,
+			     struct ieee80211_vif *vif,
+			     struct ieee80211_sta *sta)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_node *an = (struct ath_node *) sta->drv_priv;
+	struct ieee80211_key_conf ps_key = { .hw_key_idx = an->ps_key };
+
+	if (!an->ps_key)
+	    return;
+
+	ath_key_delete(common, &ps_key);
+}
+
 static int ath9k_sta_remove(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta)
 {
 	struct ath_softc *sc = hw->priv;
 
+	ath9k_del_ps_key(sc, vif, sta);
 	ath_node_detach(sc, sta);
 
 	return 0;
@@ -1850,6 +1869,9 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 
 	switch (cmd) {
 	case SET_KEY:
+		if (sta)
+			ath9k_del_ps_key(sc, vif, sta);
+
 		ret = ath_key_config(common, vif, sta, key);
 		if (ret >= 0) {
 			key->hw_key_idx = ret;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a1230c0..e9e99f7 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1526,7 +1526,7 @@ static void setup_frame_info(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ieee80211_key_conf *hw_key = tx_info->control.hw_key;
 	struct ieee80211_hdr *hdr;
 	struct ath_frame_info *fi = get_frame_info(skb);
-	struct ath_node *an;
+	struct ath_node *an = NULL;
 	struct ath_atx_tid *tid;
 	enum ath9k_key_type keytype;
 	u16 seqno = 0;
@@ -1534,11 +1534,13 @@ static void setup_frame_info(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 	keytype = ath9k_cmn_get_hw_crypto_keytype(skb);
 
+	if (sta)
+		an = (struct ath_node *) sta->drv_priv;
+
 	hdr = (struct ieee80211_hdr *)skb->data;
-	if (sta && ieee80211_is_data_qos(hdr->frame_control) &&
+	if (an && ieee80211_is_data_qos(hdr->frame_control) &&
 		conf_is_ht(&hw->conf) && (sc->sc_flags & SC_OP_TXAGGR)) {
 
-		an = (struct ath_node *) sta->drv_priv;
 		tidno = ieee80211_get_qos_ctl(hdr)[0] & IEEE80211_QOS_CTL_TID_MASK;
 
 		/*
@@ -1554,6 +1556,8 @@ static void setup_frame_info(struct ieee80211_hw *hw, struct sk_buff *skb,
 	memset(fi, 0, sizeof(*fi));
 	if (hw_key)
 		fi->keyix = hw_key->hw_key_idx;
+	else if (an && ieee80211_is_data(hdr->frame_control) && an->ps_key > 0)
+		fi->keyix = an->ps_key;
 	else
 		fi->keyix = ATH9K_TXKEYIX_INVALID;
 	fi->keytype = keytype;
diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index 0d4f39c..a61ef3d6 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -483,6 +483,9 @@ int ath_key_config(struct ath_common *common,
 	memset(&hk, 0, sizeof(hk));
 
 	switch (key->cipher) {
+	case 0:
+		hk.kv_type = ATH_CIPHER_CLR;
+		break;
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
 		hk.kv_type = ATH_CIPHER_WEP;
@@ -498,7 +501,8 @@ int ath_key_config(struct ath_common *common,
 	}
 
 	hk.kv_len = key->keylen;
-	memcpy(hk.kv_val, key->key, key->keylen);
+	if (key->keylen)
+		memcpy(hk.kv_val, key->key, key->keylen);
 
 	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
 		switch (vif->type) {
-- 
1.7.3.2

