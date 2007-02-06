Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:43671
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622AbXBFPoW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 10:44:22 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: d80211: Fix TKIP key type
Date: Tue, 6 Feb 2007 16:44:10 +0100
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <200702031832.48505.mb@bu3sch.de> <20070205221957.3c9003b5@griffin.suse.cz> <200702061033.50134.flamingice@sourmilk.net>
In-Reply-To: <200702061033.50134.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200702061644.11150.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 06 February 2007 16:33, Michael Wu wrote:
> d80211: Fix TKIP key type
> 
> Avoid the messy typecasting and let drivers handle byteordering.

Well, ok.

We need to remove all the tkip stuff from tx_control anyway,
as it's broken. It does not work to pass tkip keys along with
TX packets, as we also need the key for RX (on bcm43xx at least).
So I think we need a callback or something that sets the key in HW.
Maybe we can do that in the already existing set_key callback.
Dunno yet.

> Signed-off-by: Michael Wu <flamingice@sourmilk.net>
> 
> diff --git a/include/net/d80211.h b/include/net/d80211.h
> index 65a5d36..0bd6b15 100644
> --- a/include/net/d80211.h
> +++ b/include/net/d80211.h
> @@ -202,7 +202,10 @@ struct ieee80211_tx_control {
>  				 * hw->set_key() */
>  	u8 icv_len;		/* length of the ICV/MIC field in octets */
>  	u8 iv_len;		/* length of the IV field in octets */
> -	u8 tkip_key[16];	/* generated phase2/phase1 key for hw TKIP */
> +	union {
> +		u16 phase1[5];
> +		u8 phase2[16];
> +	} tkip;			/* generated phase2/phase1 key for hw TKIP */
>  	u8 queue;		/* hardware queue to use for this frame;
>  				 * 0 = highest, hw->queues-1 = lowest */
>  	u8 sw_retry_attempt;	/* number of times hw has tried to
> diff --git a/net/d80211/ieee80211_i.h b/net/d80211/ieee80211_i.h
> diff --git a/net/d80211/ieee80211_ioctl.c b/net/d80211/ieee80211_ioctl.c
> diff --git a/net/d80211/ieee80211_sta.c b/net/d80211/ieee80211_sta.c
> diff --git a/net/d80211/wpa.c b/net/d80211/wpa.c
> index 7b64abf..d5ef61a 100644
> --- a/net/d80211/wpa.c
> +++ b/net/d80211/wpa.c
> @@ -344,12 +344,12 @@ skip_iv_inc:
>  
>  		if (flags & IEEE80211_HW_TKIP_REQ_PHASE2_KEY)
>  			ieee80211_tkip_gen_rc4key(key, hdr->addr2,
> -						  tx->u.tx.control->tkip_key);
> +						  tx->u.tx.control->tkip.phase2);
>  		else if (flags & IEEE80211_HW_TKIP_REQ_PHASE1_KEY) {
>  			if (key->u.tkip.iv16 == 0 ||
>  			    !key->u.tkip.tx_initialized) {
>  				ieee80211_tkip_gen_phase1key(key, hdr->addr2,
> -					    (u16 *)tx->u.tx.control->tkip_key);
> +					    tx->u.tx.control->tkip.phase1);
>  				key->u.tkip.tx_initialized = 1;
>  				tx->u.tx.control->flags |=
>  					    IEEE80211_TXCTL_TKIP_NEW_PHASE1_KEY;
> 

-- 
Greetings Michael.
