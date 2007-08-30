Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41945 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643AbXHaKKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 06:10:38 -0400
Subject: Re: [PATCH 2/3] mac80211: revamp key handling
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
In-Reply-To: <20070821160001.763985000@sipsolutions.net>
References: <20070821155725.489738000@sipsolutions.net>
	 <20070821160001.763985000@sipsolutions.net>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 01:45:04 +0200
Message-Id: <1188517504.7585.17.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Huh, this turned out to be buggy in b43:

> @@ -2921,13 +2919,15 @@ static int b43_dev_set_key(struct ieee80
>  			err = b43_key_write(dev, index, algorithm,
>  					    key->key, key->keylen, NULL, key);
>  		} else {
> +			/*
> +			 * either pairwise key or address is 00:00:00:00:00:00
> +			 * for transmit-only keys
> +			 */
>  			err = b43_key_write(dev, -1, algorithm,
>  					    key->key, key->keylen, addr, key);
>  		}
> -		if (err) {
> -			key->flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
> +		if (err)
>  			goto out_unlock;
> -		}
>  		dev->key[key->hw_key_idx].enabled = 1;
>  
>  		if (algorithm == B43_SEC_ALGO_WEP40 ||

The same obviously has to be done when deleting keys. Michael, you can
either use the patch below or rework it to use the hw_key_idx to delete
the key.

Interestingly, this way I found out that when the B43_RX_MAC_DECERR flag
is set on a frame, then the hardware has decrypted the data with the
wrong key and then found that the ICV isn't correct so that the data is
completely mangled. Hence, you should simply drop the frame in that case
instead of passing it up, mac80211 will simply again attempt to decrypt
it and, since the frame is already decrypted with the wrong key, only
get garbage. This could even be used to DoS a machine with little
resources like an AP: simply send a lot of broken frames that mac80211
will try to decrypt in software.

johannes

--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-08-31 01:28:18.532792130 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-08-31 01:31:01.502792130 +0200
@@ -2939,9 +2939,18 @@ static int b43_dev_set_key(struct ieee80
 		static const u8 zero[B43_SEC_KEYSIZE] = { 0 };
 
 		algorithm = B43_SEC_ALGO_NONE;
-		err = b43_key_write(dev, index, algorithm,
-				    zero, B43_SEC_KEYSIZE,
-				    NULL, key);
+		if (is_broadcast_ether_addr(addr)) {
+			/* addr is FF:FF:FF:FF:FF:FF for default keys */
+			err = b43_key_write(dev, index, algorithm,
+					    zero, B43_SEC_KEYSIZE, NULL, key);
+		} else {
+			/*
+			 * either pairwise key or address is 00:00:00:00:00:00
+			 * for transmit-only keys
+			 */
+			err = b43_key_write(dev, -1, algorithm,
+					    zero, B43_SEC_KEYSIZE, addr, key);
+		}
 		if (err)
 			goto out_unlock;
 		break;


