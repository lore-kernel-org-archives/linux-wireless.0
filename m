Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx-del1-1.globallogic.com ([202.174.92.25]:59614 "EHLO
	emailsecurity-del1-1.globallogic.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251Ab0BBOeA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2010 09:34:00 -0500
Received: from emailsecurity-del1-1.globallogic.com (127.0.0.1) by emailsecurity-del1-1.globallogic.com (MlfMTA v3.2r9) id hd0rns0171sn for <linux-wireless@vger.kernel.org>; Tue, 2 Feb 2010 20:02:28 +0530 (envelope-from <andrit@ukr.net>)
Message-ID: <4B6837D1.6020503@ukr.net>
Date: Tue, 02 Feb 2010 16:33:53 +0200
From: Andriy Tkachuk <andrit@ukr.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] lib80211: Introduce TKIP_HDR_LEN define for code clarity
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce TKIP_HDR_LEN define for code clarity (in the same way as
CCMP_HDR_LEN).

Also odd len variable (not used) dropped from lib80211_tkip_hdr().

Signed-off-by: Andriy V. Tkachuk <andrit@ukr.net>

---

Found few more candidates for TKIP_HDR_LEN usage comparing to prev. patch.

diff --git a/net/wireless/lib80211_crypt_tkip.c
b/net/wireless/lib80211_crypt_tkip.c
index c362873..8cbdb32 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -36,6 +36,8 @@ MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("lib80211 crypt: TKIP");
 MODULE_LICENSE("GPL");

+#define TKIP_HDR_LEN 8
+
 struct lib80211_tkip_data {
 #define TKIP_KEY_LEN 32
 	u8 key[TKIP_KEY_LEN];
@@ -314,13 +316,12 @@ static int lib80211_tkip_hdr(struct sk_buff *skb,
int hdr_len,
 			      u8 * rc4key, int keylen, void *priv)
 {
 	struct lib80211_tkip_data *tkey = priv;
-	int len;
 	u8 *pos;
 	struct ieee80211_hdr *hdr;

 	hdr = (struct ieee80211_hdr *)skb->data;

-	if (skb_headroom(skb) < 8 || skb->len < hdr_len)
+	if (skb_headroom(skb) < TKIP_HDR_LEN || skb->len < hdr_len)
 		return -1;

 	if (rc4key == NULL || keylen < 16)
@@ -333,9 +334,8 @@ static int lib80211_tkip_hdr(struct sk_buff *skb,
int hdr_len,
 	}
 	tkip_mixing_phase2(rc4key, tkey->key, tkey->tx_ttak, tkey->tx_iv16);

-	len = skb->len - hdr_len;
-	pos = skb_push(skb, 8);
-	memmove(pos, pos + 8, hdr_len);
+	pos = skb_push(skb, TKIP_HDR_LEN);
+	memmove(pos, pos + TKIP_HDR_LEN, hdr_len);
 	pos += hdr_len;

 	*pos++ = *rc4key;
@@ -353,7 +353,7 @@ static int lib80211_tkip_hdr(struct sk_buff *skb,
int hdr_len,
 		tkey->tx_iv32++;
 	}

-	return 8;
+	return TKIP_HDR_LEN;
 }

 static int lib80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void
*priv)
@@ -434,7 +433,7 @@ static int lib80211_tkip_decrypt(struct sk_buff
*skb, int hdr_len, void *priv)
 		return -1;
 	}

-	if (skb->len < hdr_len + 8 + 4)
+	if (skb->len < hdr_len + TKIP_HDR_LEN + 4)
 		return -1;

 	pos = skb->data + hdr_len;
@@ -462,7 +461,7 @@ static int lib80211_tkip_decrypt(struct sk_buff
*skb, int hdr_len, void *priv)
 	}
 	iv16 = (pos[0] << 8) | pos[2];
 	iv32 = pos[4] | (pos[5] << 8) | (pos[6] << 16) | (pos[7] << 24);
-	pos += 8;
+	pos += TKIP_HDR_LEN;

 	if (tkip_replay_check(iv32, iv16, tkey->rx_iv32, tkey->rx_iv16)) {
 #ifdef CONFIG_LIB80211_DEBUG
@@ -523,8 +522,8 @@ static int lib80211_tkip_decrypt(struct sk_buff
*skb, int hdr_len, void *priv)
 	tkey->rx_iv16_new = iv16;

 	/* Remove IV and ICV */
-	memmove(skb->data + 8, skb->data, hdr_len);
-	skb_pull(skb, 8);
+	memmove(skb->data + TKIP_HDR_LEN, skb->data, hdr_len);
+	skb_pull(skb, TKIP_HDR_LEN);
 	skb_trim(skb, skb->len - 4);

 	return keyidx;
