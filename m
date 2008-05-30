Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms5.Sony.CO.JP ([211.125.136.201]:39042 "EHLO ms5.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbYE3Hww (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 03:52:52 -0400
Received: from mta6.sony.co.jp (mta6.Sony.CO.JP [137.153.71.9])
 by ms5.sony.co.jp (R8/Sony) with ESMTP id m4U7qoG8018900
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:52:50 +0900 (JST)
Received: from mta6.sony.co.jp (localhost [127.0.0.1])
 by mta6.sony.co.jp (R8/Sony) with ESMTP id m4U7qokJ015449
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:52:50 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
 by mta6.sony.co.jp (R8/Sony) with ESMTP id m4U7qnts015443
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:52:50 +0900 (JST)
Date: Fri, 30 May 2008 16:52:44 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] PS3: gelic: Use the new PMK interface in the gelic driver
Cc: geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <20080530163019.4741.40F06B3A@sm.sony.co.jp>
References: <20080530163019.4741.40F06B3A@sm.sony.co.jp>
Message-Id: <20080530164511.474A.40F06B3A@sm.sony.co.jp> (sfid-20080530_095254_483513_0A0CE73D)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the new WEXT flags, the PS3 wireless driver can tell the user space that
it would do handle 4-way handshake by itself and needs the PSK without private
ioctls.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 drivers/net/ps3_gelic_wireless.c |   46 ++++++++++-----------------------------
 1 file changed, 12 insertions(+), 34 deletions(-)

--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -350,7 +350,8 @@ static int gelic_wl_get_range(struct net
 
 	/* encryption capability */
 	range->enc_capa = IW_ENC_CAPA_WPA |
-		IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
+		IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP |
+		IW_ENC_CAPA_4WAY_HANDSHAKE;
 	if (wpa2_capable())
 		range->enc_capa |= IW_ENC_CAPA_WPA2;
 	range->encoding_size[0] = 5;	/* 40bit WEP */
@@ -1256,42 +1257,19 @@ static int gelic_wl_set_encodeext(struct
 		set_bit(key_index, &wl->key_enabled);
 		/* remember wep info changed */
 		set_bit(GELIC_WL_STAT_CONFIGURED, &wl->stat);
-	} else if ((alg == IW_ENCODE_ALG_TKIP) || (alg == IW_ENCODE_ALG_CCMP)) {
-		pr_debug("%s: TKIP/CCMP requested alg=%d\n", __func__, alg);
-		/* check key length */
-		if (IW_ENCODING_TOKEN_MAX < ext->key_len) {
-			pr_info("%s: key is too long %d\n", __func__,
-				ext->key_len);
+	} else if (alg == IW_ENCODE_ALG_PMK) {
+		if (ext->key_len != WPA_PSK_LEN) {
+			pr_err("%s: PSK length wrong %d\n", __func__,
+			       ext->key_len);
 			ret = -EINVAL;
 			goto done;
 		}
-		if (alg == IW_ENCODE_ALG_CCMP) {
-			pr_debug("%s: AES selected\n", __func__);
-			wl->group_cipher_method = GELIC_WL_CIPHER_AES;
-			wl->pairwise_cipher_method = GELIC_WL_CIPHER_AES;
-			wl->wpa_level = GELIC_WL_WPA_LEVEL_WPA2;
-		} else {
-			pr_debug("%s: TKIP selected, WPA forced\n", __func__);
-			wl->group_cipher_method = GELIC_WL_CIPHER_TKIP;
-			wl->pairwise_cipher_method = GELIC_WL_CIPHER_TKIP;
-			/* FIXME: how do we do if WPA2 + TKIP? */
-			wl->wpa_level = GELIC_WL_WPA_LEVEL_WPA;
-		}
-		if (flags & IW_ENCODE_RESTRICTED)
-			BUG();
-		wl->auth_method = GELIC_EURUS_AUTH_OPEN;
-		/* We should use same key for both and unicast */
-		if (ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY)
-			pr_debug("%s: group key \n", __func__);
-		else
-			pr_debug("%s: unicast key \n", __func__);
-		/* OK, update the key */
-		wl->key_len[key_index] = ext->key_len;
-		memset(wl->key[key_index], 0, IW_ENCODING_TOKEN_MAX);
-		memcpy(wl->key[key_index], ext->key, ext->key_len);
-		set_bit(key_index, &wl->key_enabled);
-		/* remember info changed */
-		set_bit(GELIC_WL_STAT_CONFIGURED, &wl->stat);
+		memset(wl->psk, 0, sizeof(wl->psk));
+		memcpy(wl->psk, ext->key, ext->key_len);
+		wl->psk_len = ext->key_len;
+		wl->psk_type = GELIC_EURUS_WPA_PSK_BIN;
+		/* remember PSK configured */
+		set_bit(GELIC_WL_STAT_WPA_PSK_SET, &wl->stat);
 	}
 done:
 	spin_unlock_irqrestore(&wl->lock, irqflag);

