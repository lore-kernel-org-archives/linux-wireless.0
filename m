Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:40947 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbYJ2P2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 11:28:14 -0400
Received: by ug-out-1314.google.com with SMTP id 39so642908ugf.37
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 08:28:09 -0700 (PDT)
Message-ID: <490880EA.9090207@gmail.com> (sfid-20081029_162820_221427_F4623D66)
Date: Wed, 29 Oct 2008 15:27:38 +0000
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] don't use net/ieee80211.h
References: <1225243531.1369.18.camel@johannes.berg>
In-Reply-To: <1225243531.1369.18.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Convert all the drivers using net/ieee80211.h to use linux/ieee80211.h.
> Contains a bugfix in libertas where the SSID parsing could overrun the
> buffer when the AP sends invalid information.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  drivers/net/wireless/orinoco.c             |   31 ++++++-----

Thanks for this. I have a similar version locally, waiting for me to
resolve other issues. A few comments below.

> --- everything.orig/drivers/net/wireless/orinoco.c	2008-10-29 01:21:22.000000000 +0100
> +++ everything/drivers/net/wireless/orinoco.c	2008-10-29 01:51:07.000000000 +0100
> @@ -391,8 +391,7 @@ static void orinoco_bss_data_init(struct
>  
>  }
>  
> -static inline u8 *orinoco_get_ie(u8 *data, size_t len,
> -				 enum ieee80211_mfie eid)
> +static inline u8 *orinoco_get_ie(u8 *data, size_t len, u8 eid)

Would it be better to change to enum ieee80211_eid here?

> @@ -839,7 +838,8 @@ static int orinoco_change_mtu(struct net
>  	if ( (new_mtu < ORINOCO_MIN_MTU) || (new_mtu > ORINOCO_MAX_MTU) )
>  		return -EINVAL;
>  
> -	if ( (new_mtu + ENCAPS_OVERHEAD + IEEE80211_HLEN) >
> +	/* MTU + encapsulation + header length */
> +	if ( (new_mtu + ENCAPS_OVERHEAD + 24) >

I think that constant should be 30. I'd prefer it if we didn't use a
magic number here. How about sizeof(ieee80211_hdr)?

> @@ -3289,7 +3289,7 @@ static int orinoco_init(struct net_devic
>  
>  	/* No need to lock, the hw_unavailable flag is already set in
>  	 * alloc_orinocodev() */
> -	priv->nicbuf_size = IEEE80211_FRAME_LEN + ETH_HLEN;
> +	priv->nicbuf_size = IEEE80211_MAX_FRAME_LEN + ETH_HLEN;

Note that this changes nicbuf_size from 2334 to 2352. I don't expect any
problems, and haven't noticed anything while running my version with
this change.


Regards,

Dave.
