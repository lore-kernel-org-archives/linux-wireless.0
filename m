Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:52553
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921AbXKWNxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 08:53:02 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] b43: include FCS in frames handed to mac80211
Date: Fri, 23 Nov 2007 14:51:58 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1195814776.4149.90.camel@johannes.berg>
In-Reply-To: <1195814776.4149.90.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711231451.58564.mb@bu3sch.de> (sfid-20071123_135328_675358_39285591)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 November 2007 11:46:16 Johannes Berg wrote:
> Sometimes it can be useful to see the FCS, especially when
> bad-FCS frames are shown. Pass the FCS to mac80211 and let
> it worry about snipping it off when required.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  drivers/net/wireless/b43/main.c |    3 ++-
>  drivers/net/wireless/b43/xmit.c |    1 -
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> --- everything.orig/drivers/net/wireless/b43/main.c	2007-11-22 23:35:41.208716199 +0100
> +++ everything/drivers/net/wireless/b43/main.c	2007-11-22 23:36:03.138677951 +0100
> @@ -4158,7 +4158,8 @@ static int b43_wireless_init(struct ssb_
>  	}
>  
>  	/* fill hw info */
> -	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
> +	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
> +		    IEEE80211_HW_RX_INCLUDES_FCS;
>  	hw->max_signal = 100;
>  	hw->max_rssi = -110;
>  	hw->max_noise = -110;
> --- everything.orig/drivers/net/wireless/b43/xmit.c	2007-11-22 23:36:05.668676810 +0100
> +++ everything/drivers/net/wireless/b43/xmit.c	2007-11-22 23:36:22.668677190 +0100
> @@ -489,7 +489,6 @@ void b43_rx(struct b43_wldev *dev, struc
>  	}
>  	wlhdr = (struct ieee80211_hdr *)(skb->data);
>  	fctl = le16_to_cpu(wlhdr->frame_control);
> -	skb_trim(skb, skb->len - FCS_LEN);
>  
>  	if (macstat & B43_RX_MAC_DEC) {
>  		unsigned int keyidx;
> 
> 
> 
> 

Does this work with all encryption and non-encryption modes?
There was a crypto related reason why we snipped off the FCS.
Maybe that's gone, though.

-- 
Greetings Michael.
