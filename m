Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx-del1-1.globallogic.com ([202.174.92.25]:36184 "EHLO
	emailsecurity-del1-1.globallogic.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755943Ab0BBN7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2010 08:59:08 -0500
Received: from emailsecurity-del1-1.globallogic.com (127.0.0.1) by emailsecurity-del1-1.globallogic.com (MlfMTA v3.2r9) id hd0nl40171s1 for <linux-wireless@vger.kernel.org>; Tue, 2 Feb 2010 19:27:33 +0530 (envelope-from <andrit@ukr.net>)
Message-ID: <4B682F9D.4060004@ukr.net>
Date: Tue, 02 Feb 2010 15:58:53 +0200
From: Andriy Tkachuk <andrit@ukr.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] lib80211: Cosmetics - make room for MIC/CRC near the actual
 calculation
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Andriy V. Tkachuk <andrit@ukr.net>

---
 net/wireless/lib80211_crypt_ccmp.c |    2 +-
 net/wireless/lib80211_crypt_tkip.c |   15 +++++++--------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/wireless/lib80211_crypt_ccmp.c
b/net/wireless/lib80211_crypt_ccmp.c
index 2301dc1..b7fa31d 100644
--- a/net/wireless/lib80211_crypt_ccmp.c
+++ b/net/wireless/lib80211_crypt_ccmp.c
@@ -237,7 +237,6 @@ static int lib80211_ccmp_encrypt(struct sk_buff
*skb, int hdr_len, void *priv)
 		return -1;

 	pos = skb->data + hdr_len + CCMP_HDR_LEN;
-	mic = skb_put(skb, CCMP_MIC_LEN);
 	hdr = (struct ieee80211_hdr *)skb->data;
 	ccmp_init_blocks(key->tfm, hdr, key->tx_pn, data_len, b0, b, s0);

@@ -257,6 +256,7 @@ static int lib80211_ccmp_encrypt(struct sk_buff
*skb, int hdr_len, void *priv)
 		pos += len;
 	}

+	mic = skb_put(skb, CCMP_MIC_LEN);
 	for (i = 0; i < CCMP_MIC_LEN; i++)
 		mic[i] = b[i] ^ s0[i];

diff --git a/net/wireless/lib80211_crypt_tkip.c
b/net/wireless/lib80211_crypt_tkip.c
index c362873..7d9254c 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -384,9 +384,8 @@ static int lib80211_tkip_encrypt(struct sk_buff
*skb, int hdr_len, void *priv)
 	if ((lib80211_tkip_hdr(skb, hdr_len, rc4key, 16, priv)) < 0)
 		return -1;

-	icv = skb_put(skb, 4);
-
 	crc = ~crc32_le(~0, pos, len);
+	icv = skb_put(skb, 4);
 	icv[0] = crc;
 	icv[1] = crc >> 8;
 	icv[2] = crc >> 16;
