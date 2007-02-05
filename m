Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:46378 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933460AbXBEVT7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 16:19:59 -0500
Date: Mon, 5 Feb 2007 22:19:57 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH RFC] d80211: Fix TKIP phase1 key mixing for hwcrypto
Message-ID: <20070205221957.3c9003b5@griffin.suse.cz>
In-Reply-To: <200702031832.48505.mb@bu3sch.de>
References: <200702031832.48505.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 3 Feb 2007 18:32:48 +0100, Michael Buesch wrote:
> @@ -192,10 +192,15 @@ u8 * ieee80211_tkip_add_iv(u8 *pos, stru
>  
>  
>  void ieee80211_tkip_gen_phase1key(struct ieee80211_key *key, u8 *ta,
> -				  u16 *phase1key)
> +				  u8 *phase1key)
>  {
> +	__le16 *k = (__le16 *)phase1key;
> +	int i;
> +
>  	tkip_mixing_phase1(ta, &key->key[ALG_TKIP_TEMP_ENCR_KEY],
> -			   key->u.tkip.iv32, phase1key);
> +			   key->u.tkip.iv32, (u16 *)k);
> +	for (i = 0; i < 5; i++)
> +		k[i] = cpu_to_le16(k[i]);
>  }

Maybe a slightly better type checking but still looks ugly:

@@ -192,10 +192,16 @@ u8 * ieee80211_tkip_add_iv(u8 *pos, stru
 
 
 void ieee80211_tkip_gen_phase1key(struct ieee80211_key *key, u8 *ta,
-				  u16 *phase1key)
+				  u8 *phase1key)
 {
+	u16 *tmp_result = (u16 *)phase1key;
+	__le16 *k = (__le16 *)phase1key;
+	int i;
+
 	tkip_mixing_phase1(ta, &key->key[ALG_TKIP_TEMP_ENCR_KEY],
-			   key->u.tkip.iv32, phase1key);
+			   key->u.tkip.iv32, tmp_result);
+	for (i = 0; i < 5; i++)
+		k[i] = cpu_to_le16(tmp_result[i]);
 }
 
 void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,


Moreover, I'm not sure if GCC is able to optimize out the for loop in
this case :-(

 Jiri

-- 
Jiri Benc
SUSE Labs
