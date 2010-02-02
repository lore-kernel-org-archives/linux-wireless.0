Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx-del1-1.globallogic.com ([202.174.92.25]:39974 "EHLO
	emailsecurity-del1-1.globallogic.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754626Ab0BBLcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2010 06:32:35 -0500
Received: from emailsecurity-del1-1.globallogic.com (127.0.0.1) by emailsecurity-del1-1.globallogic.com (MlfMTA v3.2r9) id hd06fk0171sq for <linux-wireless@vger.kernel.org>; Tue, 2 Feb 2010 16:40:00 +0530 (envelope-from <andriy.tkachuk@gmail.com>)
Message-ID: <4B68084E.7080306@gmail.com>
Date: Tue, 02 Feb 2010 13:11:10 +0200
From: Andriy Tkachuk <andriy.tkachuk@gmail.com>
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
 net/wireless/lib80211_crypt_tkip.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/wireless/lib80211_crypt_tkip.c
b/net/wireless/lib80211_crypt_tkip.c
index c362873..c4fb4fb 100644
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
