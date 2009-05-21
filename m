Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11380 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbZEUNyi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 09:54:38 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 1/2 V3] wireless: move some utility functions from mac80211 to cfg80211
Date: Thu, 21 May 2009 21:47:03 +0800
Message-Id: <1242913623-10559-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch moves some utility functions from mac80211 to cfg80211.
Because these functions are doing generic 802.11 operations so they
are not mac80211 specific. The moving allows some fullmac drivers
to be also benefit from these utility functions.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
V2: address comments from Johannes Berg on moving ieee80211_key_len to
    include/linux/ieee80211.h and keep ieee802_1d_to_ac static, etc.
V3: change users according to LEN_WEP{40,104} rename

 drivers/net/wireless/ath/ar9170/main.c     |    2 +-
 drivers/net/wireless/ath/ath5k/pcu.c       |    4 +-
 drivers/net/wireless/ath/ath9k/hw.c        |    8 +-
 drivers/net/wireless/b43/main.c            |    2 +-
 drivers/net/wireless/rt2x00/rt2x00crypto.c |    2 +-
 include/linux/ieee80211.h                  |    9 +
 include/net/cfg80211.h                     |   47 +++++
 include/net/mac80211.h                     |   28 ---
 net/mac80211/ieee80211_i.h                 |    2 -
 net/mac80211/mesh.h                        |    4 -
 net/mac80211/rx.c                          |   89 +--------
 net/mac80211/util.c                        |   73 -------
 net/mac80211/wme.c                         |   30 +---
 net/wireless/util.c                        |  305 ++++++++++++++++++++++++++++
 14 files changed, 375 insertions(+), 230 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 4ef1d2f..99df9dd 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -1555,7 +1555,7 @@ static int ar9170_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	switch (key->alg) {
 	case ALG_WEP:
-		if (key->keylen == LEN_WEP40)
+		if (key->keylen == WLAN_KEY_LEN_WEP40)
 			ktype = AR9170_ENC_ALG_WEP64;
 		else
 			ktype = AR9170_ENC_ALG_WEP128;
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 579aa0a..ec35503 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -1038,9 +1038,9 @@ int ath5k_keycache_type(const struct ieee80211_key_conf *key)
 	case ALG_CCMP:
 		return AR5K_KEYTABLE_TYPE_CCM;
 	case ALG_WEP:
-		if (key->keylen == LEN_WEP40)
+		if (key->keylen == WLAN_KEY_LEN_WEP40)
 			return AR5K_KEYTABLE_TYPE_40;
-		else if (key->keylen == LEN_WEP104)
+		else if (key->keylen == WLAN_KEY_LEN_WEP104)
 			return AR5K_KEYTABLE_TYPE_104;
 		return -EINVAL;
 	default:
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4acfab5..1579c94 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2472,14 +2472,14 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 		}
 		break;
 	case ATH9K_CIPHER_WEP:
-		if (k->kv_len < LEN_WEP40) {
+		if (k->kv_len < WLAN_KEY_LEN_WEP40) {
 			DPRINTF(ah->ah_sc, ATH_DBG_ANY,
 				"WEP key length %u too small\n", k->kv_len);
 			return false;
 		}
-		if (k->kv_len <= LEN_WEP40)
+		if (k->kv_len <= WLAN_KEY_LEN_WEP40)
 			keyType = AR_KEYTABLE_TYPE_40;
-		else if (k->kv_len <= LEN_WEP104)
+		else if (k->kv_len <= WLAN_KEY_LEN_WEP104)
 			keyType = AR_KEYTABLE_TYPE_104;
 		else
 			keyType = AR_KEYTABLE_TYPE_128;
@@ -2498,7 +2498,7 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 	key2 = get_unaligned_le32(k->kv_val + 6);
 	key3 = get_unaligned_le16(k->kv_val + 10);
 	key4 = get_unaligned_le32(k->kv_val + 12);
-	if (k->kv_len <= LEN_WEP104)
+	if (k->kv_len <= WLAN_KEY_LEN_WEP104)
 		key4 &= 0xff;
 
 	/*
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index ec8516e..cb4a871 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3637,7 +3637,7 @@ static int b43_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	err = -EINVAL;
 	switch (key->alg) {
 	case ALG_WEP:
-		if (key->keylen == LEN_WEP40)
+		if (key->keylen == WLAN_KEY_LEN_WEP40)
 			algorithm = B43_SEC_ALGO_WEP40;
 		else
 			algorithm = B43_SEC_ALGO_WEP104;
diff --git a/drivers/net/wireless/rt2x00/rt2x00crypto.c b/drivers/net/wireless/rt2x00/rt2x00crypto.c
index 57ab42c..bc4e81e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
+++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
@@ -33,7 +33,7 @@ enum cipher rt2x00crypto_key_to_cipher(struct ieee80211_key_conf *key)
 {
 	switch (key->alg) {
 	case ALG_WEP:
-		if (key->keylen == LEN_WEP40)
+		if (key->keylen == WLAN_KEY_LEN_WEP40)
 			return CIPHER_WEP64;
 		else
 			return CIPHER_WEP128;
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 05c29c0..34de8b2 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -493,6 +493,7 @@ struct ieee80211s_hdr {
 /* Mesh flags */
 #define MESH_FLAGS_AE_A4 	0x1
 #define MESH_FLAGS_AE_A5_A6	0x2
+#define MESH_FLAGS_AE		0x3
 #define MESH_FLAGS_PS_DEEP	0x4
 
 /**
@@ -1085,6 +1086,14 @@ enum ieee80211_spectrum_mgmt_actioncode {
 	WLAN_ACTION_SPCT_CHL_SWITCH = 4,
 };
 
+/* Security key length */
+enum ieee80211_key_len {
+	WLAN_KEY_LEN_WEP40 = 5,
+	WLAN_KEY_LEN_WEP104 = 13,
+	WLAN_KEY_LEN_CCMP = 16,
+	WLAN_KEY_LEN_TKIP = 32,
+};
+
 /*
  * IEEE 802.11-2007 7.3.2.9 Country information element
  *
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 389f1d2..f20da7d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1244,6 +1244,53 @@ extern int ieee80211_radiotap_iterator_init(
 extern int ieee80211_radiotap_iterator_next(
    struct ieee80211_radiotap_iterator *iterator);
 
+extern const unsigned char rfc1042_header[6];
+extern const unsigned char bridge_tunnel_header[6];
+
+/**
+ * ieee80211_get_hdrlen_from_skb - get header length from data
+ *
+ * Given an skb with a raw 802.11 header at the data pointer this function
+ * returns the 802.11 header length in bytes (not including encryption
+ * headers). If the data in the sk_buff is too short to contain a valid 802.11
+ * header the function returns 0.
+ *
+ * @skb: the frame
+ */
+unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb);
+
+/**
+ * ieee80211_hdrlen - get header length in bytes from frame control
+ * @fc: frame control field in little-endian format
+ */
+unsigned int ieee80211_hdrlen(__le16 fc);
+
+/**
+ * ieee80211_data_to_8023 - convert an 802.11 data frame to 802.3
+ * @skb: the 802.11 data frame
+ * @addr: the device MAC address
+ * @iftype: the virtual interface type
+ */
+int ieee80211_data_to_8023(struct sk_buff *skb, u8 *addr,
+			   enum nl80211_iftype iftype);
+
+/**
+ * ieee80211_data_from_8023 - convert an 802.3 frame to 802.11
+ * @skb: the 802.3 frame
+ * @addr: the device MAC address
+ * @iftype: the virtual interface type
+ * @bssid: the network bssid (used only for iftype STATION and ADHOC)
+ * @qos: build 802.11 QoS data frame
+ */
+int ieee80211_data_from_8023(struct sk_buff *skb, u8 *addr,
+			     enum nl80211_iftype iftype, u8 *bssid, bool qos);
+
+/**
+ * cfg80211_classify8021d - determine the 802.1p/1d tag for a data frame
+ * @skb: the data frame
+ */
+unsigned int cfg80211_classify8021d(struct sk_buff *skb);
+
 /*
  * Regulatory helper functions for wiphys
  */
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d10ed17..5314580 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -673,16 +673,6 @@ enum ieee80211_key_alg {
 };
 
 /**
- * enum ieee80211_key_len - key length
- * @LEN_WEP40: WEP 5-byte long key
- * @LEN_WEP104: WEP 13-byte long key
- */
-enum ieee80211_key_len {
-	LEN_WEP40 = 5,
-	LEN_WEP104 = 13,
-};
-
-/**
  * enum ieee80211_key_flags - key flags
  *
  * These flags are used for communication about keys between the driver
@@ -1813,24 +1803,6 @@ struct sk_buff *
 ieee80211_get_buffered_bc(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 
 /**
- * ieee80211_get_hdrlen_from_skb - get header length from data
- *
- * Given an skb with a raw 802.11 header at the data pointer this function
- * returns the 802.11 header length in bytes (not including encryption
- * headers). If the data in the sk_buff is too short to contain a valid 802.11
- * header the function returns 0.
- *
- * @skb: the frame
- */
-unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb);
-
-/**
- * ieee80211_hdrlen - get header length in bytes from frame control
- * @fc: frame control field in little-endian format
- */
-unsigned int ieee80211_hdrlen(__le16 fc);
-
-/**
  * ieee80211_get_tkip_key - get a TKIP rc4 for skb
  *
  * This function computes a TKIP rc4 key for an skb. It computes
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8db8d16..c088c46 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1085,8 +1085,6 @@ static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 
 /* utility functions/constants */
 extern void *mac80211_wiphy_privid; /* for wiphy privid */
-extern const unsigned char rfc1042_header[6];
-extern const unsigned char bridge_tunnel_header[6];
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 			enum nl80211_iftype type);
 int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 832bb50..c7d7281 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -191,12 +191,8 @@ struct mesh_rmc {
 #define PLINK_CATEGORY		30
 #define MESH_PATH_SEL_CATEGORY	32
 
-/* Mesh Header Flags */
-#define IEEE80211S_FLAGS_AE	0x3
-
 /* Public interfaces */
 /* Various */
-int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr);
 int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
 		struct ieee80211_sub_if_data *sdata);
 int mesh_rmc_check(u8 *addr, struct ieee80211s_hdr *mesh_hdr,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f3a041c..6a9b8e6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1247,93 +1247,12 @@ ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx, __le16 fc)
 }
 
 static int
-ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
+__ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 {
 	struct net_device *dev = rx->dev;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
-	u16 hdrlen, ethertype;
-	u8 *payload;
-	u8 dst[ETH_ALEN];
-	u8 src[ETH_ALEN] __aligned(2);
-	struct sk_buff *skb = rx->skb;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (unlikely(!ieee80211_is_data_present(hdr->frame_control)))
-		return -1;
-
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-
-	/* convert IEEE 802.11 header + possible LLC headers into Ethernet
-	 * header
-	 * IEEE 802.11 address fields:
-	 * ToDS FromDS Addr1 Addr2 Addr3 Addr4
-	 *   0     0   DA    SA    BSSID n/a
-	 *   0     1   DA    BSSID SA    n/a
-	 *   1     0   BSSID SA    DA    n/a
-	 *   1     1   RA    TA    DA    SA
-	 */
-	memcpy(dst, ieee80211_get_DA(hdr), ETH_ALEN);
-	memcpy(src, ieee80211_get_SA(hdr), ETH_ALEN);
-
-	switch (hdr->frame_control &
-		cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
-	case cpu_to_le16(IEEE80211_FCTL_TODS):
-		if (unlikely(sdata->vif.type != NL80211_IFTYPE_AP &&
-			     sdata->vif.type != NL80211_IFTYPE_AP_VLAN))
-			return -1;
-		break;
-	case cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS):
-		if (unlikely(sdata->vif.type != NL80211_IFTYPE_WDS &&
-			     sdata->vif.type != NL80211_IFTYPE_MESH_POINT))
-			return -1;
-		if (ieee80211_vif_is_mesh(&sdata->vif)) {
-			struct ieee80211s_hdr *meshdr = (struct ieee80211s_hdr *)
-				(skb->data + hdrlen);
-			hdrlen += ieee80211_get_mesh_hdrlen(meshdr);
-			if (meshdr->flags & MESH_FLAGS_AE_A5_A6) {
-				memcpy(dst, meshdr->eaddr1, ETH_ALEN);
-				memcpy(src, meshdr->eaddr2, ETH_ALEN);
-			}
-		}
-		break;
-	case cpu_to_le16(IEEE80211_FCTL_FROMDS):
-		if (sdata->vif.type != NL80211_IFTYPE_STATION ||
-		    (is_multicast_ether_addr(dst) &&
-		     !compare_ether_addr(src, dev->dev_addr)))
-			return -1;
-		break;
-	case cpu_to_le16(0):
-		if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
-			return -1;
-		break;
-	}
-
-	if (unlikely(skb->len - hdrlen < 8))
-		return -1;
-
-	payload = skb->data + hdrlen;
-	ethertype = (payload[6] << 8) | payload[7];
-
-	if (likely((compare_ether_addr(payload, rfc1042_header) == 0 &&
-		    ethertype != ETH_P_AARP && ethertype != ETH_P_IPX) ||
-		   compare_ether_addr(payload, bridge_tunnel_header) == 0)) {
-		/* remove RFC1042 or Bridge-Tunnel encapsulation and
-		 * replace EtherType */
-		skb_pull(skb, hdrlen + 6);
-		memcpy(skb_push(skb, ETH_ALEN), src, ETH_ALEN);
-		memcpy(skb_push(skb, ETH_ALEN), dst, ETH_ALEN);
-	} else {
-		struct ethhdr *ehdr;
-		__be16 len;
-
-		skb_pull(skb, hdrlen);
-		len = htons(skb->len);
-		ehdr = (struct ethhdr *) skb_push(skb, sizeof(struct ethhdr));
-		memcpy(ehdr->h_dest, dst, ETH_ALEN);
-		memcpy(ehdr->h_source, src, ETH_ALEN);
-		ehdr->h_proto = len;
-	}
-	return 0;
+	return ieee80211_data_to_8023(rx->skb, dev->dev_addr, sdata->vif.type);
 }
 
 /*
@@ -1472,7 +1391,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	if (!(rx->flags & IEEE80211_RX_AMSDU))
 		return RX_CONTINUE;
 
-	err = ieee80211_data_to_8023(rx);
+	err = __ieee80211_data_to_8023(rx);
 	if (unlikely(err))
 		return RX_DROP_UNUSABLE;
 
@@ -1658,7 +1577,7 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 	if (unlikely(!ieee80211_is_data_present(hdr->frame_control)))
 		return RX_DROP_MONITOR;
 
-	err = ieee80211_data_to_8023(rx);
+	err = __ieee80211_data_to_8023(rx);
 	if (unlikely(err))
 		return RX_DROP_UNUSABLE;
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ffb6e88..949d857 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -35,15 +35,6 @@
 /* privid for wiphys to determine whether they belong to us or not */
 void *mac80211_wiphy_privid = &mac80211_wiphy_privid;
 
-/* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
-/* Ethernet-II snap header (RFC1042 for most EtherTypes) */
-const unsigned char rfc1042_header[] __aligned(2) =
-	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
-
-/* Bridge-Tunnel header (for EtherTypes ETH_P_AARP and ETH_P_IPX) */
-const unsigned char bridge_tunnel_header[] __aligned(2) =
-	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
-
 struct ieee80211_hw *wiphy_to_ieee80211_hw(struct wiphy *wiphy)
 {
 	struct ieee80211_local *local;
@@ -103,70 +94,6 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 	return NULL;
 }
 
-unsigned int ieee80211_hdrlen(__le16 fc)
-{
-	unsigned int hdrlen = 24;
-
-	if (ieee80211_is_data(fc)) {
-		if (ieee80211_has_a4(fc))
-			hdrlen = 30;
-		if (ieee80211_is_data_qos(fc))
-			hdrlen += IEEE80211_QOS_CTL_LEN;
-		goto out;
-	}
-
-	if (ieee80211_is_ctl(fc)) {
-		/*
-		 * ACK and CTS are 10 bytes, all others 16. To see how
-		 * to get this condition consider
-		 *   subtype mask:   0b0000000011110000 (0x00F0)
-		 *   ACK subtype:    0b0000000011010000 (0x00D0)
-		 *   CTS subtype:    0b0000000011000000 (0x00C0)
-		 *   bits that matter:         ^^^      (0x00E0)
-		 *   value of those: 0b0000000011000000 (0x00C0)
-		 */
-		if ((fc & cpu_to_le16(0x00E0)) == cpu_to_le16(0x00C0))
-			hdrlen = 10;
-		else
-			hdrlen = 16;
-	}
-out:
-	return hdrlen;
-}
-EXPORT_SYMBOL(ieee80211_hdrlen);
-
-unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
-{
-	const struct ieee80211_hdr *hdr = (const struct ieee80211_hdr *)skb->data;
-	unsigned int hdrlen;
-
-	if (unlikely(skb->len < 10))
-		return 0;
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-	if (unlikely(hdrlen > skb->len))
-		return 0;
-	return hdrlen;
-}
-EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
-
-int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
-{
-	int ae = meshhdr->flags & IEEE80211S_FLAGS_AE;
-	/* 7.1.3.5a.2 */
-	switch (ae) {
-	case 0:
-		return 6;
-	case 1:
-		return 12;
-	case 2:
-		return 18;
-	case 3:
-		return 24;
-	default:
-		return 6;
-	}
-}
-
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 45b74f3..694343b 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -23,34 +23,6 @@
  */
 const int ieee802_1d_to_ac[8] = { 2, 3, 3, 2, 1, 1, 0, 0 };
 
-static const char llc_ip_hdr[8] = {0xAA, 0xAA, 0x3, 0, 0, 0, 0x08, 0};
-
-/* Given a data frame determine the 802.1p/1d tag to use.  */
-static unsigned int classify_1d(struct sk_buff *skb)
-{
-	unsigned int dscp;
-
-	/* skb->priority values from 256->263 are magic values to
-	 * directly indicate a specific 802.1d priority.  This is used
-	 * to allow 802.1d priority to be passed directly in from VLAN
-	 * tags, etc.
-	 */
-	if (skb->priority >= 256 && skb->priority <= 263)
-		return skb->priority - 256;
-
-	switch (skb->protocol) {
-	case htons(ETH_P_IP):
-		dscp = ip_hdr(skb)->tos & 0xfc;
-		break;
-
-	default:
-		return 0;
-	}
-
-	return dscp >> 5;
-}
-
-
 static int wme_downgrade_ac(struct sk_buff *skb)
 {
 	switch (skb->priority) {
@@ -94,7 +66,7 @@ static u16 classify80211(struct ieee80211_local *local, struct sk_buff *skb)
 
 	/* use the data classifier to determine what 802.1d tag the
 	 * data frame has */
-	skb->priority = classify_1d(skb);
+	skb->priority = cfg80211_classify8021d(skb);
 
 	/* in case we are a client verify acm is not set for this ac */
 	while (unlikely(local->wmm_acm & BIT(skb->priority))) {
diff --git a/net/wireless/util.c b/net/wireless/util.c
index b94c860..d072bff 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -4,7 +4,9 @@
  * Copyright 2007-2009	Johannes Berg <johannes@sipsolutions.net>
  */
 #include <linux/bitops.h>
+#include <linux/etherdevice.h>
 #include <net/cfg80211.h>
+#include <net/ip.h>
 #include "core.h"
 
 struct ieee80211_rate *
@@ -198,3 +200,306 @@ int cfg80211_validate_key_settings(struct key_params *params, int key_idx,
 
 	return 0;
 }
+
+/* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
+/* Ethernet-II snap header (RFC1042 for most EtherTypes) */
+const unsigned char rfc1042_header[] __aligned(2) =
+	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
+EXPORT_SYMBOL(rfc1042_header);
+
+/* Bridge-Tunnel header (for EtherTypes ETH_P_AARP and ETH_P_IPX) */
+const unsigned char bridge_tunnel_header[] __aligned(2) =
+	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
+EXPORT_SYMBOL(bridge_tunnel_header);
+
+unsigned int ieee80211_hdrlen(__le16 fc)
+{
+	unsigned int hdrlen = 24;
+
+	if (ieee80211_is_data(fc)) {
+		if (ieee80211_has_a4(fc))
+			hdrlen = 30;
+		if (ieee80211_is_data_qos(fc))
+			hdrlen += IEEE80211_QOS_CTL_LEN;
+		goto out;
+	}
+
+	if (ieee80211_is_ctl(fc)) {
+		/*
+		 * ACK and CTS are 10 bytes, all others 16. To see how
+		 * to get this condition consider
+		 *   subtype mask:   0b0000000011110000 (0x00F0)
+		 *   ACK subtype:    0b0000000011010000 (0x00D0)
+		 *   CTS subtype:    0b0000000011000000 (0x00C0)
+		 *   bits that matter:         ^^^      (0x00E0)
+		 *   value of those: 0b0000000011000000 (0x00C0)
+		 */
+		if ((fc & cpu_to_le16(0x00E0)) == cpu_to_le16(0x00C0))
+			hdrlen = 10;
+		else
+			hdrlen = 16;
+	}
+out:
+	return hdrlen;
+}
+EXPORT_SYMBOL(ieee80211_hdrlen);
+
+unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
+{
+	const struct ieee80211_hdr *hdr =
+			(const struct ieee80211_hdr *)skb->data;
+	unsigned int hdrlen;
+
+	if (unlikely(skb->len < 10))
+		return 0;
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	if (unlikely(hdrlen > skb->len))
+		return 0;
+	return hdrlen;
+}
+EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
+
+int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
+{
+	int ae = meshhdr->flags & MESH_FLAGS_AE;
+	/* 7.1.3.5a.2 */
+	switch (ae) {
+	case 0:
+		return 6;
+	case 1:
+		return 12;
+	case 2:
+		return 18;
+	case 3:
+		return 24;
+	default:
+		return 6;
+	}
+}
+
+int ieee80211_data_to_8023(struct sk_buff *skb, u8 *addr,
+			   enum nl80211_iftype iftype)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	u16 hdrlen, ethertype;
+	u8 *payload;
+	u8 dst[ETH_ALEN];
+	u8 src[ETH_ALEN] __aligned(2);
+
+	if (unlikely(!ieee80211_is_data_present(hdr->frame_control)))
+		return -1;
+
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+
+	/* convert IEEE 802.11 header + possible LLC headers into Ethernet
+	 * header
+	 * IEEE 802.11 address fields:
+	 * ToDS FromDS Addr1 Addr2 Addr3 Addr4
+	 *   0     0   DA    SA    BSSID n/a
+	 *   0     1   DA    BSSID SA    n/a
+	 *   1     0   BSSID SA    DA    n/a
+	 *   1     1   RA    TA    DA    SA
+	 */
+	memcpy(dst, ieee80211_get_DA(hdr), ETH_ALEN);
+	memcpy(src, ieee80211_get_SA(hdr), ETH_ALEN);
+
+	switch (hdr->frame_control &
+		cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
+	case cpu_to_le16(IEEE80211_FCTL_TODS):
+		if (unlikely(iftype != NL80211_IFTYPE_AP &&
+			     iftype != NL80211_IFTYPE_AP_VLAN))
+			return -1;
+		break;
+	case cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS):
+		if (unlikely(iftype != NL80211_IFTYPE_WDS &&
+			     iftype != NL80211_IFTYPE_MESH_POINT))
+			return -1;
+		if (iftype == NL80211_IFTYPE_MESH_POINT) {
+			struct ieee80211s_hdr *meshdr =
+				(struct ieee80211s_hdr *) (skb->data + hdrlen);
+			hdrlen += ieee80211_get_mesh_hdrlen(meshdr);
+			if (meshdr->flags & MESH_FLAGS_AE_A5_A6) {
+				memcpy(dst, meshdr->eaddr1, ETH_ALEN);
+				memcpy(src, meshdr->eaddr2, ETH_ALEN);
+			}
+		}
+		break;
+	case cpu_to_le16(IEEE80211_FCTL_FROMDS):
+		if (iftype != NL80211_IFTYPE_STATION ||
+		    (is_multicast_ether_addr(dst) &&
+		     !compare_ether_addr(src, addr)))
+			return -1;
+		break;
+	case cpu_to_le16(0):
+		if (iftype != NL80211_IFTYPE_ADHOC)
+			return -1;
+		break;
+	}
+
+	if (unlikely(skb->len - hdrlen < 8))
+		return -1;
+
+	payload = skb->data + hdrlen;
+	ethertype = (payload[6] << 8) | payload[7];
+
+	if (likely((compare_ether_addr(payload, rfc1042_header) == 0 &&
+		    ethertype != ETH_P_AARP && ethertype != ETH_P_IPX) ||
+		   compare_ether_addr(payload, bridge_tunnel_header) == 0)) {
+		/* remove RFC1042 or Bridge-Tunnel encapsulation and
+		 * replace EtherType */
+		skb_pull(skb, hdrlen + 6);
+		memcpy(skb_push(skb, ETH_ALEN), src, ETH_ALEN);
+		memcpy(skb_push(skb, ETH_ALEN), dst, ETH_ALEN);
+	} else {
+		struct ethhdr *ehdr;
+		__be16 len;
+
+		skb_pull(skb, hdrlen);
+		len = htons(skb->len);
+		ehdr = (struct ethhdr *) skb_push(skb, sizeof(struct ethhdr));
+		memcpy(ehdr->h_dest, dst, ETH_ALEN);
+		memcpy(ehdr->h_source, src, ETH_ALEN);
+		ehdr->h_proto = len;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(ieee80211_data_to_8023);
+
+int ieee80211_data_from_8023(struct sk_buff *skb, u8 *addr,
+			     enum nl80211_iftype iftype, u8 *bssid, bool qos)
+{
+	struct ieee80211_hdr hdr;
+	u16 hdrlen, ethertype;
+	__le16 fc;
+	const u8 *encaps_data;
+	int encaps_len, skip_header_bytes;
+	int nh_pos, h_pos;
+	int head_need;
+
+	if (unlikely(skb->len < ETH_HLEN))
+		return -EINVAL;
+
+	nh_pos = skb_network_header(skb) - skb->data;
+	h_pos = skb_transport_header(skb) - skb->data;
+
+	/* convert Ethernet header to proper 802.11 header (based on
+	 * operation mode) */
+	ethertype = (skb->data[12] << 8) | skb->data[13];
+	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA);
+
+	switch (iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
+		/* DA BSSID SA */
+		memcpy(hdr.addr1, skb->data, ETH_ALEN);
+		memcpy(hdr.addr2, addr, ETH_ALEN);
+		memcpy(hdr.addr3, skb->data + ETH_ALEN, ETH_ALEN);
+		hdrlen = 24;
+		break;
+	case NL80211_IFTYPE_STATION:
+		fc |= cpu_to_le16(IEEE80211_FCTL_TODS);
+		/* BSSID SA DA */
+		memcpy(hdr.addr1, bssid, ETH_ALEN);
+		memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
+		memcpy(hdr.addr3, skb->data, ETH_ALEN);
+		hdrlen = 24;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		/* DA SA BSSID */
+		memcpy(hdr.addr1, skb->data, ETH_ALEN);
+		memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
+		memcpy(hdr.addr3, bssid, ETH_ALEN);
+		hdrlen = 24;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if (qos) {
+		fc |= cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
+		hdrlen += 2;
+	}
+
+	hdr.frame_control = fc;
+	hdr.duration_id = 0;
+	hdr.seq_ctrl = 0;
+
+	skip_header_bytes = ETH_HLEN;
+	if (ethertype == ETH_P_AARP || ethertype == ETH_P_IPX) {
+		encaps_data = bridge_tunnel_header;
+		encaps_len = sizeof(bridge_tunnel_header);
+		skip_header_bytes -= 2;
+	} else if (ethertype > 0x600) {
+		encaps_data = rfc1042_header;
+		encaps_len = sizeof(rfc1042_header);
+		skip_header_bytes -= 2;
+	} else {
+		encaps_data = NULL;
+		encaps_len = 0;
+	}
+
+	skb_pull(skb, skip_header_bytes);
+	nh_pos -= skip_header_bytes;
+	h_pos -= skip_header_bytes;
+
+	head_need = hdrlen + encaps_len - skb_headroom(skb);
+
+	if (head_need > 0 || skb_cloned(skb)) {
+		head_need = max(head_need, 0);
+		if (head_need)
+			skb_orphan(skb);
+
+		if (pskb_expand_head(skb, head_need, 0, GFP_ATOMIC)) {
+			printk(KERN_ERR "failed to reallocate Tx buffer\n");
+			return -ENOMEM;
+		}
+		skb->truesize += head_need;
+	}
+
+	if (encaps_data) {
+		memcpy(skb_push(skb, encaps_len), encaps_data, encaps_len);
+		nh_pos += encaps_len;
+		h_pos += encaps_len;
+	}
+
+	memcpy(skb_push(skb, hdrlen), &hdr, hdrlen);
+
+	nh_pos += hdrlen;
+	h_pos += hdrlen;
+
+	/* Update skb pointers to various headers since this modified frame
+	 * is going to go through Linux networking code that may potentially
+	 * need things like pointer to IP header. */
+	skb_set_mac_header(skb, 0);
+	skb_set_network_header(skb, nh_pos);
+	skb_set_transport_header(skb, h_pos);
+
+	return 0;
+}
+EXPORT_SYMBOL(ieee80211_data_from_8023);
+
+/* Given a data frame determine the 802.1p/1d tag to use. */
+unsigned int cfg80211_classify8021d(struct sk_buff *skb)
+{
+	unsigned int dscp;
+
+	/* skb->priority values from 256->263 are magic values to
+	 * directly indicate a specific 802.1d priority.  This is used
+	 * to allow 802.1d priority to be passed directly in from VLAN
+	 * tags, etc.
+	 */
+	if (skb->priority >= 256 && skb->priority <= 263)
+		return skb->priority - 256;
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		dscp = ip_hdr(skb)->tos & 0xfc;
+		break;
+	default:
+		return 0;
+	}
+
+	return dscp >> 5;
+}
+EXPORT_SYMBOL(cfg80211_classify8021d);
-- 
1.6.0.4

