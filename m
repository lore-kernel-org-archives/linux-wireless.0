Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:56204 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771AbYFQQAZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 12:00:25 -0400
Message-Id: <20080617155920.329586297@localhost> (sfid-20080617_180055_062154_A23CFAF9)
References: <20080617154008.883383150@localhost>
Date: Tue, 17 Jun 2008 18:40:12 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 4/7] 802.11w: Use BIP (AES-128-CMAC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add mechanism for managing BIP keys (IGTK) and integrate BIP into the
TX/RX paths.

Signed-off-by: Jouni Malinen <j@w1.fi>


Index: wireless-testing/include/linux/ieee80211.h
===================================================================
--- wireless-testing.orig/include/linux/ieee80211.h
+++ wireless-testing/include/linux/ieee80211.h
@@ -909,6 +909,7 @@ enum ieee80211_back_parties {
 /* reserved: 				0x000FAC03 */
 #define WLAN_CIPHER_SUITE_CCMP		0x000FAC04
 #define WLAN_CIPHER_SUITE_WEP104	0x000FAC05
+#define WLAN_CIPHER_SUITE_AES_CMAC	0x000FAC06
 
 #define WLAN_MAX_KEY_LEN		32
 
Index: wireless-testing/include/net/mac80211.h
===================================================================
--- wireless-testing.orig/include/net/mac80211.h
+++ wireless-testing/include/net/mac80211.h
@@ -550,11 +550,13 @@ struct ieee80211_if_conf {
  * @ALG_WEP: WEP40 or WEP104
  * @ALG_TKIP: TKIP
  * @ALG_CCMP: CCMP (AES)
+ * @ALG_AES_CMAC: AES-128-CMAC
  */
 enum ieee80211_key_alg {
 	ALG_WEP,
 	ALG_TKIP,
 	ALG_CCMP,
+	ALG_AES_CMAC,
 };
 
 
Index: wireless-testing/net/mac80211/cfg.c
===================================================================
--- wireless-testing.orig/net/mac80211/cfg.c
+++ wireless-testing/net/mac80211/cfg.c
@@ -156,6 +156,9 @@ static int ieee80211_add_key(struct wiph
 	case WLAN_CIPHER_SUITE_CCMP:
 		alg = ALG_CCMP;
 		break;
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+		alg = ALG_AES_CMAC;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -296,6 +299,17 @@ static int ieee80211_get_key(struct wiph
 		else
 			params.cipher = WLAN_CIPHER_SUITE_WEP104;
 		break;
+	case ALG_AES_CMAC:
+		params.cipher = WLAN_CIPHER_SUITE_AES_CMAC;
+		seq[0] = key->u.aes_cmac.tx_pn[5];
+		seq[1] = key->u.aes_cmac.tx_pn[4];
+		seq[2] = key->u.aes_cmac.tx_pn[3];
+		seq[3] = key->u.aes_cmac.tx_pn[2];
+		seq[4] = key->u.aes_cmac.tx_pn[1];
+		seq[5] = key->u.aes_cmac.tx_pn[0];
+		params.seq = seq;
+		params.seq_len = 6;
+		break;
 	}
 
 	params.key = key->conf.key;
@@ -325,6 +339,22 @@ static int ieee80211_config_default_key(
 	return 0;
 }
 
+static int ieee80211_config_default_mgmt_key(struct wiphy *wiphy,
+					     struct net_device *dev,
+					     u8 key_idx)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	rcu_read_lock();
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	ieee80211_set_default_mgmt_key(sdata, key_idx);
+
+	rcu_read_unlock();
+
+	return 0;
+}
+
 static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -964,6 +994,7 @@ struct cfg80211_ops mac80211_config_ops 
 	.del_key = ieee80211_del_key,
 	.get_key = ieee80211_get_key,
 	.set_default_key = ieee80211_config_default_key,
+	.set_default_mgmt_key = ieee80211_config_default_mgmt_key,
 	.add_beacon = ieee80211_add_beacon,
 	.set_beacon = ieee80211_set_beacon,
 	.del_beacon = ieee80211_del_beacon,
Index: wireless-testing/net/mac80211/debugfs_key.c
===================================================================
--- wireless-testing.orig/net/mac80211/debugfs_key.c
+++ wireless-testing/net/mac80211/debugfs_key.c
@@ -76,6 +76,9 @@ static ssize_t key_algorithm_read(struct
 	case ALG_CCMP:
 		alg = "CCMP\n";
 		break;
+	case ALG_AES_CMAC:
+		alg = "AES-128-CMAC\n";
+		break;
 	default:
 		return 0;
 	}
@@ -105,6 +108,12 @@ static ssize_t key_tx_spec_read(struct f
 		len = scnprintf(buf, sizeof(buf), "%02x%02x%02x%02x%02x%02x\n",
 				tpn[0], tpn[1], tpn[2], tpn[3], tpn[4], tpn[5]);
 		break;
+	case ALG_AES_CMAC:
+		tpn = key->u.aes_cmac.tx_pn;
+		len = scnprintf(buf, sizeof(buf), "%02x%02x%02x%02x%02x%02x\n",
+				tpn[0], tpn[1], tpn[2], tpn[3], tpn[4],
+				tpn[5]);
+		break;
 	default:
 		return 0;
 	}
@@ -142,6 +151,14 @@ static ssize_t key_rx_spec_read(struct f
 		}
 		len = p - buf;
 		break;
+	case ALG_AES_CMAC:
+		rpn = key->u.aes_cmac.rx_pn;
+		p += scnprintf(p, sizeof(buf)+buf-p,
+			       "%02x%02x%02x%02x%02x%02x\n",
+			       rpn[0], rpn[1], rpn[2],
+			       rpn[3], rpn[4], rpn[5]);
+		len = p - buf;
+		break;
 	default:
 		return 0;
 	}
@@ -156,13 +173,40 @@ static ssize_t key_replays_read(struct f
 	char buf[20];
 	int len;
 
-	if (key->conf.alg != ALG_CCMP)
+	switch (key->conf.alg) {
+	case ALG_CCMP:
+		len = scnprintf(buf, sizeof(buf), "%u\n", key->u.ccmp.replays);
+		break;
+	case ALG_AES_CMAC:
+		len = scnprintf(buf, sizeof(buf), "%u\n",
+				key->u.aes_cmac.replays);
+		break;
+	default:
 		return 0;
-	len = scnprintf(buf, sizeof(buf), "%u\n", key->u.ccmp.replays);
+	}
 	return simple_read_from_buffer(userbuf, count, ppos, buf, len);
 }
 KEY_OPS(replays);
 
+static ssize_t key_icverrors_read(struct file *file, char __user *userbuf,
+				  size_t count, loff_t *ppos)
+{
+	struct ieee80211_key *key = file->private_data;
+	char buf[20];
+	int len;
+
+	switch (key->conf.alg) {
+	case ALG_AES_CMAC:
+		len = scnprintf(buf, sizeof(buf), "%u\n",
+				key->u.aes_cmac.icverrors);
+		break;
+	default:
+		return 0;
+	}
+	return simple_read_from_buffer(userbuf, count, ppos, buf, len);
+}
+KEY_OPS(icverrors);
+
 static ssize_t key_key_read(struct file *file, char __user *userbuf,
 			    size_t count, loff_t *ppos)
 {
@@ -223,6 +267,7 @@ void ieee80211_debugfs_key_add(struct ie
 	DEBUGFS_ADD(tx_spec);
 	DEBUGFS_ADD(rx_spec);
 	DEBUGFS_ADD(replays);
+	DEBUGFS_ADD(icverrors);
 	DEBUGFS_ADD(key);
 	DEBUGFS_ADD(ifindex);
 };
@@ -244,6 +289,7 @@ void ieee80211_debugfs_key_remove(struct
 	DEBUGFS_DEL(tx_spec);
 	DEBUGFS_DEL(rx_spec);
 	DEBUGFS_DEL(replays);
+	DEBUGFS_DEL(icverrors);
 	DEBUGFS_DEL(key);
 	DEBUGFS_DEL(ifindex);
 
@@ -281,6 +327,35 @@ void ieee80211_debugfs_key_remove_defaul
 	sdata->debugfs.default_key = NULL;
 }
 
+void ieee80211_debugfs_key_add_mgmt_default(struct ieee80211_sub_if_data *sdata)
+{
+	char buf[50];
+	struct ieee80211_key *key;
+
+	if (!sdata->debugfsdir)
+		return;
+
+	/* this is running under the key lock */
+
+	key = sdata->default_mgmt_key;
+	if (key) {
+		sprintf(buf, "../keys/%d", key->debugfs.cnt);
+		sdata->debugfs.default_mgmt_key =
+			debugfs_create_symlink("default_mgmt_key",
+					       sdata->debugfsdir, buf);
+	} else
+		ieee80211_debugfs_key_remove_mgmt_default(sdata);
+}
+
+void ieee80211_debugfs_key_remove_mgmt_default(struct ieee80211_sub_if_data *sdata)
+{
+	if (!sdata)
+		return;
+
+	debugfs_remove(sdata->debugfs.default_mgmt_key);
+	sdata->debugfs.default_mgmt_key = NULL;
+}
+
 void ieee80211_debugfs_key_sta_del(struct ieee80211_key *key,
 				   struct sta_info *sta)
 {
Index: wireless-testing/net/mac80211/key.h
===================================================================
--- wireless-testing.orig/net/mac80211/key.h
+++ wireless-testing/net/mac80211/key.h
@@ -59,6 +59,8 @@ struct sta_info;
  *	acceleration.
  * @KEY_FLAG_TODO_DEFKEY: Key is default key and debugfs needs to be updated.
  * @KEY_FLAG_TODO_ADD_DEBUGFS: Key needs to be added to debugfs.
+ * @KEY_FLAG_TODO_DEFMGMTKEY: Key is default management key and debugfs needs
+ *	to be updated.
  */
 enum ieee80211_internal_key_flags {
 	KEY_FLAG_UPLOADED_TO_HARDWARE	= BIT(0),
@@ -67,6 +69,7 @@ enum ieee80211_internal_key_flags {
 	KEY_FLAG_TODO_HWACCEL_REMOVE	= BIT(3),
 	KEY_FLAG_TODO_DEFKEY		= BIT(4),
 	KEY_FLAG_TODO_ADD_DEBUGFS	= BIT(5),
+	KEY_FLAG_TODO_DEFMGMTKEY	= BIT(6),
 };
 
 struct tkip_ctx {
@@ -137,6 +140,7 @@ struct ieee80211_key {
 		struct dentry *tx_spec;
 		struct dentry *rx_spec;
 		struct dentry *replays;
+		struct dentry *icverrors;
 		struct dentry *key;
 		struct dentry *ifindex;
 		int cnt;
@@ -163,6 +167,8 @@ void ieee80211_key_link(struct ieee80211
 			struct sta_info *sta);
 void ieee80211_key_free(struct ieee80211_key *key);
 void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx);
+void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
+				    int idx);
 void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata);
 void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata);
 void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata);
Index: wireless-testing/net/mac80211/rx.c
===================================================================
--- wireless-testing.orig/net/mac80211/rx.c
+++ wireless-testing/net/mac80211/rx.c
@@ -522,6 +522,31 @@ ieee80211_rx_h_check(struct ieee80211_rx
 }
 
 
+/* Get the BIP key index from MMIE; return -1 if this is not a BIP frame */
+static int ieee80211_get_mmie_keyidx(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *hdr = (struct ieee80211_mgmt *) skb->data;
+	struct ieee80211_mmie *mmie;
+
+	if (skb->len < 24 + sizeof(*mmie) ||
+	    !is_multicast_ether_addr(hdr->da))
+		return -1;
+
+	if (!ieee80211_is_disassoc(hdr->frame_control) &&
+	    !ieee80211_is_deauth(hdr->frame_control) &&
+	    !ieee80211_is_action(hdr->frame_control))
+		return -1; /* not a robust management frame */
+
+	mmie = (struct ieee80211_mmie *)
+		(skb->data + skb->len - sizeof(*mmie));
+	if (mmie->element_id != WLAN_EID_MMIE ||
+	    mmie->length != sizeof(*mmie) - 2)
+		return -1;
+
+	return get_unaligned_le16(mmie->key_id);
+}
+
+
 static ieee80211_rx_result
 ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 {
@@ -530,21 +555,23 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	int hdrlen;
 	ieee80211_rx_result result = RX_DROP_UNUSABLE;
 	struct ieee80211_key *stakey = NULL;
+	int mmie_keyidx = -1;
 
 	/*
 	 * Key selection 101
 	 *
-	 * There are three types of keys:
+	 * There are four types of keys:
 	 *  - GTK (group keys)
+	 *  - IGTK (group keys for management frames)
 	 *  - PTK (pairwise keys)
 	 *  - STK (station-to-station pairwise keys)
 	 *
 	 * When selecting a key, we have to distinguish between multicast
 	 * (including broadcast) and unicast frames, the latter can only
-	 * use PTKs and STKs while the former always use GTKs. Unless, of
-	 * course, actual WEP keys ("pre-RSNA") are used, then unicast
-	 * frames can also use key indizes like GTKs. Hence, if we don't
-	 * have a PTK/STK we check the key index for a WEP key.
+	 * use PTKs and STKs while the former always use GTKs and IGTKs.
+	 * Unless, of course, actual WEP keys ("pre-RSNA") are used, then
+	 * unicast frames can also use key indices like GTKs. Hence, if we
+	 * don't have a PTK/STK we check the key index for a WEP key.
 	 *
 	 * Note that in a regular BSS, multicast frames are sent by the
 	 * AP only, associated stations unicast the frame to the AP first
@@ -557,8 +584,14 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	 * possible.
 	 */
 
-	if (!(rx->fc & IEEE80211_FCTL_PROTECTED))
-		return RX_CONTINUE;
+	if (!(rx->fc & IEEE80211_FCTL_PROTECTED)) {
+		if (!ieee80211_is_mgmt(rx->fc) || rx->sta == NULL ||
+		    !test_sta_flags(rx->sta, WLAN_STA_MFP))
+			return RX_CONTINUE;
+		mmie_keyidx = ieee80211_get_mmie_keyidx(rx->skb);
+		if (mmie_keyidx < 0)
+			return RX_CONTINUE;
+	}
 
 	/*
 	 * No point in finding a key and decrypting if the frame is neither
@@ -572,6 +605,16 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 
 	if (!is_multicast_ether_addr(hdr->addr1) && stakey) {
 		rx->key = stakey;
+	} else if (mmie_keyidx >= 0) {
+		/* Broadcast/multicast robust management frame / BIP */
+		if ((rx->status->flag & RX_FLAG_DECRYPTED) &&
+		    (rx->status->flag & RX_FLAG_IV_STRIPPED))
+			return RX_CONTINUE;
+
+		if (mmie_keyidx < NUM_DEFAULT_KEYS ||
+		    mmie_keyidx >= NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS)
+			return RX_DROP_MONITOR; /* unexpected BIP keyidx */
+		rx->key = rcu_dereference(rx->sdata->keys[mmie_keyidx]);
 	} else {
 		/*
 		 * The device doesn't give us the IV so we won't be
@@ -639,6 +682,9 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	case ALG_CCMP:
 		result = ieee80211_crypto_ccmp_decrypt(rx);
 		break;
+	case ALG_AES_CMAC:
+		result = ieee80211_crypto_aes_cmac_decrypt(rx);
+		break;
 	}
 
 	/* either the frame has been decrypted or will be dropped */
@@ -1085,6 +1131,37 @@ ieee80211_802_1x_port_control(struct iee
 	return 0;
 }
 
+
+static int ieee80211_is_robust_mgmt_frame(__le16 fc)
+{
+	return ieee80211_is_disassoc(fc) ||
+		ieee80211_is_deauth(fc) ||
+		ieee80211_is_action(fc);
+}
+
+
+static int ieee80211_is_unicast_robust_mgmt_frame(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+
+	if (skb->len < 24 || is_multicast_ether_addr(hdr->addr1))
+		return 0;
+
+	return ieee80211_is_robust_mgmt_frame(hdr->frame_control);
+}
+
+
+static int ieee80211_is_multicast_robust_mgmt_frame(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+
+	if (skb->len < 24 || !is_multicast_ether_addr(hdr->addr1))
+		return 0;
+
+	return ieee80211_is_robust_mgmt_frame(hdr->frame_control);
+}
+
+
 static int
 ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx)
 {
@@ -1097,8 +1174,16 @@ ieee80211_drop_unencrypted(struct ieee80
 
 	/* Drop unencrypted frames if key is set. */
 	if (unlikely(!(rx->fc & IEEE80211_FCTL_PROTECTED) &&
-		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
-		     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_NULLFUNC &&
+		     (((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
+		       (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_NULLFUNC) ||
+		      (ieee80211_is_unicast_robust_mgmt_frame(rx->skb) &&
+		       rx->sta && test_sta_flags(rx->sta, WLAN_STA_MFP))) &&
+		     (rx->key || rx->sdata->drop_unencrypted)))
+		return -EACCES;
+	/* BIP does not use Protected field, so need to check MMIE */
+	if (unlikely(rx->sta && test_sta_flags(rx->sta, WLAN_STA_MFP) &&
+		     ieee80211_is_multicast_robust_mgmt_frame(rx->skb) &&
+		     ieee80211_get_mmie_keyidx(rx->skb) < 0 &&
 		     (rx->key || rx->sdata->drop_unencrypted)))
 		return -EACCES;
 
Index: wireless-testing/net/mac80211/tx.c
===================================================================
--- wireless-testing.orig/net/mac80211/tx.c
+++ wireless-testing/net/mac80211/tx.c
@@ -477,6 +477,9 @@ ieee80211_tx_h_select_key(struct ieee802
 		tx->key = NULL;
 	else if (tx->sta && (key = rcu_dereference(tx->sta->key)))
 		tx->key = key;
+	else if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT &&
+		 (key = rcu_dereference(tx->sdata->default_mgmt_key)))
+		tx->key = key;
 	else if ((key = rcu_dereference(tx->sdata->default_key)))
 		tx->key = key;
 	else if (tx->sdata->drop_unencrypted &&
@@ -510,6 +513,11 @@ ieee80211_tx_h_select_key(struct ieee802
 			    !ieee80211_use_mfp(fc, tx->sta, tx->skb))
 				tx->key = NULL;
 			break;
+		case ALG_AES_CMAC:
+			if ((fc & IEEE80211_FCTL_FTYPE) !=
+			    IEEE80211_FTYPE_MGMT)
+				tx->key = NULL;
+			break;
 		}
 	}
 
@@ -771,6 +779,8 @@ ieee80211_tx_h_encrypt(struct ieee80211_
 		return ieee80211_crypto_tkip_encrypt(tx);
 	case ALG_CCMP:
 		return ieee80211_crypto_ccmp_encrypt(tx);
+	case ALG_AES_CMAC:
+		return ieee80211_crypto_aes_cmac_encrypt(tx);
 	}
 
 	/* not reached */
Index: wireless-testing/net/mac80211/key.c
===================================================================
--- wireless-testing.orig/net/mac80211/key.c
+++ wireless-testing/net/mac80211/key.c
@@ -18,6 +18,7 @@
 #include "ieee80211_i.h"
 #include "debugfs_key.h"
 #include "aes_ccm.h"
+#include "aes_cmac.h"
 
 
 /**
@@ -218,13 +219,38 @@ void ieee80211_set_default_key(struct ie
 	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
 }
 
+static void
+__ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata, int idx)
+{
+	struct ieee80211_key *key = NULL;
+
+	if (idx >= NUM_DEFAULT_KEYS &&
+	    idx < NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS)
+		key = sdata->keys[idx];
+
+	rcu_assign_pointer(sdata->default_mgmt_key, key);
+
+	if (key)
+		add_todo(key, KEY_FLAG_TODO_DEFMGMTKEY);
+}
+
+void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
+				    int idx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdata->local->key_lock, flags);
+	__ieee80211_set_default_mgmt_key(sdata, idx);
+	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
+}
+
 
 static void __ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 				    struct sta_info *sta,
 				    struct ieee80211_key *old,
 				    struct ieee80211_key *new)
 {
-	int idx, defkey;
+	int idx, defkey, defmgmtkey;
 
 	if (new)
 		list_add(&new->list, &sdata->key_list);
@@ -240,13 +266,19 @@ static void __ieee80211_key_replace(stru
 			idx = new->conf.keyidx;
 
 		defkey = old && sdata->default_key == old;
+		defmgmtkey = old && sdata->default_mgmt_key == old;
 
 		if (defkey && !new)
 			__ieee80211_set_default_key(sdata, -1);
+		if (defmgmtkey && !new)
+			__ieee80211_set_default_mgmt_key(sdata, -1);
 
 		rcu_assign_pointer(sdata->keys[idx], new);
 		if (defkey && new)
 			__ieee80211_set_default_key(sdata, new->conf.keyidx);
+		if (defmgmtkey && new)
+			__ieee80211_set_default_mgmt_key(sdata,
+							 new->conf.keyidx);
 	}
 
 	if (old) {
@@ -265,7 +297,7 @@ struct ieee80211_key *ieee80211_key_allo
 {
 	struct ieee80211_key *key;
 
-	BUG_ON(idx < 0 || idx >= NUM_DEFAULT_KEYS);
+	BUG_ON(idx < 0 || idx >= NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS);
 
 	key = kzalloc(sizeof(struct ieee80211_key) + key_len, GFP_KERNEL);
 	if (!key)
@@ -297,6 +329,19 @@ struct ieee80211_key *ieee80211_key_allo
 		}
 	}
 
+	if (alg == ALG_AES_CMAC) {
+		/*
+		 * Initialize AES key state here as an optimization so that
+		 * it does not need to be initialized for every packet.
+		 */
+		key->u.aes_cmac.tfm =
+			ieee80211_aes_cmac_key_setup(key_data);
+		if (!key->u.aes_cmac.tfm) {
+			kfree(key);
+			return NULL;
+		}
+	}
+
 	return key;
 }
 
@@ -441,6 +486,8 @@ static void __ieee80211_key_destroy(stru
 
 	if (key->conf.alg == ALG_CCMP)
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
+	if (key->conf.alg == ALG_AES_CMAC)
+		ieee80211_aes_cmac_key_free(key->u.aes_cmac.tfm);
 	ieee80211_debugfs_key_remove(key);
 
 	kfree(key);
@@ -463,6 +510,7 @@ static void __ieee80211_key_todo(void)
 		list_del_init(&key->todo);
 		todoflags = key->flags & (KEY_FLAG_TODO_ADD_DEBUGFS |
 					  KEY_FLAG_TODO_DEFKEY |
+					  KEY_FLAG_TODO_DEFMGMTKEY |
 					  KEY_FLAG_TODO_HWACCEL_ADD |
 					  KEY_FLAG_TODO_HWACCEL_REMOVE |
 					  KEY_FLAG_TODO_DELETE);
@@ -480,6 +528,11 @@ static void __ieee80211_key_todo(void)
 			ieee80211_debugfs_key_add_default(key->sdata);
 			work_done = true;
 		}
+		if (todoflags & KEY_FLAG_TODO_DEFMGMTKEY) {
+			ieee80211_debugfs_key_remove_mgmt_default(key->sdata);
+			ieee80211_debugfs_key_add_mgmt_default(key->sdata);
+			work_done = true;
+		}
 		if (todoflags & KEY_FLAG_TODO_HWACCEL_ADD) {
 			ieee80211_key_enable_hw_accel(key);
 			work_done = true;
@@ -515,6 +568,7 @@ void ieee80211_free_keys(struct ieee8021
 	ieee80211_key_lock();
 
 	ieee80211_debugfs_key_remove_default(sdata);
+	ieee80211_debugfs_key_remove_mgmt_default(sdata);
 
 	spin_lock_irqsave(&sdata->local->key_lock, flags);
 	list_for_each_entry_safe(key, tmp, &sdata->key_list, list)
Index: wireless-testing/net/mac80211/ieee80211_i.h
===================================================================
--- wireless-testing.orig/net/mac80211/ieee80211_i.h
+++ wireless-testing/net/mac80211/ieee80211_i.h
@@ -429,8 +429,10 @@ struct ieee80211_sub_if_data {
 	unsigned int fragment_next;
 
 #define NUM_DEFAULT_KEYS 4
-	struct ieee80211_key *keys[NUM_DEFAULT_KEYS];
+#define NUM_DEFAULT_MGMT_KEYS 2
+	struct ieee80211_key *keys[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
 	struct ieee80211_key *default_key;
+	struct ieee80211_key *default_mgmt_key;
 
 	/*
 	 * BSS configuration for this interface.
@@ -492,6 +494,7 @@ struct ieee80211_sub_if_data {
 			struct dentry *mode;
 		} monitor;
 		struct dentry *default_key;
+		struct dentry *default_mgmt_key;
 	} debugfs;
 
 #ifdef CONFIG_MAC80211_MESH
Index: wireless-testing/include/net/cfg80211.h
===================================================================
--- wireless-testing.orig/include/net/cfg80211.h
+++ wireless-testing/include/net/cfg80211.h
@@ -306,6 +306,8 @@ struct wiphy;
  *
  * @set_default_key: set the default key on an interface
  *
+ * @set_default_mgmt_key: set the default management frame key on an interface
+ *
  * @add_beacon: Add a beacon with given parameters, @head, @interval
  *	and @dtim_period will be valid, @tail is optional.
  * @set_beacon: Change the beacon parameters for an access point mode
@@ -341,6 +343,9 @@ struct cfg80211_ops {
 	int	(*set_default_key)(struct wiphy *wiphy,
 				   struct net_device *netdev,
 				   u8 key_index);
+	int	(*set_default_mgmt_key)(struct wiphy *wiphy,
+					struct net_device *netdev,
+					u8 key_index);
 
 	int	(*add_beacon)(struct wiphy *wiphy, struct net_device *dev,
 			      struct beacon_parameters *info);
Index: wireless-testing/net/mac80211/debugfs_key.h
===================================================================
--- wireless-testing.orig/net/mac80211/debugfs_key.h
+++ wireless-testing/net/mac80211/debugfs_key.h
@@ -6,6 +6,10 @@ void ieee80211_debugfs_key_add(struct ie
 void ieee80211_debugfs_key_remove(struct ieee80211_key *key);
 void ieee80211_debugfs_key_add_default(struct ieee80211_sub_if_data *sdata);
 void ieee80211_debugfs_key_remove_default(struct ieee80211_sub_if_data *sdata);
+void ieee80211_debugfs_key_add_mgmt_default(
+	struct ieee80211_sub_if_data *sdata);
+void ieee80211_debugfs_key_remove_mgmt_default(
+	struct ieee80211_sub_if_data *sdata);
 void ieee80211_debugfs_key_sta_del(struct ieee80211_key *key,
 				   struct sta_info *sta);
 #else
@@ -19,6 +23,12 @@ static inline void ieee80211_debugfs_key
 static inline void ieee80211_debugfs_key_remove_default(
 	struct ieee80211_sub_if_data *sdata)
 {}
+static inline void ieee80211_debugfs_key_add_mgmt_default(
+	struct ieee80211_sub_if_data *sdata)
+{}
+static inline void ieee80211_debugfs_key_remove_mgmt_default(
+	struct ieee80211_sub_if_data *sdata)
+{}
 static inline void ieee80211_debugfs_key_sta_del(struct ieee80211_key *key,
 						 struct sta_info *sta)
 {}
Index: wireless-testing/net/wireless/nl80211.c
===================================================================
--- wireless-testing.orig/net/wireless/nl80211.c
+++ wireless-testing/net/wireless/nl80211.c
@@ -87,6 +87,8 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
 				.len = IEEE80211_MAX_MESH_ID_LEN },
 	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_U32 },
+
+	[NL80211_ATTR_KEY_DEFAULT_MGMT] = { .type = NLA_FLAG },
 };
 
 /* message building helper */
@@ -537,7 +539,7 @@ static int nl80211_get_key(struct sk_buf
 	if (info->attrs[NL80211_ATTR_KEY_IDX])
 		key_idx = nla_get_u8(info->attrs[NL80211_ATTR_KEY_IDX]);
 
-	if (key_idx > 3)
+	if (key_idx > 5)
 		return -EINVAL;
 
 	if (info->attrs[NL80211_ATTR_MAC])
@@ -603,30 +605,38 @@ static int nl80211_set_key(struct sk_buf
 	int err;
 	struct net_device *dev;
 	u8 key_idx;
+	int (*func)(struct wiphy *wiphy, struct net_device *netdev,
+		    u8 key_index);
 
 	if (!info->attrs[NL80211_ATTR_KEY_IDX])
 		return -EINVAL;
 
 	key_idx = nla_get_u8(info->attrs[NL80211_ATTR_KEY_IDX]);
 
-	if (key_idx > 3)
+	if (key_idx > 5)
 		return -EINVAL;
 
 	/* currently only support setting default key */
-	if (!info->attrs[NL80211_ATTR_KEY_DEFAULT])
+	if (!info->attrs[NL80211_ATTR_KEY_DEFAULT] &&
+	    !info->attrs[NL80211_ATTR_KEY_DEFAULT_MGMT])
 		return -EINVAL;
 
 	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
 	if (err)
 		return err;
 
-	if (!drv->ops->set_default_key) {
+	if (info->attrs[NL80211_ATTR_KEY_DEFAULT])
+		func = drv->ops->set_default_key;
+	else
+		func = drv->ops->set_default_mgmt_key;
+
+	if (!func) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
 	rtnl_lock();
-	err = drv->ops->set_default_key(&drv->wiphy, dev, key_idx);
+	err = func(&drv->wiphy, dev, key_idx);
 	rtnl_unlock();
 
  out:
@@ -662,7 +672,7 @@ static int nl80211_new_key(struct sk_buf
 	if (info->attrs[NL80211_ATTR_MAC])
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
-	if (key_idx > 3)
+	if (key_idx > 5)
 		return -EINVAL;
 
 	/*
@@ -693,6 +703,10 @@ static int nl80211_new_key(struct sk_buf
 		if (params.key_len != 13)
 			return -EINVAL;
 		break;
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+		if (params.key_len != 16)
+			return -EINVAL;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -727,7 +741,7 @@ static int nl80211_del_key(struct sk_buf
 	if (info->attrs[NL80211_ATTR_KEY_IDX])
 		key_idx = nla_get_u8(info->attrs[NL80211_ATTR_KEY_IDX]);
 
-	if (key_idx > 3)
+	if (key_idx > 5)
 		return -EINVAL;
 
 	if (info->attrs[NL80211_ATTR_MAC])
Index: wireless-testing/include/linux/nl80211.h
===================================================================
--- wireless-testing.orig/include/linux/nl80211.h
+++ wireless-testing/include/linux/nl80211.h
@@ -51,8 +51,8 @@
  *
  * @NL80211_CMD_GET_KEY: Get sequence counter information for a key specified
  *	by %NL80211_ATTR_KEY_IDX and/or %NL80211_ATTR_MAC.
- * @NL80211_CMD_SET_KEY: Set key attributes %NL80211_ATTR_KEY_DEFAULT or
- *	%NL80211_ATTR_KEY_THRESHOLD.
+ * @NL80211_CMD_SET_KEY: Set key attributes %NL80211_ATTR_KEY_DEFAULT,
+ *	%NL80211_ATTR_KEY_DEFAULT_MGMT, or %NL80211_ATTR_KEY_THRESHOLD.
  * @NL80211_CMD_NEW_KEY: add a key with given %NL80211_ATTR_KEY_DATA,
  *	%NL80211_ATTR_KEY_IDX, %NL80211_ATTR_MAC and %NL80211_ATTR_KEY_CIPHER
  *	attributes.
@@ -235,6 +235,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_MPATH_NEXT_HOP,
 	NL80211_ATTR_MPATH_INFO,
 
+	NL80211_ATTR_KEY_DEFAULT_MGMT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,

--

-- 
Jouni Malinen                                            PGP id EFC895FA
