Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52226 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993213AbbEEOlB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 10:41:01 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] mac80211: extend get_tkip_seq to all keys
Date: Tue,  5 May 2015 16:40:56 +0200
Message-Id: <1430836857-4393-1-git-send-email-johannes@sipsolutions.net> (sfid-20150505_194404_410155_5A6C1870)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Extend the function to read the TKIP IV32/IV16 to read the IV/PN for
all ciphers in order to allow drivers with full hardware crypto to
properly support this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |  1 -
 drivers/net/wireless/rt2x00/rt2800lib.c       | 16 +++--
 drivers/net/wireless/rt2x00/rt2800lib.h       |  5 +-
 drivers/net/wireless/rt2x00/rt2800pci.c       |  2 +-
 drivers/net/wireless/rt2x00/rt2800soc.c       |  2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c       |  2 +-
 include/net/mac80211.h                        | 79 +++++++++++------------
 net/mac80211/cfg.c                            | 91 +++++++++++++++++----------
 net/mac80211/driver-ops.h                     | 11 ++--
 net/mac80211/trace.h                          | 42 +++++++------
 10 files changed, 143 insertions(+), 108 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 0210630972d6..dc44cfef7517 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -798,7 +798,6 @@ const struct ieee80211_ops ath5k_hw_ops = {
 	.sw_scan_start		= ath5k_sw_scan_start,
 	.sw_scan_complete	= ath5k_sw_scan_complete,
 	.get_stats		= ath5k_get_stats,
-	/* .get_tkip_seq	= not implemented */
 	/* .set_frag_threshold	= not implemented */
 	/* .set_rts_threshold	= not implemented */
 	/* .sta_add		= not implemented */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 09135192c516..dfeca8355b22 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -7817,21 +7817,25 @@ EXPORT_SYMBOL_GPL(rt2800_probe_hw);
 /*
  * IEEE80211 stack callback functions.
  */
-void rt2800_get_tkip_seq(struct ieee80211_hw *hw, u8 hw_key_idx, u32 *iv32,
-			 u16 *iv16)
+void rt2800_get_key_seq(struct ieee80211_hw *hw,
+			struct ieee80211_key_conf *key,
+			struct ieee80211_key_seq *seq)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct mac_iveiv_entry iveiv_entry;
 	u32 offset;
 
-	offset = MAC_IVEIV_ENTRY(hw_key_idx);
+	if (key->cipher != WLAN_CIPHER_SUITE_TKIP)
+		return;
+
+	offset = MAC_IVEIV_ENTRY(key->hw_key_idx);
 	rt2800_register_multiread(rt2x00dev, offset,
 				      &iveiv_entry, sizeof(iveiv_entry));
 
-	memcpy(iv16, &iveiv_entry.iv[0], sizeof(*iv16));
-	memcpy(iv32, &iveiv_entry.iv[4], sizeof(*iv32));
+	memcpy(&seq->tkip.iv16, &iveiv_entry.iv[0], 2);
+	memcpy(&seq->tkip.iv32, &iveiv_entry.iv[4], 4);
 }
-EXPORT_SYMBOL_GPL(rt2800_get_tkip_seq);
+EXPORT_SYMBOL_GPL(rt2800_get_key_seq);
 
 int rt2800_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 3019db637a4b..1609b8a7f7eb 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -209,8 +209,9 @@ int rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev);
 
 int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev);
 
-void rt2800_get_tkip_seq(struct ieee80211_hw *hw, u8 hw_key_idx, u32 *iv32,
-			 u16 *iv16);
+void rt2800_get_key_seq(struct ieee80211_hw *hw,
+			struct ieee80211_key_conf *key,
+			struct ieee80211_key_seq *seq);
 int rt2800_set_rts_threshold(struct ieee80211_hw *hw, u32 value);
 int rt2800_conf_tx(struct ieee80211_hw *hw,
 		   struct ieee80211_vif *vif, u16 queue_idx,
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index cc1b3cc73c5a..0af22573a2eb 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -309,7 +309,7 @@ static const struct ieee80211_ops rt2800pci_mac80211_ops = {
 	.sw_scan_start		= rt2x00mac_sw_scan_start,
 	.sw_scan_complete	= rt2x00mac_sw_scan_complete,
 	.get_stats		= rt2x00mac_get_stats,
-	.get_tkip_seq		= rt2800_get_tkip_seq,
+	.get_key_seq		= rt2800_get_key_seq,
 	.set_rts_threshold	= rt2800_set_rts_threshold,
 	.sta_add		= rt2x00mac_sta_add,
 	.sta_remove		= rt2x00mac_sta_remove,
diff --git a/drivers/net/wireless/rt2x00/rt2800soc.c b/drivers/net/wireless/rt2x00/rt2800soc.c
index aaa7aa4cad9d..a985a5a7945e 100644
--- a/drivers/net/wireless/rt2x00/rt2800soc.c
+++ b/drivers/net/wireless/rt2x00/rt2800soc.c
@@ -148,7 +148,7 @@ static const struct ieee80211_ops rt2800soc_mac80211_ops = {
 	.sw_scan_start		= rt2x00mac_sw_scan_start,
 	.sw_scan_complete	= rt2x00mac_sw_scan_complete,
 	.get_stats		= rt2x00mac_get_stats,
-	.get_tkip_seq		= rt2800_get_tkip_seq,
+	.get_key_seq		= rt2800_get_key_seq,
 	.set_rts_threshold	= rt2800_set_rts_threshold,
 	.sta_add		= rt2x00mac_sta_add,
 	.sta_remove		= rt2x00mac_sta_remove,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 6ec2466b52b6..5932306084fd 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -835,7 +835,7 @@ static const struct ieee80211_ops rt2800usb_mac80211_ops = {
 	.sw_scan_start		= rt2x00mac_sw_scan_start,
 	.sw_scan_complete	= rt2x00mac_sw_scan_complete,
 	.get_stats		= rt2x00mac_get_stats,
-	.get_tkip_seq		= rt2800_get_tkip_seq,
+	.get_key_seq		= rt2800_get_key_seq,
 	.set_rts_threshold	= rt2800_set_rts_threshold,
 	.sta_add		= rt2x00mac_sta_add,
 	.sta_remove		= rt2x00mac_sta_remove,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f1b99d4f669b..d719812759fc 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1502,6 +1502,40 @@ struct ieee80211_key_conf {
 };
 
 /**
+ * struct ieee80211_key_seq - key sequence counter
+ *
+ * @tkip: TKIP data, containing IV32 and IV16 in host byte order
+ * @ccmp: PN data, most significant byte first (big endian,
+ *	reverse order than in packet)
+ * @aes_cmac: PN data, most significant byte first (big endian,
+ *	reverse order than in packet)
+ * @aes_gmac: PN data, most significant byte first (big endian,
+ *	reverse order than in packet)
+ * @gcmp: PN data, most significant byte first (big endian,
+ *	reverse order than in packet)
+ */
+struct ieee80211_key_seq {
+	union {
+		struct {
+			u32 iv32;
+			u16 iv16;
+		} tkip;
+		struct {
+			u8 pn[6];
+		} ccmp;
+		struct {
+			u8 pn[6];
+		} aes_cmac;
+		struct {
+			u8 pn[6];
+		} aes_gmac;
+		struct {
+			u8 pn[6];
+		} gcmp;
+	};
+};
+
+/**
  * struct ieee80211_cipher_scheme - cipher scheme
  *
  * This structure contains a cipher scheme information defining
@@ -2838,9 +2872,9 @@ enum ieee80211_reconfig_type {
  * 	Returns zero if statistics are available.
  *	The callback can sleep.
  *
- * @get_tkip_seq: If your device implements TKIP encryption in hardware this
- *	callback should be provided to read the TKIP transmit IVs (both IV32
- *	and IV16) for the given key from hardware.
+ * @get_key_seq: If your device implements encryption in hardware and does
+ *	IV/PN assignment then this callback should be provided to read the
+ *	IV/PN for the given key from hardware.
  *	The callback must be atomic.
  *
  * @set_frag_threshold: Configuration of fragmentation threshold. Assign this
@@ -3241,8 +3275,9 @@ struct ieee80211_ops {
 				 struct ieee80211_vif *vif);
 	int (*get_stats)(struct ieee80211_hw *hw,
 			 struct ieee80211_low_level_stats *stats);
-	void (*get_tkip_seq)(struct ieee80211_hw *hw, u8 hw_key_idx,
-			     u32 *iv32, u16 *iv16);
+	void (*get_key_seq)(struct ieee80211_hw *hw,
+			    struct ieee80211_key_conf *key,
+			    struct ieee80211_key_seq *seq);
 	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
 	int (*set_rts_threshold)(struct ieee80211_hw *hw, u32 value);
 	int (*sta_add)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
@@ -4281,40 +4316,6 @@ void ieee80211_aes_cmac_calculate_k1_k2(struct ieee80211_key_conf *keyconf,
 					u8 *k1, u8 *k2);
 
 /**
- * struct ieee80211_key_seq - key sequence counter
- *
- * @tkip: TKIP data, containing IV32 and IV16 in host byte order
- * @ccmp: PN data, most significant byte first (big endian,
- *	reverse order than in packet)
- * @aes_cmac: PN data, most significant byte first (big endian,
- *	reverse order than in packet)
- * @aes_gmac: PN data, most significant byte first (big endian,
- *	reverse order than in packet)
- * @gcmp: PN data, most significant byte first (big endian,
- *	reverse order than in packet)
- */
-struct ieee80211_key_seq {
-	union {
-		struct {
-			u32 iv32;
-			u16 iv16;
-		} tkip;
-		struct {
-			u8 pn[6];
-		} ccmp;
-		struct {
-			u8 pn[6];
-		} aes_cmac;
-		struct {
-			u8 pn[6];
-		} aes_gmac;
-		struct {
-			u8 pn[6];
-		} gcmp;
-	};
-};
-
-/**
  * ieee80211_get_key_tx_seq - get key TX sequence counter
  *
  * @keyconf: the parameter passed with the set key
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 72a0178af737..dd7014b09396 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -312,6 +312,7 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 	u32 iv32;
 	u16 iv16;
 	int err = -ENOENT;
+	struct ieee80211_key_seq kseq = {};
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -342,10 +343,12 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 		iv32 = key->u.tkip.tx.iv32;
 		iv16 = key->u.tkip.tx.iv16;
 
-		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
-			drv_get_tkip_seq(sdata->local,
-					 key->conf.hw_key_idx,
-					 &iv32, &iv16);
+		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
+		    !(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
+			drv_get_key_seq(sdata->local, key, &kseq);
+			iv32 = kseq.tkip.iv32;
+			iv16 = kseq.tkip.iv16;
+		}
 
 		seq[0] = iv16 & 0xff;
 		seq[1] = (iv16 >> 8) & 0xff;
@@ -358,49 +361,73 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_CCMP_256:
-		pn64 = atomic64_read(&key->u.ccmp.tx_pn);
-		seq[0] = pn64;
-		seq[1] = pn64 >> 8;
-		seq[2] = pn64 >> 16;
-		seq[3] = pn64 >> 24;
-		seq[4] = pn64 >> 32;
-		seq[5] = pn64 >> 40;
+		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
+		    !(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
+			drv_get_key_seq(sdata->local, key, &kseq);
+			memcpy(seq, kseq.ccmp.pn, 6);
+		} else {
+			pn64 = atomic64_read(&key->u.ccmp.tx_pn);
+			seq[0] = pn64;
+			seq[1] = pn64 >> 8;
+			seq[2] = pn64 >> 16;
+			seq[3] = pn64 >> 24;
+			seq[4] = pn64 >> 32;
+			seq[5] = pn64 >> 40;
+		}
 		params.seq = seq;
 		params.seq_len = 6;
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
-		pn64 = atomic64_read(&key->u.aes_cmac.tx_pn);
-		seq[0] = pn64;
-		seq[1] = pn64 >> 8;
-		seq[2] = pn64 >> 16;
-		seq[3] = pn64 >> 24;
-		seq[4] = pn64 >> 32;
-		seq[5] = pn64 >> 40;
+		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
+		    !(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
+			drv_get_key_seq(sdata->local, key, &kseq);
+			memcpy(seq, kseq.aes_cmac.pn, 6);
+		} else {
+			pn64 = atomic64_read(&key->u.aes_cmac.tx_pn);
+			seq[0] = pn64;
+			seq[1] = pn64 >> 8;
+			seq[2] = pn64 >> 16;
+			seq[3] = pn64 >> 24;
+			seq[4] = pn64 >> 32;
+			seq[5] = pn64 >> 40;
+		}
 		params.seq = seq;
 		params.seq_len = 6;
 		break;
 	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
 	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
-		pn64 = atomic64_read(&key->u.aes_gmac.tx_pn);
-		seq[0] = pn64;
-		seq[1] = pn64 >> 8;
-		seq[2] = pn64 >> 16;
-		seq[3] = pn64 >> 24;
-		seq[4] = pn64 >> 32;
-		seq[5] = pn64 >> 40;
+		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
+		    !(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
+			drv_get_key_seq(sdata->local, key, &kseq);
+			memcpy(seq, kseq.aes_gmac.pn, 6);
+		} else {
+			pn64 = atomic64_read(&key->u.aes_gmac.tx_pn);
+			seq[0] = pn64;
+			seq[1] = pn64 >> 8;
+			seq[2] = pn64 >> 16;
+			seq[3] = pn64 >> 24;
+			seq[4] = pn64 >> 32;
+			seq[5] = pn64 >> 40;
+		}
 		params.seq = seq;
 		params.seq_len = 6;
 		break;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
-		pn64 = atomic64_read(&key->u.gcmp.tx_pn);
-		seq[0] = pn64;
-		seq[1] = pn64 >> 8;
-		seq[2] = pn64 >> 16;
-		seq[3] = pn64 >> 24;
-		seq[4] = pn64 >> 32;
-		seq[5] = pn64 >> 40;
+		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
+		    !(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
+			drv_get_key_seq(sdata->local, key, &kseq);
+			memcpy(seq, kseq.gcmp.pn, 6);
+		} else {
+			pn64 = atomic64_read(&key->u.gcmp.tx_pn);
+			seq[0] = pn64;
+			seq[1] = pn64 >> 8;
+			seq[2] = pn64 >> 16;
+			seq[3] = pn64 >> 24;
+			seq[4] = pn64 >> 32;
+			seq[5] = pn64 >> 40;
+		}
 		params.seq = seq;
 		params.seq_len = 6;
 		break;
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index a0cd94a9a0b1..ac188e5b4f94 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -417,12 +417,13 @@ static inline int drv_get_stats(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline void drv_get_tkip_seq(struct ieee80211_local *local,
-				    u8 hw_key_idx, u32 *iv32, u16 *iv16)
+static inline void drv_get_key_seq(struct ieee80211_local *local,
+				   struct ieee80211_key *key,
+				   struct ieee80211_key_seq *seq)
 {
-	if (local->ops->get_tkip_seq)
-		local->ops->get_tkip_seq(&local->hw, hw_key_idx, iv32, iv16);
-	trace_drv_get_tkip_seq(local, hw_key_idx, iv32, iv16);
+	if (local->ops->get_key_seq)
+		local->ops->get_key_seq(&local->hw, &key->conf, seq);
+	trace_drv_get_key_seq(local, &key->conf);
 }
 
 static inline int drv_set_frag_threshold(struct ieee80211_local *local,
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index fe6ba219dd67..755e9fa61bb6 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -69,6 +69,17 @@
 #define CHANCTX_PR_ARG	CHANDEF_PR_ARG,	MIN_CHANDEF_PR_ARG,				\
 			__entry->rx_chains_static, __entry->rx_chains_dynamic
 
+#define KEY_ENTRY	__field(u32, cipher)						\
+			__field(u8, hw_key_idx)						\
+			__field(u8, flags)						\
+			__field(s8, keyidx)
+#define KEY_ASSIGN(k)	__entry->cipher = (k)->cipher;					\
+			__entry->flags = (k)->flags;					\
+			__entry->keyidx = (k)->keyidx;					\
+			__entry->hw_key_idx = (k)->hw_key_idx;
+#define KEY_PR_FMT	" cipher:0x%x, flags=%#x, keyidx=%d, hw_key_idx=%d"
+#define KEY_PR_ARG	__entry->cipher, __entry->flags, __entry->keyidx, __entry->hw_key_idx
+
 
 
 /*
@@ -522,25 +533,19 @@ TRACE_EVENT(drv_set_key,
 		LOCAL_ENTRY
 		VIF_ENTRY
 		STA_ENTRY
-		__field(u32, cipher)
-		__field(u8, hw_key_idx)
-		__field(u8, flags)
-		__field(s8, keyidx)
+		KEY_ENTRY
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
 		STA_ASSIGN;
-		__entry->cipher = key->cipher;
-		__entry->flags = key->flags;
-		__entry->keyidx = key->keyidx;
-		__entry->hw_key_idx = key->hw_key_idx;
+		KEY_ASSIGN(key);
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT,
-		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG
+		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT KEY_PR_FMT,
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, KEY_PR_ARG
 	)
 );
 
@@ -656,28 +661,25 @@ TRACE_EVENT(drv_get_stats,
 	)
 );
 
-TRACE_EVENT(drv_get_tkip_seq,
+TRACE_EVENT(drv_get_key_seq,
 	TP_PROTO(struct ieee80211_local *local,
-		 u8 hw_key_idx, u32 *iv32, u16 *iv16),
+		 struct ieee80211_key_conf *key),
 
-	TP_ARGS(local, hw_key_idx, iv32, iv16),
+	TP_ARGS(local, key),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
-		__field(u8, hw_key_idx)
-		__field(u32, iv32)
-		__field(u16, iv16)
+		KEY_ENTRY
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
-		__entry->hw_key_idx = hw_key_idx;
-		__entry->iv32 = *iv32;
-		__entry->iv16 = *iv16;
+		KEY_ASSIGN(key);
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT, LOCAL_PR_ARG
+		LOCAL_PR_FMT KEY_PR_FMT,
+		LOCAL_PR_ARG, KEY_PR_ARG
 	)
 );
 
-- 
2.1.4

