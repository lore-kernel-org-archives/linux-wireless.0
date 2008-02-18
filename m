Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta10.adelphia.net ([68.168.78.202]:42955 "EHLO
	mta10.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759590AbYBRNRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 08:17:05 -0500
Message-ID: <47B9854B.9090904@roadrunner.com> (sfid-20080218_131711_190404_A081C09B)
Date: Mon, 18 Feb 2008 08:16:59 -0500
From: David G Hamblen <dhamblen@roadrunner.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	Michael Wu <flamingice@sourmilk.net>, andreamrl@tiscali.it,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel panic after insmodding rtl8187
References: <47B71171.6040805@hauke-m.de>	 (sfid-20080216_163902_820241_FD2C42FD) <1203243029.12783.25.camel@johannes.berg>	 <47B8406E.8020105@hauke-m.de> <1203333690.12783.37.camel@johannes.berg>
In-Reply-To: <1203333690.12783.37.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this patch, the rtl8187 driver from origin/everything (2.6.25-rc1) 
seems to work well for the first time.  Previous versions sometimes 
worked, but were slow on download speeds (~2.5MB/s vs >4MB/s) compared 
to my old MA401 card.



Johannes Berg wrote:
>> http://www.hauke-m.de/fileadmin/rtl-wifi/kernel-panic-2008-02-17.JPG
>>
>> The error appears when starting the wireless network with "ifup wlan0".
>> The insmodding works without any error.
> 
> Thanks, I think this patch will fix it.
> 
> johannes
> 
> --- everything.orig/drivers/net/wireless/rtl8187_dev.c	2008-02-18 12:19:40.070030491 +0100
> +++ everything/drivers/net/wireless/rtl8187_dev.c	2008-02-18 12:20:44.290028429 +0100
> @@ -176,12 +176,16 @@ static int rtl8187_tx(struct ieee80211_h
>  
>  	flags = skb->len;
>  	flags |= RTL8187_TX_FLAG_NO_ENCRYPT;
> -	flags |= control->rts_cts_rate->hw_value << 19;
> +
> +	BUG_ON(!control->tx_rate);
> +
>  	flags |= control->tx_rate->hw_value << 24;
>  	if (ieee80211_get_morefrag((struct ieee80211_hdr *)skb->data))
>  		flags |= RTL8187_TX_FLAG_MORE_FRAG;
>  	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
> +		BUG_ON(!control->rts_cts_rate);
>  		flags |= RTL8187_TX_FLAG_RTS;
> +		flags |= control->rts_cts_rate->hw_value << 19;
>  		rts_dur = ieee80211_rts_duration(dev, priv->vif,
>  						 skb->len, control);
>  	}
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

