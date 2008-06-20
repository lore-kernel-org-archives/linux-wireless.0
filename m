Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:42738 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYFTFcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 01:32:36 -0400
Received: by wa-out-1112.google.com with SMTP id j37so809885waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 22:32:35 -0700 (PDT)
Subject: [RFC-PATCH] mac80211: add helpers for skb manipulation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 22:32:24 -0700
Message-Id: <1213939944.6591.13.camel@brick> (sfid-20080620_073256_161167_ECAEAE0C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One helper to check if the skb is long enough for the frame header
plus additional headers.

One helper to remove initialization vectors between the header and
data, and after the data (icv).

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
I have some other mac80211 cleanups, this was just a leftover patch that
I wanted to get some comments on.  I think the helpers would be worth it,
but let me know what you think.

Just about all users of ieee80211_get_hdrlen_from_skb could use the
_check version I've added here as they need to check for additional room
afterwards anyway, I've just done the net/mac80211 users here.

 include/net/mac80211.h |   15 +++++++++++++++
 net/mac80211/main.c    |   40 ++++++++++++++++++----------------------
 net/mac80211/rx.c      |    4 ++--
 net/mac80211/util.c    |   34 ++++++++++++++++++++++++++++++++++
 net/mac80211/wep.c     |   38 ++++++--------------------------------
 net/mac80211/wpa.c     |   13 +++----------
 6 files changed, 78 insertions(+), 66 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7ab4ff6..1549041 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1538,6 +1538,19 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb);
 
 /**
+ * ieee80211_hdrlen_check_skb - get header len, return zero if skb not long enough
+ * @skb: the frame
+ * @slack: number of additional bytes the skb must contain
+ *
+ * Given an skb with a raw 802.11 header at the data pointer this function
+ * returns the 802.11 header length in bytes (not including encryption
+ * headers). If the data in the sk_buff is too short to contain a valid 802.11
+ * header plus the slack bytes, the function returns 0.
+ */
+unsigned int
+ieee80211_hdrlen_check_skb(const struct sk_buff *skb, unsigned int slack);
+
+/**
  * ieee80211_get_hdrlen - get header length from frame control
  *
  * This function returns the 802.11 header length in bytes (not including
@@ -1553,6 +1566,8 @@ int ieee80211_get_hdrlen(u16 fc);
  */
 unsigned int ieee80211_hdrlen(__le16 fc);
 
+void ieee80211_skb_trim_iv_icv(struct sk_buff *skb,
+			       unsigned int iv, unsigned int icv);
 /**
  * ieee80211_get_tkip_key - get a TKIP rc4 for skb
  *
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5c5396e..296368e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1253,7 +1253,8 @@ static void ieee80211_remove_tx_extra(struct ieee80211_local *local,
 				      struct ieee80211_key *key,
 				      struct sk_buff *skb)
 {
-	int hdrlen, iv_len, mic_len;
+	struct ieee80211_hdr *hdr;
+	unsigned int hdrlen, iv_len, icv_len;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 	info->flags &=	IEEE80211_TX_CTL_REQ_TX_STATUS |
@@ -1261,46 +1262,41 @@ static void ieee80211_remove_tx_extra(struct ieee80211_local *local,
 			IEEE80211_TX_CTL_REQUEUE |
 			IEEE80211_TX_CTL_EAPOL_FRAME;
 
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-
 	if (!key)
 		goto no_key;
 
 	switch (key->conf.alg) {
 	case ALG_WEP:
 		iv_len = WEP_IV_LEN;
-		mic_len = WEP_ICV_LEN;
+		icv_len = WEP_ICV_LEN;
 		break;
 	case ALG_TKIP:
 		iv_len = TKIP_IV_LEN;
-		mic_len = TKIP_ICV_LEN;
+		icv_len = TKIP_ICV_LEN;
 		break;
 	case ALG_CCMP:
 		iv_len = CCMP_HDR_LEN;
-		mic_len = CCMP_MIC_LEN;
+		icv_len = CCMP_MIC_LEN;
 		break;
 	default:
 		goto no_key;
 	}
 
-	if (skb->len >= mic_len &&
-	    !(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
-		skb_trim(skb, skb->len - mic_len);
-	if (skb->len >= iv_len && skb->len > hdrlen) {
-		memmove(skb->data + iv_len, skb->data, hdrlen);
-		skb_pull(skb, iv_len);
-	}
+	hdrlen = ieee80211_hdrlen_check_skb(skb, iv_len + icv_len);
+	if (!hdrlen)
+		goto no_key;
+
+	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
+		icv_len = 0;
+
+	ieee80211_skb_trim_iv_icv(skb, iv_len, icv_len);
 
 no_key:
-	{
-		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-		u16 fc = le16_to_cpu(hdr->frame_control);
-		if ((fc & 0x8C) == 0x88) /* QoS Control Field */ {
-			fc &= ~IEEE80211_STYPE_QOS_DATA;
-			hdr->frame_control = cpu_to_le16(fc);
-			memmove(skb->data + 2, skb->data, hdrlen - 2);
-			skb_pull(skb, 2);
-		}
+	/* Remove QOS if present */
+	hdr = (struct ieee80211_hdr *)skb->data;
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		hdr->frame_control &= ~cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
+		ieee80211_skb_trim_iv_icv(skb, IEEE80211_QOS_CTL_LEN, 0);
 	}
 }
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c32a0bc..92d38fb 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1587,8 +1587,8 @@ static void ieee80211_rx_michael_mic_report(struct net_device *dev,
 	DECLARE_MAC_BUF(mac);
 	DECLARE_MAC_BUF(mac2);
 
-	hdrlen = ieee80211_get_hdrlen_from_skb(rx->skb);
-	if (rx->skb->len >= hdrlen + 4)
+	hdrlen = ieee80211_hdrlen_check_skb(rx->skb, 4);
+	if (hdrlen)
 		keyidx = rx->skb->data[hdrlen + 3] >> 6;
 	else
 		keyidx = -1;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ce62b16..493ce19 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -176,6 +176,40 @@ unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
 }
 EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
 
+unsigned int
+ieee80211_hdrlen_check_skb(const struct sk_buff *skb, unsigned int slack)
+{
+	const struct ieee80211_hdr *hdr;
+	unsigned int hdrlen;
+
+	hdr = (const struct ieee80211_hdr *)skb->data;
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+
+	if (skb->len < hdrlen + slack)
+		return 0;
+	else
+		return hdrlen;
+}
+EXPORT_SYMBOL(ieee80211_hdrlen_check_skb);
+
+void ieee80211_skb_trim_iv_icv(struct sk_buff *skb,
+			       unsigned int iv, unsigned int icv)
+{
+	struct ieee80211_hdr *hdr;
+	unsigned int hdrlen;
+
+	if (icv)
+		skb_trim(skb, skb->len - icv);
+
+	if (iv) {
+		hdr = (struct ieee80211_hdr *)skb->data;
+		hdrlen = ieee80211_hdrlen(hdr->frame_control);
+
+		memmove(skb->data + iv, skb->data, hdrlen);
+		skb_pull(skb, iv);
+	}
+}
+
 int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
 {
 	int ae = meshhdr->flags & IEEE80211S_FLAGS_AE;
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index e7b6344..39bd9c9 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -104,22 +104,6 @@ static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
 	return newhdr + hdrlen;
 }
 
-
-static void ieee80211_wep_remove_iv(struct ieee80211_local *local,
-				    struct sk_buff *skb,
-				    struct ieee80211_key *key)
-{
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	u16 fc;
-	int hdrlen;
-
-	fc = le16_to_cpu(hdr->frame_control);
-	hdrlen = ieee80211_get_hdrlen(fc);
-	memmove(skb->data + WEP_IV_LEN, skb->data, hdrlen);
-	skb_pull(skb, WEP_IV_LEN);
-}
-
-
 /* Perform WEP encryption using given key. data buffer must have tailroom
  * for 4-byte ICV. data_len must not include this ICV. Note: this function
  * does _not_ add IV. data = RC4(data | CRC32(data)) */
@@ -225,18 +209,15 @@ int ieee80211_wep_decrypt(struct ieee80211_local *local, struct sk_buff *skb,
 	u8 *rc4key;
 	u8 keyidx;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	u16 fc;
-	int hdrlen;
+	unsigned int hdrlen;
 	size_t len;
 	int ret = 0;
 
-	fc = le16_to_cpu(hdr->frame_control);
-	if (!(fc & IEEE80211_FCTL_PROTECTED))
+	if (!ieee80211_has_protected(hdr->frame_control))
 		return -1;
 
-	hdrlen = ieee80211_get_hdrlen(fc);
-
-	if (skb->len < 8 + hdrlen)
+	hdrlen = ieee80211_hdrlen_check_skb(skb, 8);
+	if (!hdrlen)
 		return -1;
 
 	len = skb->len - hdrlen - 8;
@@ -268,12 +249,7 @@ int ieee80211_wep_decrypt(struct ieee80211_local *local, struct sk_buff *skb,
 
 	kfree(rc4key);
 
-	/* Trim ICV */
-	skb_trim(skb, skb->len - WEP_ICV_LEN);
-
-	/* Remove IV */
-	memmove(skb->data + WEP_IV_LEN, skb->data, hdrlen);
-	skb_pull(skb, WEP_IV_LEN);
+	ieee80211_skb_trim_iv_icv(skb, WEP_IV_LEN, WEP_ICV_LEN);
 
 	return ret;
 }
@@ -319,9 +295,7 @@ ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx)
 			return RX_DROP_UNUSABLE;
 		}
 	} else if (!(rx->status->flag & RX_FLAG_IV_STRIPPED)) {
-		ieee80211_wep_remove_iv(rx->local, rx->skb, rx->key);
-		/* remove ICV */
-		skb_trim(rx->skb, rx->skb->len - 4);
+		ieee80211_skb_trim_iv_icv(rx->skb, WEP_IV_LEN, WEP_ICV_LEN);
 	}
 
 	return RX_CONTINUE;
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 345e10e..b79ef9f 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -147,7 +147,7 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 	}
 
 	/* remove Michael MIC from payload */
-	skb_trim(skb, skb->len - MICHAEL_MIC_LEN);
+	ieee80211_skb_trim_iv_icv(skb, 0, MICHAEL_MIC_LEN);
 
 	/* update IV in key information to be able to detect replays */
 	rx->key->u.tkip.rx[rx->queue].iv32 = rx->tkip_iv32;
@@ -284,12 +284,7 @@ ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
 		return RX_DROP_UNUSABLE;
 	}
 
-	/* Trim ICV */
-	skb_trim(skb, skb->len - TKIP_ICV_LEN);
-
-	/* Remove IV */
-	memmove(skb->data + TKIP_IV_LEN, skb->data, hdrlen);
-	skb_pull(skb, TKIP_IV_LEN);
+	ieee80211_skb_trim_iv_icv(skb, TKIP_IV_LEN, TKIP_ICV_LEN);
 
 	return RX_CONTINUE;
 }
@@ -546,9 +541,7 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 	memcpy(key->u.ccmp.rx_pn[rx->queue], pn, CCMP_PN_LEN);
 
 	/* Remove CCMP header and MIC */
-	skb_trim(skb, skb->len - CCMP_MIC_LEN);
-	memmove(skb->data + CCMP_HDR_LEN, skb->data, hdrlen);
-	skb_pull(skb, CCMP_HDR_LEN);
+	ieee80211_skb_trim_iv_icv(skb, CCMP_HDR_LEN, CCMP_MIC_LEN);
 
 	return RX_CONTINUE;
 }
-- 
1.5.6.290.gc4e15



