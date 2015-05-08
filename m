Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32880 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbbEHLDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 07:03:45 -0400
Date: Fri, 8 May 2015 14:03:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gaston Gonzalez <gascoar@gmail.com>
Cc: devel@driverdev.osuosl.org, arnd@arndb.de,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	joe@perches.com, navyasri.tech@gmail.com
Subject: Re: [PATCH] staging: rtl8192u: ieee80211: Silence sparse warning
Message-ID: <20150508110328.GT14154@mwanda> (sfid-20150508_130349_012739_C8777D21)
References: <1429476231-6197-1-git-send-email-gascoar@gmail.com>
 <20150420082441.GU10964@mwanda>
 <553C18B6.807@gmail.com>
 <20150427101242.GR14154@mwanda>
 <554AD76E.7060605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <554AD76E.7060605@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To be honest, I'm a little bit a newbie myself when it comes to
linux-wireless so keep that in mind.  ;)  Changing the parameters seems
simple enough.  But it needs to an EXPORT_SYMBOL() and to be declared in
a header file and I'm not sure what else.  But we have four
implementations of this function now.

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 0ae2077..f149593 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -105,11 +105,9 @@ static void tkip_mixing_phase1(const u8 *tk, struct tkip_ctx *ctx,
 	ctx->p1k_iv32 = tsc_IV32;
 }
 
-static void tkip_mixing_phase2(const u8 *tk, struct tkip_ctx *ctx,
-			       u16 tsc_IV16, u8 *rc4key)
+void tkip_mixing_phase2(const u8 *tk, const u16 *p1k, u16 tsc_IV16, u8 *rc4key)
 {
 	u16 ppk[6];
-	const u16 *p1k = ctx->p1k;
 	int i;
 
 	ppk[0] = p1k[0];
@@ -210,7 +208,7 @@ void ieee80211_get_tkip_p2k(struct ieee80211_key_conf *keyconf,
 
 	spin_lock(&key->u.tkip.txlock);
 	ieee80211_compute_tkip_p1k(key, iv32);
-	tkip_mixing_phase2(tk, ctx, iv16, p2k);
+	tkip_mixing_phase2(tk, ctx->p1k, iv16, p2k);
 	spin_unlock(&key->u.tkip.txlock);
 }
 EXPORT_SYMBOL(ieee80211_get_tkip_p2k);
@@ -295,7 +293,7 @@ int ieee80211_tkip_decrypt_data(struct crypto_cipher *tfm,
 		key->u.tkip.rx[queue].state = TKIP_STATE_PHASE1_HW_UPLOADED;
 	}
 
-	tkip_mixing_phase2(tk, &key->u.tkip.rx[queue], iv16, rc4key);
+	tkip_mixing_phase2(tk, key->u.tkip.rx[queue].p1k, iv16, rc4key);
 
 	res = ieee80211_wep_decrypt_data(tfm, rc4key, 16, pos, payload_len - 12);
  done:
