Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:36592 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965176AbbENBFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2015 21:05:15 -0400
Received: by qgg76 with SMTP id 76so4443348qgg.3
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2015 18:05:14 -0700 (PDT)
Message-ID: <5553F48E.3050008@gmail.com> (sfid-20150514_030522_036209_6D0AE5EB)
Date: Wed, 13 May 2015 22:04:14 -0300
From: Gaston Gonzalez <gascoar@gmail.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: devel@driverdev.osuosl.org, arnd@arndb.de,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	joe@perches.com, navyasri.tech@gmail.com, julian.calaby@gmail.com
Subject: Re: [PATCH] staging: rtl8192u: ieee80211: Silence sparse warning
References: <1429476231-6197-1-git-send-email-gascoar@gmail.com> <20150420082441.GU10964@mwanda> <553C18B6.807@gmail.com> <20150427101242.GR14154@mwanda> <554AD76E.7060605@gmail.com> <20150508110328.GT14154@mwanda> <55527D6E.7090207@gmail.com> <20150513083615.GS14154@mwanda>
In-Reply-To: <20150513083615.GS14154@mwanda>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13/05/15 05:36, Dan Carpenter wrote:
> How come you didn't use my patch as a base to work from, you shouldn't
> be passing tkip_ctx at all.
Hi Dan, my mistake. To be honest I assumed that the idea was not to
touch tkip.c at all, that's why I had to pass tkip_ctx... sorry about
that :-(

Coming back to your patch: below is the implementation using it. Taking
the advice of Julian Calaby, tkip_mixing_phase2() was stuffed into a
header (other  tkip.c functions are in include/net/mac80211.h so I put
there, not sure if it is the right place, if it is I'll added the
documentation lines to it)

Please let me know if it is well oriented and what changes need to be done.

thanks a lot,

Gaston

---
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c      | 53
++--------------------
 include/net/mac80211.h                             |  3 ++
 net/mac80211/tkip.c                                |  9 ++--
 3 files changed, 10 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
index 1f80c52..b7d0b06 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
@@ -18,3 +18,4 @@
 #include <linux/if_ether.h>
 #include <linux/if_arp.h>
 #include <linux/string.h>
+#include <net/mac80211.h>

 #include "ieee80211.h"

@@ -253,2 +254,2 @@ static void tkip_mixing_phase1(u16 *TTAK, const u8
*TK, const u8 *TA, u32 IV32)
     }
 }

-
-static void tkip_mixing_phase2(u8 *WEPSeed, const u8 *TK, const u16 *TTAK,
-                   u16 IV16)
-{
-    /* Make temporary area overlap WEP seed so that the final copy can be
-     * avoided on little endian hosts. */
-    u16 *PPK = (u16 *) &WEPSeed[4];
-
-    /* Step 1 - make copy of TTAK and bring in TSC */
-    PPK[0] = TTAK[0];
-    PPK[1] = TTAK[1];
-    PPK[2] = TTAK[2];
-    PPK[3] = TTAK[3];
-    PPK[4] = TTAK[4];
-    PPK[5] = TTAK[4] + IV16;
-
-    /* Step 2 - 96-bit bijective mixing using S-box */
-    PPK[0] += _S_(PPK[5] ^ Mk16_le((u16 *) &TK[0]));
-    PPK[1] += _S_(PPK[0] ^ Mk16_le((u16 *) &TK[2]));
-    PPK[2] += _S_(PPK[1] ^ Mk16_le((u16 *) &TK[4]));
-    PPK[3] += _S_(PPK[2] ^ Mk16_le((u16 *) &TK[6]));
-    PPK[4] += _S_(PPK[3] ^ Mk16_le((u16 *) &TK[8]));
-    PPK[5] += _S_(PPK[4] ^ Mk16_le((u16 *) &TK[10]));
-
-    PPK[0] += RotR1(PPK[5] ^ Mk16_le((u16 *) &TK[12]));
-    PPK[1] += RotR1(PPK[0] ^ Mk16_le((u16 *) &TK[14]));
-    PPK[2] += RotR1(PPK[1]);
-    PPK[3] += RotR1(PPK[2]);
-    PPK[4] += RotR1(PPK[3]);
-    PPK[5] += RotR1(PPK[4]);
-
-    /* Step 3 - bring in last of TK bits, assign 24-bit WEP IV value
-     * WEPSeed[0..2] is transmitted as WEP IV */
-    WEPSeed[0] = Hi8(IV16);
-    WEPSeed[1] = (Hi8(IV16) | 0x20) & 0x7F;
-    WEPSeed[2] = Lo8(IV16);
-    WEPSeed[3] = Lo8((PPK[5] ^ Mk16_le((u16 *) &TK[0])) >> 1);
-
-#ifdef __BIG_ENDIAN
-    {
-        int i;
-        for (i = 0; i < 6; i++)
-            PPK[i] = (PPK[i] << 8) | (PPK[i] >> 8);
-    }
-#endif
-}
-
-
 static int ieee80211_tkip_encrypt(struct sk_buff *skb, int hdr_len,
void *priv)
 {
     struct ieee80211_tkip_data *tkey = priv;
@@ -327,7 +280,7 @@ static int ieee80211_tkip_encrypt(struct sk_buff
*skb, int hdr_len, void *priv)
                     tkey->tx_iv32);
             tkey->tx_phase1_done = 1;
         }
-        tkip_mixing_phase2(rc4key, tkey->key, tkey->tx_ttak,
tkey->tx_iv16);
+        tkip_mixing_phase2(tkey->key, tkey->tx_ttak, tkey->tx_iv16,
rc4key);
     }
     else
     tkey->tx_phase1_done = 1;
@@ -447,4 +400,4 @@ static int ieee80211_tkip_decrypt(struct sk_buff
*skb, int hdr_len, void *priv)
             tkip_mixing_phase1(tkey->rx_ttak, tkey->key, hdr->addr2, iv32);
             tkey->rx_phase1_done = 1;
         }
-        tkip_mixing_phase2(rc4key, tkey->key, tkey->rx_ttak, iv16);
+        tkip_mixing_phase2(tkey->key, tkey->rx_ttak, iv16, rc4key);

        plen = skb->len - hdr_len - 12;

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b4bef11..62934c3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4238,2 +4238,2 @@ void ieee80211_get_tkip_rx_p1k(struct
ieee80211_key_conf *keyconf,
 void ieee80211_get_tkip_p2k(struct ieee80211_key_conf *keyconf,
                 struct sk_buff *skb, u8 *p2k);

+void tkip_mixing_phase2(const u8 *tk, const u16 *p1k, u16 tsc_IV16,
+            u8 *rc4key);
+
 /**
  * ieee80211_aes_cmac_calculate_k1_k2 - calculate the AES-CMAC sub keys
  *
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 0ae2077..a6fb85d3 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -105,2 +105,2 @@ static void tkip_mixing_phase1(const u8 *tk, struct
tkip_ctx *ctx,
     ctx->p1k_iv32 = tsc_IV32;
 }

-static void tkip_mixing_phase2(const u8 *tk, struct tkip_ctx *ctx,
-                   u16 tsc_IV16, u8 *rc4key)
+void tkip_mixing_phase2(const u8 *tk, const u16 *p1k, u16 tsc_IV16, u8
*rc4key)
 {
     u16 ppk[6];
-    const u16 *p1k = ctx->p1k;
     int i;

     ppk[0] = p1k[0];
@@ -138,3 +136,4 @@ static void tkip_mixing_phase2(const u8 *tk, struct
tkip_ctx *ctx,
     for (i = 0; i < 6; i++)
         put_unaligned_le16(ppk[i], rc4key + 2 * i);
 }
+EXPORT_SYMBOL(tkip_mixing_phase2);

 /* Add TKIP IV and Ext. IV at @pos. @iv0, @iv1, and @iv2 are the first
octets
  * of the IV. Returns pointer to the octet following IVs (i.e.,
beginning of
@@ -210,0 +209,0 @@ void ieee80211_get_tkip_p2k(struct
ieee80211_key_conf *keyconf,

     spin_lock(&key->u.tkip.txlock);
     ieee80211_compute_tkip_p1k(key, iv32);
-    tkip_mixing_phase2(tk, ctx, iv16, p2k);
+    tkip_mixing_phase2(tk, ctx->p1k, iv16, p2k);
     spin_unlock(&key->u.tkip.txlock);
 }
 EXPORT_SYMBOL(ieee80211_get_tkip_p2k);
@@ -295,2 +294,2 @@ int ieee80211_tkip_decrypt_data(struct crypto_cipher
*tfm,
         key->u.tkip.rx[queue].state = TKIP_STATE_PHASE1_HW_UPLOADED;
     }

-    tkip_mixing_phase2(tk, &key->u.tkip.rx[queue], iv16, rc4key);
+    tkip_mixing_phase2(tk, key->u.tkip.rx[queue].p1k, iv16, rc4key);

     res = ieee80211_wep_decrypt_data(tfm, rc4key, 16, pos, payload_len
- 12);
  done:
--
2.1.4

