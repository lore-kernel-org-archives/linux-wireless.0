Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:37885 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab0JJRuf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 13:50:35 -0400
Subject: Re: [PATCH] mac80211: don't kmalloc 16 bytes
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286729530.3547.15.camel@jlt3.sipsolutions.net> (sfid-20101010_185221_930882_FFFFFFFFBD12373B)
References: <1286729530.3547.15.camel@jlt3.sipsolutions.net>
	 (sfid-20101010_185221_930882_FFFFFFFFBD12373B)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Oct 2010 19:50:20 +0200
Message-ID: <1286733020.16309.15.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-10-10 at 18:52 +0200, Johannes Berg wrote: 
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Since this small buffer isn't used for DMA,
> we can simply allocate it on the stack, it
> just needs to be 16 bytes of which only 8
> will be used for WEP40 keys.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/wep.c |    8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> --- wireless-testing.orig/net/mac80211/wep.c	2010-10-08 14:50:35.000000000 +0200
> +++ wireless-testing/net/mac80211/wep.c	2010-10-08 14:51:41.000000000 +0200
> @@ -222,7 +222,7 @@ static int ieee80211_wep_decrypt(struct
>  				 struct ieee80211_key *key)
>  {
>  	u32 klen;
> -	u8 *rc4key;
> +	u8 rc4key[3 + WLAN_KEY_LEN_WEP104];
>  	u8 keyidx;
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>  	unsigned int hdrlen;
> @@ -245,10 +245,6 @@ static int ieee80211_wep_decrypt(struct
>  
>  	klen = 3 + key->conf.keylen;

What about
if (WARN_ON(klen > sizeof(rc4key)))
return -1;
to harden this a bit for accidental stack overflows?

> 
> -	rc4key = kmalloc(klen, GFP_ATOMIC);
> -	if (!rc4key)
> -		return -1;
> -
>  	/* Prepend 24-bit IV to RC4 key */
>  	memcpy(rc4key, skb->data + hdrlen, 3);
>  
> @@ -260,8 +256,6 @@ static int ieee80211_wep_decrypt(struct
>  				       len))
>  		ret = -1;
>  
> -	kfree(rc4key);
> -
>  	/* Trim ICV */
>  	skb_trim(skb, skb->len - WEP_ICV_LEN);
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Greetings Michael.

